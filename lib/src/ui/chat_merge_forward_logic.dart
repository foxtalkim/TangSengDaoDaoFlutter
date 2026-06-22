import '../chat/chat_message.dart';
import '../im/wukong_im_service.dart';
import '../l10n/app_localizations.dart';
import '../media/chat_media_service.dart';
import '../social/social_service.dart';
import 'chat_rich_message_bubbles.dart';
import 'identity_display.dart';

/// 合并转发气泡 / 详情页标题的本地化解析 (修 #9: 替代 service 层
/// `WKMergeForwardContent.resolveTitle()` 烤死的中文 `message.mergeForwardTitle`)。
/// 逻辑跟 resolveTitle 一致, 但走 AppLocalizations, 避免中英混杂。
/// raw 数据 (sourceChannelType + users) 已随 message 透传, 在 UI 层重解析。
String localizedMergeForwardTitle(AppLocalizations t, ChatMessage message) {
  if (message.mergeForwardSourceChannelType != 1) {
    return t.chatMergeForwardTitleGroup;
  }
  final names = message.mergeForwardUsers
      .map((u) => (u['name'] ?? u['display_name'] ?? '').toString().trim())
      .where((s) => s.isNotEmpty)
      .toList(growable: false);
  if (names.isEmpty) return t.chatMergeForwardTitleDefault;
  if (names.length == 1) return t.chatMergeForwardTitleOne(names[0]);
  return t.chatMergeForwardTitleTwo(names[0], names[1]);
}

List<Map<String, dynamic>> mergeForwardUsersForMessages({
  required List<ChatMessage> messages,
  required String loginUid,
  required String loginName,
  required bool isPersonChannel,
  required String peerUid,
  required String peerName,
}) {
  final seen = <String>{};
  final result = <Map<String, dynamic>>[];
  for (final message in messages) {
    final uid = message.fromUid.isEmpty
        ? (message.isMine ? loginUid : '')
        : message.fromUid;
    if (uid.isEmpty || !seen.add(uid)) continue;
    var name = message.fromName.trim();
    if (name.isEmpty) {
      if (message.isMine) {
        name = loginName.trim();
      } else if (isPersonChannel && uid == peerUid) {
        name = peerName;
      }
    }
    result.add({'uid': uid, 'name': name});
  }
  return result;
}

MergeForwardEntry chatMessageToMergeForwardEntry({
  required ChatMessage message,
  required int sourceChannelType,
  required String loginUid,
  required String loginName,
  required bool isPersonChannel,
  required String peerUid,
  required String peerName,
  required List<ChatContact> groupMembers,
  required AppLocalizations l10n,
}) {
  final inferredContentType = message.contentType > 0
      ? message.contentType
      : inferMergeForwardContentType(message);
  final payload = buildMergeForwardPayload(
    message,
    sourceChannelType: sourceChannelType,
  );
  final resolvedContentType = isMergeForwardFallbackType(inferredContentType)
      ? 1
      : inferredContentType;
  final uid = message.fromUid.isEmpty
      ? (message.isMine ? loginUid : '')
      : message.fromUid;
  var fromName = message.fromName.trim();
  if (fromName.isEmpty) {
    if (message.isMine) {
      fromName = loginName.trim();
    } else if (isPersonChannel && uid == peerUid) {
      fromName = peerName;
    } else if (!isPersonChannel && uid.isNotEmpty) {
      for (final member in groupMembers) {
        if (member.uid == uid) {
          fromName = moyuDisplayName(
            remark: member.remark,
            name: member.name,
            rawIdentity: member.uid,
            placeholder: '',
          );
          break;
        }
      }
    }
  }
  return MergeForwardEntry(
    messageId: message.messageId,
    timestamp: message.timestamp,
    fromUid: uid,
    fromName: fromName,
    contentType: resolvedContentType,
    payload: payload,
    digest: message.effectiveText.isEmpty
        ? mergeForwardDigestFromPayload(resolvedContentType, payload, l10n)
        : message.effectiveText,
  );
}

int inferMergeForwardContentType(ChatMessage message) {
  if (message.cardUid.isNotEmpty) return 7;
  if (message.attachment == null) return 1;
  switch (message.kind) {
    case ChatMediaKind.image:
      return 2;
    case ChatMediaKind.voice:
      return 4;
    case ChatMediaKind.video:
      return 5;
    case ChatMediaKind.file:
      return 8;
    case ChatMediaKind.sticker:
      return 13;
    case ChatMediaKind.livePhoto:
      return 15;
  }
}

Map<String, dynamic> buildMergeForwardPayload(
  ChatMessage message, {
  required int sourceChannelType,
}) {
  if (message.data.isNotEmpty) return Map<String, dynamic>.from(message.data);
  final attachment = message.attachment;
  final type = message.contentType > 0
      ? message.contentType
      : inferMergeForwardContentType(message);
  switch (type) {
    case 1:
      return {'content': message.effectiveText};
    case 2:
    case 3:
      if (attachment != null) {
        return {
          'url': attachment.remoteUrl,
          'width': attachment.width,
          'height': attachment.height,
        };
      }
      return {'url': '', 'width': 0, 'height': 0};
    case 4:
      if (attachment != null) {
        return {
          'url': attachment.remoteUrl,
          'timeTrad': attachment.durationSeconds,
        };
      }
      return {'url': '', 'timeTrad': 0};
    case 5:
      if (attachment != null) {
        return {
          'url': attachment.remoteUrl,
          'cover': attachment.coverUrl,
          'second': attachment.durationSeconds,
          'width': attachment.width,
          'height': attachment.height,
        };
      }
      return {'url': '', 'cover': '', 'second': 0};
    case 7:
      return {
        'uid': message.cardUid,
        'name': message.cardName,
        if (message.cardVercode.isNotEmpty) 'vercode': message.cardVercode,
      };
    case 8:
      if (attachment != null) {
        return {
          'url': attachment.remoteUrl,
          'name': message.fileName.isEmpty
              ? attachment.fileName
              : message.fileName,
        };
      }
      return {'url': '', 'name': message.fileName};
    case 11:
      final content = WKMergeForwardContent()
        ..sourceChannelType = message.mergeForwardSourceChannelType > 0
            ? message.mergeForwardSourceChannelType
            : sourceChannelType
        ..users = message.mergeForwardUsers
        ..msgs = message.mergeForwardEntries;
      return content.encodeJson();
    default:
      return {
        'content': message.effectiveText.isEmpty
            ? '[消息]'
            : message.effectiveText,
      };
  }
}

bool isMergeForwardFallbackType(int contentType) {
  const supported = {1, 2, 3, 4, 5, 7, 8, 11};
  return !supported.contains(contentType);
}
