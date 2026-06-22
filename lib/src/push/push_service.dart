import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../call/callkit_bridge.dart';
import '../social/social_service.dart';
import 'fcm_call_background_handler.dart';

/// tap-to-route event — push 通知被点击后跳转目标 chat 页用. 来源:
///   * iOS APNS tap (native AppDelegate `userNotificationCenter:didReceive:`)
///   * Android FCM tap (FirebaseMessaging onMessageOpenedApp / getInitialMessage)
///   * 本地通知 tap (flutter_local_notifications onDidReceiveNotificationResponse)
/// 由 [PushRouter.tapStream] 统一 fan-out, app 路由层订阅后调
/// home shell 暴露的 openChatByChannelId.
class PushTapEvent {
  const PushTapEvent({
    required this.channelId,
    required this.channelType,
    this.fromUid = '',
    this.isRtcInvite = false,
    this.callType = 0,
  });

  /// 从 channelKey 字符串 (`"<id>|<type>"`) parse — local notification
  /// payload 用这种 packed 格式. 解析失败返回 null.
  static PushTapEvent? parseChannelKey(String? key) {
    if (key == null || key.isEmpty) return null;
    final parts = key.split('|');
    if (parts.length != 2) return null;
    final ct = int.tryParse(parts[1]);
    if (ct == null) return null;
    return PushTapEvent(channelId: parts[0], channelType: ct);
  }

  final String channelId;
  final int channelType;
  final String fromUid;

  /// True 表示这是 RTC 邀请的 push tap. server payload `cmd=rtc.p2p.invoke`
  /// 标记. HomeShell `_handlePushTap` 收到时跳过 `_openChat`, 直接构造
  /// `IncomingCallEvent.invoke` push 接听 modal (P2P 邀请不在 server
  /// `/rtc/rooms/pending` 表里, 无法靠 reconnect 后查询补拉, 必须直接 emit).
  final bool isRtcInvite;

  /// RTC 邀请的 call_type (0=语音, 1=视频). 跟 `common.RTCCallTypeAudio` /
  /// `RTCCallTypeVideo` 对齐 (server `common.go`). 仅 `isRtcInvite=true` 有效.
  final int callType;

  @override
  String toString() =>
      'PushTapEvent(channelId=$channelId, channelType=$channelType, fromUid=$fromUid, isRtcInvite=$isRtcInvite, callType=$callType)';
}

/// 统一 tap event 路由 — push 通知被点击后, 三条来源 (iOS APNS native /
/// Android FCM / 本地通知) 都 emit 到这个 stream, app 路由层订阅一次.
/// HomeShell init 时挂 listener, 拿 PushTapEvent 调 `openChatByChannelId`.
class PushRouter {
  PushRouter._();
  static final PushRouter instance = PushRouter._();

  final StreamController<PushTapEvent> _controller =
      StreamController<PushTapEvent>.broadcast();

  /// HomeShell 订阅这个 stream 处理 tap 跳转.
  Stream<PushTapEvent> get tapStream => _controller.stream;

  /// 由各源 (iOS APNS native / FCM / 本地通知) 调, 把 tap 转发出去.
  void emit(PushTapEvent event) {
    if (_controller.isClosed) return;
    debugPrint('[push][router] emit $event');
    _controller.add(event);
  }
}

