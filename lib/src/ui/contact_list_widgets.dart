import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../auth/auth_repository.dart' show ChatServerAppConfig;
import '../im/wukong_im_service.dart'
    show kBotFatherUID, kFileHelperUID, kSystemUID;
import '../l10n/app_localizations.dart';
import '../social/social_service.dart' show ChatUserOnlineState;
import '../util/time_format.dart';
import 'models/contact_models.dart';
import 'moyu_theme.dart';
import 'moyu_widgets.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 8),
      child: Text(
        text,
        style: TextStyle(
          color: MoyuColors.of(context).textTertiary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  const ContactTile({
    super.key,
    required this.contact,
    this.presence,
    this.onTap,
    this.onLongPress,
  });

  final UiContact contact;
  final ChatUserOnlineState? presence;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final presenceText = contactPresenceText(
      contact,
      presence,
      AppLocalizations.of(context),
    );
    final row = Container(
      height: presenceText.isEmpty ? 56 : 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: MoyuColors.of(context).background,
      child: Row(
        children: [
          MoyuResolvedAvatar.raw(
            label: contact.avatarLabel,
            size: 40,
            colors: contact.colors,
            online: presence?.online ?? false,
            imageUrl: contact.avatarPath,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        contact.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 15.5,
                          letterSpacing: -0.08,
                          color: MoyuColors.of(context).textPrimary,
                        ),
                      ),
                    ),
                    if (isSystemAccount(contact)) ...[
                      const SizedBox(width: 4),
                      const MoyuOfficialTag(category: 'system'),
                    ] else if (isAIBot(contact)) ...[
                      const SizedBox(width: 4),
                      const MoyuOfficialTag(category: 'ai'),
                    ],
                  ],
                ),
                if (presenceText.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    presenceText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: MoyuColors.of(context).textTertiary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null && onLongPress == null) return row;
    return FTappable(
      onPress: onTap,
      onLongPress: onLongPress,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }
}

String contactPresenceText(
  UiContact contact,
  ChatUserOnlineState? presence,
  AppLocalizations t,
) {
  if (isSystemAccount(contact)) return '';
  final online = presence?.online ?? false;
  final device = onlineDeviceName(presence?.deviceFlag ?? 0, t);
  if (online) return t.contactPresenceOnlineWithDevice(device);

  final lastOffline = presence?.lastOffline ?? 0;
  if (lastOffline <= 0) return '';
  final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final diffSeconds = nowSeconds - lastOffline;
  if (diffSeconds < 60) return t.contactPresenceJustOnlineWithDevice(device);
  if (diffSeconds < 3600) {
    return t.contactPresenceMinutesOnlineWithDevice(diffSeconds ~/ 60, device);
  }
  return t.contactPresenceLastOnline(
    formatOnlineDateForPresence(t, lastOffline),
  );
}

String onlineDeviceName(int deviceFlag, AppLocalizations t) {
  switch (deviceFlag) {
    case 1:
      return t.contactPresenceDeviceWeb;
    case 2:
      return t.contactPresenceDeviceDesktop;
    case 0:
      return t.contactPresenceDeviceMobile;
    default:
      return '';
  }
}

String formatOnlineDateForPresence(AppLocalizations t, int seconds) {
  final date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  final raw =
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')}:'
      '${date.second.toString().padLeft(2, '0')}';
  return formatMomentTime(t, raw);
}

class StaticActionRow extends StatelessWidget {
  const StaticActionRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle = '',
    this.iconColors,
    this.value,
    this.badge = 0,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final List<Color>? iconColors;
  final String? value;
  final int badge;
  final VoidCallback? onTap;

  static const double _rowHeight = 64;

  @override
  Widget build(BuildContext context) {
    final colors = iconColors ?? [iconColor, _lighten(iconColor, 0.15)];
    final hasSubtitle = subtitle.isNotEmpty;
    final row = Container(
      height: _rowHeight,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: MoyuColors.of(context).background,
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.08,
                    color: MoyuColors.of(context).textPrimary,
                  ),
                ),
                if (hasSubtitle) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MoyuColors.of(context).textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (badge > 0)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: MoyuUnreadBadge(count: badge),
            ),
          if (value case final text?)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Text(
                text,
                style: TextStyle(
                  color: MoyuColors.of(context).textTertiary,
                  fontSize: 13,
                ),
              ),
            ),
          if (onTap != null)
            Icon(
              moyuForwardChevronIcon(context),
              color: MoyuColors.of(context).textTertiary,
              size: 16,
            ),
        ],
      ),
    );

    if (onTap == null) return row;
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }

  static Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    final adjusted = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return adjusted.toColor();
  }
}

List<UiContact> contactsAllowedForGroupInvite(
  List<UiContact> contacts,
  ChatServerAppConfig serverAppConfig,
) {
  if (serverAppConfig.inviteSystemAccountJoinGroupOn) return contacts;
  return [
    for (final contact in contacts)
      if (!isSystemAccount(contact)) contact,
  ];
}

String contactChannelId(UiContact contact) =>
    contact.uid.isEmpty ? contact.name : contact.uid;

bool isSystemAccount(UiContact contact) {
  final id = contactChannelId(contact);
  return id == kFileHelperUID || id == kSystemUID || id == kBotFatherUID;
}

bool isSystemFileHelper(UiContact contact) =>
    contactChannelId(contact) == kFileHelperUID;

/// BotFather 是 chatim bot 自助管理入口, 跟 FileHelper 一样自动加好友显示在
/// 通讯录, 但单聊页面不禁用键盘 (用户要发 /newbot 等命令).
bool isBotFather(UiContact contact) =>
    contactChannelId(contact) == kBotFatherUID;

/// AI bot: 通过 BotFather /newbot 创建的用户. 服务端 user.robot=1 + category=''.
/// 区别于系统账号 (robot=1 + category='system'). 渲染层显示 "AI" badge.
bool isAIBot(UiContact contact) {
  return contact.isRobot && !isSystemAccount(contact);
}

/// #10: 系统账号 / 文件传输助手的本地化显示名 — 客户端按 ID 映射 (server 不下发
/// 这俩的用户资料, 名字以前靠 seed 硬编码中文)。返回 null = 非特殊账号,
/// 调用方退回原 name。会话列表 / 聊天标题等显示处统一用它覆盖。
String? specialAccountDisplayName(AppLocalizations t, String id) {
  if (id == kSystemUID) return t.systemAccountName;
  if (id == kFileHelperUID) return t.fileHelperName;
  if (id == kBotFatherUID) return 'BotFather';
  return null;
}
