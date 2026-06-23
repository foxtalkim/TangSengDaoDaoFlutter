// 群相关页面（群列表/创建/详情/管理/编辑/二维码/黑名单等）。从 home_shell.dart 拆出。
import 'dart:async' show unawaited;
import 'dart:io' show File;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart' show Dio;
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;
import 'package:path_provider/path_provider.dart' show getTemporaryDirectory;

import '../../app/app_runtime.dart';
import '../../auth/auth_repository.dart' show ChatServerAppConfig;
import '../../config/app_brand.dart';
import '../../config/app_config.dart';
import '../../im/wukong_im_service.dart' show ChatImGateway;
import '../../l10n/app_localizations.dart';
import '../../media/image_editor_gateway.dart' show ImageCropLauncher;
import '../../modules/module_ids.dart' show ModuleFeatureIds;
import '../../social/social_service.dart' show ChatQrCode, ChatSocialGateway;
import '../chat_navigation.dart';
import '../contact_list_widgets.dart'
    show
        SectionTitle,
        StaticActionRow,
        contactChannelId,
        contactsAllowedForGroupInvite;
import '../detail_scaffold.dart';
import '../home_seed_data.dart' show conversationColors;
import '../models/contact_models.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_layout.dart' show MoyuContactPickerPage;
import '../settings_group_widgets.dart';
import '../settings_row_widgets.dart';
import 'my_qr_code_page.dart' show QrCodeFutureView;
import 'shared_widgets_models.dart';

class GroupListPage extends StatefulWidget {
  const GroupListPage({
    super.key,
    required this.groups,
    this.groupCandidates = const [],
    required this.contacts,
    required this.onOpenGroupChat,
    this.onSaveGroup,
    this.socialGateway,
    this.config,
    this.serverAppConfig = const ChatServerAppConfig(),
  });

  final List<UiGroup> groups;
  final List<UiGroup> groupCandidates;
  final List<UiContact> contacts;
  final ChatSocialGateway? socialGateway;
  final AppConfig? config;
  final ChatServerAppConfig serverAppConfig;
  final Future<bool> Function(String groupNo) onOpenGroupChat;
  final Future<UiGroup?> Function(UiGroup group)? onSaveGroup;

  @override
  State<GroupListPage> createState() => GroupListPageState();
}

class GroupListPageState extends State<GroupListPage> {
  late final TextEditingController _controller;
  final _locallySavedGroups = <UiGroup>[];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final query = _controller.text.trim().toLowerCase();
    final groups =
        _dedupeGroups([
              ..._locallySavedGroups,
              ...widget.groups.where((group) => group.saved),
            ])
            .where(
              (group) =>
                  query.isEmpty ||
                  group.name.toLowerCase().contains(query) ||
                  group.subtitle.toLowerCase().contains(query),
            )
            .toList();

    return DetailScaffold(
      title: t.groupSavedTitle,
      trailing: MoyuRoundIconButton(
        icon: FIcons.plus,
        tooltip: t.groupSaveTooltip,
        onPressed: () => unawaited(_pickExistingGroupToSave()),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.groupSearchHint,
            prefixBuilder: (context, style, variants) =>
                FTextField.prefixIconBuilder(
                  context,
                  style,
                  variants,
                  Icon(FIcons.search),
                ),
          ),
        ),
        MoyuSection(
          padding: EdgeInsets.zero,
          children: groups.isEmpty
              ? [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        t.groupNoMatched,
                        style: TextStyle(
                          color: MoyuColors.of(context).textTertiary,
                        ),
                      ),
                    ),
                  ),
                ]
              : [
                  for (var i = 0; i < groups.length; i++) ...[
                    Builder(
                      builder: (_) {
                        final group = _withResolvedAvatar(groups[i]);
                        return GroupTile(
                          group: group,
                          showSubtitle: false,
                          onTap: () =>
                              unawaited(widget.onOpenGroupChat(group.groupNo)),
                        );
                      },
                    ),
                    if (i != groups.length - 1) const MoyuDivider(),
                  ],
                ],
        ),
      ],
    );
  }

  Future<void> _pickExistingGroupToSave() async {
    final candidates = groupSaveCandidates(
      savedGroups: [..._locallySavedGroups, ...widget.groups],
      knownGroups: widget.groupCandidates,
    );
    if (candidates.isEmpty) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).groupNoSaveCandidatesToast,
      );
      return;
    }
    final selected = await Navigator.of(context).push<UiGroup>(
      MaterialPageRoute(
        builder: (_) =>
            SelectExistingGroupPage(groups: candidates, config: widget.config),
      ),
    );
    if (!mounted || selected == null) return;
    try {
      final saved =
          await widget.onSaveGroup?.call(selected) ??
          selected.copyWith(saved: true);
      if (!mounted) return;
      setState(() {
        _locallySavedGroups
          ..removeWhere((group) => group.groupNo == saved.groupNo)
          ..insert(0, saved);
      });
      MoyuToast.show(
        context,
        AppLocalizations.of(context).groupSavedToContacts,
      );
    } catch (error) {
      if (mounted) {
        MoyuToast.show(
          context,
          AppLocalizations.of(context).groupSaveFailed('$error'),
        );
      }
    }
  }

  List<UiGroup> _dedupeGroups(List<UiGroup> groups) {
    final byNo = <String, UiGroup>{};
    for (final group in groups) {
      final no = group.groupNo.trim();
      if (no.isEmpty || byNo.containsKey(no)) continue;
      byNo[no] = group;
    }
    return byNo.values.toList(growable: false);
  }

  UiGroup _withResolvedAvatar(UiGroup group) {
    final groupNo = group.groupNo.trim();
    if (group.avatarPath.isNotEmpty || groupNo.isEmpty) return group;
    final config = widget.config;
    if (config == null) return group;
    return group.copyWith(
      avatarPath: AvatarResolver.group(config: config, groupNo: groupNo),
    );
  }
}

List<UiGroup> groupSaveCandidates({
  required List<UiGroup> savedGroups,
  required List<UiGroup> knownGroups,
}) {
  final savedNos = {
    for (final group in savedGroups)
      if (group.saved && group.groupNo.trim().isNotEmpty) group.groupNo.trim(),
  };
  final byNo = <String, UiGroup>{};
  for (final group in knownGroups) {
    final no = group.groupNo.trim();
    if (no.isEmpty || savedNos.contains(no) || byNo.containsKey(no)) continue;
    byNo[no] = group;
  }
  return byNo.values.toList(growable: false);
}

class SelectExistingGroupPage extends StatefulWidget {
  const SelectExistingGroupPage({super.key, required this.groups, this.config});

  final List<UiGroup> groups;
  final AppConfig? config;

  @override
  State<SelectExistingGroupPage> createState() =>
      _SelectExistingGroupPageState();
}

