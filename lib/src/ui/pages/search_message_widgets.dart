import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../config/app_config.dart';
import '../../conversation/chat_conversation.dart';
import '../../l10n/app_localizations.dart';
import '../../social/social_service.dart' show ChatGlobalMessage;
import '../home_seed_data.dart' show conversationColors;
import '../identity_display.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';

/// 把 server 返回的 ChatGlobalMessage 拼成 ChatConversation 占位。
/// 对齐 iOS WKSearchMessageCell.refresh + WKAvatarUtil 头像 URL 规则。
ChatConversation searchConversationFromGlobalMessage({
  required ChatGlobalMessage message,
  required int index,
  required AppConfig? config,
  required AppLocalizations l10n,
}) {
  final channel = message.channel;
  final channelType = channel.channelType == 0 ? 1 : channel.channelType;
  final name = moyuDisplayName(
    name: channel.channelName,
    rawIdentity: channel.channelId,
    placeholder: channelType == 2
        ? l10n.messagesGroupFallback
        : l10n.globalSearchMessagesSection,
  );
  final cleanName = name.replaceAll('<mark>', '').replaceAll('</mark>', '');
  final isSystem = message.contentType >= 1000 && message.contentType <= 2000;
  final preview = isSystem
      ? l10n.chatSystemMessageDigest
      : (message.text.isEmpty
            ? l10n.globalSearchMessagesSection
            : message.text);
  final avatarPath = switch (channelType) {
    1 => AvatarResolver.user(config: config, uid: channel.channelId),
    2 => AvatarResolver.group(config: config, groupNo: channel.channelId),
    _ => '',
  };
  return ChatConversation(
    channelId: channel.channelId,
    channelType: channelType,
    name: cleanName.isEmpty ? l10n.globalSearchMessagesSection : cleanName,
    avatarLabel: cleanName.isEmpty
        ? l10n.globalSearchMessagesSection.characters.first
        : cleanName.characters.first,
    avatarPath: avatarPath,
    preview: preview,
    time: searchMessageTimeText(message.timestamp, l10n),
    colors: conversationColors(index),
    searchAnchorMessageId: message.messageId,
  );
}

/// 频道内搜索专用：头像 / name 用消息发送者，而非所属 channel。
ChatConversation searchConversationFromChannelMessage({
  required ChatGlobalMessage message,
  required int index,
  required AppConfig? config,
  required ChatConversation channelConversation,
  required AppLocalizations l10n,
}) {
  final isSystem = message.contentType >= 1000 && message.contentType <= 2000;
  if (isSystem) {
    return ChatConversation(
      channelId: channelConversation.channelId,
      channelType: channelConversation.channelType,
      name: channelConversation.name,
      avatarLabel: channelConversation.avatarLabel,
      avatarPath: channelConversation.avatarPath,
      preview: l10n.chatSystemMessageDigest,
      time: searchMessageTimeText(message.timestamp, l10n),
      colors: channelConversation.colors,
    );
  }
  final fromUid = message.fromUid;
  final fromName = moyuDisplayName(
    name: message.fromChannel.channelName,
    rawIdentity: fromUid,
    placeholder: l10n.globalSearchMessagesSection,
  );
  final preview = message.text.isEmpty
      ? l10n.globalSearchMessagesSection
      : message.text;
  final avatarPath = AvatarResolver.user(config: config, uid: fromUid);
  return ChatConversation(
    channelId: fromUid,
    channelType: 1,
    name: fromName.isEmpty ? l10n.globalSearchMessagesSection : fromName,
    avatarLabel: fromName.isEmpty
        ? l10n.globalSearchMessagesSection.characters.first
        : fromName.characters.first,
    avatarPath: avatarPath,
    preview: preview,
    time: searchMessageTimeText(message.timestamp, l10n),
    colors: conversationColors(index),
  );
}

