// 好友/联系人/扫码后的名片 - 申请加好友等流程。从 home_shell.dart 拆出。
import 'dart:async' show unawaited;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart' as device_contacts;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:forui/forui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/app_runtime.dart';
import '../../call/chat_call_gateway.dart';
import '../../config/app_brand.dart';
import '../../config/app_config.dart';
import '../../im/wukong_im_service.dart'
    show ChatImGateway, kFileHelperUID, kSystemUID;
import '../../l10n/app_localizations.dart';
import '../../modules/feature_registry.dart' show FeatureKind;
import '../../modules/module_contact_profile_row.dart';
import '../../modules/module_ids.dart' show ModuleActionIds;
import '../../modules/module_route.dart';
import '../../scan/chat_scan_service.dart';
import '../../social/social_service.dart'
    show ChatPhoneContact, ChatSocialGateway;
import '../chat_navigation.dart';
import '../contact_list_widgets.dart'
    show ContactTile, SectionTitle, StaticActionRow;
import '../detail_scaffold.dart';
import '../home_seed_data.dart' show conversationColors;
import '../identity_display.dart' show moyuDisplayName;
import '../models/contact_models.dart';
import '../moyu_image_viewer.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_group_widgets.dart';
import '../settings_row_widgets.dart';
import 'complaint_page.dart';
import 'my_qr_code_page.dart';
import 'scan_page.dart';
import 'shared_widgets_models.dart';

class ContactSearchPage extends StatefulWidget {
  const ContactSearchPage({
    super.key,
    required this.contacts,
    required this.loginUid,
    required this.callGateway,
    this.loginName = '',
    this.socialGateway,
    this.imGateway,
    this.onSocialChanged,
    this.onContactChanged,
    this.onContactRemoved,
    required this.onOpenContactChat,
  });

  final List<UiContact> contacts;
  final String loginUid;
  final String loginName;
  final ChatCallGateway? callGateway;
  final ChatSocialGateway? socialGateway;
  final ChatImGateway? imGateway;
  final Future<void> Function()? onSocialChanged;
  final ValueChanged<UiContact>? onContactChanged;
  final ValueChanged<String>? onContactRemoved;
  final Future<void> Function(UiContact contact) onOpenContactChat;

  @override
  State<ContactSearchPage> createState() => ContactSearchPageState();
}

class ContactSearchPageState extends State<ContactSearchPage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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
    final results = query.isEmpty
        ? widget.contacts
        : widget.contacts
              .where(
                (contact) =>
                    contact.name.toLowerCase().contains(query) ||
                    contact.subtitle.toLowerCase().contains(query),
              )
              .toList();

    return DetailScaffold(
      title: t.actionSearch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.contactSearchHint,
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
          children: results.isEmpty
              ? [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 28),
                    child: Center(
                      child: Text(
                        t.contactSearchNoMatches,
                        style: TextStyle(
                          color: MoyuColors.of(context).textTertiary,
                        ),
                      ),
                    ),
                  ),
                ]
              : [
                  for (var i = 0; i < results.length; i++) ...[
                    ContactTile(
                      contact: results[i],
                      onTap: () => pushPage(
                        context,
                        ContactDetailPage(
                          contact: results[i],
                          loginUid: widget.loginUid,
                          loginName: widget.loginName,
                          callGateway: widget.callGateway,
                          socialGateway: widget.socialGateway,
                          imGateway: widget.imGateway,
                          onSocialChanged: widget.onSocialChanged,
                          onContactChanged: widget.onContactChanged,
                          onContactRemoved: widget.onContactRemoved,
                          onOpenChat: widget.onOpenContactChat,
                        ),
                      ),
                    ),
                    if (i != results.length - 1) const MoyuDivider(),
                  ],
                ],
        ),
      ],
    );
  }
}

class AddFriendPage extends StatefulWidget {
  const AddFriendPage({
    super.key,
    this.config,
    this.socialGateway,
    this.scanGateway,
    this.callGateway,
    this.imGateway,
    this.contacts = const [],
    this.onOpenContactChat,
    this.onOpenGroupChat,
    this.onSocialChanged,
    this.onContactChanged,
    this.onContactRemoved,
    this.loginUid = '',
    this.loginName = '',
  });

  final AppConfig? config;
  final ChatSocialGateway? socialGateway;
  final ChatScanGateway? scanGateway;

  /// Wired to ContactDetailPage so the resulting name-card has access
  /// to voice / video call buttons when the search target is already
  /// a friend. Optional for the stranger flow (the stranger branch of
  /// ContactDetailPage hides the call actions).
  final ChatCallGateway? callGateway;
  final ChatImGateway? imGateway;

  /// Existing contact list used to detect "already-a-friend" hits.
  /// When the search keyword resolves to a uid that's already in this
  /// list, the name-card jumps into friend mode (and the bottom
  /// button reads 发消息) instead of stranger mode (申请添加).
  final List<UiContact> contacts;
  final Future<void> Function(UiContact contact)? onOpenContactChat;
  final Future<bool> Function(String groupNo)? onOpenGroupChat;
  final Future<void> Function()? onSocialChanged;
  final ValueChanged<UiContact>? onContactChanged;
  final ValueChanged<String>? onContactRemoved;
  final String loginUid;
  final String loginName;

  @override
  State<AddFriendPage> createState() => AddFriendPageState();
}

class AddFriendPageState extends State<AddFriendPage> {
  final _controller = TextEditingController();
  int _searchRevision = 0;
  bool _searching = false;

