library;

import 'dart:async';

typedef BackgroundMessageHandler = Future<void> Function(RemoteMessage message);

class FirebaseMessaging {
  FirebaseMessaging._();

  static final FirebaseMessaging instance = FirebaseMessaging._();
  static final StreamController<RemoteMessage> _onMessage =
      StreamController<RemoteMessage>.broadcast();
  static final StreamController<RemoteMessage> _onMessageOpenedApp =
      StreamController<RemoteMessage>.broadcast();

  static Stream<RemoteMessage> get onMessage => _onMessage.stream;
  static Stream<RemoteMessage> get onMessageOpenedApp =>
      _onMessageOpenedApp.stream;

  static void onBackgroundMessage(BackgroundMessageHandler handler) {}

  final StreamController<String> _tokenRefresh =
      StreamController<String>.broadcast();

  Stream<String> get onTokenRefresh => _tokenRefresh.stream;

  Future<NotificationSettings> requestPermission() async {
    return const NotificationSettings();
  }

  Future<String?> getToken() async => null;

  Future<RemoteMessage?> getInitialMessage() async => null;
}

class NotificationSettings {
  const NotificationSettings();
}

class RemoteMessage {
  const RemoteMessage({this.data = const {}, this.from});

  final Map<String, dynamic> data;
  final String? from;
}
