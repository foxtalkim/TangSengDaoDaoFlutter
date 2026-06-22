import 'package:flutter/widgets.dart';

import '../../config/app_config.dart';
import '../../social/social_service.dart';
import '../identity_display.dart';

class UiContact {
  const UiContact({
    this.uid = '',
    required this.name,
    required this.avatarLabel,
    required this.colors,
    this.avatarPath = '',
    this.subtitle = '',
    this.sourceDescription = '',
    this.online = false,
    this.rawName = '',
    this.username = '',
    this.remark = '',
    this.role = 0,
    this.vercode = '',
    this.isRobot = false,
    this.category = '',
  });

  factory UiContact.fromSocial(
    ChatContact contact, {
    required List<Color> colors,
    AppConfig? config,
  }) {
    final name = moyuDisplayName(
      remark: contact.remark,
      name: contact.name,
      rawIdentity: contact.uid,
      placeholder: '未知用户',
    );
    final relativePath = contact.uid.isEmpty
        ? ''
        : (contact.avatar.isEmpty
              ? 'users/${contact.uid}/avatar'
              : contact.avatar);
    final resolved = relativePath.isEmpty
        ? ''
        : (config == null ? relativePath : config.showUrl(relativePath));
    return UiContact(
      uid: contact.uid,
      name: name,
      // Preserve the raw nickname and remark so mention lookup can match
      // either form: e.g. user A may render `@RawName` while user B's
      // contact card has remark `LocalAlias`. Both should resolve.
      rawName: contact.name,
      // username 用于 mention 跳转匹配 (BotFather 回包用 @<username>) +
      // 给 bot 用户作为 secondary identity 显示.
      username: contact.username,
      remark: contact.remark,
      avatarLabel: name.isEmpty ? '友' : name.characters.first,
      avatarPath: resolved,
      subtitle: contact.subtitle,
      sourceDescription: contact.sourceDescription,
      online: contact.online,
      colors: colors,
      role: contact.role,
      vercode: contact.vercode,
      isRobot: contact.isRobot,
      category: contact.category,
    );
  }

  final String uid;
  final String name;
  final String rawName;

  /// 服务端 user.username. 用于 mention 跳转匹配 (BotFather token 消息里
  /// @<username> 点击时 chat_mention_logic 走 candidates 含 username 才能找到).
  final String username;

  final String remark;
  final String avatarLabel;
  final String avatarPath;
  final List<Color> colors;
  final String subtitle;
  final String sourceDescription;
  final bool online;

  /// 0 = normal member, 1 = owner, 2 = manager.
  final int role;

  /// Stranger-only vercode threaded through from `/user/search` or qr
  /// scans. Used as the proof-of-source token when posting
  /// `friend/apply`. Empty for established friends and synthetic rows.
  final String vercode;

  /// 服务端 user.robot=1. 决定渲染 badge:
  ///   isRobot && category == 'system' → 蓝色"系统" badge
  ///   isRobot && category != 'system' → 紫色"AI" badge (用户通过 BotFather 创建)
  ///   !isRobot                         → 无 badge (真人)
  final bool isRobot;

  /// 服务端 user.category. 'system' / '' (空).
  final String category;

  UiContact copyWith({
    String? name,
    String? rawName,
    String? username,
    String? remark,
    String? avatarLabel,
    String? avatarPath,
    String? subtitle,
    String? sourceDescription,
    bool? online,
    int? role,
    String? vercode,
    bool? isRobot,
    String? category,
  }) {
    final nextName = name ?? this.name;
    return UiContact(
      uid: uid,
      name: nextName,
      rawName: rawName ?? this.rawName,
      username: username ?? this.username,
      remark: remark ?? this.remark,
      avatarLabel:
          avatarLabel ??
          (nextName.isEmpty ? this.avatarLabel : nextName.characters.first),
      avatarPath: avatarPath ?? this.avatarPath,
      subtitle: subtitle ?? this.subtitle,
      sourceDescription: sourceDescription ?? this.sourceDescription,
      online: online ?? this.online,
      colors: colors,
      role: role ?? this.role,
      vercode: vercode ?? this.vercode,
      isRobot: isRobot ?? this.isRobot,
      category: category ?? this.category,
    );
  }
}

class UiGroup {
  const UiGroup({
    this.groupNo = '',
    required this.name,
    required this.avatarLabel,
    required this.memberCount,
    required this.subtitle,
    required this.color,
    this.avatarPath = '',
    this.muted = false,
    this.saved = true,
    this.inviteConfirm = false,
    this.forbidden = false,
    this.forbiddenAddFriend = false,
    this.allowViewHistoryMsg = true,
    this.allowMemberPinnedMessage = false,
  });