class _SelectExistingGroupPageState extends State<SelectExistingGroupPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final query = _controller.text.trim().toLowerCase();
    final groups = widget.groups
        .where(
          (group) =>
              query.isEmpty ||
              group.name.toLowerCase().contains(query) ||
              group.subtitle.toLowerCase().contains(query),
        )
        .toList(growable: false);

    return DetailScaffold(
      title: t.groupSelectTitle,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.groupSearchHint,
            prefixBuilder: (context, style, variants) =>
                FTextField.prefixIconBuilder(
                  context,
                  style,
                  variants,
                  Icon(FIcons.search),
                ),
          ),
        ),
        MoyuSection(
          padding: EdgeInsets.zero,
          children: groups.isEmpty
              ? [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        t.groupNoSaveCandidates,
                        style: TextStyle(
                          color: MoyuColors.of(context).textTertiary,
                        ),
                      ),
                    ),
                  ),
                ]
              : [
                  for (var i = 0; i < groups.length; i++) ...[
                    Builder(
                      builder: (_) {
                        final group = _withResolvedAvatar(groups[i]);
                        return GroupTile(
                          group: group,
                          showSubtitle: false,
                          onTap: () => Navigator.of(context).pop(group),
                        );
                      },
                    ),
                    if (i != groups.length - 1) const MoyuDivider(),
                  ],
                ],
        ),
      ],
    );
  }

  UiGroup _withResolvedAvatar(UiGroup group) {
    final groupNo = group.groupNo.trim();
    if (group.avatarPath.isNotEmpty || groupNo.isEmpty) return group;
    final config = widget.config;
    if (config == null) return group;
    return group.copyWith(
      avatarPath: AvatarResolver.group(config: config, groupNo: groupNo),
    );
  }
}

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({
    super.key,
    required this.contacts,
    required this.onCreateGroup,
    this.serverAppConfig = const ChatServerAppConfig(),
  });

  final List<UiContact> contacts;
  final Future<UiGroup?> Function(List<UiContact> members) onCreateGroup;
  final ChatServerAppConfig serverAppConfig;

  @override
  State<CreateGroupPage> createState() => CreateGroupPageState();
}

class CreateGroupPageState extends State<CreateGroupPage> {
  late final TextEditingController _searchController;
  late final Set<String> _selectedIds;
  bool _creating = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(() => setState(() {}));
    // Native iOS `WKContactsSelectVC` opens with no pre-checked rows
    // — the user picks from scratch. Pre-selecting the first two
    // contacts was a Flutter-only convenience that surprised the user
    // ("发起群聊默认全勾选").
    _selectedIds = <String>{};
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final contacts = _filteredContacts();

    return DetailScaffold(
      title: t.groupCreateTitle,
      trailing: MoyuTextButton(
        label: t.actionDone,
        onPressed: _creating || _selectedIds.isEmpty ? null : _submit,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _searchController),
            hint: t.groupSearchContactsHint,
            prefixBuilder: (context, style, variants) =>
                FTextField.prefixIconBuilder(
                  context,
                  style,
                  variants,
                  Icon(FIcons.search),
                ),
          ),
        ),
        MoyuSection(
          padding: EdgeInsets.zero,
          children: contacts.isEmpty
              ? [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        t.groupNoMatchedContacts,
                        style: TextStyle(
                          color: MoyuColors.of(context).textTertiary,
                        ),
                      ),
                    ),
                  ),
                ]
              : [
                  for (var i = 0; i < contacts.length; i++) ...[
                    SelectableContactRow(
                      contact: contacts[i],
                      selected: _selectedIds.contains(
                        contactChannelId(contacts[i]),
                      ),
                      onChanged: (selected) =>
                          _setSelected(contacts[i], selected),
                    ),
                    if (i != contacts.length - 1) const MoyuDivider(),
                  ],
                ],
        ),
      ],
    );
  }

  List<UiContact> _filteredContacts() {
    final query = _searchController.text.trim().toLowerCase();
    final contacts = _inviteableContacts;
    if (query.isEmpty) {
      return contacts;
    }

    return contacts
        .where(
          (contact) =>
              contact.name.toLowerCase().contains(query) ||
              contact.subtitle.toLowerCase().contains(query),
        )
        .toList();
  }

  List<UiContact> get _inviteableContacts =>
      contactsAllowedForGroupInvite(widget.contacts, widget.serverAppConfig);

  void _setSelected(UiContact contact, bool selected) {
    final id = contactChannelId(contact);
    setState(() {
      if (selected) {
        _selectedIds.add(id);
      } else {
        _selectedIds.remove(id);
      }
    });
  }

  Future<void> _submit() async {
    setState(() => _creating = true);
    final selectedContacts = [
      for (final contact in _inviteableContacts)
        if (_selectedIds.contains(contactChannelId(contact))) contact,
    ];
    await widget.onCreateGroup(selectedContacts);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }
}

class GroupTile extends StatelessWidget {
  const GroupTile({
    super.key,
    required this.group,
    this.showSubtitle = true,
    this.onTap,
  });

  final UiGroup group;
  final bool showSubtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // 保存群聊对齐原版 iOS/Android: 只显示头像 + 群名，不显示人数/副标题。
    // 即使 avatarPath 为空也走统一头像字母兜底，避免落到 64 高 action row。
    if (!showSubtitle || group.avatarPath.isNotEmpty) {
      final row = Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        color: MoyuColors.of(context).background,
        child: Row(
          children: [
            MoyuResolvedAvatar.raw(
              label: group.avatarLabel,
              size: 40,
              colors: [group.color],
              online: false,
              imageUrl: group.avatarPath,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 15.5,
                      letterSpacing: -0.08,
                      color: MoyuColors.of(context).textPrimary,
                    ),
                  ),
                  if (showSubtitle) ...[
                    const SizedBox(height: 2),
                    Text(
                      t.groupMemberSummary(group.memberCount, group.subtitle),
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
            if (group.muted)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  t.groupMuted,
                  style: TextStyle(
                    fontSize: 12,
                    color: MoyuColors.of(context).textTertiary,
                  ),
                ),
              ),
          ],
        ),
      );
      return onTap == null
          ? row
          : FTappable(
              onPress: onTap,
              behavior: HitTestBehavior.opaque,
              child: row,
            );
    }
    return StaticActionRow(
      icon: FIcons.usersRound,
      iconColor: group.color,
      title: group.name,
      subtitle: showSubtitle
          ? t.groupMemberSummary(group.memberCount, group.subtitle)
          : '',
      value: group.muted ? t.groupMuted : null,
      onTap: onTap,
    );
  }
}

class GroupManagePage extends StatefulWidget {
  const GroupManagePage({
    super.key,
    required this.group,
    this.socialGateway,
    this.imGateway,
    this.loginUid = '',
  });

  final UiGroup group;
  final ChatSocialGateway? socialGateway;

  /// 给 switch handler 改完调 refreshChannel 用 — server 写完后必须刷 SDK
  /// channel info cache, 否则 conversation list / chat header / 回 chat
  /// settings 都拿 stale 数据.
  final ChatImGateway? imGateway;

  /// Used to filter the login user out of admin / transfer / forbid
  /// pickers — server rejects self-promote-to-admin and self-mute
  /// with a 400, so the picker shouldn't even surface those rows.
  final String loginUid;

  @override
  State<GroupManagePage> createState() => GroupManagePageState();
}

class GroupManagePageState extends State<GroupManagePage> {
  final _members = <UiContact>[];
  final _managers = <UiContact>[];