/// 本地通知服务 — 给 app 在后台 / 锁屏但 process 还活的场景用. SDK
/// 长连接收到消息时 (`_applyRemoteMessage` 内 fire), 调
/// `LocalNotificationCenter.show` 弹横幅. 跟 server push (FCM/APNS) 互补:
///   * app 杀进程 → server 推 (FCM/APNS, 系统层)
///   * app 后台/锁屏 process 活 → 本地通知 (这个 service)
///   * app 前台 chat 页 → 不弹 (用户正在看)
/// 对齐微信 / WhatsApp 的标准做法 — IM 长连接消息到达, app 在后台时 client
/// 自己显示通知. iOS 后台时 process 大概率被挂起, 本地通知主要给 Android.
class LocalNotificationCenter {
  LocalNotificationCenter._();
  static final LocalNotificationCenter instance = LocalNotificationCenter._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// 最近显示过的 messageId — dedup APNS 已显示 + SDK 长连接重连后补送
  /// 同条消息导致本地通知重复弹的场景. APNS 跟 local notification 不同源,
  /// 系统 id 替换不生效, 必须 client 端 set 检查. LRU 容量 256 (够撑用户
  /// 短期内多条消息, 老的 evict 不影响真新消息).
  final List<String> _recentMessageIds = <String>[];
  static const int _dedupCap = 256;

  /// app resume 时间 — paused → resumed 后 SDK 自动 reconnect 补送 paused
  /// 期间的消息 (含 APNS 已显示过的). 这窗口内不弹本地通知 (用户已在 app
  /// 内, 即将看到 chat 列表更新, 不需要横幅再吵). 跟微信 / WhatsApp resume
  /// 后不弹老消息行为对齐. 调 `markResumed()` 由 main.dart lifecycle
  /// resumed 触发.
  DateTime? _resumedAt;
  static const Duration _resumeSuppressWindow = Duration(seconds: 5);

  void markResumed() {
    _resumedAt = DateTime.now();
  }

  bool _withinResumeWindow() {
    final at = _resumedAt;
    if (at == null) return false;
    return DateTime.now().difference(at) < _resumeSuppressWindow;
  }

  bool _seenAndRecord(String messageId) {
    if (messageId.isEmpty) return false;
    if (_recentMessageIds.contains(messageId)) return true;
    _recentMessageIds.add(messageId);
    if (_recentMessageIds.length > _dedupCap) {
      _recentMessageIds.removeAt(0);
    }
    return false;
  }

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    const init = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        // iOS 权限请求由 native AppDelegate 在 push_service 里做, 这里不重复
        // 请求 (会导致两次弹框).
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(
      init,
      // 用户点通知 → flutter_local_notifications fire response, 我们 parse
      // payload (`channelId|channelType` packed string) 转 PushTapEvent
      // emit 到 router. iOS 本地通知 tap 不走 native UNNotificationCenter
      // delegate (那是 APNS path), 走这个 callback.
      onDidReceiveNotificationResponse: (response) {
        final event = PushTapEvent.parseChannelKey(response.payload);
        if (event != null) PushRouter.instance.emit(event);
      },
    );
    // Android 13+ 需要 runtime 权限请求 — manifest 已有 POST_NOTIFICATIONS,
    // 这里走 plugin API 触发 system 对话框.
    if (Platform.isAndroid) {
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await android?.requestNotificationsPermission();
    }
  }

  /// 弹一条 IM 消息的横幅通知. [messageId] 用于 dedup (跟 APNS 已显示 +
  /// SDK 重连补送同条对齐); 留空跳过 dedup. [title] 一般是发送者名,
  /// [body] 是消息预览, [channelKey] 是 `"<id>|<type>"` 给 tap-to-route.
  Future<void> showMessage({
    required int id,
    required String title,
    required String body,
    String messageId = '',
    String? channelKey,
  }) async {
    // app 前台直接 return — 跟 iOS 原版 WKLocalNotificationManager.m:35-38
    // `state == UIApplicationStateActive` return 行为一致. 用户在 app 内
    // 用 chat list 红点提示就够, 弹横幅反而打扰. 这一条覆盖 SDK reconnect
    // 后大量补送离线消息时的横幅风暴 (用户回前台后已经是 resumed 状态).
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    if (lifecycle == AppLifecycleState.resumed) {
      debugPrint('[push][local] app foreground skip messageId=$messageId');
      _seenAndRecord(messageId);
      return;
    }
    if (_withinResumeWindow()) {
      debugPrint('[push][local] resume window skip messageId=$messageId');
      _seenAndRecord(messageId); // 记入 set 避免后续 reconnect 再弹
      return;
    }
    if (_seenAndRecord(messageId)) {
      debugPrint('[push][local] dedup skip messageId=$messageId');
      return;
    }
    if (!_initialized) await init();
    const android = AndroidNotificationDetails(
      'foxtalk_messages',
      '聊天消息',
      channelDescription: '收到新聊天消息时显示',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
      // 聊天通知合并 — 同 channelKey 的多条消息合并到一个通知, 避免刷屏.
      groupKey: 'foxtalk_messages_group',
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: android, iOS: ios),
      payload: channelKey,
    );
  }
}