  /// Non-null when the most recent search finished with a `not-found`
  /// answer. Used to render the 用户不存在 notice. Cleared whenever
  /// the user edits the query so stale toasts don't linger.
  String? _notFoundQuery;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_clearNotFoundOnEdit);
  }

  @override
  void dispose() {
    _controller.removeListener(_clearNotFoundOnEdit);
    _controller.dispose();
    super.dispose();
  }

  void _clearNotFoundOnEdit() {
    if (_notFoundQuery != null) {
      setState(() => _notFoundQuery = null);
    }
  }

  /// Trigger search on keyboard search action (return key) — matches
  /// iOS WKContactsSearchVC.textFieldShouldReturn. Previous version
  /// fired on every keystroke which floods the backend + races
  /// state. Empty query short-circuits.
  Future<void> _submitSearch() async {
    final query = _controller.text.trim();
    final gateway = widget.socialGateway;
    if (query.isEmpty || gateway == null) return;
    final revision = ++_searchRevision;
    if (mounted) {
      setState(() {
        _searching = true;
        _notFoundQuery = null;
      });
    }
    try {
      final result = await gateway.searchUser(query);
      if (!mounted || revision != _searchRevision) return;
      setState(() => _searching = false);
      if (!result.exist || result.contact == null) {
        setState(() => _notFoundQuery = query);
        return;
      }
      // Map server payload onto UiContact, threading vercode through.
      final synthesised = UiContact.fromSocial(
        result.contact!,
        colors: conversationColors(query.hashCode.abs()),
        config: widget.config,
      );
      // Detect already-a-friend so the name-card opens in friend
      // mode (with 发消息 button) instead of stranger mode (申请添加).
      UiContact? matched;
      for (final c in widget.contacts) {
        if (c.uid == synthesised.uid) {
          matched = c;
          break;
        }
      }
      final isStranger = matched == null;
      final target = matched ?? synthesised;
      await pushPage(
        context,
        ContactDetailPage(
          contact: target,
          loginUid: widget.loginUid,
          loginName: widget.loginName,
          callGateway: widget.callGateway,
          socialGateway: widget.socialGateway,
          imGateway: widget.imGateway,
          config: widget.config,
          isStranger: isStranger,
          onSocialChanged: widget.onSocialChanged,
          onContactChanged: widget.onContactChanged,
          onContactRemoved: widget.onContactRemoved,
          onOpenChat: widget.onOpenContactChat ?? (target) async {},
        ),
      );
    } catch (error) {
      if (!mounted || revision != _searchRevision) return;
      setState(() {
        _searching = false;
        _notFoundQuery = query;
      });
      debugPrint('[add-friend] searchUser($query) failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.addFriendTitle,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.addFriendSearchHint(AppBrand.displayName),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.search,
            onSubmit: (_) => unawaited(_submitSearch()),
            prefixBuilder: (context, style, variants) =>
                FTextField.prefixIconBuilder(
                  context,
                  style,
                  variants,
                  const Icon(FIcons.search),
                ),
          ),
        ),
        if (_searching)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 18),
            child: Center(child: CircularProgressIndicator.adaptive()),
          )
        else if (_notFoundQuery != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 8),
            child: Text(
              t.addFriendNotFound,
              style: TextStyle(
                color: MoyuColors.of(context).textTertiary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              leading: const Icon(FIcons.qrCode),
              title: t.myQrCodeTitle,
              showChevron: true,
              onTap: () => pushPage(
                context,
                MyQrCodePage(
                  socialGateway: widget.socialGateway,
                  config: widget.config,
                  loginUid: widget.loginUid,
                ),
              ),
            ),
            const RowDivider(),
            PlainSettingRow(
              leading: const Icon(FIcons.scan),
              title: t.scanTitle,
              showChevron: true,
              onTap: () => pushPage(
                context,
                ScanPage(
                  config: widget.config,
                  socialGateway: widget.socialGateway,
                  scanGateway: widget.scanGateway,
                  callGateway: widget.callGateway,
                  contacts: widget.contacts,
                  onOpenContactChat: widget.onOpenContactChat,
                  onOpenGroupChat: widget.onOpenGroupChat,
                  loginUid: widget.loginUid,
                  loginName: widget.loginName,
                  webLoginConfirmPageBuilder: (_, authCode, socialGateway) =>
                      WebLoginConfirmPage(
                        authCode: authCode,
                        socialGateway: socialGateway,
                      ),
                  contactDetailPageBuilder:
                      (_, {required contact, required isStranger}) =>
                          ContactDetailPage(
                            contact: contact,
                            loginUid: widget.loginUid,
                            loginName: widget.loginName,
                            callGateway: widget.callGateway,
                            socialGateway: widget.socialGateway,
                            imGateway: widget.imGateway,
                            config: widget.config,
                            isStranger: isStranger,
                            onSocialChanged: widget.onSocialChanged,
                            onContactChanged: widget.onContactChanged,
                            onContactRemoved: widget.onContactRemoved,
                            onOpenChat:
                                widget.onOpenContactChat ?? (target) async {},
                          ),
                ),
              ),
            ),
            const RowDivider(),
            PlainSettingRow(
              leading: const Icon(FIcons.smartphone),
              title: t.phoneContactsTitle,
              showChevron: true,
              onTap: () => pushPage(
                context,
                _PhoneContactsPage(socialGateway: widget.socialGateway),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PhoneContactsPage extends StatefulWidget {
  const _PhoneContactsPage({this.socialGateway});

  final ChatSocialGateway? socialGateway;

  @override
  State<_PhoneContactsPage> createState() => _PhoneContactsPageState();
}

const _seedPhoneContacts = [
  ChatPhoneContact(name: '张一', phone: '18800000001', uid: 'zhangyi'),
  ChatPhoneContact(name: '李二', phone: '18800000002'),
  ChatPhoneContact(
    name: '王三',
    phone: '18800000003',
    uid: 'wangsan',
    isFriend: true,
  ),
];

class _PhoneContactsPageState extends State<_PhoneContactsPage> {
  var _contacts = <ChatPhoneContact>[];
  bool _loading = false;
  String _notice = '';

  @override
  void initState() {
    super.initState();
    if (widget.socialGateway == null) {
      _contacts = List.of(_seedPhoneContacts);
      return;
    }
    _loading = true;
    unawaited(_loadContacts());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.phoneContactsTitle,
      children: [
        SectionTitle(t.phoneContactsSection),
        MoyuSection(
          padding: EdgeInsets.zero,
          children: [
            if (_loading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 28),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_contacts.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 28),
                child: Center(
                  child: Text(
                    _notice.isEmpty ? t.phoneContactsEmpty : _notice,
                    style: TextStyle(
                      color: MoyuColors.of(context).textTertiary,
                    ),
                  ),
                ),
              )
            else ...[
              for (var i = 0; i < _contacts.length; i++) ...[
                StaticActionRow(
                  icon: _contacts[i].isFriend
                      ? FIcons.userCheck
                      : FIcons.userPlus,
                  iconColor: _contacts[i].isFriend
                      ? MoyuColors.of(context).textSecondary
                      : MoyuColors.of(context).primary,
                  title: _contacts[i].name.isEmpty
                      ? _contacts[i].phone
                      : _contacts[i].name,
                  subtitle: _contacts[i].phone,
                  value: _actionLabel(t, _contacts[i]),
                  onTap: _contacts[i].isFriend
                      ? null
                      : () => unawaited(_handleContactAction(_contacts[i])),
                ),
                if (i != _contacts.length - 1) MoyuDivider(),
              ],
            ],
          ],
        ),
        if (_notice.isNotEmpty && _contacts.isNotEmpty)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: Text(
              _notice,
              style: TextStyle(
                color: MoyuColors.of(context).primary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  Future<void> _loadContacts() async {
    final t = AppLocalizations.of(context);
    final gateway = widget.socialGateway;
    var visibleContacts = <ChatPhoneContact>[];
    try {
      final serverContacts = await gateway?.loadPhoneContacts() ?? const [];
      visibleContacts = serverContacts;
      if (serverContacts.isNotEmpty) {
        if (!mounted) {
          return;
        }
        setState(() {
          _contacts = serverContacts;
          _notice = '';
          _loading = false;
        });
      }

      final deviceContacts = await _readDeviceContacts();
      if (gateway != null && deviceContacts.isNotEmpty) {
        await gateway.uploadPhoneContacts(deviceContacts);
        final refreshedContacts = await gateway.loadPhoneContacts();
        visibleContacts = _mergePhoneContacts(
          deviceContacts,
          refreshedContacts,
        );
      } else {
        visibleContacts = _mergePhoneContacts(deviceContacts, visibleContacts);
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _contacts = visibleContacts;
        _notice = _contacts.isEmpty ? t.phoneContactsNoAddable : '';
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        if (_contacts.isEmpty) {
          _contacts = visibleContacts;
        }
        _notice = _contacts.isEmpty
            ? error.toString()
            : t.phoneContactsServerSyncFailed;
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<List<ChatPhoneContact>> _readDeviceContacts() async {
    try {
      final status = await device_contacts.FlutterContacts.permissions.request(
        device_contacts.PermissionType.read,
      );
      final hasAccess =
          status == device_contacts.PermissionStatus.granted ||
          status == device_contacts.PermissionStatus.limited;
      if (!hasAccess) {
        return const [];
      }
      final contacts = await device_contacts.FlutterContacts.getAll(
        properties: {device_contacts.ContactProperty.phone},
      );
      return [
        for (final contact in contacts)
          for (final phone in contact.phones)
            if (_normalizePhone(phone.number).isNotEmpty)
              ChatPhoneContact(
                name: contact.displayName ?? '',
                phone: _normalizePhone(phone.number),
                zone: '',
              ),
      ];
    } catch (_) {
      return const [];
    }
  }

  String _normalizePhone(String value) {
    return value.replaceAll(RegExp(r'[\s\-()]'), '');
  }

  List<ChatPhoneContact> _mergePhoneContacts(
    List<ChatPhoneContact> deviceContacts,
    List<ChatPhoneContact> serverContacts,
  ) {
    if (deviceContacts.isEmpty) {
      return serverContacts;
    }
    if (serverContacts.isEmpty) {
      return deviceContacts;
    }

    final serverPhones = {
      for (final contact in serverContacts) _normalizePhone(contact.phone),
    };
    return [
      ...serverContacts,
      for (final contact in deviceContacts)
        if (!serverPhones.contains(_normalizePhone(contact.phone))) contact,
    ];
  }

  String _actionLabel(AppLocalizations t, ChatPhoneContact contact) {
    if (contact.isFriend) {
      return t.friendAlreadyAdded;
    }
    return contact.uid.isEmpty ? t.actionInvite : t.actionAdd;
  }

  Future<void> _handleContactAction(ChatPhoneContact contact) async {
    final t = AppLocalizations.of(context);
    if (contact.uid.isEmpty) {
      await _inviteContact(contact);
      return;
    }
    await widget.socialGateway?.applyFriend(
      uid: contact.uid,
      vercode: contact.vercode,
    );
    if (!mounted) {
      return;
    }
    setState(() => _notice = t.friendRequestSent);
  }

  Future<void> _inviteContact(ChatPhoneContact contact) async {
    final t = AppLocalizations.of(context);
    final uri = Uri(
      scheme: 'sms',
      path: contact.phone,
      queryParameters: {
        'body': t.phoneContactsInviteSmsBody(AppBrand.displayName),
      },
    );
    try {
      await launchUrl(uri);
      if (mounted) {
        setState(() => _notice = t.phoneContactsInviteOpened);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _notice = t.phoneContactsInviteFailed);
      }
    }
  }
}

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({
    super.key,
    required this.requests,
    required this.onAccept,
    required this.onRefuse,
    required this.onDelete,
    required this.onRefresh,
    this.socialGateway,
    this.scanGateway,
    this.config,
    this.loginUid = '',
    this.loginName = '',
  });

  final List<UiFriendRequest> requests;
  final ChatSocialGateway? socialGateway;
  final ChatScanGateway? scanGateway;
  final AppConfig? config;
  final String loginUid;
  final String loginName;
  final Future<void> Function(UiFriendRequest request) onAccept;
  final Future<void> Function(UiFriendRequest request) onRefuse;
  final Future<void> Function(UiFriendRequest request) onDelete;

  /// Fire-and-forget reload of the receiver's apply list. Called on
  /// mount (so the page never relies on a stale HomeShell snapshot)
  /// and on pull-to-refresh. HomeShell wires this to
  /// `_loadSocialSnapshot` which re-fetches /v1/friend/apply +
  /// contacts + groups in one round-trip.
  final Future<void> Function() onRefresh;

  @override
  State<FriendRequestsPage> createState() => FriendRequestsPageState();
}

class FriendRequestsPageState extends State<FriendRequestsPage> {
  late List<UiFriendRequest> _requests;
  final Set<String> _pendingRequestKeys = {};

  @override
  void initState() {
    super.initState();
    _requests = List.of(widget.requests);
    // iOS WKContactsFriendRequestVC reads from local DB which was
    // populated by friendRequest CMD pushes. We don't have a local
    // DB, so we GET /v1/friend/apply on mount to cover the case
    // where the CMD push was missed (transient IM disconnect, app
    // background while peer was applying, etc).
    unawaited(widget.onRefresh());
  }

  @override
  void didUpdateWidget(covariant FriendRequestsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.requests, widget.requests)) {
      _requests = List.of(widget.requests);
    }
  }

  String _requestKey(UiFriendRequest request) =>
      request.token.isNotEmpty ? request.token : request.uid;

  Future<void> _accept(UiFriendRequest request) async {
    final key = _requestKey(request);
    if (_pendingRequestKeys.contains(key)) return;
    setState(() => _pendingRequestKeys.add(key));
    try {
      await widget.onAccept(request);
      if (!mounted) return;
      setState(() {
        _pendingRequestKeys.remove(key);
        _requests = [
          for (final item in _requests)
            if (_requestKey(item) == key)
              item.copyWith(accepted: true, refused: false)
            else
              item,
        ];
      });
    } catch (_) {
      if (mounted) setState(() => _pendingRequestKeys.remove(key));
    }
  }

  Future<void> _refuse(UiFriendRequest request) async {
    final key = _requestKey(request);
    if (_pendingRequestKeys.contains(key)) return;
    setState(() => _pendingRequestKeys.add(key));
    try {
      await widget.onRefuse(request);
      if (!mounted) return;
      setState(() {
        _pendingRequestKeys.remove(key);
        _requests = [
          for (final item in _requests)
            if (_requestKey(item) == key)
              item.copyWith(refused: true, accepted: false)
            else
              item,
        ];
      });
    } catch (_) {
      if (mounted) setState(() => _pendingRequestKeys.remove(key));
    }
  }

  Future<void> _delete(UiFriendRequest request) async {
    final key = _requestKey(request);
    if (_pendingRequestKeys.contains(key)) return;
    setState(() => _pendingRequestKeys.add(key));
    try {
      await widget.onDelete(request);
      if (!mounted) return;
      setState(() {
        _pendingRequestKeys.remove(key);
        _requests = [
          for (final item in _requests)
            if (_requestKey(item) != key) item,
        ];
      });
    } catch (_) {
      if (mounted) setState(() => _pendingRequestKeys.remove(key));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final requests = _requests;
    // 对齐 iOS WKContactsFriendRequestVC：本页就是一张好友申请列表
    // （加导航栏右上角"添加朋友"按钮）。**不再** 在底部塞"添加方式"
    // 区块——那是 AddFriendPage 的内容，重复了。
    return DetailScaffold(
      title: t.contactActionNewFriends,
      onRefresh: widget.onRefresh,
      children: [
        if (requests.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: MoyuEmptyState(
              icon: FIcons.userPlus,
              title: t.friendRequestsEmptyTitle,
              subtitle: t.friendRequestsEmptySubtitle,
            ),
          )
        else ...[
          SectionTitle(t.friendRequestsPendingSection),
          settingsFlatGroup(
            context,
            rows: [
              for (var i = 0; i < requests.length; i++) ...[
                _FriendRequestTile(
                  request: requests[i],
                  onAccept: () => unawaited(_accept(requests[i])),
                  onRefuse: () => unawaited(_refuse(requests[i])),
                  onDelete: () => unawaited(_delete(requests[i])),
                ),
                if (i != requests.length - 1) const MoyuDivider(),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

/// 新的朋友 row。对齐 iOS WKContactsFriendRequestCell：**单按钮**
/// "确认"，按完变 "已确认" 灰字。**没有** 拒绝/删除 inline 按钮——
/// 删除走左滑 Dismissible，跟 iOS 系统 swipe-to-delete 一致。
class _FriendRequestTile extends StatelessWidget {
  const _FriendRequestTile({
    required this.request,
    required this.onAccept,
    // ignore: unused_element_parameter
    required this.onRefuse,
    required this.onDelete,
  });

  final UiFriendRequest request;
  final VoidCallback onAccept;
  // 保留参数；本 tile 不再暴露独立"拒绝"按钮（对齐原版 iOS）。如果
  // 上层需要保留 PUT /friend/refuse 链路，可以从 sheet/menu 调用。
  final VoidCallback onRefuse;
  final VoidCallback onDelete;

  static const double _height = 76;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final tile = Container(
      color: MoyuColors.of(context).background,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      constraints: const BoxConstraints(minHeight: _height),
      child: Row(
        children: [
          MoyuResolvedAvatar.raw(
            label: request.avatarLabel,
            size: 44,
            colors: request.colors,
            imageUrl: request.avatarPath,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  request.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.08,
                    color: MoyuColors.of(context).textPrimary,
                  ),
                ),
                if (request.message.isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    request.message,
                    maxLines: 1,
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
          const SizedBox(width: 8),
          _buildAction(context),
        ],
      ),
    );

    // #5: 改为滑出删除按钮 (不再全滑即删) + 点击弹 destructive 二次确认,
    // 跟会话列表 / 收藏 swipe action 同款, 防误删。列表数据仍由 HomeShell
    // 从服务端拉取, 删除靠 onDelete 触发 server DELETE + 自动 refresh。
    return Slidable(
      key: ValueKey('friendreq-${request.uid}-${request.token}'),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) => MoyuActionSheet.show(
              context,
              items: [
                MoyuActionSheetItem(
                  title: t.actionDelete,
                  destructive: true,
                  onSelected: onDelete,
                ),
              ],
            ),
            backgroundColor: MoyuColors.of(context).red,
            foregroundColor: Colors.white,
            icon: Icons.delete_outline,
            label: t.actionDelete,
          ),
        ],
      ),
      child: tile,
    );
  }

  Widget _buildAction(BuildContext context) {
    // 已同意 / 已拒绝 → 灰字状态标签，无 button。
    if (request.accepted) {
      return Text(
        AppLocalizations.of(context).friendAlreadyAdded,
        style: TextStyle(
          color: MoyuColors.of(context).textTertiary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      );
    }
    if (request.refused) {
      return Text(
        AppLocalizations.of(context).friendRequestRefused,
        style: TextStyle(
          color: MoyuColors.of(context).textTertiary,
          fontSize: 13,
          fontWeight: FontWeight.w400,
        ),
      );
    }
    // pending → 主色文字 CTA "确认" (无实心背景, 对齐微信"接受"轻量样式)。
    // 用现成 MoyuTextButton (primary 文字 15/w500/-0.08), 不 inline 重写按钮。
    return MoyuTextButton(
      label: AppLocalizations.of(context).actionConfirm,
      onPressed: onAccept,
    );
  }
}

/// 用 uid + 显示名打开用户名片页, 对齐 iOS `WKApp.invoke:WKPOINT_USER_INFO`
/// 入口。优先从 contacts 列表 lookup; 找不到 → synthesise 一个 stranger
/// 模式的 `UiContact` (姓名走传入的 displayName).
/// 调用方:
/// - 朋友圈 cell avatar / name tap (`_MomentsPage.onOpenUserCard`)
/// - 通知列表 (gap #6 后)
/// - 其它需要从纯 uid 打开名片的场景
/// `onOpenChat` 在多数 secondary 入口没有真实可用的 chat 跳转 (e.g. 朋友圈
/// cell 不属于 _HomeShellState 的会话调度环), 用 toast 提示用户去通讯录里
/// 真开会话, 跟 home_shell:5189 `_ChatScreenState` 已有的 fallback 一致.
void openUserCardByUid(
  BuildContext context, {
  required String uid,
  required String displayName,
  required String loginUid,
  String loginName = '',
  required List<UiContact> contacts,
  ChatSocialGateway? socialGateway,
  ChatCallGateway? callGateway,
  AppConfig? config,
  Future<void> Function(UiContact contact)? onOpenChat,
}) {
  if (uid.isEmpty) return;
  UiContact? matched;
  for (final contact in contacts) {
    if (contact.uid == uid) {
      matched = contact;
      break;
    }
  }
  // self uid 永远不是 stranger (contacts 里没 self 是正常情况, 不能据此
  // 判 stranger). 对齐 iOS WKApp.m:1352 WKPOINT_USER_INFO handler — 一律
  // 走同一个 user info VC, vc 内部用 isSelf 判断渲染 (Flutter 这边由
  // ContactDetailPage._isSelf getter 处理).
  final isSelfUser = uid == loginUid && loginUid.isNotEmpty;
  final isStranger = matched == null && !isSelfUser;
  final resolvedName = moyuDisplayName(
    name: displayName,
    rawIdentity: uid,
    placeholder: AppLocalizations.of(context).contactUnknownUser,
  );
  final target =
      matched ??
      UiContact(
        uid: uid,
        name: resolvedName,
        avatarLabel: resolvedName.characters.first,
        colors: [
          MoyuColors.of(context).primary,
          MoyuColors.of(context).primarySoft,
        ],
        avatarPath: AvatarResolver.user(config: config, uid: uid),
      );
  unawaited(
    pushPage(
      context,
      ContactDetailPage(
        contact: target,
        loginUid: loginUid,
        loginName: loginName,
        callGateway: callGateway,
        socialGateway: socialGateway,
        config: config,
        isStranger: isStranger,
        // 调用方传了真 onOpenChat hook (home_shell._openContactChat) 时, 名片页
        // "发消息" 直接打开会话; 没传的老入口 fallback 提示去通讯录 (向后兼容)。
        onOpenChat:
            onOpenChat ??
            (_) async {
              if (!context.mounted) return;
              MoyuToast.show(
                context,
                AppLocalizations.of(
                  context,
                ).contactOpenFromContacts(target.name),
              );
            },
      ),
    ),
  );
}

/// Personal info page — mirrors native iOS `WKUserInfoVC` layout:
/// header (avatar + name + FoxTalk ID), sectioned rows (设置备注 / 朋友圈
/// / 解除好友关系 + 拉入黑名单 + 投诉 / 来源), and a sticky 发消息
/// footer button. Section breakpoints match iOS endpoint sort/height
/// ordering (`user.info.setRemark` 4000 / `user.info.moments` 3900 /
/// `user.info.freeFriend` 3000 + `user.info.addBlack` 2000 +
/// `user.info.report` 1000 / `user.info.source` 900).
class ContactDetailPage extends StatefulWidget {
  const ContactDetailPage({
    super.key,
    required this.contact,
    required this.loginUid,
    this.loginName = '',
    this.callGateway,
    this.socialGateway,
    this.imGateway,
    this.onSocialChanged,
    this.onContactChanged,
    this.onContactRemoved,
    required this.onOpenChat,
    this.config,
    this.isStranger = false,
  });

  final UiContact contact;
  final String loginUid;
  final String loginName;
  final ChatCallGateway? callGateway;
  final ChatSocialGateway? socialGateway;
  final ChatImGateway? imGateway;
  final Future<void> Function()? onSocialChanged;
  final ValueChanged<UiContact>? onContactChanged;
  final ValueChanged<String>? onContactRemoved;
  final AppConfig? config;
  final Future<void> Function(UiContact contact) onOpenChat;

  /// True when this page is rendered for someone the login user is
  /// not yet a friend with (typically reached via the AddFriend page
  /// search or a card scan). The page then:
  ///   * hides setting-remark / 朋友圈 / 解除好友 / 拉黑 / 投诉 / 来源
  ///     rows (they only apply to established friendships)
  ///   * swaps the bottom action button from 发消息 to 添加到通讯录,
  ///     which routes through _ApplyFriendPage to send the apply
  /// Mirrors the iOS WKUserInfoVC branching on the friend flag.
  final bool isStranger;

  @override
  State<ContactDetailPage> createState() => ContactDetailPageState();
}

class ContactDetailPageState extends State<ContactDetailPage> {
  late UiContact _contact;
  bool _blocked = false;

  /// 朋友圈行 trailing 缩略图 (前 4 张近期发布的图). 对齐 iOS
  /// WKUserMomentCell.m imgSize=48, 显示该用户近期朋友圈的前 4 张图.
  /// 数据来自 GET /moments?uid=<contact.uid>&page_size=10 累积 imgs.
  List<String> _momentPreviewImgs = const [];

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
    if (!widget.isStranger && !_isSystemAccountPage) {
      unawaited(_refreshContactFromSnapshot());
    }
    if (_momentProfileRoute() != null) {
      unawaited(_loadMomentPreview());
    }
  }

  Future<void> _refreshContactFromSnapshot() async {
    final gateway = widget.socialGateway;
    if (gateway == null || _contact.uid.isEmpty) return;
    try {
      final snapshot = await gateway.loadSnapshot();
      for (final contact in snapshot.contacts) {
        if (contact.uid != _contact.uid) continue;
        if (!mounted) return;
        setState(() {
          _contact = UiContact.fromSocial(
            contact,
            colors: _contact.colors,
            config: widget.config,
          );
        });
        widget.onContactChanged?.call(_contact);
        return;
      }
    } catch (_) {
      // 资料页可展示旧值；同步失败不打断用户进页。
    }
  }

  Future<void> _loadMomentPreview() async {
    final gateway = widget.socialGateway;
    if (gateway == null || _contact.uid.isEmpty) return;
    try {
      final moments = await gateway.loadMoments(uid: _contact.uid);
      if (!mounted) return;
      final imgs = <String>[];
      for (final m in moments) {
        if (m.imgs.isNotEmpty) {
          imgs.addAll(m.imgs);
        } else if (m.videoCoverPath.isNotEmpty) {
          imgs.add(m.videoCoverPath);
        }
        if (imgs.length >= 4) break;
      }
      setState(() => _momentPreviewImgs = imgs.take(4).toList());
    } catch (_) {
      // 拉失败 trailing 留空即可, 不让 contact 主页因此崩 / toast.
    }
  }

  bool get _isSelf =>
      widget.loginUid.isNotEmpty && _contact.uid == widget.loginUid;

  /// 内置 system 账号 (fileHelper / 系统通知). 对齐 iOS [WKApp isSystemAccount:]
  /// + [WKUserInfoVM tableSectionMaps] — 这两个 uid 在资料页只显示"功能介绍",
  /// 屏蔽所有其他 cell (设置备注 / 朋友圈 / 解除好友 / 拉黑 / 投诉 / 来源).
  bool get _isSystemAccountPage =>
      _contact.uid == kFileHelperUID || _contact.uid == kSystemUID;

  /// 功能介绍文案 — 对齐 iOS WKUserInfoVM.m:385-389 全套 introEndpoint handler.
  String? _systemAccountIntro(AppLocalizations t) {
    if (_contact.uid == kFileHelperUID) {
      return t.fileHelperIntro;
    }
    if (_contact.uid == kSystemUID) {
      return t.systemAccountIntro(AppBrand.displayName);
    }
    return null;
  }

  ModuleContactProfileRow? _momentProfileRow() {
    final runtime = AppRuntime.current;
    if (runtime == null) return null;
    for (final feature in runtime.registry.enabledFeatures(
      kind: FeatureKind.contactProfileRow,
    )) {
      final value = feature.value;
      if (feature.id == ModuleActionIds.contactProfileMoment &&
          value is ModuleContactProfileRow) {
        return value;
      }
    }
    return null;
  }

  ModuleRouteDescriptor? _momentProfileRoute() {
    final runtime = AppRuntime.current;
    final row = _momentProfileRow();
    if (runtime == null || row == null) return null;
    final feature = runtime.registry.featureById(row.routeId);
    if (feature == null || !runtime.isModuleEnabled(feature.moduleId)) {
      return null;
    }
    final value = feature.value;
    return value is ModuleRouteDescriptor ? value : null;
  }

  void _openContactMoments(BuildContext context, ModuleRouteDescriptor route) {
    pushPage(
      context,
      route.build(
        context,
        ModuleRouteContext(
          socialGateway: widget.socialGateway,
          config: widget.config,
          loginUid: widget.loginUid,
          extra: {
            'loginName': widget.loginName,
            'targetUid': _contact.uid,
            'targetName': _contact.remark.isNotEmpty
                ? _contact.remark
                : _contact.name,
            'contacts': [_contact],
            'runtime': AppRuntime.current,
            'showMsg': _contact.uid == widget.loginUid,
            'onOpenUserCard': (String uid, String name) {
              if (uid == _contact.uid) return;
              openUserCardByUid(
                context,
                uid: uid,
                displayName: name,
                loginUid: widget.loginUid,
                loginName: widget.loginName,
                contacts: [_contact],
                socialGateway: widget.socialGateway,
                callGateway: widget.callGateway,
                config: widget.config,
                // 名片页内再点头像进另一名片页时, 透传 onOpenChat 让 "发消息" 可用。
                onOpenChat: widget.onOpenChat,
              );
            },
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final shortNo = _contact.subtitle;
    final momentRoute = _momentProfileRoute();
    // DESIGN.md §4：所有二级页面统一走 DetailScaffold 的毛玻璃 sticky
    // 头部 + 底部 sticky CTA slot。之前名片页自己手搓 navBar + Column +
    // FCard.raw 全是违规，统一回收到 scaffold。
    return DetailScaffold(
      title: '',
      bottomSticky: _isSelf
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: widget.isStranger
                  ? _buildAddFriendButton(context)
                  : _buildSendMessageButton(context),
            ),
      children: [
        _buildHeaderCard(t, shortNo),
        // 系统账号 (fileHelper / u_10000) 资料页只保留"功能介绍" — 对齐
        // iOS WKUserInfoVM.m:425-435 (isSystemAccount → 仅 introEndpoint).
        // 不显示备注 / 朋友圈 / 危险动作 / 来源等 cell.
        if (_isSystemAccountPage) ...[
          settingsBlockGap(context),
          settingsFlatGroup(
            context,
            rows: [
              PlainSettingRow(
                title: t.contactIntroTitle,
                value: _systemAccountIntro(t) ?? '',
                valueMuted: true,
              ),
            ],
          ),
        ],
        // 设置备注: 仅好友 (不 self, 不陌生人, 不 system 账号) 才显示
        if (!_isSelf && !widget.isStranger && !_isSystemAccountPage) ...[
          settingsBlockGap(context),
          settingsFlatGroup(
            context,
            rows: [
              PlainSettingRow(
                title: t.contactSetRemark,
                value: _contact.remark,
                valueMuted: true,
                showChevron: true,
                onTap: () => unawaited(_openRemarkEditor()),
              ),
            ],
          ),
        ],
        // 朋友圈行: self + friend 都显示 (对齐 iOS WKUserInfoVC isSelf
        // 只 hide footerHeader 不 hide 朋友圈 cell; stranger 不显示因为
        // 没加好友看不到对方朋友圈). cell 高度 68pt (= imgSize+20pt, iOS
        // WKUserMomentCell.sizeForModel m:27), trailing 缩略图 48×48
        // 5pt 间距 (对齐 iOS m:23 + m:53).
        if (!widget.isStranger &&
            !_isSystemAccountPage &&
            momentRoute != null) ...[
          settingsBlockGap(context),
          _ContactMomentRow(
            previewImgs: _momentPreviewImgs,
            config: widget.config,
            onTap: _contact.uid.isEmpty
                ? null
                : () => _openContactMoments(context, momentRoute),
          ),
        ],
        // 危险动作 (拉黑/投诉/解除好友): 仅好友 (不 self, 不陌生人, 不 system 账号) 显示
        if (!_isSelf && !widget.isStranger && !_isSystemAccountPage) ...[
          settingsBlockGap(context),
          _buildDangerSection(),
          if (_contact.sourceDescription.isNotEmpty) ...[
            settingsBlockGap(context),
            settingsFlatGroup(
              context,
              rows: [
                PlainSettingRow(
                  title: t.contactSource,
                  value: _contact.sourceDescription,
                  valueMuted: true,
                ),
              ],
            ),
          ],
        ],
        if (!_isSelf &&
            widget.isStranger &&
            !_isSystemAccountPage &&
            _contact.sourceDescription.isNotEmpty) ...[
          settingsBlockGap(context),
          settingsFlatGroup(
            context,
            rows: [
              PlainSettingRow(
                title: t.contactSource,
                value: _contact.sourceDescription,
                valueMuted: true,
              ),
            ],
          ),
        ],
      ],
    );
  }

  /// 头部卡片：大头像 + 名字 + FoxTalk ID。flat 白底贴满（不再 FCard.raw），
  /// 跟 §4.C scaffold 给的整页灰底配色形成自然分块。
  Widget _buildHeaderCard(AppLocalizations t, String shortNo) {
    return Container(
      width: double.infinity,
      color: MoyuColors.of(context).background,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 点头像看大图 (名片页头像可点, 对齐微信/iOS WKUserInfoVC)。
          FTappable(
            behavior: HitTestBehavior.opaque,
            onPress: _contact.avatarPath.trim().isEmpty
                ? null
                : () => unawaited(
                    MoyuImageViewer.show(
                      context,
                      imageUrl: _contact.avatarPath,
                    ),
                  ),
            child: MoyuResolvedAvatar.raw(
              label: _contact.avatarLabel,
              size: 64,
              colors: _contact.colors,
              online: _contact.online,
              imageUrl: _contact.avatarPath,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // name + verified badge — 系统账号 (fileHelper / u_10000) 显示
                // chatim 独有蓝勋章. iOS 原版 WKUserInfoVC header 只覆盖标题
                // 文案不加 badge, 这是 chatim 偏离, 跟会话列表 / 通讯录同思路.
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        _contact.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.2,
                          color: MoyuColors.of(context).textPrimary,
                        ),
                      ),
                    ),
                    if (_isSystemAccountPage) ...[
                      const SizedBox(width: 4),
                      const MoyuOfficialTag(category: 'system'),
                    ],
                  ],
                ),
                // #2: 系统账号 / 文件传输助手资料页不显示 FoxTalk ID
                // (内置账号无对外 ID 概念), 但顶部官方星标 (MoyuOfficialTag) 保留。
                if (shortNo.isNotEmpty && !_isSystemAccountPage) ...[
                  SizedBox(height: 6),
                  Text(
                    '${AppBrand.idLabel}：$shortNo',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MoyuColors.of(context).textTertiary,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (_nicknameLine(t).isNotEmpty) ...[
                  SizedBox(height: 4),
                  Text(
                    _nicknameLine(t),
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
        ],
      ),
    );
  }

  /// 危险行组（解除好友 / 拉入黑名单 / 投诉）。前两行 danger=true → 红字，
  /// onTap 先弹 confirm sheet。投诉非 destructive，普通色 + chevron。
  /// DESIGN.md §6 行版危险动作模式。
  Widget _buildDangerSection() {
    final t = AppLocalizations.of(context);
    return settingsFlatGroup(
      context,
      rows: [
        PlainSettingRow(
          title: t.contactRemoveFriendRelation,
          danger: true,
          onTap: () => unawaited(_confirmFreeFriend()),
        ),
        const RowDivider(),
        PlainSettingRow(
          title: _blocked
              ? t.contactRemoveFromBlacklist
              : t.contactAddToBlacklist,
          danger: !_blocked,
          onTap: () => unawaited(_toggleBlacklist()),
        ),
        const RowDivider(),
        PlainSettingRow(
          title: t.chatSettingsComplaint,
          showChevron: true,
          onTap: () => pushPage(
            context,
            ComplaintPage(socialGateway: widget.socialGateway),
          ),
        ),
      ],
    );
  }

  Widget _buildSendMessageButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: MoyuPrimaryButton(
        label: AppLocalizations.of(context).contactSendMessage,
        prefixIcon: FIcons.messageCircle,
        onPressed: () {
          Navigator.of(context).pop();
          unawaited(widget.onOpenChat(_contact));
        },
      ),
    );
  }

  /// Stranger-mode bottom button: routes through _ApplyFriendPage so
  /// the user can type a remark before posting `friend/apply`. The
  /// page handles the actual server call + toast — we only push it.
  Widget _buildAddFriendButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: MoyuPrimaryButton(
        label: AppLocalizations.of(context).contactAddToContacts,
        prefixIcon: FIcons.userRoundPlus,
        onPressed: () => pushPage(
          context,
          _ApplyFriendPage(
            contact: _contact,
            socialGateway: widget.socialGateway,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmFreeFriend() async {
    if (_contact.uid.isEmpty) return;
    final t = AppLocalizations.of(context);
    await MoyuActionSheet.show(
      context,
      title: t.contactRemoveFriendConfirm,
      items: [
        MoyuActionSheetItem(
          title: t.contactRemoveFriendRelation,
          destructive: true,
          onSelected: () => unawaited(_deleteFriend()),
        ),
      ],
    );
  }

  Future<void> _openRemarkEditor() async {
    final value = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (_) => _ContactRemarkEditorPage(
          contact: _contact,
          socialGateway: widget.socialGateway,
        ),
      ),
    );
    if (!mounted || value == null) return;
    final rawName = _contact.rawName.isNotEmpty
        ? _contact.rawName
        : _contact.name;
    final displayName = value.isEmpty
        ? moyuDisplayName(
            name: rawName,
            rawIdentity: _contact.uid,
            placeholder: AppLocalizations.of(context).contactUnknownUser,
          )
        : value;
    setState(() {
      _contact = _contact.copyWith(
        name: displayName,
        rawName: rawName,
        remark: value,
      );
    });
    widget.onContactChanged?.call(_contact);
    unawaited(widget.onSocialChanged?.call() ?? Future<void>.value());
  }

  String _nicknameLine(AppLocalizations t) {
    final rawName = _contact.rawName.trim();
    if (rawName.isEmpty) return '';
    if (_contact.remark.trim().isEmpty) return '';
    if (rawName == _contact.name.trim()) return '';
    return t.contactNicknameLine(rawName);
  }

  Future<void> _toggleBlacklist() async {
    if (_contact.uid.isEmpty) return;
    final wasBlocked = _blocked;
    final t = AppLocalizations.of(context);
    await MoyuActionSheet.show(
      context,
      title: wasBlocked
          ? t.contactRemoveFromBlacklistConfirm
          : t.chatBlockConfirm,
      items: [
        MoyuActionSheetItem(
          title: wasBlocked
              ? t.contactRemoveFromBlacklist
              : t.contactAddToBlacklist,
          destructive: !wasBlocked,
          onSelected: () => unawaited(_doToggleBlacklist(wasBlocked)),
        ),
      ],
    );
  }

  Future<void> _doToggleBlacklist(bool wasBlocked) async {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    try {
      if (wasBlocked) {
        await gateway.removeUserBlacklist(_contact.uid);
      } else {
        await gateway.addUserBlacklist(_contact.uid);
        await widget.imGateway?.deleteConversation(
          channelId: _contact.uid,
          channelType: 1,
        );
      }
      if (!mounted) return;
      setState(() => _blocked = !wasBlocked);
      if (!wasBlocked) {
        widget.onContactRemoved?.call(_contact.uid);
        unawaited(widget.onSocialChanged?.call() ?? Future<void>.value());
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (_) {
      // swallow — surfacing is handled by gateway / global error boundary
    }
  }

  Future<void> _deleteFriend() async {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    try {
      await gateway.deleteFriend(_contact.uid);
      await widget.imGateway?.deleteConversation(
        channelId: _contact.uid,
        channelType: 1,
      );
      if (!mounted) return;
      widget.onContactRemoved?.call(_contact.uid);
      unawaited(widget.onSocialChanged?.call() ?? Future<void>.value());
      Navigator.of(context).pop();
    } catch (_) {}
  }
}

/// Plain label row used by the iOS-style profile page: left-aligned
/// label, optional gray value, optional chevron when tappable.
// _ProfileLabelRow 已删除（DESIGN.md §5）：合并到 PlainSettingRow 统一
// 走 settingsFlatGroup + 标准行；danger=true 提供红字 destructive 变体。

/// 网页登录确认页. Pushed by _ScanPage when the scanned qr is a
/// `loginConfirm` payload. Replaces the old in-page auth_code text
/// input which doubled as the only post-scan UI for any qr type.
/// Mirrors iOS WKConfirmLoginVC — single page, single CTA, brief
/// success/failure feedback before pop.
class WebLoginConfirmPage extends StatefulWidget {
  const WebLoginConfirmPage({
    super.key,
    required this.authCode,
    this.socialGateway,
  });

  final String authCode;
  final ChatSocialGateway? socialGateway;

  @override
  State<WebLoginConfirmPage> createState() => WebLoginConfirmPageState();
}

class WebLoginConfirmPageState extends State<WebLoginConfirmPage> {
  bool _submitting = false;
  String? _notice;
  bool _noticeIsSuccess = false;

  Future<void> _confirm() async {
    final t = AppLocalizations.of(context);
    if (_submitting) return;
    final gateway = widget.socialGateway;
    if (gateway == null) {
      setState(() {
        _notice = t.chatSocialDisconnected;
        _noticeIsSuccess = false;
      });
      return;
    }
    setState(() {
      _submitting = true;
      _notice = null;
    });
    try {
      await gateway.grantWebLogin(widget.authCode);
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _notice = t.webLoginConfirmed;
        _noticeIsSuccess = true;
      });
      Future.delayed(const Duration(milliseconds: 700), () {
        if (mounted) Navigator.of(context).maybePop();
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _notice = t.webLoginConfirmFailed(error.toString());
        _noticeIsSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.webLoginTitle,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 8),
          child: Text(
            t.webLoginConfirmTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(22, 0, 22, 24),
          child: Text(
            t.webLoginConfirmBody,
            style: TextStyle(
              color: MoyuColors.of(context).textTertiary,
              fontSize: 13,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
          child: MoyuPrimaryButton(
            label: t.webLoginConfirmAction,
            loadingLabel: t.webLoginConfirming,
            loading: _submitting,
            onPressed: () => unawaited(_confirm()),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
          child: FTappable(
            behavior: HitTestBehavior.opaque,
            onPress: () => Navigator.of(context).maybePop(),
            child: Container(
              height: 48,
              alignment: Alignment.center,
              child: Text(
                t.actionCancel,
                style: TextStyle(
                  color: MoyuColors.of(context).textSecondary,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        if (_notice != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 8, 22, 0),
            child: Text(
              _notice!,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _noticeIsSuccess
                    ? MoyuColors.of(context).green
                    : MoyuColors.of(context).red,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}

/// "申请添加朋友" form. Pushed from ContactDetailPage's stranger-mode
/// bottom button. Shows the target's avatar + name + a remark textbox
/// (seeded with "我是<loginName>" so the receiving side knows who's
/// reaching out). On 发送 → POST friend/apply with the per-stranger
/// vercode pulled from the search response, then toast + pop.
/// Mirrors iOS WKApplyFriendVC — single page, single CTA, fire-and-
/// forget. We do NOT keep the page open while waiting; the user
/// returns to ContactDetailPage and ultimately to the search page.
class _ApplyFriendPage extends StatefulWidget {
  const _ApplyFriendPage({required this.contact, this.socialGateway});

  final UiContact contact;
  final ChatSocialGateway? socialGateway;

  @override
  State<_ApplyFriendPage> createState() => _ApplyFriendPageState();
}

class _ApplyFriendPageState extends State<_ApplyFriendPage> {
  final _remarkController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final t = AppLocalizations.of(context);
    if (_submitting) return;
    final gateway = widget.socialGateway;
    if (gateway == null) {
      MoyuToast.show(context, t.chatSocialDisconnected);
      return;
    }
    setState(() => _submitting = true);
    try {
      await gateway.applyFriend(
        uid: widget.contact.uid,
        remark: _remarkController.text.trim(),
        vercode: widget.contact.vercode,
      );
      if (!mounted) return;
      setState(() => _submitting = false);
      MoyuToast.show(context, t.friendRequestSent);
      // Tear down the entire friend-flow stack (apply → detail →
      // scan / add-friend → home). Previous behaviour popped only the
      // apply page, leaving the user staring at the stranger card
      // again — and if they kept tapping back they'd end up on the
      // scan page WITH the already-fired "已识别 / 再次扫描" overlay
      // still up, which looked like a stuck-state bug. popUntil
      // isFirst sends them straight back to the main tab.
      Future.delayed(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        Navigator.of(context).popUntil((r) => r.isFirst);
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      MoyuToast.show(context, t.friendRequestSendFailed(error.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.applyFriendTitle,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
              child: Row(
                children: [
                  MoyuResolvedAvatar.raw(
                    label: widget.contact.avatarLabel,
                    size: 56,
                    colors: widget.contact.colors,
                    imageUrl: widget.contact.avatarPath,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.contact.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: MoyuColors.of(context).textPrimary,
                          ),
                        ),
                        if (widget.contact.subtitle.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            widget.contact.subtitle,
                            maxLines: 1,
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
                ],
              ),
            ),
          ],
        ),
        settingsBlockGap(context),
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 8),
          child: Text(
            t.applyFriendSectionTitle,
            style: TextStyle(
              color: MoyuColors.of(context).textTertiary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        settingsFlatGroup(
          context,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          rows: [
            SizedBox(
              height: 88,
              child: FTextField(
                control: FTextFieldControl.managed(
                  controller: _remarkController,
                ),
                hint: t.applyFriendRemarkHint,
                keyboardType: TextInputType.text,
                maxLines: 3,
                maxLength: 80,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: MoyuPrimaryButton(
            label: t.actionSend,
            loadingLabel: t.statusSending,
            loading: _submitting,
            onPressed: () => unawaited(_submit()),
          ),
        ),
      ],
    );
  }
}

class _ContactRemarkEditorPage extends StatefulWidget {
  const _ContactRemarkEditorPage({required this.contact, this.socialGateway});

  final UiContact contact;
  final ChatSocialGateway? socialGateway;

  @override
  State<_ContactRemarkEditorPage> createState() =>
      _ContactRemarkEditorPageState();
}

class _ContactRemarkEditorPageState extends State<_ContactRemarkEditorPage> {
  late final TextEditingController _controller;
  bool _saving = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.contact.remark.isNotEmpty
          ? widget.contact.remark
          : (widget.contact.rawName.isNotEmpty
                ? widget.contact.rawName
                : widget.contact.name),
    );
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
    final canSubmit = !_saving;

    return DetailScaffold(
      title: t.contactSetRemark,
      trailing: MoyuTextButton(
        label: _saving ? t.actionSaving : t.actionDone,
        onPressed: canSubmit ? _submit : null,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: t.contactRemarkHint,
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
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 10),
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
      await widget.socialGateway?.updateFriendRemark(
        uid: widget.contact.uid,
        remark: value,
      );
      if (mounted) {
        Navigator.of(context).pop(value);
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

class _ContactMomentSettingsPage extends StatefulWidget {
  const _ContactMomentSettingsPage({
    required this.contact,
    required this.socialGateway,
  });

  final UiContact contact;
  final ChatSocialGateway? socialGateway;

  @override
  State<_ContactMomentSettingsPage> createState() =>
      _ContactMomentSettingsPageState();
}

class _ContactMomentSettingsPageState
    extends State<_ContactMomentSettingsPage> {
  bool _loading = true;
  bool _hideMy = false;
  bool _hideHis = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    unawaited(_loadSetting());
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.momentPermissionsTitle,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
          child: Text(
            widget.contact.name,
            style: TextStyle(
              color: MoyuColors.of(context).textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        if (_loading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator.adaptive()),
          )
        else ...[
          MoyuSection(
            padding: EdgeInsets.zero,
            children: [
              SwitchRow(
                title: t.momentHideMineFromContact,
                value: _hideMy,
                onChanged: (value) => unawaited(_setHideMy(value)),
              ),
              const MoyuDivider(),
              SwitchRow(
                title: t.momentHideContactFromMe,
                value: _hideHis,
                onChanged: (value) => unawaited(_setHideHis(value)),
              ),
            ],
          ),
          if (_error.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: Text(
                _error,
                style: TextStyle(
                  color: MoyuColors.of(context).red,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ],
    );
  }

  Future<void> _loadSetting() async {
    final gateway = widget.socialGateway;
    if (gateway == null || widget.contact.uid.isEmpty) {
      if (mounted) {
        setState(() => _loading = false);
      }
      return;
    }
    try {
      final setting = await gateway.loadMomentSetting(widget.contact.uid);
      if (!mounted) {
        return;
      }
      setState(() {
        _hideMy = setting.hideMy;
        _hideHis = setting.hideHis;
        _loading = false;
      });
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error.toString();
          _loading = false;
        });
      }
    }
  }

  Future<void> _setHideMy(bool enabled) async {
    setState(() {
      _hideMy = enabled;
      _error = '';
    });
    try {
      await widget.socialGateway?.setMomentHideMy(
        uid: widget.contact.uid,
        enabled: enabled,
      );
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
      }
    }
  }

  Future<void> _setHideHis(bool enabled) async {
    setState(() {
      _hideHis = enabled;
      _error = '';
    });
    try {
      await widget.socialGateway?.setMomentHideHis(
        uid: widget.contact.uid,
        enabled: enabled,
      );
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
      }
    }
  }
}

/// 朋友圈行 trailing 缩略图 (前 4 张). 对齐 iOS WKUserMomentCell.m
/// imgSize=48, 横排 5pt 间距.
/// 用户名片"朋友圈"行 — 高度 68pt 对齐 iOS WKUserMomentCell.sizeForModel
/// (`m:27` 返 `imgSize + 20`). 不能复用 PlainSettingRow (固定 56pt 行高).
///   - 左 16pt "朋友圈" 15.5pt w400 textPrimary
///   - 中右 缩略图列 48×48 5pt 间距 (iOS m:23/53)
///   - 最右 chevron
class _ContactMomentRow extends StatelessWidget {
  const _ContactMomentRow({required this.previewImgs, this.config, this.onTap});

  static const double _rowHeight = 68; // iOS imgSize(48) + 20
  static const double _imgSize = 48;
  static const double _imgSpace = 5;

  final List<String> previewImgs;
  final AppConfig? config;
  final VoidCallback? onTap;

  String _resolveUrl(String img) {
    if (img.isEmpty) return '';
    if (img.startsWith('http://') || img.startsWith('https://')) return img;
    return config?.showUrl(img) ?? img;
  }

  @override
  Widget build(BuildContext context) {
    final row = Container(
      height: _rowHeight,
      color: MoyuColors.of(context).background,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            AppLocalizations.of(context).momentTitle,
            style: TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.08,
              color: MoyuColors.of(context).textPrimary,
            ),
          ),
          const Spacer(),
          // 缩略图列 (最多 4 张, 已被上层裁), 不在则不渲染.
          for (var i = 0; i < previewImgs.length; i++) ...[
            if (i != 0) const SizedBox(width: _imgSpace),
            ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: SizedBox(
                width: _imgSize,
                height: _imgSize,
                child: CachedNetworkImage(
                  imageUrl: _resolveUrl(previewImgs[i]),
                  fit: BoxFit.cover,
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  placeholder: (_, _) =>
                      Container(color: MoyuColors.of(context).backgroundSoft),
                  errorWidget: (_, _, _) => Container(
                    color: MoyuColors.of(context).backgroundSoft,
                    alignment: Alignment.center,
                    child: Icon(
                      FIcons.imageOff,
                      size: 16,
                      color: MoyuColors.of(context).textTertiary,
                    ),
                  ),
                ),
              ),
            ),
          ],
          SizedBox(width: 8),
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
}
