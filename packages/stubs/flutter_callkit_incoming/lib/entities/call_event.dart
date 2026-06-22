library;

enum Event {
  actionDidUpdateDevicePushTokenVoip,
  actionCallAccept,
  actionCallDecline,
  actionCallEnded,
  actionCallTimeout,
  actionCallIncoming,
  actionCallStart,
  actionCallConnected,
  actionCallCallback,
  actionCallToggleHold,
  actionCallToggleMute,
  actionCallToggleDmtf,
  actionCallToggleGroup,
  actionCallToggleAudioSession,
  actionCallCustom,
}

class CallEvent {
  const CallEvent({required this.event, this.body});

  final Event event;
  final dynamic body;
}
