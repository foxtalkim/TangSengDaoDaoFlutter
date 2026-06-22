// 聊天设置 + 消息搜索 + 投诉。从 home_shell.dart 拆出。
import 'dart:async' show unawaited;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../chat/chat_message.dart';
import '../../config/app_config.dart';
import '../../conversation/chat_conversation.dart';
import '../../im/wukong_im_service.dart' show ChatImGateway;
import '../../l10n/app_localizations.dart';
import '../../social/social_service.dart'
    show ChatGlobalMessage, ChatGroup, ChatSocialGateway;
import '../flame_duration_helpers.dart';
import '../chat_navigation.dart';
import '../contact_list_widgets.dart' show contactChannelId, isSystemFileHelper;
import '../detail_scaffold.dart';
import '../home_seed_data.dart' show conversationColors;
import '../models/contact_models.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_group_widgets.dart';
import '../settings_layout.dart' show MoyuContactPickerPage;
import '../settings_row_widgets.dart';
import 'account_pages.dart'
    show
        ChatNotificationSettingsPage,
        ChatPasswordPage,
        GroupRemarkEditorPage,
        SwitchRowWithSubtitle;
import 'chat_background_pages.dart'
    show ChatBackgroundsPage, chatBackgroundChannelScope;
import 'complaint_page.dart' show ComplaintPage;
import 'friend_pages.dart' show ContactDetailPage;
import 'group_pages.dart'
    show
        GroupAvatarPage,
        GroupFieldEditorPage,
        GroupManagePage,
        GroupMemberRemarkEditorPage,
        GroupNoticeMeta,
        GroupNoticeListPage,
        GroupQrCodePage;
import 'search_message_widgets.dart'
    show SearchMessageTile, SearchTabChip, searchConversationFromChannelMessage;
import 'shared_widgets_models.dart' show MemberRoleBadge, SwitchRow;

class ConversationSettingsPage extends StatefulWidget {
  const ConversationSettingsPage({
    super.key,
    required this.conversation,
    required this.messages,
    required this.config,
    required this.loginUid,
    required this.loginName,
    required this.loginChatPwd,
    required this.onClearMessages,
    required this.onDeleteConversation,
    this.imGateway,
    this.socialGateway,
    this.onScreenshotNotifyChanged,
    this.onFlameChanged,
    this.onJumpToMessage,
    this.onGroupRemarkChanged,
    this.onContactRemoved,
    this.contacts = const [],
  });

  final ChatConversation conversation;
  final List<ChatMessage> messages;
  final AppConfig config;
  final String loginUid;
  final String loginName;
  final String loginChatPwd;
  final VoidCallback onClearMessages;
  final Future<void> Function() onDeleteConversation;
  final ChatImGateway? imGateway;
  final ChatSocialGateway? socialGateway;

  /// Login user's full contact roster — feeds the "+" picker on the
  /// member grid so we can offer adoptable invitees that aren't
  /// already in the group / chat. Optional: defaults to empty so
  /// older call-sites don't break.
  final List<UiContact> contacts;

  /// Hook back to the parent chat screen so toggling 截屏通知 from this
  /// page updates the gate the screen-capture listener consults
  /// immediately (rather than waiting for a fresh conversation
  /// snapshot to round-trip back through the IM stream).
  final ValueChanged<bool>? onScreenshotNotifyChanged;

  /// Hook back to the parent chat screen so toggling 阅后即焚 (or
  /// changing the TTL) from this page updates the header chip
  /// (block 5.7) immediately.
  final void Function(bool enabled, int seconds)? onFlameChanged;

  /// 用户在 MessageSearchPage tap 一条结果时回调 — 收到目标 messageId,
  /// 让聊天页 scrollToMessage 定位 (对齐 iOS locationAtOrderSeq). settings
  /// 在收到回调内 pop 自己 + 透传给 chat. 没 hook 则只 pop 不滚动.
  final ValueChanged<String>? onJumpToMessage;
  final ValueChanged<String>? onGroupRemarkChanged;
  final ValueChanged<String>? onContactRemoved;

  @override
  State<ConversationSettingsPage> createState() =>
      ConversationSettingsPageState();
}

class ConversationSettingsPageState extends State<ConversationSettingsPage> {
  bool _blocked = false;
  late bool _muted;
  late bool _pinned;
  late bool _receiptEnabled;
  late bool _chatPasswordEnabled;
  late bool _flameEnabled;
  late int _flameSecond;
  // Initialized from `widget.conversation.notifyScreenshot` in
  // `initState` so toggling the setting reflects the actual server
  // state on page open (was previously hard-coded false → toggle UI
  // always showed the wrong initial value for groups, which default
  // on per native).
  late bool _screenshotNotify;
  bool _revokeNotify = false;
  late String _groupNickname;
  bool _savedToContacts = true;

  /// Group-only state. When `_isGroup` is false these stay at their
  /// defaults — the build-side `if (_isGroup)` branches never read them.
  late String _groupName;
  String _groupNotice = '';
  String _groupRemark = '';
  late String _groupAvatarUrl;
  int _groupMemberCount = 0;
  int _myRole = 0;
  ChatGroup? _groupInfo;
  GroupNoticeMeta? _groupNoticeLocalMeta;
  final List<UiContact> _groupMembers = <UiContact>[];

  bool get _isGroup => widget.conversation.channelType == 2;

  /// True when the login user is owner (role 2) or manager (role 1)
  /// of the open group. Drives visibility of the 「群管理」 entry, mirroring
  /// the iOS native page where the admin section is gated by role.
  bool get _isAdmin => _isGroup && _myRole >= 1;

  GroupNoticeMeta _groupNoticeMeta() {
    final message = _latestNoticeUpdateMessage();
    if (message == null) {
      return _groupNoticeLocalMeta ?? const GroupNoticeMeta();
    }
    final uid = _noticePublisherUid(message);
    final avatarUrl = message.fromAvatarUrl.trim().isNotEmpty
        ? message.fromAvatarUrl.trim()
        : uid.isEmpty
        ? ''
        : AvatarResolver.user(config: widget.config, uid: uid);
    final messageMeta = GroupNoticeMeta(
      publisherUid: uid,
      publisherName: _noticePublisherName(message),
      publisherAvatarUrl: avatarUrl,
      publishedAt: _dateFromSeconds(message.timestamp),
    );
    final localMeta = _groupNoticeLocalMeta;
    if (localMeta?.publishedAt != null && messageMeta.publishedAt != null) {
      if (localMeta!.publishedAt!.isAfter(messageMeta.publishedAt!)) {
        return localMeta;
      }
    }
    return messageMeta;
  }

  GroupNoticeMeta _currentUserNoticeMeta() {
    final uid = widget.loginUid.trim();
    return GroupNoticeMeta(
      publisherUid: uid,
      publisherName: widget.loginName.trim(),
      publisherAvatarUrl: AvatarResolver.user(config: widget.config, uid: uid),
    );
  }

  ChatMessage? _latestNoticeUpdateMessage() {
    for (final message in widget.messages.reversed) {
      if (_isNoticeUpdateMessage(message)) {
        return message;
      }
    }
    return null;
  }

  bool _isNoticeUpdateMessage(ChatMessage message) {
    if (message.contentType == 1005) {
      final attr = (message.data['attr'] ?? message.data['attribute'] ?? '')
          .toString();
      if (attr == 'notice') return true;
      final data = message.data['data'];
      if (data is Map && data.containsKey('notice')) return true;
      if (message.data.containsKey('notice')) return true;
      final text = message.effectiveText.trim();
      return text.contains('修改群公告') || text.contains('群公告为');
    }
    if (!message.isSystemMessage) return false;
    final text = message.effectiveText.trim();
    return text.contains('修改群公告') || text.contains('群公告为');
  }

