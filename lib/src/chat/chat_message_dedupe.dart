import 'chat_message.dart';
import '../im/wukong_im_service.dart';
import '../media/chat_media_service.dart';

const int _ownEchoMatchWindowSeconds = 30;

int findOwnOptimisticMessageIndex(
  List<ChatMessage> messages,
  WukongMessageSnapshot snapshot,
) {
  var bestIndex = -1;
  var bestDistance = 1 << 30;
  var fallbackIndex = -1;
  var fallbackCount = 0;
  for (var i = messages.length - 1; i >= 0; i--) {
    final message = messages[i];
    if (!message.isMine) continue;
    if (message.messageId.isNotEmpty || message.clientMsgNo.isNotEmpty) {
      continue;
    }
    if (_isLikelySameOwnMessage(message, snapshot)) {
      final distance = _timestampDistance(message, snapshot);
      if (distance < bestDistance) {
        bestDistance = distance;
        bestIndex = i;
      }
      continue;
    }
    fallbackIndex = i;
    fallbackCount += 1;
  }
  if (bestIndex >= 0) {
    return bestIndex;
  }
  if (snapshot.text.trim().isNotEmpty) {
    return -1;
  }
  return fallbackCount == 1 ? fallbackIndex : -1;
}

int findEquivalentOwnMessageIndex(
  List<ChatMessage> messages,
  WukongMessageSnapshot snapshot,
) {
  for (var i = messages.length - 1; i >= 0; i--) {
    final message = messages[i];
    if (!message.isMine) continue;
    if (_isLikelySameOwnMessage(message, snapshot)) {
      return i;
    }
  }
  return -1;
}

List<ChatMessage> mergeFreshWithLocalMessages(
  List<ChatMessage> fresh,
  List<ChatMessage> current,
) {
  final freshMsgIds = <String>{};
  final freshClientNos = <String>{};
  for (final message in fresh) {
    if (message.messageId.isNotEmpty) freshMsgIds.add(message.messageId);
    if (message.clientMsgNo.isNotEmpty) freshClientNos.add(message.clientMsgNo);
  }
  final localOnly = current.where((message) {
    final coveredById =
        message.messageId.isNotEmpty && freshMsgIds.contains(message.messageId);
    final coveredByClient =
        message.clientMsgNo.isNotEmpty &&
        freshClientNos.contains(message.clientMsgNo);
    final coveredByEquivalentOwnMessage =
        message.isMine &&
        message.messageId.isEmpty &&
        message.clientMsgNo.isEmpty &&
        fresh.any((freshMessage) {
          return _isLikelySameOwnChatMessage(message, freshMessage);
        });
    return !coveredById && !coveredByClient && !coveredByEquivalentOwnMessage;
  }).toList();
  if (localOnly.isEmpty) return fresh;
  return [...fresh, ...localOnly]..sort((a, b) {
    if (a.timestamp != b.timestamp) {
      return a.timestamp.compareTo(b.timestamp);
    }
    return a.messageSeq.compareTo(b.messageSeq);
  });
}

bool _isLikelySameOwnMessage(
  ChatMessage message,
  WukongMessageSnapshot snapshot,
) {
  if (!snapshot.isMine) return false;
  if (!_withinOwnEchoWindow(message.timestamp, snapshot.timestamp)) {
    return false;
  }
  final messageText = message.text.trim();
  final snapshotText = snapshot.text.trim();
  if (messageText.isNotEmpty && messageText == snapshotText) {
    return true;
  }
  return _hasSameMediaIdentity(message, snapshot);
}

bool _isLikelySameOwnChatMessage(ChatMessage local, ChatMessage fresh) {
  if (!local.isMine || !fresh.isMine) return false;
  if (!_withinOwnEchoWindow(local.timestamp, fresh.timestamp)) {
    return false;
  }
  final localText = local.text.trim();
  final freshText = fresh.text.trim();
  if (localText.isNotEmpty && localText == freshText) {
    return true;
  }
  return _hasSameMediaIdentityForMessages(local, fresh);
}

int _timestampDistance(ChatMessage message, WukongMessageSnapshot snapshot) {
  if (message.timestamp <= 0 || snapshot.timestamp <= 0) {
    return 0;
  }
  return (message.timestamp - snapshot.timestamp).abs();
}

bool _withinOwnEchoWindow(int leftTimestamp, int rightTimestamp) {
  if (leftTimestamp <= 0 || rightTimestamp <= 0) {
    return true;
  }
  return (leftTimestamp - rightTimestamp).abs() <= _ownEchoMatchWindowSeconds;
}

bool _hasSameMediaIdentity(
  ChatMessage message,
  WukongMessageSnapshot snapshot,
) {
  final snapshotKind = _chatMediaKindForSnapshot(snapshot.kind);
  if (!_looksLikeMediaMessage(message) || snapshotKind == null) {
    return false;
  }
  if (message.kind != snapshotKind) {
    return false;
  }
  if (_sameNonEmpty(_messageRemoteUrl(message), snapshot.remoteUrl)) {
    return true;
  }
  if (_sameNonEmpty(_messageLocalPath(message), snapshot.localPath)) {
    return true;
  }
  if (_sameNonEmpty(_messageFileName(message), snapshot.fileName)) {
    return true;
  }
  return message.contentType != 0 &&
      snapshot.contentType != 0 &&
      message.contentType == snapshot.contentType;
}

bool _hasSameMediaIdentityForMessages(ChatMessage local, ChatMessage fresh) {
  if (!_looksLikeMediaMessage(local) || !_looksLikeMediaMessage(fresh)) {
    return false;
  }
  if (local.kind != fresh.kind) {
    return false;
  }
  if (_sameNonEmpty(_messageRemoteUrl(local), _messageRemoteUrl(fresh))) {
    return true;
  }
  if (_sameNonEmpty(_messageLocalPath(local), _messageLocalPath(fresh))) {
    return true;
  }
  if (_sameNonEmpty(_messageFileName(local), _messageFileName(fresh))) {
    return true;
  }
  return local.contentType != 0 &&
      fresh.contentType != 0 &&
      local.contentType == fresh.contentType;
}

bool _looksLikeMediaMessage(ChatMessage message) {
  if (message.attachment != null) return true;
  if (message.kind != ChatMediaKind.file) return true;
  return message.contentType != 0 && message.contentType != 1;
}

ChatMediaKind? _chatMediaKindForSnapshot(WukongMessageKind kind) {
  return switch (kind) {
    WukongMessageKind.image => ChatMediaKind.image,
    WukongMessageKind.file => ChatMediaKind.file,
    WukongMessageKind.voice => ChatMediaKind.voice,
    WukongMessageKind.video => ChatMediaKind.video,
    WukongMessageKind.sticker => ChatMediaKind.sticker,
    WukongMessageKind.livePhoto => ChatMediaKind.livePhoto,
    _ => null,
  };
}

String _messageRemoteUrl(ChatMessage message) {
  return message.attachment?.remoteUrl ?? '';
}

String _messageLocalPath(ChatMessage message) {
  return message.attachment?.localPath ?? '';
}

String _messageFileName(ChatMessage message) {
  if (message.fileName.isNotEmpty) return message.fileName;
  return message.attachment?.fileName ?? '';
}

bool _sameNonEmpty(String left, String right) {
  return left.isNotEmpty && left == right;
}