/// 推送服务 — 拿 device_token + 上报 server.
/// **平台分支**:
///   * iOS  走 `flutter_apns_only`,  device_type=`"IOS"`     (server `DeviceTypeIOS`)
///   * Android 走 `firebase_messaging`, device_type=`"Firebase"` (server `DeviceTypeFirebase`)
/// **对齐 iOS 原版** `AppDelegate.m -application:didRegisterForRemoteNotificationsWithDeviceToken:`
/// + `WKAppDelegate.m registerForRemoteNotifications` 的 token 上报链路.
/// **server 端**:
///   * iOS APNS — configure your own APNS Auth Key / certificate on the server.
///   * Android FCM — configure your own Firebase project and service account.
///   * Client-side Firebase config files are deployment-specific and should not
///     be committed to the public repository.
/// **lifecycle**:
///   * `start(gateway)` 在 login 成功后 (`_activateSession` 内) 调.
///     iOS: 注册 APNS → token callback → 上报.
///     Android: Firebase init → request permission → getToken → 上报.
///     已 register 过 (同一 process) 直接返回, 不重复注册.
///   * `stop()` 在 logout / kicked 路径调.
///     调 `unregisterDeviceToken` 告知 server 别再推, 然后释放 plugin 句柄.
class PushService {
  PushService();

  static const String _bundleId = 'com.chatim.foxtalk';

  ChatSocialGateway? _gateway;
  String? _lastReportedToken;
  bool _started = false;

  // iOS — 走 native MethodChannel 拿 raw APNS deviceToken (替代
  // flutter_apns_only plugin, 1.6.0 swizzle 跟 iOS 26 不兼容拿不到 token).
  // native 实现在 ios/Runner/AppDelegate.swift `registerPushChannel`.
  static const MethodChannel _iosChannel = MethodChannel('foxtalk/push');

  // Android (FCM)
  StreamSubscription<String>? _fcmTokenSub;
  StreamSubscription<RemoteMessage>? _fcmOnMessageSub;
  StreamSubscription<RemoteMessage>? _fcmOpenedSub;

  // iOS PushKit VoIP token (CallKitBridge.onVoipTokenChange) — 独立于 alert
  // APNS token. plugin event channel actionDidUpdateDevicePushTokenVoip 触发
  // 后转发到 backend `voip_device_token` 字段. AppDelegate.swift pushRegistry
  // didUpdate credentials → SwiftFlutterCallkitIncomingPlugin.setDevicePushTokenVoIP
  // → plugin event → CallKitBridge → 这里上报.
  StreamSubscription<String>? _voipTokenSub;
  String? _lastReportedVoipToken;

  /// login 后启动: 注册 push channel + 拿 token + 上报 server.
  /// 重复调用幂等 (同一 process 内只跑一次).
  Future<void> start(ChatSocialGateway gateway) async {
    if (_started) {
      _gateway = gateway;
      // gateway 换了 (e.g. 切账号同进程), 强制重报当前 token
      if (_lastReportedToken != null) {
        unawaited(_reportToken(_lastReportedToken!, _deviceTypeForPlatform()));
      }
      return;
    }
    _started = true;
    _gateway = gateway;
    try {
      if (Platform.isIOS) {
        await _startIOS();
      } else if (Platform.isAndroid) {
        await _startAndroid();
      } else {
        debugPrint(
          '[push] platform ${Platform.operatingSystem} not supported, skip',
        );
      }
    } catch (e, st) {
      debugPrint('[push] start fail: $e\n$st');
      _started = false;
    }
  }

