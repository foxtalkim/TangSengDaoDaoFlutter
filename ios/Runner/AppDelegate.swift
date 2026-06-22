import Flutter
import CoreImage
import Photos
import UIKit
import UserNotifications
#if FOXTALK_MODULE_NATIVE
import AMapFoundationKit
import AMapLocationKit
import MAMapKit
import AMapSearchKit
#endif
// PushKit + CallKit — RTC 系统级来电 UI. Backend 把 RTC invite 推到
// .voip APNS topic (跟普通 alert push 用不同 cert) → iOS 把 payload 路由到
// `pushRegistry didReceiveIncomingPushWith` → 我们调
// SwiftFlutterCallkitIncomingPlugin.showCallkitIncoming(.., fromPushKit: true)
// 让 CallKit 全屏弹起 (锁屏 / 杀进程都能唤). 用户接听 / 拒绝 → plugin event
// channel 转 Dart 端 CallKitBridge → home_shell 路由到 gateway.accept / refuse.
// Token 通过 plugin 自身 event (Event.actionDidUpdateDevicePushTokenVoip)
// 转 Dart, 不需要本地另外 forward.
import PushKit
import CallKit
#if FOXTALK_MODULE_NATIVE
import flutter_callkit_incoming
#endif

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, PKPushRegistryDelegate {
  private var scanChannel: FlutterMethodChannel?
  private var mediaChannel: FlutterMethodChannel?
  /// Push notification channel — Dart 端调 `requestPermission` / `getToken`
  /// 触发 native APNS 注册 + 读取 token. native fire `onToken` event 把
  /// hex deviceToken 回传 Dart. 取代 flutter_apns_only plugin (它 1.6.0
  /// 太老, swizzle 跟 iOS 26 不兼容, token callback 永远不 fire).
  private var pushChannel: FlutterMethodChannel?
  /// 已 cache 的 deviceToken — `didRegisterForRemoteNotifications` fire
  /// 之前 Dart 调 `getToken` 会先存到这, native 拿到 token 时立即 invoke
  /// pendingResult, 让 Dart `getToken` 等待 native register.
  private var pendingTokenResult: FlutterResult?
  private var cachedDeviceToken: String?
  private var pendingTapPayload: [String: Any]?
  private var dartReady = false

  #if FOXTALK_MODULE_NATIVE
  private static let aMapIosKey =
    Bundle.main.object(forInfoDictionaryKey: "AMAP_IOS_KEY") as? String ?? ""
  #endif

  private var voipRegistry: PKPushRegistry?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    #if FOXTALK_MODULE_NATIVE
    AMapServices.shared().enableHTTPS = true
    if !Self.aMapIosKey.isEmpty {
      AMapServices.shared().apiKey = Self.aMapIosKey
    }
    #endif

    UNUserNotificationCenter.current().delegate = self
    NSLog("[push] UN delegate set BEFORE super = \(String(describing: UNUserNotificationCenter.current().delegate))")

    let launched = super.application(application, didFinishLaunchingWithOptions: launchOptions)

    UNUserNotificationCenter.current().delegate = self
    NSLog("[push] UN delegate set AFTER super = \(String(describing: UNUserNotificationCenter.current().delegate))")

    // VoIP PushKit setup — registry 强引用在 self.voipRegistry, 防 ARC 回收.
    // 必须放在 super 后 (Flutter engine 已 init, plugin 注册路径走完).
    // desiredPushTypes = .voIP → APNS 推 .voip topic 时调到下面的
    // pushRegistry didReceiveIncomingPushWith. iOS 13+ 不许"静默" voip
    // push, 收到必须立即 showCallkitIncoming + completion(), 否则 app 被
    // 系统 kill + 失去 VoIP push 资格.
    #if FOXTALK_MODULE_NATIVE
    setupVoipPushRegistry()
    #endif

    return launched
  }

  // MARK: - PushKit (VoIP) for CallKit incoming
  //
  // 当前 backend 还没配 VoIP cert 推 .voip topic, 下面 3 个 delegate method
  // 暂时不会被触发. 框架先就位, cert 到位后 backend 推一条 voip topic 即可
  // 触发 CallKit 全屏来电界面 (锁屏 / 杀进程都唤醒). 见 backend
  // modules/rtc/api.go + push_iosapns.go 后续接入计划.

  private func setupVoipPushRegistry() {
    let registry = PKPushRegistry(queue: DispatchQueue.main)
    registry.delegate = self
    registry.desiredPushTypes = [.voIP]
    voipRegistry = registry
    NSLog("[voip] PKPushRegistry initialized, desiredPushTypes=[.voIP]")
  }

  /// VoIP push token 拿到 / 刷新. plugin 自带的
  /// `setDevicePushTokenVoIP` 会通过自己的 event channel 把 token 转发
  /// 到 Dart 端 (CallKitBridge.onVoipTokenChange), 之后 push_service 上
  /// 报 server. 这里**不要**自己再 forward token 到 `foxtalk/push` channel
  /// — 跟 alert APNS token 区分 (server 端区分: device_type 加 IOS_VOIP).
  func pushRegistry(_ registry: PKPushRegistry,
                    didUpdate credentials: PKPushCredentials,
                    for type: PKPushType) {
    guard type == .voIP else { return }
    let token = credentials.token.map { String(format: "%02x", $0) }.joined()
    NSLog("[voip] didUpdate token length=\(token.count)")
    #if FOXTALK_MODULE_NATIVE
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP(token)
    #endif
  }

  func pushRegistry(_ registry: PKPushRegistry,
                    didInvalidatePushTokenFor type: PKPushType) {
    guard type == .voIP else { return }
    NSLog("[voip] didInvalidatePushTokenFor .voIP")
    #if FOXTALK_MODULE_NATIVE
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?.setDevicePushTokenVoIP("")
    #endif
  }

  /// VoIP push 到达 → 必须立即 showCallkitIncoming + completion(), 否则
  /// iOS 13+ 会 kill app + 失去 PushKit 资格. 字段语义跟 Dart 端
  /// CallKitBridge.showIncoming 对齐 (id / nameCaller / handle / isVideo
  /// + extra map).
  ///
  /// Backend 推送 payload 示例:
  /// ```json
  /// {
  ///   "id": "<同 Dart CallKitBridge.uuidFor(event) 的 UUID>",
  ///   "nameCaller": "张三",
  ///   "handle": "<fromUid 或 groupChannelId>",
  ///   "isVideo": true,
  ///   "extra": {
  ///     "fromUid": "abc", "fromName": "张三",
  ///     "roomId": "abc@def", "isGroup": false,
  ///     "groupChannelId": "", "groupChannelType": 0,
  ///     "callType": 1
  ///   }
  /// }
  /// ```
  func pushRegistry(_ registry: PKPushRegistry,
                    didReceiveIncomingPushWith payload: PKPushPayload,
                    for type: PKPushType,
                    completion: @escaping () -> Void) {
    guard type == .voIP else {
      completion()
      return
    }
    #if FOXTALK_MODULE_NATIVE
    NSLog("[voip] didReceiveIncomingPushWith payload=\(payload.dictionaryPayload)")
    let dict = payload.dictionaryPayload
    let id = (dict["id"] as? String) ?? UUID().uuidString
    let nameCaller = (dict["nameCaller"] as? String) ?? "未知"
    let handle = (dict["handle"] as? String) ?? ""
    let isVideo = (dict["isVideo"] as? Bool) ?? false
    let data = flutter_callkit_incoming.Data(
      id: id,
      nameCaller: nameCaller,
      handle: handle,
      type: isVideo ? 1 : 0
    )
    let appDisplayName =
      (Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String)
      ?? (Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String)
      ?? ""
    data.appName = appDisplayName
    data.supportsVideo = isVideo
    data.handleType = "generic"
    data.iconName = "AppIcon"
    data.ringtonePath = "call.aac"
    if let extra = dict["extra"] as? [String: Any] {
      data.extra = NSDictionary(dictionary: extra)
    }
    SwiftFlutterCallkitIncomingPlugin.sharedInstance?
      .showCallkitIncoming(data, fromPushKit: true) {
        completion()
      }
    #else
    completion()
    #endif
  }

  /// 给 SceneDelegate / 其他 native 路径调 — 收到 push tap 时统一走这条.
  /// 内部会 pending buffer 或立即 forward 给 Dart.
  @objc func handlePushTap(userInfo: [AnyHashable: Any]) {
    NSLog("[push] handlePushTap userInfo=\(userInfo)")
    forwardTapToDart(userInfo: userInfo)
  }

  // MARK: - Push (APNS) native bridge

  /// 用 plugin registry 的 messenger 注册 push channel.
  /// 在 `didInitializeImplicitFlutterEngine` 调用 (此时 Flutter engine 已
  /// init, plugin registry 可用). 跟之前 `window?.rootViewController as
  /// FlutterViewController` 路径相比, 这条**不依赖 Scene activation** —
  /// chatim 是 Scene-based lifecycle (Info.plist `UIApplicationSceneManifest`),
  /// `didFinishLaunchingWithOptions` 时 `window.rootViewController` 还是
  /// nil → channel 注册 fail silent → Dart `invokeMethod` 抛
  /// MissingPluginException.
  private func registerPushChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "foxtalk/push", binaryMessenger: messenger)
    pushChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      guard let self else { return }
      switch call.method {
      case "requestPermissionAndRegister":
        self.requestPermissionAndRegister(result: result)
      case "getToken":
        if let token = self.cachedDeviceToken {
          result(token)
        } else {
          // 还没拿到 token, pending — `didRegisterForRemoteNotifications`
          // fire 时 invoke 这个 result.
          self.pendingTokenResult = result
        }
      case "consumeInitialTap":
        // Dart 端 `_startIOS` setMethodCallHandler 后立即调这个 — 拉取
        // cold-start 时被缓存的 tap payload (SceneDelegate 或 AppDelegate
        // 在 Dart handler 没 ready 前接到的). 同时**标记 dartReady=true**,
        // 之后 forwardTapToDart 走直接 invokeMethod 不再缓存.
        let payload = self.pendingTapPayload
        self.pendingTapPayload = nil
        self.dartReady = true
        NSLog("[push] consumeInitialTap returns \(String(describing: payload)), dartReady=true")
        result(payload)
      case "setBadge":
        // 同步桌面图标 badge 数字 — 对齐 iOS 原版 `WKApp.m:638`
        // `appDidEnterBackground` 时 `[UIApplication ... setApplicationIconBadgeNumber:unreadCount]`.
        // Dart 端 `_syncBadge` 算总未读 (server 也同步上报给 APNS push 的
        // badge 字段) → 同时 native 这里清桌面图标. 不调 native 这条 →
        // 桌面图标 badge 减不下来, 用户读完消息 icon 还显数字.
        let count: Int
        if let n = call.arguments as? Int {
          count = n
        } else if let n = call.arguments as? NSNumber {
          count = n.intValue
        } else {
          count = 0
        }
        DispatchQueue.main.async {
          if #available(iOS 16.0, *) {
            UNUserNotificationCenter.current().setBadgeCount(count) { error in
              if let error = error {
                NSLog("[push] setBadgeCount error: \(error)")
              }
            }
          } else {
            UIApplication.shared.applicationIconBadgeNumber = count
          }
        }
        result(nil)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    NSLog("[push] registerPushChannel OK")
    // **不要在这里 flush pending tap** — channel 注册不等于 Dart handler
    // setMethodCallHandler 已执行 (cold-start 时 Dart 还在 init main). 让
    // Dart `consumeInitialTap` 主动拉, dartReady 一起翻 true 才走 invoke.
  }

  private func requestPermissionAndRegister(result: @escaping FlutterResult) {
    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert, .badge, .sound]
    ) { granted, error in
      if let error = error {
        NSLog("[push] permission error: \(error)")
        DispatchQueue.main.async {
          result(FlutterError(code: "PERMISSION_ERROR",
                              message: error.localizedDescription,
                              details: nil))
        }
        return
      }
      NSLog("[push] permission granted=\(granted)")
      if granted {
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
          result(true)
        }
      } else {
        DispatchQueue.main.async { result(false) }
      }
    }
  }

  override func application(
    _ application: UIApplication,
    // **必须** Foundation.Data 全名 — `import flutter_callkit_incoming` 引入了
    // 同名 `flutter_callkit_incoming.Data` 类 (VoIP push payload 模型), 不加
    // namespace Swift 编译报 "'Data' is ambiguous for type lookup in this context".
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Foundation.Data
  ) {
    // deviceToken 是 Data, 转 64-char hex string (server APNS push 要这个).
    let hex = deviceToken.map { String(format: "%02x", $0) }.joined()
    NSLog("[push] didRegisterForRemoteNotifications token length=\(hex.count)")
    cachedDeviceToken = hex
    if let pending = pendingTokenResult {
      pending(hex)
      pendingTokenResult = nil
    }
    pushChannel?.invokeMethod("onToken", arguments: hex)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    NSLog("[push] didFailToRegisterForRemoteNotifications error=\(error)")
    pushChannel?.invokeMethod("onError", arguments: error.localizedDescription)
    if let pending = pendingTokenResult {
      pending(FlutterError(code: "APNS_REGISTER_FAILED",
                           message: error.localizedDescription,
                           details: nil))
      pendingTokenResult = nil
    }
  }

  // MARK: - Push tap (tap-to-route)
  //
  // App 在前台收到 push 时 iOS 系统不弹横幅 (默认), Flutter 自己显示
  // local notification (LocalNotificationCenter). 用户点 push 横幅或锁屏
  // 通知时, iOS 走两条路径:
  //   1. App 杀进程被点 → 启动后 launchOptions 含 push payload
  //   2. App 后台被点 → `userNotificationCenter:didReceive:` 触发
  // 两条都把 payload 通过 MethodChannel `foxtalk/push` invokeMethod
  // `onNotificationTap` 给 Dart, Dart 根据 channel_id/channel_type 跳对应
  // chat 页 (路由在 push_service.dart `onNotificationTap` handler).
  //
  // 这里需要 self 是 UNUserNotificationCenterDelegate. FlutterAppDelegate
  // 默认实现这个 protocol (forward 给 plugins), override 不破坏现有行为.
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    let userInfo = response.notification.request.content.userInfo
    NSLog("[push] userNotificationCenter:didReceive userInfo=\(userInfo)")
    forwardTapToDart(userInfo: userInfo)
    super.userNotificationCenter(
      center,
      didReceive: response,
      withCompletionHandler: completionHandler
    )
  }

  /// 把 APNS payload 转 Dart 用的 args dict — 字段:
  ///   * channel_id (String, 普通消息必填; RTC 邀请也带, server 走
  ///     `routeChannelID = from_uid`)
  ///   * channel_type (Int, NSNumber 都兼容)
  ///   * from_uid (String, RTC 邀请的发起人 uid)
  ///   * cmd (String, "rtc.p2p.invoke" / "room.invoke" 标识 RTC, 普通消息空)
  ///   * call_type (Int, 0=语音/1=视频, 仅 RTC 有效)
  ///
  /// Dart 端 (`push_service.dart` onNotificationTap handler) 解析 cmd 判定
  /// `isRtcInvite`, → HomeShell `_handlePushTap` 走 RTC 接听 modal 而不是
  /// chat 页. **不能 early-return on empty channel_id** — RTC payload 也带
  /// channel_id 但即使空也要 forward (cmd 字段才是 RTC 判定的 source of truth).
  private func tapArgs(from userInfo: [AnyHashable: Any]) -> [String: Any]? {
    let channelID = (userInfo["channel_id"] as? String) ?? ""
    let cmd = (userInfo["cmd"] as? String) ?? ""
    // 完全没 channel_id 也没 cmd → 不是 chatim push, skip (避免误转其他
    // 来源的通知, e.g. 系统 / 第三方 SDK).
    if channelID.isEmpty && cmd.isEmpty { return nil }
    var args: [String: Any] = ["channel_id": channelID]
    if let ct = userInfo["channel_type"] as? Int {
      args["channel_type"] = ct
    } else if let ctNum = userInfo["channel_type"] as? NSNumber {
      args["channel_type"] = ctNum.intValue
    } else if let ctStr = userInfo["channel_type"] as? String,
              let ctParsed = Int(ctStr) {
      args["channel_type"] = ctParsed
    }
    if let fromUID = userInfo["from_uid"] as? String {
      args["from_uid"] = fromUID
    }
    if !cmd.isEmpty {
      args["cmd"] = cmd
    }
    // call_type 可能是 NSNumber (APNS JSON int) / Int / String, 都兼容.
    if let cType = userInfo["call_type"] as? Int {
      args["call_type"] = cType
    } else if let cTypeNum = userInfo["call_type"] as? NSNumber {
      args["call_type"] = cTypeNum.intValue
    } else if let cTypeStr = userInfo["call_type"] as? String,
              let cTypeParsed = Int(cTypeStr) {
      args["call_type"] = cTypeParsed
    }
    return args
  }

  /// 转发 tap 给 Dart. Dart MethodCallHandler 未 ready (`dartReady=false`,
  /// cold-start setMethodCallHandler 未执行) → 缓存 pendingTapPayload,
  /// `consumeInitialTap` 拉. Dart ready → 直接 invokeMethod.
  private func forwardTapToDart(userInfo: [AnyHashable: Any]) {
    guard let args = tapArgs(from: userInfo) else {
      NSLog("[push] forwardTapToDart skipped (no channel_id / cmd) — \(userInfo)")
      return
    }
    NSLog("[push] forwardTapToDart args=\(args) dartReady=\(dartReady) channelReady=\(pushChannel != nil)")
    if dartReady, let channel = pushChannel {
      channel.invokeMethod("onNotificationTap", arguments: args)
    } else {
      // Dart 还没 setMethodCallHandler / consumeInitialTap — 缓存到 pending,
      // Dart `_startIOS` 启动后 consumeInitialTap 拉取.
      pendingTapPayload = args
    }
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    #if FOXTALK_MODULE_NATIVE
    // PlatformView factory 必须注册到 Implicit Engine 的 plugin registry
    // (不是 FlutterAppDelegate self 的 `registrar(forPlugin:)`, 那是
    // 另一套). 没注册到正确 registry → Flutter 端 UiKitView 渲染 placeholder
    // 或抛 "Unknown view type" 异常, picker 顶部 300pt 区域空白.
    NSLog("【AMap】registering PlatformView factory in implicit engine")
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "foxtalk.amap_platform_view") {
      let factory = AMapPlatformViewFactory(messenger: registrar.messenger())
      registrar.register(factory, withId: "foxtalk/amap_view")
      NSLog("【AMap】PlatformView factory registered OK")
    } else {
      NSLog("【AMap】FAILED to get registrar from implicit engine")
    }
    #endif
    // App native channels 必须用 implicit engine 的 messenger (Scene 模式下
    // window.rootViewController 在 didFinishLaunchingWithOptions 时为 nil).
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "foxtalk.scan") {
      registerScanChannel(messenger: registrar.messenger())
    } else {
      NSLog("[scan] FAILED to get scan registrar from implicit engine")
    }
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "foxtalk.media") {
      registerMediaChannel(messenger: registrar.messenger())
    } else {
      NSLog("[media] FAILED to get media registrar from implicit engine")
    }
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "foxtalk.push") {
      registerPushChannel(messenger: registrar.messenger())
    } else {
      NSLog("[push] FAILED to get push registrar from implicit engine")
    }
    // **GeneratedPluginRegistrant 注册完成后再 re-assert UN delegate**.
    // firebase_messaging iOS pod 在 plugin init 时会接管 UN delegate
    // (swizzle / 直接 set), 我们要在它之后再 set 一次抢回来. 否则
    // `userNotificationCenter:didReceive:` 永远不会调到我们 override 的版本,
    // tap event 全部走 Firebase 内部, Dart 端拿不到 RTC payload.
    UNUserNotificationCenter.current().delegate = self
    NSLog("[push] UN delegate set after plugin registrant = \(String(describing: UNUserNotificationCenter.current().delegate))")
  }

  private func registerScanChannel(messenger: FlutterBinaryMessenger) {
    scanChannel = FlutterMethodChannel(
      name: "foxtalk/scan",
      binaryMessenger: messenger
    )
    scanChannel?.setMethodCallHandler { call, result in
      guard call.method == "decodeQrImage" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard
        let arguments = call.arguments as? [String: Any],
        let path = arguments["path"] as? String,
        !path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "图片路径为空", details: nil))
        return
      }
      result(Self.decodeQrImage(path: path))
    }
    NSLog("[scan] registerScanChannel OK")
  }

  private static func decodeQrImage(path: String) -> String? {
    let imageUrl = URL(fileURLWithPath: path)
    let ciImage = CIImage(contentsOf: imageUrl)
    guard let ciImage else {
      return nil
    }
    let detector = CIDetector(
      ofType: CIDetectorTypeQRCode,
      context: nil,
      options: [CIDetectorAccuracy: CIDetectorAccuracyHigh]
    )
    let features = detector?.features(in: ciImage) as? [CIQRCodeFeature]
    return features?.compactMap { $0.messageString }.first
  }

  private func registerMediaChannel(messenger: FlutterBinaryMessenger) {
    mediaChannel = FlutterMethodChannel(
      name: "foxtalk/media",
      binaryMessenger: messenger
    )
    mediaChannel?.setMethodCallHandler { call, result in
      guard call.method == "saveImageToAlbum" else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard
        let arguments = call.arguments as? [String: Any],
        let path = arguments["path"] as? String,
        !path.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
      else {
        result(FlutterError(code: "INVALID_ARGUMENT", message: "图片路径为空", details: nil))
        return
      }
      Self.saveImageToAlbum(path: path, result: result)
    }
    NSLog("[media] registerMediaChannel OK")
  }

  private static func saveImageToAlbum(path: String, result: @escaping FlutterResult) {
    guard let image = UIImage(contentsOfFile: path) else {
      result(FlutterError(code: "INVALID_IMAGE", message: "图片无法读取", details: nil))
      return
    }

    let save = {
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAsset(from: image)
      }) { success, error in
        DispatchQueue.main.async {
          if success {
            result(nil)
          } else {
            result(
              FlutterError(
                code: "SAVE_FAILED",
                message: error?.localizedDescription ?? "保存图片失败",
                details: nil
              )
            )
          }
        }
      }
    }

    switch PHPhotoLibrary.authorizationStatus() {
    case .authorized:
      save()
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
          save()
        } else {
          DispatchQueue.main.async {
            result(FlutterError(code: "NO_PERMISSION", message: "没有相册写入权限", details: nil))
          }
        }
      }
    default:
      result(FlutterError(code: "NO_PERMISSION", message: "没有相册写入权限", details: nil))
    }
  }
}
