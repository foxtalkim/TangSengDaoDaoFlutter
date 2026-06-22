import 'package:flutter/widgets.dart';

import '../config/app_config.dart';
import '../conversation/chat_conversation.dart';
import '../im/wukong_im_service.dart';
import '../call/chat_call_gateway.dart';
import '../ui/models/contact_models.dart';

typedef ModuleCallPageBuilder = Widget Function(ModuleCallPageRequest request);
typedef ModuleIncomingCallPageBuilder =
    Widget Function(ModuleIncomingCallPageRequest request);

final class ModuleRtcSessionApi {
  const ModuleRtcSessionApi({
    required this.hasActiveCall,
    required this.endStream,
    required this.end,
    this.init,
    this.disposeAll,
    this.notifyPeerOnExit,
    this.isRoomEnded,
    this.markRoomEnded,
    this.stopRinging,
    this.hangup,
  });

  final bool Function() hasActiveCall;
  final Stream<void> endStream;
  final VoidCallback end;
  final void Function({
    required ChatCallGateway? callGateway,
    required ChatImGateway? imGateway,
  })?
  init;
  final Future<void> Function()? disposeAll;
  final Future<void> Function()? notifyPeerOnExit;
  final bool Function(String roomId)? isRoomEnded;
  final void Function(String roomId)? markRoomEnded;
  final Future<void> Function()? stopRinging;
  final Future<void> Function({required String peerOrRoomId})? hangup;
}

final class ModuleCallPageRequest {
  const ModuleCallPageRequest({
    required this.conversation,
    required this.type,
    this.callGateway,
    this.imGateway,
    this.isIncoming = false,
    this.isGroupCall = false,
    this.invitedContacts = const [],
    this.incomingRoomId = '',
    this.isRestoredFromPip = false,
    this.config,
    this.selfUid = '',
    this.selfName = '',
    this.knownContacts = const [],
  });

  final ChatConversation conversation;
  final ChatCallType type;
  final ChatCallGateway? callGateway;
  final ChatImGateway? imGateway;
  final bool isIncoming;
  final bool isGroupCall;
  final List<UiContact> invitedContacts;
  final String incomingRoomId;
  final bool isRestoredFromPip;
  final AppConfig? config;
  final String selfUid;
  final String selfName;
  final List<UiContact> knownContacts;
}

final class ModuleIncomingCallPageRequest {
  const ModuleIncomingCallPageRequest({
    required this.event,
    required this.peerName,
    required this.avatarLabel,
    required this.avatarColors,
    required this.avatarUrl,
    required this.onAcceptedNavigate,
    required this.onDismiss,
    this.callGateway,
  });

  final IncomingCallEvent event;
  final ChatCallGateway? callGateway;
  final String peerName;
  final String avatarLabel;
  final List<Color> avatarColors;
  final String avatarUrl;
  final void Function(ChatCallType type, String roomId) onAcceptedNavigate;
  final VoidCallback onDismiss;
}