  /// logout / kicked 时调: 通知 server 不要再推, 释放 plugin.
  /// 失败静默 (网络 / server 错误不影响 logout 主流程).
  Future<void> stop() async {
    if (!_started) return;
    _started = false;
    final gateway = _gateway;
    final token = _lastReportedToken;
    _gateway = null;
    _lastReportedToken = null;
    if (gateway != null && token != null) {
      try {
        await gateway.unregisterDeviceToken();
        debugPrint('[push] unregister token OK');
      } catch (e) {
        debugPrint('[push] unregister fail (ignored): $e');
      }
    }
    // iOS — 卸载 method channel handler, token 还在 native cache 但下次
    // start 时 setMethodCallHandler 会覆盖.
    if (Platform.isIOS) {
      _iosChannel.setMethodCallHandler(null);
    }
    // Android
    await _fcmTokenSub?.cancel();
    await _fcmOnMessageSub?.cancel();
    await _fcmOpenedSub?.cancel();
    _fcmTokenSub = null;
    _fcmOnMessageSub = null;
    _fcmOpenedSub = null;
    // iOS VoIP — 释放 PushKit token 订阅 + polling
    await _voipTokenSub?.cancel();
    _voipTokenSub = null;
    _voipTokenPollTimer?.cancel();
    _voipTokenPollTimer = null;
    _lastReportedVoipToken = null;
  }

  /// 订阅 iOS PKPushRegistry VoIP token. 三道保险:
  ///   1. plugin event channel listen — Apple 返回 token 时 plugin fire 事件
  ///   2. CallKitBridge.initialize() 内 getDevicePushTokenVoIP() poll cached
  ///   3. 30s 轮询兜底 — Apple 返回 token 是异步的, _startIOS 跑时 (login
  ///      完成后, 通常 cold-start 1-3 秒内) Apple 可能还没返回. 1+2 都拿不
  ///      到时, periodic 重试直到拿到 (或 30s 超时放弃 — 说明 PushKit 真没
  ///      issue, 多半 App ID capability 没开 Push Notifications 或 entitlement
  ///      问题).
  void _subscribeVoipToken() {
    if (kCallKitDisabled) return; // flag 关 CallKit, VoIP token 没意义
    if (_voipTokenSub != null) return; // idempotent
    final bridge = CallKitBridge.instance;
    _voipTokenSub = bridge.onVoipTokenChange.listen((token) {
      debugPrint('[push][voip] onVoipTokenChange len=${token.length}');
      if (token.isNotEmpty) {
        unawaited(_reportVoipToken(token));
      }
    });
    // 主动调 bridge.initialize() — 防 HomeShell mount 比 push_service.start
    // 晚 (理论上 initialize 是 idempotent, 重复调安全), 让 plugin event listener
    // 立即起来, 同时触发一次 poll.
    unawaited(bridge.initialize());
    // listen 后已经被 plugin 缓存的 token 不会通过 broadcast stream 重发,
    // 手动 fetch 一次.
    if (bridge.currentVoipToken.isNotEmpty) {
      debugPrint(
        '[push][voip] cached token at subscribe time len=${bridge.currentVoipToken.length}',
      );
      unawaited(_reportVoipToken(bridge.currentVoipToken));
      return;
    }
    // Periodic retry — Apple async issue VoIP token, 早 poll 太早. 2s 一次,
    // 最多 15 次 (30s). 拿到 token 立即停, 上报. 30s 还没拿到放弃 (log warn).
    _startVoipTokenPolling();
  }

  Timer? _voipTokenPollTimer;

