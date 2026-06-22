import 'dart:collection';
import 'dart:convert';

import '../proto/packet.dart';

typedef WKEventListener = void Function(WKEvent event);

class WKEvent {
  const WKEvent({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.data,
  });

  final String id;
  final String type;
  final int timestamp;
  final String data;

  Map<String, dynamic>? get dataJson {
    if (data.isEmpty) {
      return null;
    }
    dynamic decoded;
    try {
      decoded = jsonDecode(data);
    } catch (_) {
      return null;
    }
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    if (decoded is Map) {
      return decoded.map((key, value) => MapEntry(key.toString(), value));
    }
    return null;
  }
}

class WKEventManager {
  WKEventManager._privateConstructor();
  static final WKEventManager _instance = WKEventManager._privateConstructor();
  static WKEventManager get shared => _instance;

  final HashMap<String, WKEventListener> _listeners = HashMap();

  void addEventListener(String key, WKEventListener listener) {
    _listeners[key] = listener;
  }

  void removeEventListener(String key) {
    _listeners.remove(key);
  }

  void pushEvent(EventPacket packet) {
    if (_listeners.isEmpty) {
      return;
    }
    final event = WKEvent(
      id: packet.id,
      type: packet.type,
      timestamp: packet.timestamp,
      data: packet.data,
    );
    for (final listener in List<WKEventListener>.from(_listeners.values)) {
      listener(event);
    }
  }
}