  /// switch 状态 — 进页时 widget.group 来自 chat_settings 的 _groupInfo,
  /// 那是 stale 快照 (chat_settings 只在 initState 拉一次, switch 改完 pop
  /// 回去不会自动 reload). 进页 initState 立刻调 _refreshGroupInfo 重拉
  /// server 最新值覆盖本地 state, 修"开关重进恢复旧值"的 BUG.
  late bool _inviteConfirm = widget.group.inviteConfirm;
  late bool _forbidden = widget.group.forbidden;
  late bool _forbiddenAddFriend = widget.group.forbiddenAddFriend;
  late bool _allowViewHistoryMsg = widget.group.allowViewHistoryMsg;

  @override
  void initState() {
    super.initState();
    unawaited(_loadMembers());
    // 关键: 进页拉一次 server 最新 group info, 覆盖 widget.group stale 值.
    unawaited(_refreshGroupInfo());
  }

  /// 拉 server 最新 group 配置覆盖本地 switch state. switch handler 调完
  /// API 也调一次, 保证下次进页 / 当前页都是 server truth.
  Future<void> _refreshGroupInfo() async {
    final gateway = widget.socialGateway;
    if (gateway == null || _groupNo.isEmpty) return;
    try {
      final group = await gateway.loadGroupInfo(_groupNo);
      if (!mounted || group == null) return;
      setState(() {
        _inviteConfirm = group.inviteConfirm;
        _forbidden = group.forbidden;
        _forbiddenAddFriend = group.forbiddenAddFriend;
        _allowViewHistoryMsg = group.allowViewHistoryMsg;
      });
    } catch (_) {}
  }

  /// Owner-only sections (currently just 「群主管理权转让」) gate on
  /// this. Read from member fetch; default false until the request
  /// resolves so the transfer row stays hidden if we can't confirm.
  bool _isCreator = false;

