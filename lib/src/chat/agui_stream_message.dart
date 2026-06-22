import 'dart:convert';

import 'chat_message.dart';
import '../im/wukong_im_service.dart';
import '../media/chat_media_service.dart';

const aguiStreamDelta = 'stream.delta';
const aguiStreamClose = 'stream.close';
const aguiStreamError = 'stream.error';
const aguiStreamCancel = 'stream.cancel';
const aguiTextMessageStart = '___TextMessageStart';
const aguiTextMessageContent = '___TextMessageContent';
const aguiTextMessageEnd = '___TextMessageEnd';
const aguiStreamingKey = chatMessageAguiStreamingKey;
const aguiStreamingPlaceholderKey = chatMessageAguiStreamingPlaceholderKey;

WukongAguiEventSnapshot? aguiEventFromStreamSnapshot(
  WukongMessageSnapshot snapshot,
) {
  final streamNo = _readString(snapshot.data[wukongStreamNoKey]);
  final streamFlag = _readInt(snapshot.data[wukongStreamFlagKey]);
  if (streamNo.isEmpty && streamFlag == 0) {
    return null;
  }
  final clientMsgNo = streamNo.isNotEmpty ? streamNo : snapshot.clientMsgNo;
  if (clientMsgNo.isEmpty) {
    return null;
  }
  final payload = snapshot.data[wukongStreamPayloadKey];
  final eventType = switch (streamFlag) {
    0 => aguiTextMessageStart,
    1 => aguiStreamDelta,
    2 => aguiStreamClose,
    _ => '',
  };
  if (eventType.isEmpty) {
    return null;
  }
  return WukongAguiEventSnapshot(
    channelId: snapshot.channelId,
    channelType: snapshot.channelType,
    fromUid: snapshot.fromUid,
    fromName: snapshot.fromName,
    fromAvatarUrl: snapshot.fromAvatarUrl,
    clientMsgNo: clientMsgNo,
    eventType: eventType,
    delta: streamFlag == 1 ? _streamText(payload, fallback: snapshot.text) : '',
    snapshotText: streamFlag == 2
        ? _streamText(payload, fallback: snapshot.text)
        : '',
    timestamp: snapshot.timestamp,
  );
}

List<ChatMessage> mergeAguiStreamEvent(
  List<ChatMessage> messages,
  WukongAguiEventSnapshot event,
) {
  if (event.clientMsgNo.trim().isEmpty) {
    return messages;
  }
  final index = messages.indexWhere(
    (message) => message.clientMsgNo == event.clientMsgNo,
  );
  final terminal = _isAguiTerminalEvent(event.eventType);

  if (index < 0) {
    if (terminal) {
      return messages;
    }
    return [
      ...messages,
      ChatMessage.left(
        event.delta,
        clientMsgNo: event.clientMsgNo,
        timestamp: event.timestamp,
        fromUid: event.fromUid,
        fromName: event.fromName,
        fromAvatarUrl: event.fromAvatarUrl,
        data: {
          aguiStreamingKey: true,
          aguiStreamingPlaceholderKey: event.delta.trim().isEmpty,
        },
      ),
    ];
  }

  final current = messages[index];
  final nextText = _isAguiDeltaEvent(event.eventType)
      ? current.text + event.delta
      : (event.snapshotText.isNotEmpty ? event.snapshotText : current.text);
  if (terminal && nextText.trim().isEmpty) {
    return [...messages.take(index), ...messages.skip(index + 1)];
  }
  final next = _withAguiText(
    current,
    nextText,
    streaming: !terminal,
    placeholder: !terminal && nextText.trim().isEmpty,
    event: event,
  );
  return [...messages.take(index), next, ...messages.skip(index + 1)];
}

bool _isAguiDeltaEvent(String eventType) {
  return eventType == aguiStreamDelta ||
      eventType == aguiTextMessageStart ||
      eventType == aguiTextMessageContent;
}

bool _isAguiTerminalEvent(String eventType) {
  return eventType == aguiStreamClose ||
      eventType == aguiStreamError ||
      eventType == aguiStreamCancel ||
      eventType == aguiTextMessageEnd;
}

bool isAguiStreamingPlaceholder(ChatMessage message) {
  return message.isAguiStreamingPlaceholder;
}

