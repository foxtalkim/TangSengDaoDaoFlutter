/// Core call gateway contract.
/// Keep this file free of LiveKit / CallKit / platform plugin imports so the
/// app shell can still compile when `RtcModule` is not registered or exported.
/// The RTC module owns the concrete LiveKit implementation.
class ChatActiveRoom {
  const ChatActiveRoom({required this.roomId, this.callType = 0});

  final String roomId;
  final int callType;
}

abstract interface class ChatCallGateway {
  Stream<ChatCallState> get callStates;

  Stream<void> get videoTrackEvents;

  Stream<bool> get reconnectingEvents;

  Object? get currentLocalVideoTrack;

  Object? get currentRemoteVideoTrack;

  Object? remoteVideoTrackOf(String uid);

  Set<String> get remoteParticipantUids;

  Set<String> get speakingUids;

  Set<String> get mutedUids;

  Future<void> flipCamera();

  Future<CallPermissionResult> ensureCallPermissions(ChatCallType type);

  Future<ChatCallState> startP2pCall({
    required String peerId,
    required String peerName,
    required ChatCallType type,
  });

  Future<void> hangup({
    required String peerId,
    required ChatCallType type,
    required bool isCaller,
    int seconds = 0,
  });

  Future<void> accept({
    required String peerId,
    required String peerName,
    required ChatCallType type,
    String roomId = '',
  });

  Future<void> refuse({required String peerId, required ChatCallType type});

  Future<void> cancel({required String peerId, required ChatCallType type});

  Future<void> requestSwitchToVideo(String peerId);

  Future<void> replySwitchToVideo(String peerId, bool agree);

  Future<void> requestSwitchToVoice(String peerId);

  void notifyPeerAccepted({
    required String peerName,
    required ChatCallType type,
  });

  void notifyPeerEnded({
    required String peerName,
    required ChatCallType type,
    String message,
  });

  Future<void> setMicrophoneEnabled(bool enabled);

  Stream<List<Object>> get onAudioDeviceChange;

  Future<List<Object>> audioOutputs();

  Future<void> setCameraEnabled(bool enabled);

  Future<void> setSpeakerphoneOn(bool enabled);

  Future<String> createGroupCall({
    String name = '',
    List<String> uids = const [],
    bool inviteOnly = false,
    String channelId = '',
    int channelType = 0,
    int callType = 0,
  });

  Future<(ChatCallState, String roomId)> startGroupCall({
    required List<String> invitedUids,
    required ChatCallType type,
    required String channelId,
    required int channelType,
    required String groupName,
  });

  Future<void> disconnectActiveRoom();

  Future<void> dispose();

  Future<ChatActiveRoom?> queryActiveGroupCall({
    required String channelId,
    required int channelType,
  });

  Future<void> acceptGroupCall({
    required String roomId,
    required String groupName,
    required ChatCallType type,
  });

  Future<void> inviteToCall({
    required String roomId,
    required List<String> uids,
  });

  Future<Object> prejoinCall(String roomId);

  Future<void> hangupCall(String roomId);

  Future<void> refuseCall(String roomId);

  Future<void> markCallJoined(String roomId);
}

enum ChatCallType { audio, video }

enum ChatCallStatus { ringing, connected, ended, failed }

enum CallPermissionResult { granted, denied, permanentlyDenied }

class ChatCallState {
  const ChatCallState({
    required this.peerName,
    required this.status,
    required this.type,
    this.message = '',
  });

  final String peerName;
  final ChatCallStatus status;
  final ChatCallType type;
  final String message;

  String get statusLabel {
    return switch (status) {
      ChatCallStatus.ringing => '等待接听',
      ChatCallStatus.connected => '通话中',
      ChatCallStatus.ended => '已挂断',
      ChatCallStatus.failed => message.isEmpty ? '通话失败' : message,
    };
  }

  ChatCallState copyWith({
    String? peerName,
    ChatCallStatus? status,
    ChatCallType? type,
    String? message,
  }) {
    return ChatCallState(
      peerName: peerName ?? this.peerName,
      status: status ?? this.status,
      type: type ?? this.type,
      message: message ?? this.message,
    );
  }
}