  /// Build the admin/owner roster shown at the top section. Includes
  /// the creator (no remove button) + every manager (⊖ remove
  /// button) + a final "添加群管理员" row. Mirrors iOS
  /// `WKGroupManagerVM.getMembersAndCreatorsSections`.
  List<Widget> _ownerSectionRows() {
    final t = AppLocalizations.of(context);
    final rows = <Widget>[];
    final ownersAndManagers =
        [
          for (final m in _members)
            if (m.role == 1 || m.role == 2) m,
        ]..sort((a, b) {
          // Creator first, then managers; preserve order within each.
          final ap = a.role == 1 ? 2 : 1;
          final bp = b.role == 1 ? 2 : 1;
          return bp.compareTo(ap);
        });
    for (var i = 0; i < ownersAndManagers.length; i++) {
      final m = ownersAndManagers[i];
      final isCreator = m.role == 1;
      rows.add(
        GroupMemberContactTile(
          contact: m,
          subtitle: isCreator ? t.groupOwnerRole : t.groupAdminRole,
          // Only the creator can remove managers, and the creator
          // row itself never carries a remove control.
          trailing: (!isCreator && _isCreator)
              ? Text(
                  t.groupRemove,
                  style: TextStyle(
                    color: MoyuColors.of(context).red,
                    fontSize: 14,
                  ),
                )
              : null,
          onTap: (!isCreator && _isCreator)
              ? () => unawaited(_removeManager(m))
              : null,
        ),
      );
      rows.add(const RowDivider());
    }
    // Only the creator can add new managers.
    if (_isCreator) {
      rows.add(
        PlainSettingRow(
          title: t.groupAddAdmin,
          showChevron: true,
          onTap: () => unawaited(_addManager()),
        ),
      );
    } else if (rows.isEmpty) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 18),
          child: Center(
            child: Text(
              t.groupNoAdmins,
              style: TextStyle(color: MoyuColors.of(context).textTertiary),
            ),
          ),
        ),
      );
    } else {
      // Drop the trailing divider when there's no `添加群管理员` row.
      if (rows.last is RowDivider) {
        rows.removeLast();
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    // Layout mirrors iOS WKGroupManagerVM (groups/iOS-original):
    //   1. 群主、管理员 列表 + 添加管理员
    //   2. 群聊邀请确认 + remark
    //   3. 群主管理权转让（creator only）
    //   4. 成员设置 / 全员禁言 + remark
    //   5. 禁止群成员互加好友 + remark
    //   6. 允许新成员查看历史消息 + remark
    //   7. 群黑名单
    // The previous Flutter version had several non-native rows
    // (设置成员禁言 / 解除成员禁言 / 允许群成员置顶消息 / 退群用户 /
    // 解散群聊) — those have been removed. 成员禁言 lives on the
    // member profile page in iOS native, not on this screen.
    return DetailScaffold(
      title: t.groupManageTitle,
      children: [
        settingsBlockGap(context),
        SectionTitle(t.groupOwnerAdminSection),
        settingsFlatGroup(context, rows: _ownerSectionRows()),
        settingsBlockGap(context),
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          child: Text(
            t.groupInviteConfirmRemark,
            style: TextStyle(
              color: MoyuColors.of(context).textTertiary,
              fontSize: 12,
            ),
          ),
        ),
        settingsFlatGroup(
          context,
          rows: [
            SwitchRow(
              title: t.groupInviteConfirm,
              value: _inviteConfirm,
              onChanged: (value) =>
                  unawaited(_updateSettingSwitch('invite', value)),
            ),
          ],
        ),
        if (_isCreator) ...[
          settingsBlockGap(context),
          settingsFlatGroup(
            context,
            rows: [
              PlainSettingRow(
                title: t.groupOwnerTransfer,
                showChevron: true,
                onTap: () => unawaited(_transferOwner()),
              ),
            ],
          ),
        ],
        settingsBlockGap(context),
        SectionTitle(t.groupMemberSettingsSection),
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          child: Text(
            t.groupAllMutedRemark,
            style: TextStyle(
              color: MoyuColors.of(context).textTertiary,
              fontSize: 12,
            ),
          ),
        ),
        settingsFlatGroup(
          context,
          rows: [
            SwitchRow(
              title: t.groupAllMuted,
              value: _forbidden,
              onChanged: (value) => unawaited(_setGroupForbidden(value)),
            ),
          ],
        ),
        settingsBlockGap(context),
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          child: Text(
            t.groupForbiddenAddFriendRemark,
            style: TextStyle(
              color: MoyuColors.of(context).textTertiary,
              fontSize: 12,
            ),
          ),
        ),
        settingsFlatGroup(
          context,
          rows: [
            SwitchRow(
              title: t.groupForbiddenAddFriend,
              value: _forbiddenAddFriend,
              onChanged: (value) => unawaited(
                _updateSettingSwitch('forbidden_add_friend', value),
              ),
            ),
          ],
        ),
        settingsBlockGap(context),
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
          child: Text(
            t.groupAllowHistoryRemark,
            style: TextStyle(
              color: MoyuColors.of(context).textTertiary,
              fontSize: 12,
            ),
          ),
        ),
        settingsFlatGroup(
          context,
          rows: [
            SwitchRow(
              title: t.groupAllowHistory,
              value: _allowViewHistoryMsg,
              onChanged: (value) => unawaited(
                _updateSettingSwitch('allow_view_history_msg', value),
              ),
            ),
          ],
        ),
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.groupBlacklistTitle,
              showChevron: true,
              onTap: () => pushPage(
                context,
                GroupBlacklistPage(
                  group: widget.group,
                  socialGateway: widget.socialGateway,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _loadMembers() async {
    final t = AppLocalizations.of(context);
    final gateway = widget.socialGateway;
    if (gateway == null || _groupNo.isEmpty) {
      return;
    }
    try {
      final members = await gateway.loadGroupMembers(_groupNo);
      if (!mounted) {
        return;
      }
      setState(() {
        _members
          ..clear()
          ..addAll([
            for (var i = 0; i < members.length; i++)
              UiContact.fromSocial(members[i], colors: conversationColors(i)),
          ]);
        // Keep the legacy `_managers` cache in sync — `_addManager` /
        // `_removeManager` still read from it to compute candidate
        // sets and optimistic updates.
        _managers
          ..clear()
          ..addAll(_members.where((m) => m.role == 2));
        // Determine whether the login user is the creator, gating
        // owner-only sections (transfer / remove-manager / add-manager).
        _isCreator = _members.any(
          (m) => m.uid == widget.loginUid && m.role == 1,
        );
      });
    } catch (error) {
      _toast(t.groupMembersSyncFailed('$error'));
    }
  }

  /// MBProgressHUD-style transient toast at the bottom — replaces the
  /// old `_status` text panel that lived permanently in the page until
  /// the next operation overwrote it. Mirrors iOS native behaviour
  /// (auto-dismiss after 1-2s) and matches every other toast in the
  /// app.
  void _toast(String msg) {
    if (!mounted) return;
    MoyuToast.show(context, msg);
  }

  /// 调用 server 改 channel 设置后, 必须刷 SDK channel info cache, 否则:
  ///   - chat header / conversation list 拿 stale 数据
  ///   - 上层 chat_settings 重进 GroupManagePage 时 widget.group 还是 stale
  /// 修"开关重进恢复"的 BUG.
  Future<void> _syncAfterSwitch() async {
    // fallback 到全局单例 — GroupListPage / chat_settings → GroupManagePage
    // 多层 widget 不便都 thread imGateway, 用 ChatImGateway.current.
    final imGateway = widget.imGateway ?? ChatImGateway.current;
    await imGateway?.refreshChannel(
      channelId: _groupNo,
      // UiGroup 没存 channelType, group 永远是 group 类型 = 2 (WKChannelType.group)
      channelType: 2,
    );
    await _refreshGroupInfo();
  }

  Future<void> _setGroupForbidden(bool value) async {
    final t = AppLocalizations.of(context);
    setState(() {
      _forbidden = value;
    });
    try {
      await widget.socialGateway?.setGroupForbidden(
        groupNo: _groupNo,
        enabled: value,
      );
      await _syncAfterSwitch();
      _toast(t.groupSettingsUpdated);
    } catch (error) {
      if (mounted) {
        setState(() {
          _forbidden = !value;
        });
        _toast(t.groupSettingsUpdateFailed('$error'));
      }
    }
  }

  Future<void> _updateSettingSwitch(String key, bool value) async {
    final t = AppLocalizations.of(context);
    _setLocalSwitch(key, value);
    try {
      await widget.socialGateway?.updateGroupSetting(
        groupNo: _groupNo,
        setting: {key: value ? 1 : 0},
      );
      await _syncAfterSwitch();
      _toast(t.groupSettingsUpdated);
    } catch (error) {
      if (mounted) {
        _setLocalSwitch(key, !value);
      }
      _toast(t.groupSettingsUpdateFailed('$error'));
    }
  }

  Future<void> _addManager() async {
    final t = AppLocalizations.of(context);
    final managerIds = _managers.map(_contactId).toSet();
    final candidates = [
      for (final member in _memberChoices)
        if (!managerIds.contains(_contactId(member))) member,
    ];
    final selected = await _pickMembers(t.groupAddAdminPickerTitle, candidates);
    if (!mounted || selected.isEmpty) {
      return;
    }
    final memberUids = _contactIds(selected);
    try {
      await widget.socialGateway?.addGroupManagers(
        groupNo: _groupNo,
        memberUids: memberUids,
      );
      if (!mounted) {
        return;
      }
      // 重拉 — server 是真相源, _members 里被加为 manager 的人 role 字段
      // 需要同步过来 (optimistic 只更 _managers cache 不更 _members.role,
      // 下次重进才一致). 对齐 iOS WKGroupManagerVM:106 pop 后 reload.
      await _loadMembers();
      _toast(t.groupAdminAddedCount(selected.length));
    } catch (error) {
      _toast(t.groupAddAdminFailed('$error'));
    }
  }

  Future<void> _removeManager(UiContact member) async {
    final t = AppLocalizations.of(context);
    final uid = _contactId(member);
    if (uid.isEmpty) {
      return;
    }
    // DESIGN.md §6：移除管理员权限是 admin-level 改动，应该 confirm。
    var confirmed = false;
    await MoyuActionSheet.show(
      context,
      title: t.groupRemoveAdminConfirm(member.name),
      items: [
        MoyuActionSheetItem(
          title: t.groupRemoveAdminAction,
          destructive: true,
          onSelected: () => confirmed = true,
        ),
      ],
    );
    if (!confirmed || !mounted) return;
    try {
      await widget.socialGateway?.removeGroupManagers(
        groupNo: _groupNo,
        memberUids: [uid],
      );
      if (!mounted) {
        return;
      }
      // 重拉 — 跟 _addManager 同, server 是真相源.
      await _loadMembers();
      _toast(t.groupRemoveAdminSuccess);
    } catch (error) {
      _toast(t.groupRemoveAdminFailed('$error'));
    }
  }

  Future<void> _transferOwner() async {
    final t = AppLocalizations.of(context);
    final selected = await _pickMembers(t.groupSelectNewOwner, _memberChoices);
    if (!mounted || selected.isEmpty) {
      return;
    }
    final uid = _contactId(selected.first);
    if (uid.isEmpty) {
      return;
    }
    // DESIGN.md §6：转让群主 = 失去管理权限，**最不可撤销**的群操作。
    // picker 选完之后必须 final confirm。
    final newOwner = selected.first;
    var confirmed = false;
    await MoyuActionSheet.show(
      context,
      title: t.groupTransferOwnerConfirm(newOwner.name),
      items: [
        MoyuActionSheetItem(
          title: t.groupTransferOwnerAction,
          destructive: true,
          onSelected: () => confirmed = true,
        ),
      ],
    );
    if (!confirmed || !mounted) return;
    try {
      await widget.socialGateway?.transferGroupOwner(
        groupNo: _groupNo,
        uid: uid,
      );
      _toast(t.groupOwnerTransferred);
    } catch (error) {
      _toast(t.groupOwnerTransferFailed('$error'));
    }
  }

  Future<List<UiContact>> _pickMembers(
    String title,
    List<UiContact> contacts,
  ) async {
    final selected = await Navigator.of(context).push<List<UiContact>>(
      MaterialPageRoute(
        builder: (_) => MoyuContactPickerPage(
          title: title,
          contacts: contacts,
          selectedContacts: const [],
        ),
      ),
    );
    return selected ?? const [];
  }

  void _setLocalSwitch(String key, bool value) {
    setState(() {
      switch (key) {
        case 'invite':
          _inviteConfirm = value;
        case 'forbidden_add_friend':
          _forbiddenAddFriend = value;
        case 'allow_view_history_msg':
          _allowViewHistoryMsg = value;
      }
    });
  }

  /// Members eligible for admin / forbid / transfer pickers — strips
  /// the login user (server-side validations reject self-promote /
  /// self-mute with 400) and falls back to the seed roster only when
  /// the live fetch produced nothing.
  List<UiContact> get _memberChoices {
    final source = _members; // 不再 fallback seedContacts mock
    if (widget.loginUid.isEmpty) {
      return source;
    }
    return [
      for (final m in source)
        if (contactChannelId(m) != widget.loginUid) m,
    ];
  }

  List<String> _contactIds(List<UiContact> contacts) {
    return [
      for (final contact in contacts)
        if (_contactId(contact).isNotEmpty) _contactId(contact),
    ];
  }

  String _contactId(UiContact contact) => contactChannelId(contact);

  String get _groupNo =>
      widget.group.groupNo.isEmpty ? widget.group.name : widget.group.groupNo;
}

// `_GroupForbiddenTimePage` 与 `_GroupExitedMembersPage` 已删除：
// native iOS `WKGroupManagerVM` 不暴露这两条入口（成员禁言在「成员个人页」，
// 退群用户列表原版无此页）。如未来需要 recover 这两个 widget，从
// git 历史 (rev pre-2026-05-11) 取回。

class GroupFieldEditorPage extends StatefulWidget {
  const GroupFieldEditorPage({
    super.key,
    required this.title,
    required this.groupNo,
    required this.fieldKey,
    required this.initialValue,
    required this.onSaved,
    this.socialGateway,
  });

  final String title;
  final String groupNo;
  final String fieldKey;
  final String initialValue;
  final ChatSocialGateway? socialGateway;
  final ValueChanged<String> onSaved;

  @override
  State<GroupFieldEditorPage> createState() => GroupFieldEditorPageState();
}

class GroupFieldEditorPageState extends State<GroupFieldEditorPage> {
  late final TextEditingController _controller;
  bool _saving = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final value = _controller.text.trim();
    final isLongForm = widget.fieldKey == 'notice';
    final canSubmit =
        value != widget.initialValue &&
        !_saving &&
        (isLongForm || value.isNotEmpty);

    // DESIGN.md §6 + iOS WKGroupNameEditVC：单字段编辑类（群名/公告/
    // 备注 / 我在本群的昵称等）的"完成"按钮放在 nav 右上 MoyuTextButton，
    // 跟 CreateGroupPage / _TagEditorPage / _MomentReplyPage 一致。
    // 不再在 page 底部放大块 FButton.lg。
    return DetailScaffold(
      title: widget.title,
      trailing: MoyuTextButton(
        label: _saving ? t.actionSaving : t.actionDone,
        onPressed: canSubmit ? _submit : null,
      ),
      children: [
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: widget.title,
            maxLines: isLongForm ? 8 : 1,
            minLines: isLongForm ? 6 : 1,
            prefixBuilder: isLongForm
                ? null
                : (context, style, variants) => FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    Icon(FIcons.pencil),
                  ),
          ),
        ),
        if (_error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 10),
            child: Text(
              _error,
              style: TextStyle(
                color: MoyuColors.of(context).red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _submit() async {
    final value = _controller.text.trim();
    setState(() {
      _saving = true;
      _error = '';
    });
    try {
      if (widget.socialGateway != null && widget.groupNo.isNotEmpty) {
        await widget.socialGateway!.updateGroupInfo(
          groupNo: widget.groupNo,
          key: widget.fieldKey,
          value: value,
        );
      }
      widget.onSaved(value);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() => _error = error.toString());
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class GroupNoticeListPage extends StatefulWidget {
  const GroupNoticeListPage({
    super.key,
    required this.groupNo,
    required this.notice,
    required this.canEdit,
    required this.onSaved,
    this.meta = const GroupNoticeMeta(),
    this.currentUserMeta,
    this.socialGateway,
  });

  final String groupNo;
  final String notice;
  final bool canEdit;
  final GroupNoticeMeta meta;
  final GroupNoticeMeta? currentUserMeta;
  final ChatSocialGateway? socialGateway;
  final ValueChanged<String> onSaved;

  @override
  State<GroupNoticeListPage> createState() => GroupNoticeListPageState();
}

class GroupNoticeMeta {
  const GroupNoticeMeta({
    this.publisherUid = '',
    this.publisherName = '',
    this.publisherAvatarUrl = '',
    this.publishedAt,
  });

  final String publisherUid;
  final String publisherName;
  final String publisherAvatarUrl;
  final DateTime? publishedAt;

  String get displayName {
    final name = publisherName.trim();
    return name;
  }

  String displayNameOr(String fallback) {
    final name = displayName;
    return name.isEmpty ? fallback : name;
  }

  String timeLabel(AppLocalizations t) => groupNoticeTimeText(t, publishedAt);

  String listMetaLabel(AppLocalizations t, String fallback) {
    final displayName = displayNameOr(fallback);
    final time = timeLabel(t);
    return time.isEmpty ? displayName : '$displayName $time';
  }

  GroupNoticeMeta withPublishedAt(DateTime value) {
    return GroupNoticeMeta(
      publisherUid: publisherUid,
      publisherName: publisherName,
      publisherAvatarUrl: publisherAvatarUrl,
      publishedAt: value,
    );
  }
}

String groupNoticeTimeText(AppLocalizations t, DateTime? value) {
  if (value == null) return '';
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return t.dateYearMonthDayTime(
    value.day,
    value.month,
    '$hour:$minute',
    value.year,
  );
}

class GroupNoticeListPageState extends State<GroupNoticeListPage> {
  late String _notice;
  late GroupNoticeMeta _meta;

  @override
  void initState() {
    super.initState();
    _notice = widget.notice.trim();
    _meta = widget.meta;
  }

  @override
  void didUpdateWidget(covariant GroupNoticeListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.meta != widget.meta) {
      _meta = widget.meta;
    }
  }

  void _saveNotice(String value) {
    final currentUserMeta = widget.currentUserMeta;
    setState(() {
      _notice = value;
      if (value.trim().isNotEmpty && currentUserMeta != null) {
        _meta = currentUserMeta.withPublishedAt(DateTime.now());
      }
    });
    widget.onSaved(value);
  }

  void _openEditor() {
    final t = AppLocalizations.of(context);
    pushPage(
      context,
      GroupFieldEditorPage(
        title: _notice.isEmpty
            ? t.groupNoticePublishTitle
            : t.groupNoticeEditTitle,
        groupNo: widget.groupNo,
        fieldKey: 'notice',
        initialValue: _notice,
        socialGateway: widget.socialGateway,
        onSaved: _saveNotice,
      ),
    );
  }

  void _openDetail() {
    if (_notice.isEmpty) return;
    pushPage(
      context,
      GroupNoticeDetailPage(
        groupNo: widget.groupNo,
        notice: _notice,
        meta: _meta,
        currentUserMeta: widget.currentUserMeta,
        canEdit: widget.canEdit,
        socialGateway: widget.socialGateway,
        onSaved: _saveNotice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.groupNoticeTitle,
      trailing: widget.canEdit
          ? MoyuTextButton(
              label: _notice.isEmpty
                  ? t.groupNoticePublishAction
                  : t.actionEdit,
              onPressed: _openEditor,
            )
          : null,
      children: [
        const SizedBox(height: 14),
        if (_notice.isEmpty)
          settingsFlatGroup(
            context,
            rows: [
              if (widget.canEdit)
                PlainSettingRow(
                  title: t.groupNoticePublishTitle,
                  showChevron: true,
                  onTap: _openEditor,
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 28),
                  child: Center(
                    child: Text(
                      t.groupNoticeEmpty,
                      style: TextStyle(
                        color: MoyuColors.of(context).textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
            ],
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _GroupNoticeCard(
              notice: _notice,
              meta: _meta,
              onTap: _openDetail,
            ),
          ),
      ],
    );
  }
}

class GroupNoticeDetailPage extends StatefulWidget {
  const GroupNoticeDetailPage({
    super.key,
    required this.groupNo,
    required this.notice,
    required this.meta,
    required this.canEdit,
    required this.onSaved,
    this.currentUserMeta,
    this.socialGateway,
  });

  final String groupNo;
  final String notice;
  final GroupNoticeMeta meta;
  final GroupNoticeMeta? currentUserMeta;
  final bool canEdit;
  final ChatSocialGateway? socialGateway;
  final ValueChanged<String> onSaved;

  @override
  State<GroupNoticeDetailPage> createState() => GroupNoticeDetailPageState();
}

class GroupNoticeDetailPageState extends State<GroupNoticeDetailPage> {
  late String _notice;
  late GroupNoticeMeta _meta;

  @override
  void initState() {
    super.initState();
    _notice = widget.notice.trim();
    _meta = widget.meta;
  }

  void _openEditor() {
    final t = AppLocalizations.of(context);
    pushPage(
      context,
      GroupFieldEditorPage(
        title: t.groupNoticeEditTitle,
        groupNo: widget.groupNo,
        fieldKey: 'notice',
        initialValue: _notice,
        socialGateway: widget.socialGateway,
        onSaved: (value) {
          final currentUserMeta = widget.currentUserMeta;
          setState(() {
            _notice = value;
            if (value.trim().isNotEmpty && currentUserMeta != null) {
              _meta = currentUserMeta.withPublishedAt(DateTime.now());
            }
          });
          widget.onSaved(value);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.groupNoticeTitle,
      trailing: widget.canEdit
          ? MoyuTextButton(label: t.actionEdit, onPressed: _openEditor)
          : null,
      children: [
        Container(
          width: double.infinity,
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
          child: Row(
            children: [
              MoyuResolvedAvatar.raw(
                label: _meta
                    .displayNameOr(t.groupNoticePublisherDefault)
                    .characters
                    .first,
                size: 52,
                colors: [
                  MoyuColors.of(context).primarySoft,
                  MoyuColors.of(context).primary,
                ],
                imageUrl: _meta.publisherAvatarUrl,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _meta.displayNameOr(t.groupNoticePublisherDefault),
                      style: TextStyle(
                        color: MoyuColors.of(context).textPrimary,
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _meta.timeLabel(t).isEmpty
                          ? t.groupNoticePublishedAtUnknown
                          : _meta.timeLabel(t),
                      style: TextStyle(
                        color: MoyuColors.of(context).textTertiary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        RowDivider(),
        Container(
          width: double.infinity,
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 28, 16, 20),
          child: SelectableText(
            _notice.isEmpty ? t.groupNoticeEmpty : _notice,
            style: TextStyle(
              color: _notice.isEmpty
                  ? MoyuColors.of(context).textTertiary
                  : MoyuColors.of(context).textPrimary,
              fontSize: 18,
              height: 1.48,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

class _GroupNoticeCard extends StatelessWidget {
  const _GroupNoticeCard({
    required this.notice,
    required this.meta,
    required this.onTap,
  });

  final String notice;
  final GroupNoticeMeta meta;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: MoyuColors.of(context).background,
          borderRadius: BorderRadius.circular(14),
        ),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notice,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: MoyuColors.of(context).textPrimary,
                fontSize: 18,
                height: 1.42,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    meta.listMetaLabel(t, t.groupNoticePublisherDefault),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MoyuColors.of(context).textTertiary,
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(
                  moyuForwardChevronIcon(context),
                  size: 16,
                  color: MoyuColors.of(context).textTertiary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class GroupMemberRemarkEditorPage extends StatefulWidget {
  const GroupMemberRemarkEditorPage({
    super.key,
    required this.groupNo,
    required this.memberUid,
    required this.initialValue,
    required this.onSaved,
    this.socialGateway,
  });

  final String groupNo;
  final String memberUid;
  final String initialValue;
  final ChatSocialGateway? socialGateway;
  final ValueChanged<String> onSaved;

  @override
  State<GroupMemberRemarkEditorPage> createState() =>
      GroupMemberRemarkEditorPageState();
}

class GroupMemberRemarkEditorPageState
    extends State<GroupMemberRemarkEditorPage> {
  late final TextEditingController _controller;
  bool _saving = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final value = _controller.text.trim();
    final canSubmit = value != widget.initialValue && !_saving;

    return DetailScaffold(
      title: t.groupMemberRemarkTitle,
      trailing: MoyuTextButton(
        label: _saving ? t.actionSaving : t.actionDone,
        onPressed: canSubmit ? _submit : null,
      ),
      children: [
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.groupMemberRemarkHint,
            prefixBuilder: (context, style, variants) =>
                FTextField.prefixIconBuilder(
                  context,
                  style,
                  variants,
                  Icon(FIcons.pencil),
                ),
          ),
        ),
        if (_error.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 10),
            child: Text(
              _error,
              style: TextStyle(
                color: MoyuColors.of(context).red,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _submit() async {
    final value = _controller.text.trim();
    setState(() {
      _saving = true;
      _error = '';
    });
    try {
      await widget.socialGateway?.updateGroupMemberRemark(
        groupNo: widget.groupNo,
        memberUid: widget.memberUid,
        remark: value,
      );
      widget.onSaved(value);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }
}

class GroupQrCodePage extends StatefulWidget {
  const GroupQrCodePage({
    super.key,
    required this.group,
    this.socialGateway,
    this.config,
  });

  final UiGroup group;
  final ChatSocialGateway? socialGateway;
  final AppConfig? config;

  @override
  State<GroupQrCodePage> createState() => GroupQrCodePageState();
}

class GroupQrCodePageState extends State<GroupQrCodePage> {
  late final Future<ChatQrCode> _qrCode =
      widget.socialGateway?.loadGroupQrCode(widget.group.groupNo) ??
      Future.value(const ChatQrCode(data: ''));

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.groupQrCodeTitle,
      children: [
        Container(
          width: double.infinity,
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(22, 26, 22, 24),
          child: Column(
            children: [
              MoyuResolvedAvatar.raw(
                label: widget.group.avatarLabel,
                size: 58,
                colors: [
                  widget.group.color,
                  MoyuColors.of(context).primarySoft,
                ],
                imageUrl: AvatarResolver.group(
                  config: widget.config,
                  groupNo: widget.group.groupNo,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.group.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 20),
              QrCodeFutureView(future: _qrCode, emptyText: t.groupQrCodeEmpty),
              const SizedBox(height: 16),
              _GroupQrRemark(future: _qrCode),
            ],
          ),
        ),
      ],
    );
  }
}

class _GroupQrRemark extends StatelessWidget {
  const _GroupQrRemark({required this.future});

  final Future<ChatQrCode> future;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return FutureBuilder<ChatQrCode>(
      future: future,
      builder: (context, snapshot) {
        final code = snapshot.data;
        final text = code != null && code.day > 0 && code.expire.isNotEmpty
            ? t.groupQrCodeValid(code.day, code.expire)
            : t.groupQrCodeScanToJoin;
        return Center(
          child: Text(
            text,
            style: TextStyle(color: MoyuColors.of(context).textTertiary),
          ),
        );
      },
    );
  }
}

class GroupBlacklistPage extends StatefulWidget {
  const GroupBlacklistPage({
    super.key,
    required this.group,
    this.socialGateway,
    this.config,
  });

  final UiGroup group;
  final ChatSocialGateway? socialGateway;
  final AppConfig? config;

  @override
  State<GroupBlacklistPage> createState() => GroupBlacklistPageState();
}

class GroupBlacklistPageState extends State<GroupBlacklistPage> {
  /// 当前黑名单成员 — 从 server `loadGroupBlacklist` 拉. 之前是空 list 永远
  /// 显示"暂无", root cause 是没接 server API.
  final _members = <UiContact>[];

  /// 所有非黑名单的普通群成员 — 给"添加黑名单成员" picker 用. 排除 manager
  /// / creator (iOS WKGroupBlacklistVM:65 `getMembersWithChannel:role:Common`).
  final _availableMembers = <UiContact>[];

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    unawaited(_loadAll());
  }

  Future<void> _loadAll() async {
    // 并行拉两个 — blacklist 数据 + 普通成员候选, 一次进页一起 ready.
    final gateway = widget.socialGateway;
    if (gateway == null || _groupNo.isEmpty) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final results = await Future.wait([
        gateway.loadGroupBlacklist(_groupNo),
        gateway.loadGroupMembers(_groupNo),
      ]);
      if (!mounted) return;
      final blacklist = results[0];
      final allMembers = results[1];
      setState(() {
        _members
          ..clear()
          ..addAll([
            for (var i = 0; i < blacklist.length; i++)
              UiContact.fromSocial(
                blacklist[i],
                colors: conversationColors(i),
                config: widget.config,
              ),
          ]);
        _availableMembers
          ..clear()
          ..addAll([
            for (var i = 0; i < allMembers.length; i++)
              // role: 0=普通, 1=群主, 2=管理员; iOS 排除 manager/creator
              if (allMembers[i].role == 0)
                UiContact.fromSocial(
                  allMembers[i],
                  colors: conversationColors(i),
                  config: widget.config,
                ),
          ]);
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _loading = false);
      MoyuToast.show(
        context,
        AppLocalizations.of(context).groupBlacklistLoadFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.groupBlacklistTitle,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            if (_loading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(child: CircularProgressIndicator.adaptive()),
              )
            else if (_members.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(
                    t.groupBlacklistEmpty,
                    style: TextStyle(
                      color: MoyuColors.of(context).textTertiary,
                    ),
                  ),
                ),
              )
            else
              for (var i = 0; i < _members.length; i++) ...[
                GroupMemberContactTile(
                  contact: _members[i],
                  trailing: Text(
                    t.groupRemove,
                    style: TextStyle(
                      color: MoyuColors.of(context).red,
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => unawaited(_removeMember(_members[i])),
                ),
                if (i != _members.length - 1) const RowDivider(),
              ],
            const RowDivider(),
            PlainSettingRow(
              title: t.groupBlacklistAddMember,
              showChevron: true,
              onTap: () => unawaited(_addMember()),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _addMember() async {
    final t = AppLocalizations.of(context);
    // 真选成员流程 — 对齐 iOS WKGroupBlacklistVM:64 `toSelectMembers`: push
    // contacts.select (only role=Normal, 排除已在黑名单), 选完调 add API.
    final blacklistedUids = _members.map(contactChannelId).toSet();
    final candidates = [
      for (final m in _availableMembers)
        if (!blacklistedUids.contains(contactChannelId(m))) m,
    ];
    if (candidates.isEmpty) {
      MoyuToast.show(context, t.groupBlacklistNoCandidates);
      return;
    }
    final selected = await Navigator.of(context).push<List<UiContact>>(
      MaterialPageRoute(
        builder: (_) => MoyuContactPickerPage(
          title: t.groupSelectMember,
          contacts: candidates,
          selectedContacts: const [],
        ),
      ),
    );
    if (!mounted || selected == null || selected.isEmpty) return;
    final memberUids = [for (final m in selected) contactChannelId(m)];
    try {
      await widget.socialGateway?.addGroupBlacklist(
        groupNo: _groupNo,
        memberUids: memberUids,
      );
      if (!mounted) return;
      // 重拉, server 是真相源 (iOS 调 syncMemebers 同模式).
      await _loadAll();
      if (!mounted) return;
      MoyuToast.show(context, t.groupBlacklistAdded);
    } catch (error) {
      if (!mounted) return;
      MoyuToast.show(context, t.groupBlacklistAddFailed);
    }
  }

  Future<void> _removeMember(UiContact member) async {
    final t = AppLocalizations.of(context);
    final uid = contactChannelId(member);
    if (uid.isEmpty) return;
    // 二次确认 — 对齐 iOS WKGroupBlacklistVC.m:39 AlertController
    // '把"X"拉出群黑名单？'.
    var confirmed = false;
    await MoyuActionSheet.show(
      context,
      title: t.groupBlacklistRemoveConfirm(member.name),
      items: [
        MoyuActionSheetItem(
          title: t.groupBlacklistRemoveAction,
          destructive: true,
          onSelected: () => confirmed = true,
        ),
      ],
    );
    if (!confirmed || !mounted) return;
    try {
      await widget.socialGateway?.removeGroupBlacklist(
        groupNo: _groupNo,
        memberUids: [uid],
      );
      if (!mounted) return;
      await _loadAll();
    } catch (error) {
      if (!mounted) return;
      MoyuToast.show(context, t.groupBlacklistRemoveFailed);
    }
  }

  String get _groupNo =>
      widget.group.groupNo.isEmpty ? widget.group.name : widget.group.groupNo;
}

// =============================================================================
// GroupAvatarPage — 群头像查看 + 更换页 (对齐 iOS WKGroupAvatarVC)
// =============================================================================
// 整页白底, 中央大图 (ScreenWidth/2 居中). 右上 More 按钮弹 ActionSheet:
//   - 拍照 (admin only) → 相机 → square crop → 上传
//   - 从手机相册选择 (admin only) → 相册 → square crop → 上传
//   - 保存图片 (任何人) → 保存到系统相册
// 之前 _changeGroupAvatar 直接弹 picker, 缺"大图预览 + ActionSheet 选项 +
// 拍照 + 保存"四件事 — 对齐 iOS m:76-93 完整流程.

class GroupAvatarPage extends StatefulWidget {
  const GroupAvatarPage({
    super.key,
    required this.groupNo,
    required this.channelType,
    required this.isAdmin,
    required this.avatarUrl,
    required this.avatarLabel,
    required this.colors,
    this.socialGateway,
    this.imGateway,
    this.onAvatarUpdated,
  });

  final String groupNo;
  final int channelType;

  /// True = creator / manager. iOS m:78 只在该条件下显示拍照/相册.
  final bool isAdmin;
  final String avatarUrl;
  final String avatarLabel;
  final List<Color> colors;
  final ChatSocialGateway? socialGateway;
  final ChatImGateway? imGateway;
  final ValueChanged<String>? onAvatarUpdated;

  @override
  State<GroupAvatarPage> createState() => GroupAvatarPageState();
}

class GroupAvatarPageState extends State<GroupAvatarPage> {
  /// cache-bust query — 上传后改一下让 CachedNetworkImage 重拉.
  int _cacheBuster = 0;
  bool _uploading = false;

  String get _displayUrl {
    if (widget.avatarUrl.isEmpty) return '';
    final sep = widget.avatarUrl.contains('?') ? '&' : '?';
    return _cacheBuster == 0
        ? widget.avatarUrl
        : '${widget.avatarUrl}${sep}v=$_cacheBuster';
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final mediaSize = MediaQuery.sizeOf(context);
    final imgSide = mediaSize.width / 2;
    return FScaffold(
      childPad: false,
      child: ColoredBox(
        color: MoyuColors.of(context).background,
        child: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: SizedBox(
                  width: imgSide,
                  height: imgSide,
                  // 群头像编辑预览 — 统一头像自带方角圆角 (微信风
                  // size*0.18), 不再外层 ClipRRect 强制 8pt 窄圆角.
                  child: MoyuResolvedAvatar.raw(
                    label: widget.avatarLabel,
                    size: imgSide,
                    colors: widget.colors,
                    imageUrl: _displayUrl.isEmpty ? null : _displayUrl,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ColoredBox(
                color: MoyuColors.of(context).background,
                child: SafeArea(
                  bottom: false,
                  child: SizedBox(
                    height: 44,
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            t.groupAvatarTitle,
                            style: TextStyle(
                              color: MoyuColors.of(context).textPrimary,
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.16,
                            ),
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () =>
                              Navigator.of(context).maybePop(_displayUrl),
                          child: SizedBox(
                            width: 44,
                            height: 44,
                            child: Icon(
                              moyuBackChevronIcon(context),
                              color: MoyuColors.of(context).textPrimary,
                              size: 24,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: _showMoreSheet,
                            child: SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                FIcons.ellipsis,
                                color: MoyuColors.of(context).textPrimary,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_uploading)
              const Positioned.fill(
                child: ColoredBox(
                  color: Color(0x66000000),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showMoreSheet() {
    final t = AppLocalizations.of(context);
    final items = <MoyuActionSheetItem>[
      if (widget.isAdmin) ...[
        MoyuActionSheetItem(
          title: t.groupAvatarTakePhoto,
          onSelected: () => unawaited(_pickAndUpload(ImageSource.camera)),
        ),
        MoyuActionSheetItem(
          title: t.groupAvatarChooseFromAlbum,
          onSelected: () => unawaited(_pickAndUpload(ImageSource.gallery)),
        ),
      ],
      MoyuActionSheetItem(
        title: t.groupAvatarSaveImage,
        onSelected: () => unawaited(_saveCurrent()),
      ),
    ];
    MoyuActionSheet.show(context, items: items);
  }

  void _evictCachedAvatars(Iterable<String> urls) {
    for (final url in urls) {
      if (url.trim().isEmpty) continue;
      unawaited(
        CachedNetworkImage.evictFromCache(
          url,
        ).then<void>((_) {}).catchError((_) {}),
      );
    }
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final t = AppLocalizations.of(context);
    final gateway = widget.socialGateway;
    if (gateway == null) {
      MoyuToast.show(context, t.groupAvatarUnsupported);
      return;
    }
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: source, imageQuality: 90);
      if (picked == null || !mounted) return;
      final feature = AppRuntime.current?.registry.featureById(
        ModuleFeatureIds.imageCropLauncher,
      );
      final launcher = feature?.value;
      if (feature == null ||
          AppRuntime.current?.registry.isModuleEnabled(feature.moduleId) !=
              true ||
          launcher is! ImageCropLauncher) {
        MoyuToast.show(context, AppLocalizations.of(context).moduleUnsupported);
        return;
      }
      // square crop — 对齐 iOS m:111 AspectRatioPresetSquare.
      final croppedPath = await launcher(context, File(picked.path));
      if (croppedPath == null || !mounted) return;
      final staleAvatarUrls = <String>{
        if (widget.avatarUrl.isNotEmpty) widget.avatarUrl,
        if (_displayUrl.isNotEmpty) _displayUrl,
      };
      setState(() => _uploading = true);
      await gateway.uploadGroupAvatar(
        groupNo: widget.groupNo,
        filePath: croppedPath,
      );
      if (!mounted) return;
      _evictCachedAvatars(staleAvatarUrls);
      setState(() {
        _uploading = false;
        _cacheBuster = DateTime.now().millisecondsSinceEpoch;
      });
      widget.onAvatarUpdated?.call(_displayUrl);
      unawaited(
        widget.imGateway?.refreshChannel(
              channelId: widget.groupNo,
              channelType: widget.channelType,
            ) ??
            Future.value(),
      );
      MoyuToast.show(context, t.groupAvatarUpdated);
    } catch (error) {
      if (!mounted) return;
      setState(() => _uploading = false);
      MoyuToast.show(context, t.groupAvatarUpdateFailed);
    }
  }

  Future<void> _saveCurrent() async {
    final t = AppLocalizations.of(context);
    final url = _displayUrl;
    if (url.isEmpty) {
      MoyuToast.show(context, t.groupAvatarNoImageToSave);
      return;
    }
    try {
      final tempDir = await getTemporaryDirectory();
      final tempPath =
          '${tempDir.path}/group-avatar-${widget.groupNo}-${DateTime.now().millisecondsSinceEpoch}.jpg';
      final dio = Dio();
      await dio.download(url, tempPath);
      if (!mounted) return;
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          if (!mounted) return;
          MoyuToast.show(
            context,
            t.groupPhotoPermissionRequired(AppBrand.displayName),
          );
          return;
        }
      }
      await Gal.putImage(tempPath);
      if (!mounted) return;
      MoyuToast.show(context, t.groupImageSavedToAlbum);
    } catch (error) {
      if (!mounted) return;
      MoyuToast.show(context, t.groupImageSaveFailed);
    }
  }
}