bool shouldSuppressEmptyInboundSnapshot(WukongMessageSnapshot snapshot) {
  if (snapshot.isMine) return false;
  if (snapshot.text.trim().isNotEmpty ||
      snapshot.editedText.trim().isNotEmpty) {
    return false;
  }
  if (snapshot.revoked) return false;
  if (snapshot.contentType != 0 && snapshot.contentType != 1) return false;
  if (snapshot.kind != WukongMessageKind.text &&
      snapshot.kind != WukongMessageKind.unknown) {
    return false;
  }
  if (snapshot.fileName.isNotEmpty ||
      snapshot.localPath.isNotEmpty ||
      snapshot.remoteUrl.isNotEmpty ||
      snapshot.coverUrl.isNotEmpty ||
      snapshot.livePhotoVideoUrl.isNotEmpty ||
      snapshot.livePhotoVideoLocalPath.isNotEmpty) {
    return false;
  }
  return true;
}

int findMatchingAguiFinalIndex(
  List<ChatMessage> messages,
  WukongMessageSnapshot snapshot,
) {
  if (snapshot.isMine) return -1;
  final snapshotText = snapshot.text.trim();
  if (snapshotText.isEmpty) return -1;
  if (snapshot.contentType != 0 && snapshot.contentType != 1) return -1;
  for (var i = messages.length - 1; i >= 0; i--) {
    final message = messages[i];
    if (!_isAguiStreamMessage(message)) continue;
    if (message.isMine) continue;
    if (message.effectiveText.trim() != snapshotText) continue;
    if (snapshot.fromUid.isNotEmpty && message.fromUid != snapshot.fromUid) {
      continue;
    }
    if (message.timestamp > 0 &&
        snapshot.timestamp > 0 &&
        (message.timestamp - snapshot.timestamp).abs() > 300) {
      continue;
    }
    return i;
  }
  return -1;
}

bool _isAguiStreamMessage(ChatMessage message) {
  return message.data.containsKey(aguiStreamingKey) ||
      message.data.containsKey(aguiStreamingPlaceholderKey);
}

String _streamText(Object? payload, {required String fallback}) {
  final normalized = _normalizePayload(payload);
  if (normalized is Map) {
    final nested = normalized['payload'] ?? normalized['data'];
    if (nested != null) {
      final text = _streamText(nested, fallback: '');
      if (text.isNotEmpty) return text;
    }
    final snapshot = normalized['snapshot'];
    if (snapshot != null) {
      final text = _streamText(snapshot, fallback: '');
      if (text.isNotEmpty) return text;
    }
    for (final key in const ['delta', 'text', 'content']) {
      final value = normalized[key];
      if (value is String && value.isNotEmpty) {
        return value;
      }
    }
  } else if (normalized is String && normalized.isNotEmpty) {
    return normalized;
  }
  final clean = fallback.trim() == '[未知消息]' ? '' : fallback;
  return clean;
}

Object? _normalizePayload(Object? payload) {
  if (payload is String) {
    final trimmed = payload.trim();
    if (trimmed.isEmpty) return '';
    try {
      return jsonDecode(trimmed);
    } catch (_) {
      return payload;
    }
  }
  return payload;
}

String _readString(Object? value) => value?.toString().trim() ?? '';

int _readInt(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim()) ?? 0;
  return 0;
}