  void _startVoipTokenPolling() {
    _voipTokenPollTimer?.cancel();
    var attempts = 0;
    _voipTokenPollTimer = Timer.periodic(const Duration(seconds: 2), (
      timer,
    ) async {
      attempts++;
      if (_lastReportedVoipToken != null) {
        timer.cancel();
        return;
      }
      try {
        final token = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
        if (token is String && token.isNotEmpty) {
          debugPrint(
            '[push][voip] poll attempt=$attempts got token len=${token.length}',
          );
          timer.cancel();
          unawaited(_reportVoipToken(token));
          return;
        }
      } catch (e) {
        debugPrint('[push][voip] poll attempt=$attempts error: $e');
      }
      if (attempts >= 15) {
        timer.cancel();
        debugPrint(
          '[push][voip] giving up after 30s — Apple never returned VoIP token. '
          '检查: App ID Push capability / aps-environment entitlement / '
          'UIBackgroundModes voip / 设备 push 权限是否允许.',
        );
      }
    });
  }

  Future<void> _startIOS() async {
    debugPrint('[push][ios] _startIOS BEGIN');
    // 注册 native MethodCallHandler 接收 `onToken` (`didRegisterForRemote
    // NotificationsWithDeviceToken` 触发) — token 是 64-char hex string.
    // 同时接收 `onNotificationTap` (tap-to-route, native AppDelegate
    // `userNotificationCenter:didReceive:` 触发) — emit 到 PushRouter.
    _iosChannel.setMethodCallHandler((call) async {
      if (call.method == 'onToken' && call.arguments is String) {
        final t = call.arguments as String;
        debugPrint('[push][ios] onToken received len=${t.length}');
        if (t.isNotEmpty) unawaited(_reportToken(t, 'IOS'));
      } else if (call.method == 'onError') {
        debugPrint('[push][ios] native error: ${call.arguments}');
      } else if (call.method == 'onNotificationTap') {
        final args = call.arguments as Map?;
        if (args != null) {
          final channelId = args['channel_id'] as String? ?? '';
          final channelType = args['channel_type'] as int? ?? 0;
          final cmd = args['cmd'] as String? ?? '';
          final isRtc = cmd == 'rtc.p2p.invoke' || cmd == 'room.invoke';
          if (channelId.isNotEmpty || isRtc) {
            PushRouter.instance.emit(
              PushTapEvent(
                channelId: channelId,
                channelType: channelType,
                fromUid: args['from_uid'] as String? ?? '',
                isRtcInvite: isRtc,
                callType: args['call_type'] is int
                    ? args['call_type'] as int
                    : (args['call_type'] is num
                          ? (args['call_type'] as num).toInt()
                          : 0),
              ),
            );
          }
        }
      }
    });
    try {
      // **Cold-start tap drain** — Dart 端 `setMethodCallHandler` 是异步注册,
      // native 端 SceneDelegate / AppDelegate 收到 cold-start push tap 时
      // Dart handler 可能还没 ready, 被缓存到 `pendingTapPayload`. 这里
      // 立即 `consumeInitialTap` 拉缓存, 走跟 `onNotificationTap` 同款
      // PushRouter emit 路径. 没缓存返 null, no-op.
      try {
        final initial = await _iosChannel.invokeMethod<Map<dynamic, dynamic>>(
          'consumeInitialTap',
        );
        if (initial != null && initial.isNotEmpty) {
          final channelId = initial['channel_id'] as String? ?? '';
          final channelType = initial['channel_type'] as int? ?? 0;
          final cmd = initial['cmd'] as String? ?? '';
          final isRtc = cmd == 'rtc.p2p.invoke' || cmd == 'room.invoke';
          if (channelId.isNotEmpty || isRtc) {
            debugPrint('[push][ios] consumeInitialTap → emit RTC=$isRtc');
            PushRouter.instance.emit(
              PushTapEvent(
                channelId: channelId,
                channelType: channelType,
                fromUid: initial['from_uid'] as String? ?? '',
                isRtcInvite: isRtc,
                callType: initial['call_type'] is int
                    ? initial['call_type'] as int
                    : (initial['call_type'] is num
                          ? (initial['call_type'] as num).toInt()
                          : 0),
              ),
            );
          }
        }
      } catch (e) {
        debugPrint('[push][ios] consumeInitialTap error: $e');
      }
      // requestPermission 弹"允许通知"对话框 + 注册 APNS (用户首次 launch).
      // 拒绝后 returns false, token 永远 null, 跟 iOS 原版同行为.
      final granted = await _iosChannel.invokeMethod<bool>(
        'requestPermissionAndRegister',
      );
      debugPrint('[push][ios] permission granted=$granted');
      // 已经早于 system fire (e.g. 二次启动 native cache 在), 主动 pull.
      final token = await _iosChannel.invokeMethod<String>('getToken');
      debugPrint('[push][ios] getToken returned len=${token?.length ?? -1}');
      if (token != null && token.isNotEmpty) {
        unawaited(_reportToken(token, 'IOS'));
      }
      // 同步订阅 PushKit VoIP token. AppDelegate.swift 在
      // didFinishLaunchingWithOptions 内已 init PKPushRegistry, 一旦
      // Apple 返回 voip token, plugin 转发到 CallKitBridge.onVoipTokenChange,
      // 这里 listen + 上报 server. cold-start subscribe 时若 token 已 cache,
      // _subscribeVoipToken 内手动 fetch + 上报兜底 (broadcast stream 不重发).
      _subscribeVoipToken();
    } catch (e) {
      debugPrint('[push][ios] start error: $e');
    }
    debugPrint('[push][ios] _startIOS END');
  }

