library;

import 'android_params.dart';
import 'ios_params.dart';
import 'notification_params.dart';

class CallKitParams {
  const CallKitParams({
    required this.id,
    required this.nameCaller,
    this.appName = '',
    this.avatar = '',
    this.handle = '',
    this.type = 0,
    this.duration = 0,
    this.textAccept = '',
    this.textDecline = '',
    this.missedCallNotification,
    this.extra = const {},
    this.ios,
    this.android,
  });

  final String id;
  final String nameCaller;
  final String appName;
  final String avatar;
  final String handle;
  final int type;
  final int duration;
  final String textAccept;
  final String textDecline;
  final NotificationParams? missedCallNotification;
  final Map<String, dynamic> extra;
  final IOSParams? ios;
  final AndroidParams? android;
}