  String _noticePublisherUid(ChatMessage message) {
    final fromData =
        (message.data['operator'] ??
                message.data['operator_uid'] ??
                message.data['operatorUid'] ??
                message.data['from_uid'] ??
                '')
            .toString()
            .trim();
    if (fromData.isNotEmpty) return fromData;
    final extra = message.data['extra'];
    if (extra is List && extra.isNotEmpty) {
      final first = extra.first;
      if (first is Map) {
        final uid = (first['uid'] ?? first['user_id'] ?? '').toString().trim();
        if (uid.isNotEmpty) return uid;
      }
    }
    return message.fromUid.trim();
  }

  String _noticePublisherName(ChatMessage message) {
    final fromData =
        (message.data['operator_name'] ??
                message.data['operatorName'] ??
                message.data['from_name'] ??
                '')
            .toString()
            .trim();
    if (fromData.isNotEmpty) return fromData;

    final extra = message.data['extra'];
    if (extra is List && extra.isNotEmpty) {
      final first = extra.first;
      if (first is Map) {
        final name =
            (first['name'] ?? first['nickname'] ?? first['display_name'] ?? '')
                .toString()
                .trim();
        if (name.isNotEmpty) return name;
      }
    }

    final match = RegExp(
      r'^(.+?)\s*修改群公告',
    ).firstMatch(message.effectiveText.trim());
    final parsed = match?.group(1)?.trim() ?? '';
    if (parsed.isNotEmpty) return parsed;
    return message.fromName.trim();
  }

  DateTime? _dateFromSeconds(int value) {
    if (value <= 0) return null;
    return DateTime.fromMillisecondsSinceEpoch(value * 1000);
  }

  String _groupRemarkKey() =>
      'group_remark::${widget.loginUid}::${widget.conversation.channelId}';

  @override
  void initState() {
    super.initState();
    _muted = widget.conversation.muted;
    _pinned = widget.conversation.pinned;
    _receiptEnabled = widget.conversation.receiptEnabled;
    _chatPasswordEnabled = widget.conversation.chatPasswordEnabled;
    _flameEnabled = widget.conversation.flameEnabled;
    _flameSecond = widget.conversation.flameSecond;
    _screenshotNotify = widget.conversation.notifyScreenshot;
    _groupNickname = widget.loginName;
    _groupName = widget.conversation.name;
    _groupAvatarUrl = _resolvedGroupAvatarUrl(widget.conversation.avatarPath);
    _groupMemberCount = 0; // 由 _loadGroupInfo 拿 server 权威值填, 不再 regex/默认2 瞎猜
    if (_isGroup) {
      unawaited(_loadGroupNickname());
      unawaited(_loadGroupInfo());
      unawaited(_loadGroupMembers());
      unawaited(_loadGroupRemark());
    }
  }

