library;

typedef DidReceiveNotificationResponseCallback =
    void Function(NotificationResponse response);

class FlutterLocalNotificationsPlugin {
  Future<bool?> initialize(
    InitializationSettings initializationSettings, {
    DidReceiveNotificationResponseCallback? onDidReceiveNotificationResponse,
  }) async {
    return false;
  }

  T? resolvePlatformSpecificImplementation<T>() => null;

  Future<void> show(
    int id,
    String? title,
    String? body,
    NotificationDetails? notificationDetails, {
    String? payload,
  }) async {}
}

class NotificationResponse {
  const NotificationResponse({this.payload});

  final String? payload;
}

class InitializationSettings {
  const InitializationSettings({this.android, this.iOS});

  final AndroidInitializationSettings? android;
  final DarwinInitializationSettings? iOS;
}

class AndroidInitializationSettings {
  const AndroidInitializationSettings(this.defaultIcon);

  final String defaultIcon;
}

class DarwinInitializationSettings {
  const DarwinInitializationSettings({
    this.requestAlertPermission = true,
    this.requestBadgePermission = true,
    this.requestSoundPermission = true,
  });

  final bool requestAlertPermission;
  final bool requestBadgePermission;
  final bool requestSoundPermission;
}

class AndroidFlutterLocalNotificationsPlugin {
  Future<bool?> requestNotificationsPermission() async => false;
}

class AndroidNotificationDetails {
  const AndroidNotificationDetails(
    this.channelId,
    this.channelName, {
    this.channelDescription,
    this.importance,
    this.priority,
    this.enableVibration,
    this.playSound,
    this.groupKey,
  });

  final String channelId;
  final String channelName;
  final String? channelDescription;
  final Importance? importance;
  final Priority? priority;
  final bool? enableVibration;
  final bool? playSound;
  final String? groupKey;
}

class DarwinNotificationDetails {
  const DarwinNotificationDetails({
    this.presentAlert,
    this.presentBadge,
    this.presentSound,
  });

  final bool? presentAlert;
  final bool? presentBadge;
  final bool? presentSound;
}

class NotificationDetails {
  const NotificationDetails({this.android, this.iOS});

  final AndroidNotificationDetails? android;
  final DarwinNotificationDetails? iOS;
}

enum Importance { high }

enum Priority { high }