  factory UiGroup.fromSocial(
    ChatGroup group, {
    required Color color,
    AppConfig? config,
  }) {
    final name = group.name.isEmpty ? group.groupNo : group.name;
    final relativeAvatar = group.groupNo.isEmpty
        ? ''
        : 'groups/${group.groupNo}/avatar';
    final avatarPath = relativeAvatar.isEmpty
        ? ''
        : (config == null ? relativeAvatar : config.showUrl(relativeAvatar));
    return UiGroup(
      groupNo: group.groupNo,
      name: name,
      avatarLabel: name.isEmpty ? '群' : name.characters.first,
      avatarPath: avatarPath,
      memberCount: group.memberCount,
      subtitle: group.notice.isEmpty ? '群聊' : group.notice,
      color: color,
      muted: group.muted,
      saved: group.saved,
      inviteConfirm: group.inviteConfirm,
      forbidden: group.forbidden,
      forbiddenAddFriend: group.forbiddenAddFriend,
      allowViewHistoryMsg: group.allowViewHistoryMsg,
      allowMemberPinnedMessage: group.allowMemberPinnedMessage,
    );
  }

  UiGroup copyWith({
    String? name,
    String? subtitle,
    String? avatarPath,
    bool? saved,
    bool? inviteConfirm,
    bool? forbidden,
    bool? forbiddenAddFriend,
    bool? allowViewHistoryMsg,
    bool? allowMemberPinnedMessage,
  }) {
    return UiGroup(
      groupNo: groupNo,
      name: name ?? this.name,
      avatarLabel: avatarLabel,
      memberCount: memberCount,
      subtitle: subtitle ?? this.subtitle,
      color: color,
      avatarPath: avatarPath ?? this.avatarPath,
      muted: muted,
      saved: saved ?? this.saved,
      inviteConfirm: inviteConfirm ?? this.inviteConfirm,
      forbidden: forbidden ?? this.forbidden,
      forbiddenAddFriend: forbiddenAddFriend ?? this.forbiddenAddFriend,
      allowViewHistoryMsg: allowViewHistoryMsg ?? this.allowViewHistoryMsg,
      allowMemberPinnedMessage:
          allowMemberPinnedMessage ?? this.allowMemberPinnedMessage,
    );
  }

  final String groupNo;
  final String name;
  final String avatarLabel;
  final String avatarPath;
  final int memberCount;
  final String subtitle;
  final Color color;
  final bool muted;
  final bool saved;
  final bool inviteConfirm;
  final bool forbidden;
  final bool forbiddenAddFriend;
  final bool allowViewHistoryMsg;
  final bool allowMemberPinnedMessage;
}

class UiFriendRequest {
  const UiFriendRequest({
    this.uid = '',
    this.token = '',
    required this.name,
    required this.avatarLabel,
    required this.message,
    required this.colors,
    this.avatarPath = '',
    this.accepted = false,
    this.refused = false,
  });

  factory UiFriendRequest.fromSocial(
    ChatFriendRequest request, {
    required List<Color> colors,
    AppConfig? config,
  }) {
    final name = moyuDisplayName(
      name: request.name,
      rawIdentity: request.uid,
      placeholder: '未知用户',
    );
    final relative = request.uid.isEmpty ? '' : 'users/${request.uid}/avatar';
    final resolved = relative.isEmpty
        ? ''
        : (config == null ? relative : config.showUrl(relative));
    return UiFriendRequest(
      uid: request.uid,
      token: request.token,
      name: name,
      avatarLabel: name.isEmpty ? '友' : name.characters.first,
      avatarPath: resolved,
      message: request.message,
      colors: colors,
      accepted: request.accepted,
      refused: request.refused,
    );
  }

  final String uid;
  final String token;
  final String name;
  final String avatarLabel;
  final String avatarPath;
  final String message;
  final List<Color> colors;
  final bool accepted;
  final bool refused;

  UiFriendRequest copyWith({bool? accepted, bool? refused}) {
    return UiFriendRequest(
      uid: uid,
      token: token,
      name: name,
      avatarLabel: avatarLabel,
      avatarPath: avatarPath,
      message: message,
      colors: colors,
      accepted: accepted ?? this.accepted,
      refused: refused ?? this.refused,
    );
  }
}

class UiContactAction {
  const UiContactAction({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.colors,
    this.badge = 0,
    this.routeId,
  });

  final IconData icon;
  final Color color;
  final List<Color>? colors;
  final String title;
  final String subtitle;
  final int badge;
  final String? routeId;
}
