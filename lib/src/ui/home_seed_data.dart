import 'package:flutter/material.dart' show Color;
import 'package:forui/forui.dart' show FIcons;

import '../chat/chat_tool_action.dart';
import '../modules/module_ids.dart';
import 'models/contact_models.dart';
import 'moyu_theme.dart';

// 注意: 本文件曾有大量 mock seed 数据 (seedConversations / seedContacts /
// seedGroups / seedFriendRequests / initialMessagesFor / conversationMemberCount)
// 用作无后端时的占位, 但会在 prod 加载态闪假数据 (假群成员 / 假气泡)。
// 已全部删除 — 列表一律空起步, 由 IM / social 同步填充, 不再有 mock。
// 这里只保留真正的"配置型常量"(工具按钮 / 通讯录入口 / 头像配色)。

const coreChatToolActions = [
  ChatToolAction(
    id: ModuleActionIds.composerAlbum,
    title: 'album',
    icon: FIcons.image,
    color: MoyuColors.blue,
    sortOrder: 10,
  ),
  ChatToolAction(
    id: ModuleActionIds.composerCamera,
    title: 'camera',
    icon: FIcons.camera,
    color: MoyuColors.orange,
    sortOrder: 20,
  ),
  ChatToolAction(
    id: ModuleActionIds.composerContactCard,
    title: 'contact_card',
    icon: FIcons.contactRound,
    color: Color(0xFFFF6A88),
    sortOrder: 50,
  ),
];

const coreContactActions = [
  // 朋友圈入口已移至发现 tab (用户要求, 跟微信通讯录无朋友圈入口对齐).
  // iOS WKMomentModule:54-78 注册的 contacts.header.moment 仍在通讯录顶部
  // header, 但我们这里只复刻"发现 → 朋友圈"作为主入口, 通讯录不重复.
  UiContactAction(
    icon: FIcons.userRoundPlus,
    color: Color(0xFF4FACFE),
    colors: [Color(0xFF4FACFE), Color(0xFF00B6FE)],
    title: 'new_friends',
    subtitle: '',
  ),
  UiContactAction(
    icon: FIcons.usersRound,
    color: Color(0xFFFF7A8A),
    colors: [Color(0xFFFF7A8A), Color(0xFFFF9DA8)],
    title: 'saved_groups',
    subtitle: '',
  ),
];

int nowSeconds() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

List<Color> conversationColors(int index) {
  const palettes = [
    [Color(0xFFFF9A8B), Color(0xFFFF6A88)],
    [MoyuColors.primary, MoyuColors.primarySoft],
    [Color(0xFF4A90FF), Color(0xFF6DE0FF)],
    [Color(0xFFFFB86C), MoyuColors.orange],
    [MoyuColors.primarySoft, Color(0xFFD6A6FF)],
    [Color(0xFF34C759), Color(0xFF7DDE8A)],
  ];
  return palettes[index % palettes.length];
}
