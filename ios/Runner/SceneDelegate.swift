import Flutter
import UIKit
import UserNotifications

class SceneDelegate: FlutterSceneDelegate {

  /// Scene-based app cold-start 时, 用户点 push 通知唤起 app — 通知
  /// payload 在 `connectionOptions.notificationResponse` 里, 不在
  /// `UIApplication.application:didFinishLaunchingWithOptions:` 的
  /// `launchOptions[.remoteNotification]` (那是 pre-iOS 13 的路径).
  ///
  /// 把 payload 转给 AppDelegate.handlePushTap → forwardTapToDart →
  /// pending buffer (Dart MethodCallHandler 还没 ready, 等 push channel
  /// register + Dart `consumeInitialTap` 时 flush 出去).
  ///
  /// 点横幅启动 app 但不弹接听 UI 的真正根因之一.
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    if let response = connectionOptions.notificationResponse {
      let userInfo = response.notification.request.content.userInfo
      NSLog("[push][scene] cold-start tap userInfo=\(userInfo)")
      (UIApplication.shared.delegate as? AppDelegate)?.handlePushTap(userInfo: userInfo)
    }
  }
}