  Future<void> _startAndroid() async {
    // Firebase.initializeApp reads deployment-specific configuration supplied
    // by the app owner. If another path already initialized Firebase, this
    // call reuses the existing instance.
    await Firebase.initializeApp();
    // RTC 邀请 FCM 后台 handler — high-priority data message (cmd=rtc.p2p.invoke
    // / room.invoke) 触发时弹 system CallKit / ConnectionService 全屏来电.
    // 锁屏 + 杀进程都唤起, 跟 iOS PushKit pushRegistry didReceiveIncomingPushWith
    // 对称. **必须**在 onMessage / getToken 等 listener 之前 register, 后台
    // isolate 找不到 handler 会丢这次唤醒. 见 fcm_call_background_handler.dart.
    //
    // **FEATURE FLAG**: kCallKitDisabled=true 时不 register, bg handler 内部
    // 也有 flag 双保险. 见 callkit_bridge.dart kCallKitDisabled 注释.
    if (!kCallKitDisabled) {
      FirebaseMessaging.onBackgroundMessage(foxtalkFcmBackgroundHandler);
    }
    final messaging = FirebaseMessaging.instance;
    // Android 13+ 需要 runtime 权限 (manifest 已加 POST_NOTIFICATIONS),
    // 老版本 (12 及以下) 该方法直接返回 authorized 不弹框.
    await messaging.requestPermission();
    final token = await messaging.getToken();
    if (token != null && token.isNotEmpty) {
      unawaited(_reportToken(token, 'FIREBASE'));
    }
    // FCM token 有时会 refresh (server-side 重置 / Firebase 内部触发).
    _fcmTokenSub = messaging.onTokenRefresh.listen((t) {
      if (t.isNotEmpty) {
        unawaited(_reportToken(t, 'FIREBASE'));
      }
    });
    // 前台收消息 — Firebase 默认前台不展示通知. 留接口给未来接
    // flutter_local_notifications 显横幅 (现在先 noop, 用 SDK 长连接).
    _fcmOnMessageSub = FirebaseMessaging.onMessage.listen((msg) {
      debugPrint('[push] fg msg from=${msg.from} data=${msg.data}');
    });
    // tap-to-route — app 杀进程时被点 push 启动, getInitialMessage 拿
    // 当前启动的 push payload (用过一次后 Firebase 自动清掉, 不会重复 fire).
    final initial = await messaging.getInitialMessage();
    if (initial != null) {
      _emitFcmTap(initial);
    }
    // app 后台被点 push 唤醒 (非首次启动) 走 onMessageOpenedApp.
    _fcmOpenedSub = FirebaseMessaging.onMessageOpenedApp.listen(_emitFcmTap);
  }