  @override
  void didUpdateWidget(covariant ConversationSettingsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.conversation.channelId != widget.conversation.channelId ||
        oldWidget.conversation.avatarPath != widget.conversation.avatarPath) {
      _groupAvatarUrl = _resolvedGroupAvatarUrl(widget.conversation.avatarPath);
    }
  }

  String _resolvedGroupAvatarUrl(String imageUrl) {
    if (!_isGroup) return imageUrl;
    final groupNo = widget.conversation.channelId.trim();
    if (groupNo.isEmpty) return imageUrl;
    return AvatarResolver.group(
      config: widget.config,
      groupNo: groupNo,
      imageUrl: imageUrl,
    );
  }

  Future<void> _loadGroupRemark() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_groupRemarkKey()) ?? '';
      if (!mounted || stored.isEmpty) {
        return;
      }
      setState(() => _groupRemark = stored);
    } catch (_) {
      // SharedPreferences failure is non-fatal — remark just stays empty.
    }
  }

  Future<void> _saveGroupRemark(String value) async {
    // 对齐 iOS WKChannelSettingManager.channel:remark: (m:206-213) — 群备注是
    // **服务端字段** (channelInfo.remark), 通过 `PUT groups/<no>/setting`
    // body {"remark": value} 写到 server. 多设备共享, 跨重装保留.
    // 之前 Flutter 只存 SharedPreferences → 换设备/重装丢, 别人设备看不到.
    setState(() => _groupRemark = value);
    widget.onGroupRemarkChanged?.call(value);
    // 先存本地兜底, server 失败也保留 UI 显示
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value.isEmpty) {
        await prefs.remove(_groupRemarkKey());
      } else {
        await prefs.setString(_groupRemarkKey(), value);
      }
    } catch (_) {}
    // server 同步: groups/<no>/setting (PUT)
    final gateway = widget.socialGateway;
    final groupNo = widget.conversation.channelId;
    if (gateway == null || groupNo.isEmpty) return;
    try {
      await gateway.updateGroupSetting(
        groupNo: groupNo,
        setting: {'remark': value},
      );
      // 刷 channel info 让 conversation list 也更新 (iOS 收到 channelInfoUpdate
      // 通知自动 reload).
      await widget.imGateway?.refreshChannel(
        channelId: groupNo,
        channelType: widget.conversation.channelType,
      );
    } catch (error) {
      if (!mounted) return;
      MoyuToast.show(
        context,
        AppLocalizations.of(context).groupRemarkSyncFailed(error.toString()),
      );
    }
  }

  Future<void> _loadGroupInfo() async {
    final gateway = widget.socialGateway;
    final groupNo = widget.conversation.channelId;
    if (gateway == null || groupNo.isEmpty) {
      return;
    }
    try {
      final group = await gateway.loadGroupInfo(groupNo);
      if (!mounted || group == null) {
        return;
      }
      setState(() {
        _groupInfo = group;
        _groupName = group.name.isEmpty ? _groupName : group.name;
        _groupNotice = group.notice;
        if (group.memberCount > 0) {
          _groupMemberCount = group.memberCount;
        }
      });
    } catch (_) {
      // Surface nothing — fall back to conversation snapshot values.
    }
  }

  Future<void> _loadGroupMembers() async {
    final gateway = widget.socialGateway;
    final groupNo = widget.conversation.channelId;
    if (gateway == null || groupNo.isEmpty) {
      return;
    }
    try {
      final members = await gateway.loadGroupMembers(groupNo);
      if (!mounted) {
        return;
      }
      setState(() {
        _groupMembers
          ..clear()
          ..addAll([
            for (var i = 0; i < members.length; i++)
              UiContact.fromSocial(
                members[i],
                colors: conversationColors(i),
                config: widget.config,
              ),
          ]);
        if (members.isNotEmpty) {
          _groupMemberCount = members.length;
        }
        // Capture the login user's role so the admin entry can gate
        // by it. ChatContact role: 1 = owner, 2 = manager.
        for (final m in members) {
          if (m.uid == widget.loginUid) {
            _myRole = m.role;
            break;
          }
        }
      });
    } catch (_) {
      // Members are decorative on this page — silent fallback.
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final conversation = widget.conversation;

    return DetailScaffold(
      title: _isGroup
          ? t.chatSettingsGroupTitle(_groupMemberCount)
          : t.chatSettingsTitle,
      children: [
        // Member grid header — 对齐 iOS WKSettingMemberGridView:
        //   每行固定 5 个 cell, member 列后接 + 按钮; admin/creator 再多
        //   一个 - 按钮. LayoutBuilder 算 cellW = (w - 4*spacing)/5 让一
        //   行恰好 5 列, 不让 Wrap 在小屏自适应成 4 列.
        _flatGroup(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
          rows: [
            LayoutBuilder(
              builder: (context, constraints) {
                const cols = 5;
                const spacing = 14.0;
                const runSpacing = 12.0;
                final cellW =
                    (constraints.maxWidth - (cols - 1) * spacing) / cols;
                final cells = <Widget>[
                  for (final contact in _settingMembers())
                    _memberAvatarCell(contact, cellW),
                  // 加号永远显示 (对齐 iOS showMemberAddBtn = YES)
                  _memberAddCell(cellW),
                  // 减号只 admin/creator 显示 (对齐 iOS showMemberSubBtn =
                  // isManagerOrCreatorForMe)
                  if (_isAdmin) _memberSubCell(cellW),
                ];
                final rows = <Widget>[];
                for (var i = 0; i < cells.length; i += cols) {
                  final rowCells = <Widget>[];
                  for (var j = 0; j < cols; j++) {
                    if (j > 0) {
                      rowCells.add(const SizedBox(width: spacing));
                    }
                    final idx = i + j;
                    rowCells.add(
                      idx < cells.length ? cells[idx] : SizedBox(width: cellW),
                    );
                  }
                  rows.add(
                    Padding(
                      padding: EdgeInsets.only(top: i == 0 ? 0 : runSpacing),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: rowCells,
                      ),
                    ),
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rows,
                );
              },
            ),
          ],
        ),
        if (_isGroup) ...[
          _settingsGap(),
          _flatGroup(
            rows: [
              PlainSettingRow(
                title: t.chatSettingsGroupName,
                value: _groupName,
                showChevron: true,
                onTap: () => _editGroupField(
                  title: t.chatSettingsGroupName,
                  fieldKey: 'name',
                  initialValue: _groupName,
                  onSaved: (value) => setState(() => _groupName = value),
                ),
              ),
              const RowDivider(),
              PlainSettingRow(
                title: t.groupAvatarTitle,
                trailing: MoyuResolvedAvatar.raw(
                  label: widget.conversation.avatarLabel,
                  size: 28,
                  colors: widget.conversation.colors,
                  imageUrl: _groupAvatarUrl,
                ),
                onTap: () => unawaited(_changeGroupAvatar()),
              ),
              const RowDivider(),
              PlainSettingRow(
                title: t.groupRemarkTitle,
                value: _groupRemark,
                showChevron: true,
                onTap: _openGroupRemarkEditor,
              ),
              const RowDivider(),
              PlainSettingRow(
                title: t.chatSettingsGroupQrCode,
                trailing: Icon(
                  FIcons.qrCode,
                  size: 18,
                  color: MoyuColors.of(context).textSecondary,
                ),
                showChevron: true,
                onTap: _openGroupQrCode,
              ),
              const RowDivider(),
              PlainSettingRow(
                title: t.groupNoticeTitle,
                value: _groupNotice.isEmpty ? t.groupNoticeUnset : _groupNotice,
                valueMuted: _groupNotice.isEmpty,
                showChevron: true,
                onTap: () => pushPage(
                  context,
                  GroupNoticeListPage(
                    groupNo: widget.conversation.channelId,
                    notice: _groupNotice,
                    meta: _groupNoticeMeta(),
                    currentUserMeta: _currentUserNoticeMeta(),
                    canEdit: _isAdmin,
                    socialGateway: widget.socialGateway,
                    onSaved: (value) {
                      setState(() {
                        _groupNotice = value;
                        _groupNoticeLocalMeta = value.trim().isEmpty
                            ? null
                            : _currentUserNoticeMeta().withPublishedAt(
                                DateTime.now(),
                              );
                      });
                      unawaited(
                        widget.imGateway?.refreshChannel(
                              channelId: widget.conversation.channelId,
                              channelType: widget.conversation.channelType,
                            ) ??
                            Future.value(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
        if (_isAdmin) ...[
          _settingsGap(),
          _flatGroup(
            rows: [
              PlainSettingRow(
                title: t.groupManageTitle,
                showChevron: true,
                onTap: _openGroupManage,
              ),
            ],
          ),
        ],
        _settingsGap(),
        _flatGroup(
          rows: [
            PlainSettingRow(
              title: t.chatSearchContentTitle,
              showChevron: true,
              onTap: () => pushPage(
                context,
                MessageSearchPage(
                  conversation: conversation,
                  messages: widget.messages,
                  socialGateway: widget.socialGateway,
                  config: widget.config,
                  onJumpToMessage: (messageId) {
                    // MessageSearchPage 自己已 pop search; 这里 pop settings
                    // 回到 chat, 然后透传 messageId 让 chat 滚定位.
                    Navigator.of(context).pop();
                    widget.onJumpToMessage?.call(messageId);
                  },
                ),
              ),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.chatSettingsBackground,
              showChevron: true,
              onTap: () => pushPage(
                context,
                ChatBackgroundsPage(
                  config: widget.config,
                  loginUid: widget.loginUid,
                  socialGateway: widget.socialGateway,
                  scopeSuffix: chatBackgroundChannelScope(
                    widget.conversation.channelType,
                    widget.conversation.channelId,
                  ),
                  selectedStatus: t.chatSettingsBackgroundSelected,
                ),
              ),
            ),
            const RowDivider(),
            SwitchRow(
              title: t.chatSettingsMute,
              value: _muted,
              onChanged: (value) =>
                  unawaited(_updateChannelSetting('mute', value)),
            ),
            const RowDivider(),
            SwitchRow(
              title: t.chatSettingsPin,
              value: _pinned,
              onChanged: (value) =>
                  unawaited(_updateChannelSetting('top', value)),
            ),
            if (_isGroup) ...[
              const RowDivider(),
              SwitchRow(
                title: t.chatSettingsSaveToContacts,
                value: _savedToContacts,
                onChanged: (value) => unawaited(_updateGroupSave(value)),
              ),
            ],
            const RowDivider(),
            SwitchRow(
              title: t.securityChatPassword,
              value: _chatPasswordEnabled,
              onChanged: (value) =>
                  unawaited(_updateChatPasswordSetting(value)),
            ),
            const RowDivider(),
            SwitchRowWithSubtitle(
              title: t.chatSettingsReadReceipt,
              subtitle: t.chatSettingsReadReceiptSubtitle,
              value: _receiptEnabled,
              onChanged: (value) =>
                  unawaited(_updateChannelSetting('receipt', value)),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.chatNotificationSettingsTitle,
              showChevron: true,
              onTap: () => pushPage(
                context,
                ChatNotificationSettingsPage(
                  screenshotNotify: _screenshotNotify,
                  revokeNotify: _revokeNotify,
                  onScreenshotChanged: (value) {
                    setState(() => _screenshotNotify = value);
                    unawaited(_updateReminderSetting('screenshot', value));
                  },
                  onRevokeChanged: (value) {
                    setState(() => _revokeNotify = value);
                    unawaited(_updateReminderSetting('revoke_remind', value));
                  },
                ),
              ),
            ),
            const RowDivider(),
            // 阅后即焚 — toggle row "阅后即焚 [开关]" 跟周围其他 SwitchRow
            // 统一风格 (项目统一优先). 开关 ON 后下面才展开 tip + Slider 详细
            // 设置卡片. iOS WKFlameSettingView.m 实际是 always 显 80pt 卡片
            // (含 switch + slider 同行), 但 user 反馈"先展示开关, 开了才有
            // slider"更符合预期 — 接受偏离 iOS 紧凑布局, 用 toggle + 展开模式.
            SwitchRow(
              title: t.chatSettingsFlame,
              value: _flameEnabled,
              onChanged: (value) =>
                  unawaited(_updateChannelSetting('flame', value)),
            ),
            if (_flameEnabled) ...[
              const RowDivider(),
              // 展开后的详细面板: 火焰 icon + 动态 tip + 离散 Slider (7 step).
              // 对齐 iOS WKFlameSettingView 的 tip 文案 + Slider 0-6 mapping.
              Container(
                color: MoyuColors.of(context).background,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 1),
                          child: Icon(
                            FIcons.flame,
                            size: 16,
                            color: MoyuColors.of(context).red,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _flameTipText(t, _flameSecond),
                            style: TextStyle(
                              color: MoyuColors.of(context).textSecondary,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // forui FScaffold 不带, 包 Material(transparent) 最轻.
                    Material(
                      color: Colors.transparent,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(trackHeight: 2),
                        child: Slider(
                          value: flameSecondToProgress(_flameSecond).toDouble(),
                          min: 0,
                          max: 6,
                          divisions: 6,
                          label: _flameSecondLabel(t, _flameSecond),
                          onChanged: (v) => setState(
                            () =>
                                _flameSecond = flameProgressToSecond(v.toInt()),
                          ),
                          onChangeEnd: (v) => unawaited(
                            _updateFlameSecond(
                              flameProgressToSecond(v.toInt()),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (_isGroup) ...[
              const RowDivider(),
              PlainSettingRow(
                title: t.chatSettingsGroupNickname,
                value: _groupNickname,
                showChevron: true,
                onTap: () => pushPage(
                  context,
                  GroupMemberRemarkEditorPage(
                    groupNo: widget.conversation.channelId,
                    memberUid: widget.loginUid,
                    initialValue: _groupNickname,
                    socialGateway: widget.socialGateway,
                    onSaved: (value) => setState(() => _groupNickname = value),
                  ),
                ),
              ),
            ],
          ],
        ),
        _settingsGap(),
        _flatGroup(
          rows: [
            if (!_isGroup) ...[
              PlainSettingRow(
                title: _blocked
                    ? t.chatSettingsBlacklisted
                    : t.contactAddToBlacklist,
                value: _blocked ? t.chatSettingsPeerBlacklisted : '',
                valueMuted: true,
                showChevron: false,
                onTap: _blocked
                    ? null
                    : () => unawaited(_confirmBlockConversation()),
              ),
              const RowDivider(),
            ],
            PlainSettingRow(
              title: t.chatSettingsComplaint,
              showChevron: true,
              onTap: () => pushPage(
                context,
                ComplaintPage(
                  conversation: conversation,
                  socialGateway: widget.socialGateway,
                ),
              ),
            ),
          ],
        ),
        _settingsGap(),
        // 删除并退出 / 清空聊天记录 — 跟"退出登录"同款 destructive row 样式
        // (danger + center, 满铺白底 + 红字居中), 不再用 FButton outline.
        _flatGroup(
          rows: [
            PlainSettingRow(
              title: _isGroup
                  ? t.chatSettingsDeleteAndExit
                  : t.generalClearMessages,
              danger: true,
              center: true,
              onTap: _isGroup
                  ? () => unawaited(_confirmDeleteConversation())
                  : () => unawaited(_confirmClearMessages()),
            ),
          ],
        ),
        _settingsGap(),
      ],
    );
  }

  Widget _flatGroup({
    required List<Widget> rows,
    EdgeInsets padding = EdgeInsets.zero,
  }) => settingsFlatGroup(context, rows: rows, padding: padding);

  Widget _settingsGap() => settingsBlockGap(context);

  String _flameTipText(AppLocalizations t, int second) {
    if (second <= 0) return t.chatFlameTipExit;
    if (second >= 60) return t.chatFlameTipMinutes(second ~/ 60);
    return t.chatFlameTipSeconds(second);
  }

  String _flameSecondLabel(AppLocalizations t, int second) {
    if (second <= 0) return t.valueOff;
    if (second >= 60) return t.chatFlameLabelMinutes(second ~/ 60);
    return t.chatFlameLabelSeconds(second);
  }

  List<UiContact> _settingMembers() {
    if (_isGroup) {
      // Prefer freshly-fetched group members (carry role for badge);
      // fall back to global contact roster while the fetch is in
      // flight so the grid never blanks out on first paint.
      // Role enum: 0=common, 1=creator, 2=manager — straight numeric
      // compare would put manager before creator, so remap to a
      // priority axis (creator > manager > common).
      int prio(int role) => role == 1 ? 2 : (role == 2 ? 1 : 0);
      // 不再用 seedContacts 占位 (加载时闪假成员)。空就只显示操作按钮,
      // 拿到真实成员再填。
      final source = _groupMembers;
      final sorted = [...source];
      sorted.sort((a, b) => prio(b.role).compareTo(prio(a.role)));
      // 对齐 iOS WKConversationGroupSettingVC.viewDidLoad limitMemberCount:
      //   admin = 20 - 2(+/-) = 18; 普通 = 20 - 1(+) = 19.
      //   每行 5 cells × 4 行 = 20 槽位, member 数 + 操作按钮恰好填满.
      return sorted.take(_isAdmin ? 18 : 19).toList();
    }

    return [
      UiContact(
        uid: widget.conversation.channelId,
        name: widget.conversation.name,
        avatarLabel: widget.conversation.avatarLabel,
        avatarPath: widget.conversation.avatarPath,
        colors: widget.conversation.colors,
        online: widget.conversation.online,
      ),
    ];
  }

  /// Member-avatar tap in chat detail → push the iOS-style profile
  /// page. Matches native `WKConversationPersonSettingVC.membberAvatarClick`
  /// which invokes `WKPOINT_USER_INFO` to surface `WKUserInfoVC`. The
  /// 发消息 button inside the profile pops back to the chat (one extra
  /// pop here closes the settings page so we land on the conversation).
  ///
  /// 在 widget.contacts (friend/sync 全量好友列表) 里查同 uid 的更
  /// 完整的 UiContact —— 服务端 /groups/<no>/members 不返 short_no，
  /// 而 friend/sync 会返。命中则用 friend 版本（带 subtitle），不然
  /// 退回 chat-settings 本地的 contact（陌生群友）。
  /// 同时透传 widget.config 让 ContactDetailPage 能 resolve 头像 URL。
  void _openMemberProfile(UiContact contact) {
    UiContact resolved = contact;
    if (contact.uid.isNotEmpty) {
      for (final c in widget.contacts) {
        if (c.uid == contact.uid) {
          resolved = c;
          break;
        }
      }
    }
    pushPage(
      context,
      ContactDetailPage(
        contact: resolved,
        loginUid: widget.loginUid,
        loginName: widget.loginName,
        socialGateway: widget.socialGateway,
        imGateway: widget.imGateway,
        config: widget.config,
        onContactRemoved: widget.onContactRemoved,
        onOpenChat: (_) async {
          if (mounted) {
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Future<void> _updateChannelSetting(String key, bool value) async {
    setState(() {
      if (key == 'mute') {
        _muted = value;
      } else if (key == 'top') {
        _pinned = value;
      } else if (key == 'receipt') {
        _receiptEnabled = value;
      } else if (key == 'chat_pwd_on') {
        _chatPasswordEnabled = value;
      } else if (key == 'flame') {
        _flameEnabled = value;
      }
    });
    // Surface flame mirror updates to the parent chat screen even when
    // the remote PUT is skipped (e.g. local-only conversations in
    // tests / offline mode). The local UI flip should still propagate
    // so the chat header's flame chip and per-bubble timers reconcile.
    if (key == 'flame') {
      widget.onFlameChanged?.call(_flameEnabled, _flameSecond);
    }
    final gateway = widget.imGateway;
    if (gateway == null || !widget.conversation.isRemote) {
      return;
    }
    await gateway.updateChannelSetting(
      channelId: widget.conversation.channelId,
      channelType: widget.conversation.channelType,
      setting: {key: value ? 1 : 0},
    );
  }

  Future<void> _updateFlameSecond(int second) async {
    setState(() => _flameSecond = second);
    widget.onFlameChanged?.call(_flameEnabled, _flameSecond);
    final gateway = widget.imGateway;
    if (gateway == null || !widget.conversation.isRemote) {
      return;
    }
    await gateway.updateChannelSetting(
      channelId: widget.conversation.channelId,
      channelType: widget.conversation.channelType,
      setting: {'flame_second': second},
    );
  }

  Future<void> _updateChatPasswordSetting(bool value) async {
    // 关闭 → 直接 PUT chat_pwd_on=0
    if (!value) {
      await _updateChannelSetting('chat_pwd_on', false);
      return;
    }
    // 开启 + 用户没设过全局账号密码 → 先让用户设全局密码 (push 全屏 page),
    // 用户在该 page 成功 setChatPassword 后 pop(true), 我们这里接着开
    // per-channel chat_pwd_on. 否则只 push 不接续 → 用户回来后开关还是
    // off 状态, 必须再点一次才生效 — 这就是用户报"重进显关闭"BUG.
    if (widget.loginChatPwd.isEmpty) {
      // 先回滚 switch 到 off (await 期间防止视觉抖动), push 后据返回值
      // 再决定要不要重开.
      setState(() => _chatPasswordEnabled = false);
      final ok = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => ChatPasswordPage(
            loginUid: widget.loginUid,
            socialGateway: widget.socialGateway,
          ),
        ),
      );
      if (!mounted || ok != true) return;
      // 全局密码设好了, 接着开 per-channel chat_pwd_on
      setState(() => _chatPasswordEnabled = true);
      await _updateChannelSetting('chat_pwd_on', true);
      return;
    }
    // 全局密码已设, 直接开
    await _updateChannelSetting('chat_pwd_on', true);
  }

  Future<void> _updateReminderSetting(String key, bool value) async {
    setState(() {
      if (key == 'screenshot') {
        _screenshotNotify = value;
      } else if (key == 'revoke_remind') {
        _revokeNotify = value;
      }
    });
    final setting = {key: value ? 1 : 0};
    if (_isGroup) {
      await widget.socialGateway?.updateGroupSetting(
        groupNo: widget.conversation.channelId,
        setting: setting,
      );
    } else {
      await widget.socialGateway?.updateUserSetting(
        uid: widget.conversation.channelId,
        setting: setting,
      );
    }
    // 修"开关重进恢复"BUG — 写完 server 必须刷 SDK channel info, 否则
    // conversation list / chat header / 重进设置页 widget.conversation
    // 都拿 stale 数据.
    await widget.imGateway?.refreshChannel(
      channelId: widget.conversation.channelId,
      channelType: widget.conversation.channelType,
    );
    if (key == 'screenshot') {
      // Surface the new value to the parent chat screen so its
      // screen-capture broadcast gate flips immediately. Without this
      // the chat would keep using the stale `widget.conversation`
      // snapshot it was opened with until a fresh sync arrives.
      widget.onScreenshotNotifyChanged?.call(value);
    }
  }

  Future<void> _loadGroupNickname() async {
    final gateway = widget.socialGateway;
    if (gateway == null) {
      return;
    }
    final members = await gateway.loadGroupMembers(
      widget.conversation.channelId,
    );
    if (!mounted) {
      return;
    }
    for (final member in members) {
      if (member.uid != widget.loginUid) {
        continue;
      }
      final nickname = member.displayName;
      if (nickname.isNotEmpty) {
        setState(() => _groupNickname = nickname);
      }
      return;
    }
  }

  /// 群设置头像格 — avatar cell (member). 对齐 iOS
  /// WKConversationGroupSettingVC.memberAvatarView: role badge 是头像内部
  /// 底部居中 overlay，不占用头像和名字之间的纵向布局。
  Widget _memberAvatarCell(UiContact contact, double cellW) {
    return SizedBox(
      width: cellW,
      child: FTappable(
        behavior: HitTestBehavior.opaque,
        onPress: contact.uid.isEmpty ? null : () => _openMemberProfile(contact),
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                MoyuResolvedAvatar.raw(
                  label: contact.avatarLabel,
                  size: 42,
                  colors: contact.colors,
                  online: contact.online,
                  imageUrl: contact.avatarPath,
                ),
                if (_isGroup && contact.role > 0)
                  Positioned(
                    bottom: 0,
                    child: MemberRoleBadge(role: contact.role),
                  ),
              ],
            ),
            const SizedBox(height: 5),
            Text(
              contact.name,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  /// 加号 cell — 永远显示, 对齐 iOS WKConversationGroupSettingVC
  /// showMemberAddBtn = YES.
  Widget _memberAddCell(double cellW) {
    return SizedBox(
      width: cellW,
      child: FTappable(
        onPress: () => unawaited(_addChatMember()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: MoyuColors.of(context).background,
                border: Border.all(color: MoyuColors.of(context).line),
                // 跟头像同源比例 size×0.18 (42×0.18 ≈ 7.56pt 圆角),
                // 让 +/- cell 视觉跟左侧群成员头像方角圆角同款.
                borderRadius: BorderRadius.circular(42 * 0.18),
              ),
              child: Icon(
                FIcons.plus,
                color: MoyuColors.of(context).textTertiary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              AppLocalizations.of(context).actionAdd,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  /// 减号 cell — admin/creator 才显示, 对齐 iOS
  /// showMemberSubBtn = isManagerOrCreatorForMe.
  Widget _memberSubCell(double cellW) {
    return SizedBox(
      width: cellW,
      child: FTappable(
        onPress: () => unawaited(_removeChatMember()),
        behavior: HitTestBehavior.opaque,
        child: Column(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: MoyuColors.of(context).background,
                border: Border.all(color: MoyuColors.of(context).line),
                // 跟头像同源比例, 跟 + cell 一致.
                borderRadius: BorderRadius.circular(42 * 0.18),
              ),
              child: Icon(
                FIcons.minus,
                color: MoyuColors.of(context).textTertiary,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              AppLocalizations.of(context).actionRemove,
              style: const TextStyle(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  /// "-" tap on the member grid. 对齐 iOS WKConversationGroupSettingVC.
  /// memberSubClick: push member-list picker (排除自己), 选完 →
  /// ActionSheet 确认 → socialGateway.removeGroupMembers → 本地刷新.
  Future<void> _removeChatMember() async {
    final t = AppLocalizations.of(context);
    final gateway = widget.socialGateway;
    if (gateway == null) {
      MoyuToast.show(context, t.chatSocialDisconnected);
      return;
    }
    if (!_isGroup) {
      // 1v1 不该走到这里 (_isAdmin gate 已经限制群聊), 防御兜底.
      return;
    }
    // 候选 = _groupMembers - 自己. iOS WKMemberListVC.hiddenUsers =
    // @[loginInfo.uid] 同款.
    final candidates = [
      for (final m in _groupMembers)
        if (m.uid != widget.loginUid && contactChannelId(m).isNotEmpty) m,
    ];
    if (candidates.isEmpty) {
      MoyuToast.show(context, t.chatNoRemovableMembers);
      return;
    }
    final selected = await Navigator.of(context).push<List<UiContact>>(
      MaterialPageRoute(
        builder: (_) => MoyuContactPickerPage(
          title: t.chatSelectMembersToRemove,
          contacts: candidates,
          selectedContacts: const [],
        ),
      ),
    );
    if (!mounted || selected == null || selected.isEmpty) {
      return;
    }
    // DESIGN.md §6: 移除不可撤销, picker 后必须二次 confirm.
    final namesPreview = selected.length == 1
        ? t.chatMemberNameQuoted(selected.first.name)
        : t.chatMemberCount(selected.length);
    var confirmed = false;
    await MoyuActionSheet.show(
      context,
      title: t.chatRemoveMembersConfirm(namesPreview),
      items: [
        MoyuActionSheetItem(
          title: t.actionRemove,
          destructive: true,
          onSelected: () => confirmed = true,
        ),
      ],
    );
    if (!confirmed || !mounted) return;
    final uids = [
      for (final c in selected)
        if (contactChannelId(c).isNotEmpty) contactChannelId(c),
    ];
    if (uids.isEmpty) return;
    try {
      await gateway.removeGroupMembers(
        groupNo: widget.conversation.channelId,
        memberUids: uids,
      );
      if (!mounted) return;
      final removed = uids.toSet();
      setState(() {
        _groupMembers.removeWhere((m) => removed.contains(contactChannelId(m)));
        _groupMemberCount = _groupMembers.length;
      });
      MoyuToast.show(context, t.chatMembersRemoved(selected.length));
    } catch (error) {
      if (!mounted) return;
      MoyuToast.show(context, t.chatRemoveMembersFailed(error.toString()));
    }
  }

  /// "+" tap on the member grid. Routes to the contact picker, then:
  ///   * Group: invite the picked uids into the current group via
  ///     `addGroupMembers` (or `inviteGroupMembers` if the group is
  ///     in invite-confirm mode — we treat the simple add path as the
  ///     default since this page doesn't surface the confirm switch).
  ///   * Person: spin up a fresh group conversation containing the
  ///     other party + the picks. Mirrors iOS native: tapping + on a
  ///     1-1 chat info page creates a new multi-member chat.
  Future<void> _addChatMember() async {
    final t = AppLocalizations.of(context);
    final gateway = widget.socialGateway;
    if (gateway == null) {
      MoyuToast.show(context, t.chatSocialDisconnected);
      return;
    }

    // Build exclusion set so we don't surface members who are
    // already in the group / the other party in a 1-1 chat.
    final excluded = <String>{widget.loginUid};
    if (_isGroup) {
      for (final m in _groupMembers) {
        final id = contactChannelId(m);
        if (id.isNotEmpty) excluded.add(id);
      }
    } else {
      excluded.add(widget.conversation.channelId);
    }

    final candidates = [
      for (final c in widget.contacts)
        if (!excluded.contains(contactChannelId(c)) && !isSystemFileHelper(c))
          c,
    ];

    if (candidates.isEmpty) {
      MoyuToast.show(context, t.chatNoInviteCandidates);
      return;
    }

    final selected = await Navigator.of(context).push<List<UiContact>>(
      MaterialPageRoute(
        builder: (_) => MoyuContactPickerPage(
          title: _isGroup ? t.chatInviteMembers : t.chatSelectContacts,
          contacts: candidates,
          selectedContacts: const [],
        ),
      ),
    );
    if (!mounted || selected == null || selected.isEmpty) {
      return;
    }

    final uids = [
      for (final c in selected) contactChannelId(c),
    ].where((s) => s.isNotEmpty).toList();
    if (uids.isEmpty) {
      return;
    }

    if (_isGroup) {
      try {
        await gateway.addGroupMembers(
          groupNo: widget.conversation.channelId,
          memberUids: uids,
        );
        if (!mounted) return;
        await _loadGroupMembers();
        if (!mounted) return;
        MoyuToast.show(context, t.chatMembersInvited(selected.length));
      } catch (error) {
        if (!mounted) return;
        MoyuToast.show(context, t.chatInviteMembersFailed(error.toString()));
      }
    } else {
      // 1-1 chat → create a fresh group containing the other party
      // plus the picks. We don't navigate to the new group yet — the
      // server fan-out will surface it on the conversation list once
      // the create response lands; the user can open it from there.
      final memberUids = [widget.conversation.channelId, ...uids];
      try {
        final group = await gateway.createGroup(memberUids);
        if (!mounted) return;
        MoyuToast.show(
          context,
          group != null ? t.chatGroupCreated : t.chatGroupCreateFailed,
        );
      } catch (error) {
        if (!mounted) return;
        MoyuToast.show(
          context,
          t.chatGroupCreateFailedWithError(error.toString()),
        );
      }
    }
  }

  void _openGroupRemarkEditor() {
    pushPage(
      context,
      GroupRemarkEditorPage(
        initialValue: _groupRemark,
        onSaved: (value) => unawaited(_saveGroupRemark(value)),
      ),
    );
  }

  void _editGroupField({
    required String title,
    required String fieldKey,
    required String initialValue,
    required ValueChanged<String> onSaved,
  }) {
    pushPage(
      context,
      GroupFieldEditorPage(
        title: title,
        groupNo: widget.conversation.channelId,
        fieldKey: fieldKey,
        initialValue: initialValue,
        socialGateway: widget.socialGateway,
        onSaved: (value) {
          onSaved(value);
          // Force the SDK to re-fetch this channel so the new title /
          // notice / etc lands in cached `WKChannel`, the conversation
          // list cell rebuilds with the new title, and the chat header
          // refreshes via the conversation snapshot stream.
          unawaited(
            widget.imGateway?.refreshChannel(
                  channelId: widget.conversation.channelId,
                  channelType: widget.conversation.channelType,
                ) ??
                Future.value(),
          );
        },
      ),
    );
  }

  Future<void> _changeGroupAvatar() async {
    // 对齐 iOS WKGroupAvatarVC — push 全屏大图查看页, 进去后通过右上 More
    // ActionSheet (拍照 / 相册 / 保存) 触发. 之前是直接弹 picker, 缺
    // "大图预览 + 拍照 + 保存" 三个 iOS 都有的功能.
    final groupNo = widget.conversation.channelId;
    if (groupNo.isEmpty) {
      MoyuToast.show(
        context,
        AppLocalizations.of(context).groupAvatarUnsupported,
      );
      return;
    }
    final updatedAvatarUrl = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => GroupAvatarPage(
          groupNo: groupNo,
          channelType: widget.conversation.channelType,
          isAdmin: _isAdmin,
          avatarUrl: _groupAvatarUrl,
          avatarLabel: widget.conversation.avatarLabel,
          colors: widget.conversation.colors,
          socialGateway: widget.socialGateway,
          imGateway: widget.imGateway,
          onAvatarUpdated: (updatedAvatarUrl) {
            if (!mounted || updatedAvatarUrl.isEmpty) return;
            setState(() {
              _groupAvatarUrl = updatedAvatarUrl;
            });
          },
        ),
      ),
    );
    if (!mounted || updatedAvatarUrl == null || updatedAvatarUrl.isEmpty) {
      return;
    }
    setState(() {
      _groupAvatarUrl = updatedAvatarUrl;
    });
  }

  /// Push the group-admin tools page. Reuses `GroupManagePage`,
  /// passing through `_groupInfo` (or a synthesised `UiGroup` from
  /// the conversation snapshot) so the page renders the right
  /// initial switch state without an extra round-trip.
  void _openGroupManage() {
    final info = _groupInfo;
    final fallback = UiGroup(
      groupNo: widget.conversation.channelId,
      name: _groupName,
      avatarLabel: widget.conversation.avatarLabel,
      memberCount: _groupMemberCount,
      subtitle: _groupNotice,
      color: widget.conversation.colors.first,
    );
    final group = info == null
        ? fallback
        : UiGroup(
            groupNo: info.groupNo,
            name: info.name.isEmpty ? fallback.name : info.name,
            avatarLabel: fallback.avatarLabel,
            memberCount: info.memberCount > 0
                ? info.memberCount
                : fallback.memberCount,
            subtitle: info.notice,
            color: fallback.color,
            muted: info.muted,
            saved: info.saved,
            inviteConfirm: info.inviteConfirm,
            forbidden: info.forbidden,
            forbiddenAddFriend: info.forbiddenAddFriend,
            allowViewHistoryMsg: info.allowViewHistoryMsg,
            allowMemberPinnedMessage: info.allowMemberPinnedMessage,
          );
    pushPage(
      context,
      GroupManagePage(
        group: group,
        socialGateway: widget.socialGateway,
        imGateway: widget.imGateway,
        loginUid: widget.loginUid,
      ),
    );
  }

  void _openGroupQrCode() {
    pushPage(
      context,
      GroupQrCodePage(
        config: widget.config,
        group: UiGroup(
          groupNo: widget.conversation.channelId,
          name: _groupName,
          avatarLabel: widget.conversation.avatarLabel,
          memberCount: _groupMemberCount,
          subtitle: _groupNotice,
          color: widget.conversation.colors.first,
        ),
        socialGateway: widget.socialGateway,
      ),
    );
  }

  Future<void> _confirmClearMessages() async {
    final t = AppLocalizations.of(context);
    await MoyuActionSheet.show(
      context,
      title: t.chatClearCurrentConfirm,
      items: [
        MoyuActionSheetItem(
          title: t.generalClearMessages,
          destructive: true,
          onSelected: () => unawaited(_clearMessages()),
        ),
      ],
    );
  }

  Future<void> _clearMessages() async {
    final gateway = widget.imGateway;
    if (gateway != null && widget.conversation.isRemote) {
      await gateway.clearConversationMessages(
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        messageSeq: _lastMessageSeq(),
      );
    }
    if (!mounted) {
      return;
    }
    widget.onClearMessages();
    Navigator.of(context).pop();
  }

  Future<void> _confirmDeleteConversation() async {
    final t = AppLocalizations.of(context);
    await MoyuActionSheet.show(
      context,
      title: t.chatDeleteAndExitConfirm,
      items: [
        MoyuActionSheetItem(
          title: t.chatSettingsDeleteAndExit,
          destructive: true,
          onSelected: () => unawaited(_deleteConversation()),
        ),
      ],
    );
  }

  Future<void> _deleteConversation() async {
    if (_isGroup) {
      final groupNo = widget.conversation.channelId;
      if (widget.socialGateway != null && groupNo.isNotEmpty) {
        try {
          await widget.socialGateway!.exitGroup(groupNo);
        } catch (_) {
          // Surface nothing — fall back to local removal so the user
          // is never stuck on a stale group page.
        }
      }
    }
    await widget.onDeleteConversation();
    if (!mounted) {
      return;
    }
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  int _lastMessageSeq() {
    var messageSeq = 0;
    for (final message in widget.messages) {
      if (message.messageSeq > messageSeq) {
        messageSeq = message.messageSeq;
      }
    }
    return messageSeq;
  }

  Future<void> _confirmBlockConversation() async {
    final t = AppLocalizations.of(context);
    await MoyuActionSheet.show(
      context,
      title: t.chatBlockConfirm,
      items: [
        MoyuActionSheetItem(
          title: t.contactAddToBlacklist,
          destructive: true,
          onSelected: () => unawaited(_blockConversation()),
        ),
      ],
    );
  }

  Future<void> _blockConversation() async {
    final uid = widget.conversation.channelId;
    await widget.socialGateway?.addUserBlacklist(uid);
    await widget.imGateway?.deleteConversation(
      channelId: uid,
      channelType: widget.conversation.channelType,
    );
    if (!mounted) {
      return;
    }
    setState(() => _blocked = true);
    widget.onContactRemoved?.call(uid);
    MoyuToast.show(
      context,
      AppLocalizations.of(context).contactAddedToBlacklist,
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  Future<void> _updateGroupSave(bool value) async {
    setState(() => _savedToContacts = value);
    await widget.socialGateway?.updateGroupSetting(
      groupNo: widget.conversation.channelId,
      setting: {'save': value ? 1 : 0},
    );
    // 修"开关重进恢复"BUG — 跟 _updateNotifySetting 同模式.
    await widget.imGateway?.refreshChannel(
      channelId: widget.conversation.channelId,
      channelType: widget.conversation.channelType,
    );
  }
}

/// 频道内搜索 tab — 严格对齐 iOS WKGlobalSearchResultController.tabbar
/// 当 searchInChannel=true 时: 聊天 / 图片/视频 / 文件.
///   all   → 当前 channel 所有消息 (onlyMessage=1, 不限 contentType)
///   media → 抹掉 keyword, contentTypes=[image, smallvideo]
///   file  → contentTypes=[file]
enum _ChannelSearchTab { all, media, file }

class MessageSearchPage extends StatefulWidget {
  const MessageSearchPage({
    super.key,
    required this.conversation,
    required this.messages,
    required this.onJumpToMessage,
    this.socialGateway,
    this.config,
  });

  final ChatConversation conversation;

  /// 本地已加载消息 (loaded chunk) — 兜底用, server 拉失败时 fallback 用
  /// 本地内存搜.
  final List<ChatMessage> messages;
  final ChatSocialGateway? socialGateway;
  final AppConfig? config;

  /// tap 一条搜索结果时调 — 收到目标 messageId. 实现方负责: pop 搜索页
  /// (本 widget 内自动 pop) + 通知上游聊天页 scrollToMessage. 对齐 iOS
  /// WKConversationVC.locationAtOrderSeq 跳转语义.
  final ValueChanged<String> onJumpToMessage;

  @override
  State<MessageSearchPage> createState() => MessageSearchPageState();
}

class MessageSearchPageState extends State<MessageSearchPage> {
  late final TextEditingController _controller;
  _ChannelSearchTab _tab = _ChannelSearchTab.all;

  /// server 搜索结果 — 保留 raw ChatGlobalMessage. 列表 tab (all/file) 在
  /// build 时即用 searchConversationFromChannelMessage 转 ChatConversation +
  /// SearchMessageTile 渲染; 媒体 tab 直接读 message.payload.url 做 3 列
  /// 网格 (对齐 iOS WKSearchMediaCell).
  final List<ChatGlobalMessage> _serverResults = [];
  String _query = '';
  bool _searching = false;
  String _error = '';
  int _page = 1;
  bool _hasMore = false;
  bool _loadingMore = false;
  static const int _pageLimit = 20;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onQueryChanged);
    // 对齐 iOS WKBaseTableVC.viewDidLoad → reloadRemoteData: 进入查找
    // 页立即用空关键字 fire 一次. searchInChannel=true 时服务端按 channel
    // 过滤返回最近的消息, 用户进来就有列表, 不用先打字.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_search(''));
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onQueryChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged() {
    setState(() {});
    final q = _controller.text.trim();
    unawaited(_search(q));
  }

  Future<void> _selectTab(_ChannelSearchTab tab) async {
    if (_tab == tab) return;
    setState(() {
      _tab = tab;
      _serverResults.clear();
      _page = 1;
      _hasMore = false;
    });
    final q = _controller.text.trim();
    // 切 tab 一律 fire (空 query 也搜) — iOS WKGlobalSearchVM.changeTabType
    // 同款行为, media tab 本就需要空 keyword.
    await _search(q);
  }

  ({String keyword, int onlyMessage, List<int> contentTypes}) _paramsForTab(
    _ChannelSearchTab tab,
    String q,
  ) {
    // 严格对齐 iOS WKGlobalSearchVM.search:
    //   searchInChannel=true → 强制 onlyMessage=1
    //   all: contentTypes=[] (server 不限类型, 返回该 channel 所有消息)
    //   media: keyword='', contentTypes=[WK_IMAGE=2, WK_SMALLVIDEO=5]
    //          (图片视频不按关键字搜, server 按 channel + contentType 拉)
    //   file: contentTypes=[WK_FILE=8]
    switch (tab) {
      case _ChannelSearchTab.all:
        return (keyword: q, onlyMessage: 1, contentTypes: const []);
      case _ChannelSearchTab.media:
        return (keyword: '', onlyMessage: 1, contentTypes: const [2, 5]);
      case _ChannelSearchTab.file:
        return (keyword: q, onlyMessage: 1, contentTypes: const [8]);
    }
  }

  Future<void> _search(String rawQuery) async {
    final gateway = widget.socialGateway;
    final q = rawQuery.trim();
    setState(() {
      _query = q;
      _page = 1;
      _hasMore = false;
      _error = '';
    });
    // 无 gateway → 走纯本地 fallback (build() 里 widget.messages where text
    // contains query). 空 query 仍要 fire server — searchInChannel + 空
    // keyword 返回最近消息, 对齐 iOS 行为.
    if (gateway == null) {
      return;
    }
    setState(() => _searching = true);
    try {
      final params = _paramsForTab(_tab, q);
      final result = await gateway.searchGlobal(
        keyword: params.keyword,
        onlyMessage: params.onlyMessage,
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        contentTypes: params.contentTypes,
        page: 1,
        limit: _pageLimit,
      );
      if (!mounted) return;
      setState(() {
        _serverResults
          ..clear()
          ..addAll(result.messages);
        _hasMore = result.messages.length >= _pageLimit;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  Future<void> _loadMore() async {
    final gateway = widget.socialGateway;
    if (gateway == null || !_hasMore || _loadingMore) return;
    // 空 query 也允许 pullup — searchInChannel 不依赖 keyword (服务端按
    // channel 过滤), iOS WKGlobalSearchVM.pullup 同款行为.
    setState(() {
      _loadingMore = true;
      _page += 1;
    });
    try {
      final params = _paramsForTab(_tab, _query);
      final result = await gateway.searchGlobal(
        keyword: params.keyword,
        onlyMessage: params.onlyMessage,
        channelId: widget.conversation.channelId,
        channelType: widget.conversation.channelType,
        contentTypes: params.contentTypes,
        page: _page,
        limit: _pageLimit,
      );
      if (!mounted) return;
      setState(() {
        _serverResults.addAll(result.messages);
        _hasMore = result.messages.length >= _pageLimit;
      });
    } catch (_) {
      if (mounted) setState(() => _page -= 1);
    } finally {
      if (mounted) setState(() => _loadingMore = false);
    }
  }

  bool _onScroll(ScrollNotification n) {
    if (_loadingMore || _searching || !_hasMore) return false;
    if (n.metrics.maxScrollExtent - n.metrics.pixels < 120) {
      unawaited(_loadMore());
    }
    return false;
  }

  /// tap 一条搜索结果: pop 搜索页 + 把目标 messageId 透传给上游 (settings
  /// 再 pop 自己 + 转给 chat _scrollToMessage). 跟 iOS WKConversationVC.
  /// locationAtOrderSeq 同款跳转语义.
  void _onResultTap(String messageId) {
    Navigator.of(context).pop();
    widget.onJumpToMessage(messageId);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final query = _controller.text.trim();
    final hasServer = widget.socialGateway != null;

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: DetailScaffold(
        title: t.chatSearchContentTitle,
        children: [
          Container(
            color: MoyuColors.of(context).background,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: FTextField(
              control: FTextFieldControl.managed(controller: _controller),
              hint: t.actionSearch,
              prefixBuilder: (context, style, variants) =>
                  FTextField.prefixIconBuilder(
                    context,
                    style,
                    variants,
                    const Icon(FIcons.search),
                  ),
            ),
          ),
          // tab chip row — 对齐 iOS searchInChannel=true 分支: 聊天 / 图片视频 / 文件
          if (hasServer)
            Container(
              color: MoyuColors.of(context).background,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  for (final tab in _ChannelSearchTab.values) ...[
                    SearchTabChip(
                      label: switch (tab) {
                        _ChannelSearchTab.all => t.chatSearchTabAll,
                        _ChannelSearchTab.media => t.chatSearchTabMedia,
                        _ChannelSearchTab.file => t.chatSearchTabFile,
                      },
                      active: _tab == tab,
                      onTap: () => unawaited(_selectTab(tab)),
                    ),
                    if (tab != _ChannelSearchTab.values.last)
                      const SizedBox(width: 8),
                  ],
                ],
              ),
            ),
          if (_searching)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 18),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else if (_error.isNotEmpty && _serverResults.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
              child: Text(
                _error,
                style: TextStyle(color: MoyuColors.of(context).red),
              ),
            ),
          // 列表区 — 没 gateway 走本地兜底 (ChatMessage.text 简单 list), 有
          // gateway 用 server 返回的 ChatConversation + SearchMessageTile 渲染.
          if (!hasServer)
            settingsFlatGroup(
              context,
              rows: widget.messages
                  .where(
                    (m) =>
                        query.isEmpty ||
                        m.text.toLowerCase().contains(query.toLowerCase()),
                  )
                  .toList()
                  .let(
                    (local) => local.isEmpty
                        ? <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 28),
                              child: Center(
                                child: Text(
                                  t.chatSearchNoMatches,
                                  style: TextStyle(
                                    color: MoyuColors.of(context).textTertiary,
                                  ),
                                ),
                              ),
                            ),
                          ]
                        : [
                            for (var i = 0; i < local.length; i++) ...[
                              InfoRow(
                                label: local[i].isMine
                                    ? t.profileDefaultName
                                    : widget.conversation.name,
                                value: local[i].text,
                              ),
                              if (i != local.length - 1) const RowDivider(),
                            ],
                          ],
                  ),
            )
          else if (_serverResults.isEmpty && !_searching)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 36),
              child: Center(
                child: Text(
                  t.chatSearchNoMatches,
                  style: TextStyle(color: MoyuColors.of(context).textTertiary),
                ),
              ),
            )
          else if (_tab == _ChannelSearchTab.media)
            // 媒体 tab — 3 列网格 (对齐 iOS WKSearchMediaCell, numOfRow=3,
            // 每格 screenWidth/3 正方形 BoxFit.cover, video 加播放角标).
            _MediaSearchGrid(
              messages: _serverResults,
              config: widget.config,
              onTap: (m) => _onResultTap(m.messageId),
            )
          else
            MoyuSection(
              padding: EdgeInsets.zero,
              children: [
                for (var i = 0; i < _serverResults.length; i++) ...[
                  SearchMessageTile(
                    conversation: searchConversationFromChannelMessage(
                      message: _serverResults[i],
                      index: i,
                      config: widget.config,
                      channelConversation: widget.conversation,
                      l10n: t,
                    ),
                    keyword: query,
                    config: widget.config,
                    onTap: () => _onResultTap(_serverResults[i].messageId),
                  ),
                  if (i != _serverResults.length - 1) const MoyuDivider(),
                ],
              ],
            ),
          if (_loadingMore)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator.adaptive()),
            )
          else if (hasServer && !_hasMore && _serverResults.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Text(
                  t.chatSearchNoMore,
                  style: TextStyle(
                    fontSize: 12,
                    color: MoyuColors.of(context).textTertiary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// dart 扩展, 让链式 fluent 写法更顺手 (避免一长串临时变量).
extension _LetExt<T> on T {
  R let<R>(R Function(T) f) => f(this);
}

/// 媒体搜索结果 3 列网格 — 对齐 iOS WKSearchMediaCell:
/// 每格 screenWidth/3 正方形, BoxFit.cover, 无圆角无间距. video 类型加
/// 右下角播放图标. 服务端 payload.url 给的是相对路径, 用 config.showUrl 拼绝对 URL.
class _MediaSearchGrid extends StatelessWidget {
  const _MediaSearchGrid({
    required this.messages,
    required this.onTap,
    this.config,
  });

  final List<ChatGlobalMessage> messages;
  final AppConfig? config;
  final ValueChanged<ChatGlobalMessage> onTap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      // 嵌在 DetailScaffold 的外层 ListView 里 — 必须 shrinkWrap + 禁
      // 自己滚动, 滚动事件交给外层.
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 0,
        mainAxisSpacing: 0,
        childAspectRatio: 1.0,
      ),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        // contentType: 2=image, 5=smallvideo (与 iOS WK_IMAGE / WK_SMALLVIDEO 对齐)
        final isVideo = message.contentType == 5;
        final rawUrl = (message.payload['url'] ?? '').toString();
        final fullUrl = rawUrl.isEmpty
            ? ''
            : (rawUrl.startsWith('http')
                  ? rawUrl
                  : (config?.showUrl(rawUrl) ?? rawUrl));
        return FTappable(
          onPress: () => onTap(message),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                color: MoyuColors.of(context).backgroundSoft,
                child: fullUrl.isEmpty
                    ? Icon(
                        FIcons.image,
                        color: MoyuColors.of(context).textTertiary,
                        size: 24,
                      )
                    : CachedNetworkImage(
                        imageUrl: fullUrl,
                        fit: BoxFit.cover,
                        // 缩略图加载失败兜底
                        errorWidget: (_, _, _) => Icon(
                          FIcons.image,
                          color: MoyuColors.of(context).textTertiary,
                          size: 24,
                        ),
                      ),
              ),
              if (isVideo)
                Center(
                  child: Icon(
                    FIcons.play,
                    color: MoyuColors.of(context).background,
                    size: 28,
                    shadows: [Shadow(color: Color(0x80000000), blurRadius: 4)],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
