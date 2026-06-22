import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../icon/app_icon_service.dart';
import '../../l10n/app_localizations.dart';
import '../detail_scaffold.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_group_widgets.dart';

class AppIconSettingsPage extends StatefulWidget {
  const AppIconSettingsPage({super.key});

  @override
  State<AppIconSettingsPage> createState() => _AppIconSettingsPageState();
}

class _AppIconSettingsPageState extends State<AppIconSettingsPage> {
  static const _service = AppIconService();
  int _currentId = 1;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadCurrent());
  }

  Future<void> _loadCurrent() async {
    final icon = await _service.current();
    if (!mounted) return;
    setState(() => _currentId = icon.id);
  }

  Future<void> _select(AppIcon icon) async {
    if (_busy || icon.id == _currentId) return;
    setState(() => _busy = true);
    final ok = await _service.setIcon(icon);
    if (!mounted) return;
    setState(() => _busy = false);
    if (!ok) {
      MoyuToast.show(context, AppLocalizations.of(context).appIconUpdateFailed);
      return;
    }
    setState(() => _currentId = icon.id);
    // Android：AppIconService 已通过 blacklistBrands 强制走 plugin 的
    //   "立即切换"分支（在 activity 上 setComponentEnabledSetting），
    //   桌面 launcher 0–10s refresh，无需用户划走 App。
    // iOS：setAlternateIconName 同步生效；首次会弹系统 alert，后续
    //   静默切换，toast 兜底告知。
    MoyuToast.show(context, AppLocalizations.of(context).appIconUpdated);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return DetailScaffold(
      title: t.appearanceAppIcon,
      children: [
        settingsFlatGroup(
          context,
          rows: [
            for (var i = 0; i < kAppIcons.length; i++) ...[
              if (i > 0) const RowDivider(),
              _AppIconChoiceRow(
                icon: kAppIcons[i],
                selected: kAppIcons[i].id == _currentId,
                label: _appIconLabel(t, kAppIcons[i]),
                onTap: _busy ? null : () => _select(kAppIcons[i]),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

String _appIconLabel(AppLocalizations t, AppIcon icon) => switch (icon.id) {
  1 => t.appIconClassic,
  2 => t.appIconSimple,
  3 => t.appIconDark,
  4 => t.appIconFestive,
  5 => t.appIconGradient,
  _ => icon.label,
};

class _AppIconChoiceRow extends StatelessWidget {
  const _AppIconChoiceRow({
    required this.icon,
    required this.selected,
    required this.label,
    required this.onTap,
  });

  final AppIcon icon;
  final bool selected;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final row = Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: MoyuColors.of(context).background,
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              icon.assetPath,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                letterSpacing: -0.08,
                color: MoyuColors.of(context).textPrimary,
              ),
            ),
          ),
          if (selected)
            Icon(
              FIcons.circleCheck,
              size: 20,
              color: MoyuColors.of(context).primary,
            )
          else
            const SizedBox(width: 20),
        ],
      ),
    );
    if (onTap == null) return Opacity(opacity: 0.5, child: row);
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: row,
    );
  }
}
