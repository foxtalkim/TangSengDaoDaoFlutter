library;

import 'dart:async';

class ProximitySensor {
  static final StreamController<int> _events =
      StreamController<int>.broadcast();

  static Stream<int> get events => _events.stream;

  static Stream<int> get proximityEvents => events;

  static Future<void> setProximityScreenOff(bool enabled) async {}
}