/// 对齐 iOS WKTimeTool.getTimeStringAutoShort2。
String searchMessageTimeText(int timestamp, AppLocalizations l10n) {
  if (timestamp <= 0) return '';
  final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final messageDay = DateTime(date.year, date.month, date.day);
  final dayDiff = today.difference(messageDay).inDays;
  if (dayDiff == 0) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
  if (dayDiff == 1) return l10n.dateYesterday;
  if (dayDiff > 1 && dayDiff < 7) {
    return _weekdayShort(l10n, date.weekday);
  }
  if (date.year == now.year) return '${date.month}/${date.day}';
  return '${date.year}/${date.month}/${date.day}';
}

String _weekdayShort(AppLocalizations t, int weekday) => switch (weekday) {
  DateTime.monday => t.dateWeekdayShortMonday,
  DateTime.tuesday => t.dateWeekdayShortTuesday,
  DateTime.wednesday => t.dateWeekdayShortWednesday,
  DateTime.thursday => t.dateWeekdayShortThursday,
  DateTime.friday => t.dateWeekdayShortFriday,
  DateTime.saturday => t.dateWeekdayShortSaturday,
  DateTime.sunday => t.dateWeekdayShortSunday,
  _ => '',
};

class SearchTabChip extends StatelessWidget {
  const SearchTabChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: active
              ? MoyuColors.of(context).primary
              : MoyuColors.of(context).backgroundSoft,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            color: active
                ? MoyuColors.of(context).bubbleSendForeground
                : MoyuColors.of(context).textPrimary,
            letterSpacing: -0.05,
          ),
        ),
      ),
    );
  }
}

class SearchMessageTile extends StatelessWidget {
  const SearchMessageTile({
    super.key,
    required this.conversation,
    required this.keyword,
    required this.onTap,
    this.config,
  });

  final ChatConversation conversation;
  final String keyword;
  final AppConfig? config;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: MoyuColors.of(context).background,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MoyuResolvedAvatar.raw(
              label: conversation.avatarLabel,
              size: 40,
              colors: conversation.colors,
              imageUrl: conversation.avatarPath,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          conversation.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w400,
                            letterSpacing: -0.08,
                            color: MoyuColors.of(context).textPrimary,
                          ),
                        ),
                      ),
                      if (conversation.time.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Text(
                          conversation.time,
                          style: TextStyle(
                            fontSize: 12,
                            color: MoyuColors.of(context).textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  _highlight(
                    text: conversation.preview,
                    keyword: keyword,
                    base: TextStyle(
                      fontSize: 13,
                      color: MoyuColors.of(context).textTertiary,
                      letterSpacing: -0.05,
                    ),
                    highlight: TextStyle(
                      fontSize: 13,
                      color: MoyuColors.of(context).primary,
                      letterSpacing: -0.05,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _highlight({
    required String text,
    required String keyword,
    required TextStyle base,
    required TextStyle highlight,
  }) {
    if (text.isEmpty) {
      return Text(
        '',
        style: base,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }
    final spans = <InlineSpan>[];
    final markRegex = RegExp(r'<mark>(.*?)</mark>');
    final markMatches = markRegex.allMatches(text).toList();
    if (markMatches.isNotEmpty) {
      var cursor = 0;
      for (final m in markMatches) {
        if (m.start > cursor) {
          spans.add(
            TextSpan(text: text.substring(cursor, m.start), style: base),
          );
        }
        spans.add(TextSpan(text: m.group(1) ?? '', style: highlight));
        cursor = m.end;
      }
      if (cursor < text.length) {
        spans.add(TextSpan(text: text.substring(cursor), style: base));
      }
    } else if (keyword.isNotEmpty) {
      final lowerText = text.toLowerCase();
      final lowerKw = keyword.toLowerCase();
      var cursor = 0;
      while (cursor < text.length) {
        final idx = lowerText.indexOf(lowerKw, cursor);
        if (idx < 0) {
          spans.add(TextSpan(text: text.substring(cursor), style: base));
          break;
        }
        if (idx > cursor) {
          spans.add(TextSpan(text: text.substring(cursor, idx), style: base));
        }
        spans.add(
          TextSpan(
            text: text.substring(idx, idx + keyword.length),
            style: highlight,
          ),
        );
        cursor = idx + keyword.length;
      }
    } else {
      spans.add(TextSpan(text: text, style: base));
    }
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: spans),
    );
  }
}