  /// FCM data fields → PushTapEvent. Android FCM `Data` 全是 string, channel_type
  /// 是 server 端 `fmt.Sprintf("%d", ...)` 出来, parse 回 int.
  void _emitFcmTap(RemoteMessage msg) {
    final data = msg.data;
    final channelId = data['channel_id'] as String? ?? '';
    final cmd = data['cmd'] as String? ?? '';
    final isRtc = cmd == 'rtc.p2p.invoke' || cmd == 'room.invoke';
    if (channelId.isEmpty && !isRtc) return;
    final channelTypeStr = data['channel_type'] as String? ?? '0';
    final channelType = int.tryParse(channelTypeStr) ?? 0;
    final callTypeStr = data['call_type'] as String? ?? '0';
    PushRouter.instance.emit(
      PushTapEvent(
        channelId: channelId,
        channelType: channelType,
        fromUid: data['from_uid'] as String? ?? '',
        isRtcInvite: isRtc,
        callType: int.tryParse(callTypeStr) ?? 0,
      ),
    );
  }

  /// 同步桌面图标 badge — 对齐 iOS 原版 WKApp.m:638 `appDidEnterBackground`
  /// 调 `setApplicationIconBadgeNumber:unreadCount`. server `/user/device_badge`
  /// 只决定**下次 push 时**塞到 APNS badge 字段, 不立即更新桌面图标. 用户读完
  /// 消息但不收新 push → 桌面 icon 角标永远不减. 必须 native 调一下.
  /// Android 端 launcher icon badge 由 FCM notification channel 自动管, 不需要.
  /// static 方便 UI 层 (home_shell `_syncBadge`) 直接调, 不用拿 PushService
  /// 实例.
  static Future<void> setIconBadge(int count) async {
    if (!Platform.isIOS) return;
    try {
      await _iosChannel.invokeMethod('setBadge', count);
    } catch (e) {
      debugPrint('[push] setBadge fail: $e');
    }
  }

  Future<void> _reportToken(String token, String deviceType) async {
    if (_lastReportedToken == token) return;
    final gateway = _gateway;
    if (gateway == null) return;
    try {
      await gateway.registerDeviceToken(
        token: token,
        deviceType: deviceType,
        bundleId: _bundleId,
      );
      _lastReportedToken = token;
      debugPrint(
        '[push] register device_token len=${token.length} type=$deviceType OK',
      );
    } catch (e) {
      debugPrint('[push] register fail: $e');
    }
  }

  /// iOS PushKit VoIP token 上报. 跟 _reportToken 同结构, 但只 set
  /// voip_device_token 字段 — server 端 Hmset 不动其他字段, 跟 alert token
  /// 独立轨道.
  Future<void> _reportVoipToken(String voipToken) async {
    if (_lastReportedVoipToken == voipToken) return;
    final gateway = _gateway;
    if (gateway == null) return;
    try {
      await gateway.registerVoipDeviceToken(voipToken);
      _lastReportedVoipToken = voipToken;
      debugPrint(
        '[push][voip] register voip_device_token len=${voipToken.length} OK',
      );
    } catch (e) {
      debugPrint('[push][voip] register fail: $e');
    }
  }

  String _deviceTypeForPlatform() {
    if (Platform.isIOS) return 'IOS';
    if (Platform.isAndroid) return 'FIREBASE';
    return '';
  }
}
