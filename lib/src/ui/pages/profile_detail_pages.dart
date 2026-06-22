// 个人资料详情 + 字段编辑 + 性别。从 home_shell.dart 拆出。
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, ImageSource;

import '../../auth/auth_repository.dart' show ChatServerAppConfig;
import '../../auth/user_session.dart';
import '../../config/app_brand.dart';
import '../../config/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../../social/social_service.dart';
import '../chat_navigation.dart';
import '../detail_scaffold.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_group_widgets.dart';
import '../settings_row_widgets.dart';
import 'my_qr_code_page.dart';

const _profileSexMaleRaw = '\u7537';
const _profileSexFemaleRaw = '\u5973';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({
    super.key,
    required this.session,
    required this.config,
    required this.displayName,
    required this.shortNo,
    required this.sex,
    required this.serverAppConfig,
    required this.onProfileChanged,
    this.socialGateway,
  });

  final UserSession session;
  final AppConfig config;
  final String displayName;
  final String shortNo;
  final String sex;
  final ChatServerAppConfig serverAppConfig;
  final ChatSocialGateway? socialGateway;
  final void Function({String? name, String? shortNo, String? sex})
  onProfileChanged;

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  late String _name = widget.displayName;
  late String _shortNo = widget.shortNo;
  late String _sex = widget.sex;
  int _avatarBuster = 0;
  bool _uploadingAvatar = false;
  String _avatarStatus = '';

  String? get _avatarUrl {
    final base = AvatarResolver.user(
      config: widget.config,
      uid: widget.session.uid,
    );
    if (base.isEmpty) return null;
    return _avatarBuster == 0 ? base : '$base?v=$_avatarBuster';
  }

  String _sexDisplay(AppLocalizations t) {
    if (_sex.trim().isEmpty) return t.profileGenderUnset;
    if (_sex == '1' ||
        _sex == _profileSexMaleRaw ||
        _sex == t.profileGenderMale) {
      return t.profileGenderMale;
    }
    if (_sex == '0' ||
        _sex == _profileSexFemaleRaw ||
        _sex == t.profileGenderFemale) {
      return t.profileGenderFemale;
    }
    return _sex;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final canEditShortNo =
        !(widget.serverAppConfig.shortNoEditOff ||
            widget.session.shortStatus == 1);
    return DetailScaffold(
      title: t.profileDetailTitle,
      children: [
        settingsBlockGap(context),
        settingsFlatGroup(
          context,
          rows: [
            PlainSettingRow(
              title: t.profileAvatar,
              trailing: Stack(
                alignment: Alignment.center,
                children: [
                  MoyuResolvedAvatar.raw(
                    label: _name.isEmpty ? t.profileDefaultName : _name,
                    size: 48,
                    colors: [
                      const Color(0xFFFF9A8B),
                      MoyuColors.of(context).primary,
                    ],
                    imageUrl: _avatarUrl,
                    online: true,
                  ),
                  if (_uploadingAvatar)
                    const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              showChevron: true,
              onTap: _uploadingAvatar ? null : _pickAndUploadAvatar,
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.profileNickname,
              value: _name,
              showChevron: true,
              onTap: () => _editField(
                title: t.profileEditNickname,
                keyName: 'name',
                initialValue: _name,
                onSaved: (value) {
                  setState(() => _name = value);
                  widget.onProfileChanged(name: value);
                },
              ),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: AppBrand.idLabel,
              value: _shortNo.isEmpty ? widget.session.uid : _shortNo,
              showChevron: canEditShortNo,
              onTap: !canEditShortNo
                  ? null
                  : () => _editField(
                      title: t.profileEditFoxId(AppBrand.displayName),
                      keyName: 'short_no',
                      initialValue: _shortNo.isEmpty
                          ? widget.session.uid
                          : _shortNo,
                      onSaved: (value) {
                        setState(() => _shortNo = value);
                        widget.onProfileChanged(shortNo: value);
                      },
                    ),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.profileGender,
              value: _sexDisplay(t),
              showChevron: true,
              onTap: () => pushPage(
                context,
                _ProfileSexPage(
                  initialSex: _sex,
                  socialGateway: widget.socialGateway,
                  onSaved: (value) {
                    setState(() => _sex = value);
                    widget.onProfileChanged(sex: value);
                  },
                ),
              ),
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.accountPhoneLabel,
              value: widget.session.displayPhone.isEmpty
                  ? t.profilePhoneUnbound
                  : widget.session.displayPhone,
            ),
            const RowDivider(),
            PlainSettingRow(
              title: t.myQrCodeTitle,
              trailing: Icon(
                FIcons.qrCode,
                size: 18,
                color: MoyuColors.of(context).textSecondary,
              ),
              showChevron: true,
              onTap: () => pushPage(
                context,
                MyQrCodePage(
                  displayName: _name,
                  socialGateway: widget.socialGateway,
                  config: widget.config,
                  loginUid: widget.session.uid,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _editField({
    required String title,
    required String keyName,
    required String initialValue,
    required ValueChanged<String> onSaved,
  }) {
    pushPage(
      context,
      _ProfileFieldEditorPage(
        title: title,
        fieldKey: keyName,
        initialValue: initialValue,
        socialGateway: widget.socialGateway,
        onSaved: onSaved,
      ),
    );
  }

  Future<void> _pickAndUploadAvatar() async {
    final gateway = widget.socialGateway;
    if (gateway == null) return;
    final t = AppLocalizations.of(context);
    setState(() {
      _uploadingAvatar = true;
      _avatarStatus = '';
    });
    try {
      final picked = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1024,
      );
      if (picked == null) {
        if (!mounted) return;
        setState(() => _uploadingAvatar = false);
        return;
      }
      await gateway.uploadCurrentUserAvatar(
        uid: widget.session.uid,
        filePath: picked.path,
      );
      // server 端头像换了, 但客户端固定 URL `users/${uid}/avatar` 不变.
      // CachedNetworkImage 用旧 URL 仍然命中本地 disk cache → 不拉新图.
      // 主动 evict 当前 URL 的 cache, 任何 widget (会话列表 / chat header /
      // 朋友圈 cover / 个人资料) 下次 rebuild 时都从 server 拉新图. 修复
      // "上传成功 → pop 出去 → 回来仍是旧头像" 的 cache invalidation bug.
      final fullUrl = AvatarResolver.user(
        config: widget.config,
        uid: widget.session.uid,
      );
      await CachedNetworkImage.evictFromCache(fullUrl);
      if (!mounted) return;
      setState(() {
        _uploadingAvatar = false;
        _avatarBuster = DateTime.now().millisecondsSinceEpoch;
        _avatarStatus = t.profileAvatarUpdated;
      });
      MoyuToast.show(context, _avatarStatus);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _uploadingAvatar = false;
        _avatarStatus = t.profileAvatarUpdateFailed;
      });
      MoyuToast.show(context, _avatarStatus);
    }
  }
}

class _ProfileFieldEditorPage extends StatefulWidget {
  const _ProfileFieldEditorPage({
    required this.title,
    required this.fieldKey,
    required this.initialValue,
    required this.onSaved,
    this.socialGateway,
  });

  final String title;
  final String fieldKey;
  final String initialValue;
  final ChatSocialGateway? socialGateway;
  final ValueChanged<String> onSaved;

  @override
  State<_ProfileFieldEditorPage> createState() =>
      _ProfileFieldEditorPageState();
}

class _ProfileFieldEditorPageState extends State<_ProfileFieldEditorPage> {
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
    final canSubmit =
        value.isNotEmpty && value != widget.initialValue && !_saving;

    return DetailScaffold(
      title: widget.title,
      children: [
        Container(
          color: MoyuColors.of(context).background,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: FTextField(
            control: FTextFieldControl.managed(controller: _controller),
            hint: widget.title,
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
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 48,
            child: FButton(
              onPress: canSubmit ? _submit : null,
              child: Text(_saving ? t.actionSaving : t.actionDone),
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
      await widget.socialGateway?.updateCurrentUserInfo(
        key: widget.fieldKey,
        value: value,
      );
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

class _ProfileSexPage extends StatelessWidget {
  const _ProfileSexPage({
    required this.initialSex,
    required this.onSaved,
    this.socialGateway,
  });

  final String initialSex;
  final ChatSocialGateway? socialGateway;
  final ValueChanged<String> onSaved;

  bool _isMale(AppLocalizations t) =>
      initialSex == '1' ||
      initialSex == _profileSexMaleRaw ||
      initialSex == t.profileGenderMale;

  bool _isFemale(AppLocalizations t) =>
      initialSex == '0' ||
      initialSex == _profileSexFemaleRaw ||
      initialSex == t.profileGenderFemale;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.profileGender,
      children: [
        MoyuSection(
          padding: EdgeInsets.zero,
          children: [
            InfoRow(
              label: t.profileGenderMale,
              value: _isMale(t) ? t.profileGenderSelected : '',
              onTap: () => _save(context, '1'),
            ),
            const MoyuDivider(),
            InfoRow(
              label: t.profileGenderFemale,
              value: _isFemale(t) ? t.profileGenderSelected : '',
              onTap: () => _save(context, '0'),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _save(BuildContext context, String value) async {
    await socialGateway?.updateCurrentUserInfo(key: 'sex', value: value);
    onSaved(value == '1' ? _profileSexMaleRaw : _profileSexFemaleRaw);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
