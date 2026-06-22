library;

import 'dart:async';

import 'entities/call_event.dart';
import 'entities/call_kit_params.dart';

class FlutterCallkitIncoming {
  static final StreamController<CallEvent?> _events =
      StreamController<CallEvent?>.broadcast();

  static Stream<CallEvent?> get onEvent => _events.stream;

  static Future<String?> getDevicePushTokenVoIP() async => null;

  static Future<void> showCallkitIncoming(CallKitParams params) async {}

  static Future<void> endCall(String id) async {}

  static Future<void> endAllCalls() async {}

  static Future<void> setCallConnected(String id) async {}
}
