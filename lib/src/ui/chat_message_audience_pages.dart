import 'dart:async';

import 'package:flutter/material.dart';

import '../config/app_config.dart';
import '../im/wukong_im_service.dart' show ChatImGateway;
import '../l10n/app_localizations.dart';
import 'chat_reactions.dart';
import 'detail_scaffold.dart';
import 'identity_display.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

/// "N 人回应" 点赞人列表页. 对齐 iOS WKReactionsListVC.
class ReactionReactorListPage extends StatelessWidget {
  const ReactionReactorListPage({
    super.key,
    required this.reactionUsers,
    required this.onTapUser,
    this.config,
  });

  /// 已 filter isDeleted=1 的 per-user list, 每行 {uid, name, emoji}.
  final List<Map<String, Object>> reactionUsers;
  final AppConfig? config;
  final void Function(String uid, String name) onTapUser;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.chatActionReactedBy(reactionUsers.length),
      children: [
        if (reactionUsers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                t.chatNoReactions,
                style: TextStyle(color: MoyuColors.of(context).textTertiary),
              ),
            ),
          )
        else
          ColoredBox(
            color: MoyuColors.of(context).background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < reactionUsers.length; i++) ...[
                  _ReactionReactorRow(
                    uid: (reactionUsers[i]['uid'] ?? '').toString(),
                    name: (reactionUsers[i]['name'] ?? '').toString(),
                    emoji: (reactionUsers[i]['emoji'] ?? '').toString(),
                    config: config,
                    onTap: () => onTapUser(
                      (reactionUsers[i]['uid'] ?? '').toString(),
                      (reactionUsers[i]['name'] ?? '').toString(),
                    ),
                  ),
                  if (i != reactionUsers.length - 1)
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: MoyuColors.of(context).line,
                      indent: 15 + 40 + 15,
                      endIndent: 15,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ReactionReactorRow extends StatelessWidget {
  const _ReactionReactorRow({
    required this.uid,
    required this.name,
    required this.emoji,
    required this.onTap,
    this.config,
  });

  final String uid;
  final String name;
  final String emoji;
  final AppConfig? config;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = AvatarResolver.user(config: config, uid: uid);
    final displayName = moyuDisplayName(
      name: name,
      rawIdentity: uid,
      placeholder: AppLocalizations.of(context).contactUnknownUser,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MoyuResolvedAvatar.raw(
              label: displayName.characters.first,
              size: 40,
              colors: const [MoyuColors.primary, MoyuColors.primarySoft],
              imageUrl: avatarUrl,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: MoyuColors.of(context).textPrimary,
                ),
              ),
            ),
            Text(
              reactionDisplayEmoji(emoji),
              style: const TextStyle(
                inherit: false,
                fontSize: 28,
                color: Color(0xFF000000),
                fontFamily: 'Apple Color Emoji',
                fontFamilyFallback: [
                  'Noto Color Emoji',
                  'Segoe UI Emoji',
                  'EmojiOne Color',
                  'Twemoji Mozilla',
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// "N 人已读" 已读列表页. 对齐 iOS WKReceiptListVC.
class ReceiptListPage extends StatefulWidget {
  const ReceiptListPage({
    super.key,
    required this.messageId,
    required this.channelId,
    required this.channelType,
    required this.initialReadedCount,
    required this.initialUnreadCount,
    required this.gateway,
    required this.onTapUser,
    this.config,
  });

  final String messageId;
  final String channelId;
  final int channelType;
  final int initialReadedCount;
  final int initialUnreadCount;
  final ChatImGateway gateway;
  final AppConfig? config;
  final void Function(String uid, String name) onTapUser;

  @override
  State<ReceiptListPage> createState() => _ReceiptListPageState();
}

class _ReceiptListPageState extends State<ReceiptListPage> {
  List<Map<String, String>>? _readedUsers;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadReaders());
  }

  Future<void> _loadReaders() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final users = await widget.gateway.queryMessageReceipt(
        messageId: widget.messageId,
        channelId: widget.channelId,
        channelType: widget.channelType,
        readed: true,
      );
      if (!mounted) return;
      setState(() {
        _readedUsers = users;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final users = _readedUsers;
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.chatReadStatusReadCount(
        users?.length ?? widget.initialReadedCount,
      ),
      children: [
        if (_loading && users == null)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator.adaptive()),
          )
        else if (users == null || users.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Center(
              child: Text(
                t.chatNoReadReceipts,
                style: TextStyle(color: MoyuColors.of(context).textTertiary),
              ),
            ),
          )
        else
          ColoredBox(
            color: MoyuColors.of(context).background,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < users.length; i++) ...[
                  _ReceiptListRow(
                    uid: users[i]['uid'] ?? '',
                    name: users[i]['name'] ?? '',
                    config: widget.config,
                    onTap: () => widget.onTapUser(
                      users[i]['uid'] ?? '',
                      users[i]['name'] ?? '',
                    ),
                  ),
                  if (i != users.length - 1)
                    Divider(
                      height: 0.5,
                      thickness: 0.5,
                      color: MoyuColors.of(context).line,
                      indent: 15 + 40 + 15,
                      endIndent: 15,
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _ReceiptListRow extends StatelessWidget {
  const _ReceiptListRow({
    required this.uid,
    required this.name,
    required this.onTap,
    this.config,
  });

  final String uid;
  final String name;
  final AppConfig? config;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final avatarUrl = AvatarResolver.user(config: config, uid: uid);
    final displayName = moyuDisplayName(
      name: name,
      rawIdentity: uid,
      placeholder: AppLocalizations.of(context).contactUnknownUser,
    );
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MoyuResolvedAvatar.raw(
              label: displayName.characters.first,
              size: 40,
              colors: const [MoyuColors.primary, MoyuColors.primarySoft],
              imageUrl: avatarUrl,
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: MoyuColors.of(context).textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