ChatMessage _withAguiText(
  ChatMessage message,
  String text, {
  required bool streaming,
  required bool placeholder,
  required WukongAguiEventSnapshot event,
}) {
  final data = <String, Object?>{
    ...message.data,
    aguiStreamingKey: streaming,
    aguiStreamingPlaceholderKey: placeholder,
  };
  if (message.isMine && message.attachment != null) {
    return ChatMessage.rightMedia(
      text,
      kind: message.kind,
      fileName: message.fileName,
      attachment: message.attachment,
      status: message.status,
      messageId: message.messageId,
      messageSeq: message.messageSeq,
      clientMsgNo: message.clientMsgNo,
      timestamp: message.timestamp,
      readed: message.readed,
      readedCount: message.readedCount,
      unreadCount: message.unreadCount,
      contentType: message.contentType,
      callType: message.callType,
      mergeForwardTitle: message.mergeForwardTitle,
      mergeForwardEntries: message.mergeForwardEntries,
      mergeForwardSourceChannelType: message.mergeForwardSourceChannelType,
      mergeForwardUsers: message.mergeForwardUsers,
      cardVercode: message.cardVercode,
      data: data,
      replyToSender: message.replyToSender,
      replyToText: message.replyToText,
      replyToMessageId: message.replyToMessageId,
      replyToRevoked: message.replyToRevoked,
      mentionUids: message.mentionUids,
      mentionAll: message.mentionAll,
      voiceStatus: message.voiceStatus,
      locationLat: message.locationLat,
      locationLng: message.locationLng,
      locationTitle: message.locationTitle,
      locationAddress: message.locationAddress,
      locationImageUrl: message.locationImageUrl,
      revoked: message.revoked,
      revoker: message.revoker,
      editedText: message.editedText,
      editedAt: message.editedAt,
      reactions: message.reactions,
      cardUid: message.cardUid,
      cardName: message.cardName,
      screenshotFromName: message.screenshotFromName,
      replyCount: message.replyCount,
    );
  }
  if (message.isMine) {
    return ChatMessage.right(
      text,
      status: message.status,
      messageId: message.messageId,
      messageSeq: message.messageSeq,
      clientMsgNo: message.clientMsgNo,
      timestamp: message.timestamp,
      readed: message.readed,
      readedCount: message.readedCount,
      unreadCount: message.unreadCount,
      contentType: message.contentType,
      callType: message.callType,
      mergeForwardTitle: message.mergeForwardTitle,
      mergeForwardEntries: message.mergeForwardEntries,
      mergeForwardSourceChannelType: message.mergeForwardSourceChannelType,
      mergeForwardUsers: message.mergeForwardUsers,
      cardVercode: message.cardVercode,
      data: data,
      replyToSender: message.replyToSender,
      replyToText: message.replyToText,
      replyToMessageId: message.replyToMessageId,
      replyToRevoked: message.replyToRevoked,
      mentionUids: message.mentionUids,
      mentionAll: message.mentionAll,
      voiceStatus: message.voiceStatus,
      locationLat: message.locationLat,
      locationLng: message.locationLng,
      locationTitle: message.locationTitle,
      locationAddress: message.locationAddress,
      locationImageUrl: message.locationImageUrl,
      revoked: message.revoked,
      revoker: message.revoker,
      editedText: message.editedText,
      editedAt: message.editedAt,
      reactions: message.reactions,
      cardUid: message.cardUid,
      cardName: message.cardName,
      screenshotFromName: message.screenshotFromName,
      replyCount: message.replyCount,
    );
  }
  return ChatMessage.left(
    text,
    kind: message.attachment == null ? ChatMediaKind.file : message.kind,
    fileName: message.fileName,
    attachment: message.attachment,
    messageId: message.messageId,
    messageSeq: message.messageSeq,
    clientMsgNo: message.clientMsgNo,
    timestamp: message.timestamp > 0 ? message.timestamp : event.timestamp,
    fromUid: message.fromUid.isNotEmpty ? message.fromUid : event.fromUid,
    fromName: message.fromName.isNotEmpty ? message.fromName : event.fromName,
    fromAvatarUrl: message.fromAvatarUrl.isNotEmpty
        ? message.fromAvatarUrl
        : event.fromAvatarUrl,
    contentType: message.contentType,
    callType: message.callType,
    mergeForwardTitle: message.mergeForwardTitle,
    mergeForwardEntries: message.mergeForwardEntries,
    mergeForwardSourceChannelType: message.mergeForwardSourceChannelType,
    mergeForwardUsers: message.mergeForwardUsers,
    cardVercode: message.cardVercode,
    data: data,
    replyToSender: message.replyToSender,
    replyToText: message.replyToText,
    replyToMessageId: message.replyToMessageId,
    replyToRevoked: message.replyToRevoked,
    mentionUids: message.mentionUids,
    mentionAll: message.mentionAll,
    voiceStatus: message.voiceStatus,
    locationLat: message.locationLat,
    locationLng: message.locationLng,
    locationTitle: message.locationTitle,
    locationAddress: message.locationAddress,
    locationImageUrl: message.locationImageUrl,
    revoked: message.revoked,
    revoker: message.revoker,
    editedText: message.editedText,
    editedAt: message.editedAt,
    reactions: message.reactions,
    cardUid: message.cardUid,
    cardName: message.cardName,
    screenshotFromName: message.screenshotFromName,
    replyCount: message.replyCount,
  );
}
