// 发现 tab 基础页。可选入口只消费 registry，不 import 具体模块页面。
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../app/app_runtime.dart';
import '../../config/app_config.dart';
import '../../l10n/app_localizations.dart';
import '../../modules/feature_registry.dart' show FeatureKind;
import '../../modules/module_ids.dart' show ModuleActionIds, ModuleRouteIds;
import '../../modules/module_route.dart'
    show ModuleRouteContext, ModuleRouteDescriptor;
import '../../scan/chat_scan_service.dart' show ChatScanGateway;
import '../../social/moment_msg_gateway.dart' show MomentNotificationGateway;
import '../../social/social_service.dart' show ChatSocialGateway;
import '../chat_navigation.dart';
import '../models/contact_models.dart';
import '../moyu_ink.dart';
import '../moyu_theme.dart';
import '../moyu_widgets.dart';
import '../settings_group_widgets.dart';
import '../settings_row_widgets.dart';

typedef OpenDiscoverUserCard =
    void Function(BuildContext context, String uid, String displayName);

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({
    super.key,
    this.socialGateway,
    this.scanGateway,
    this.loginUid = '',
    this.loginName = '',
    this.contacts = const [],
    this.config,
    this.onOpenGroupChat,
    this.onCreateGroup,
    this.momentMsgService,
    this.runtime,
    required this.scanPageBuilder,
    required this.onOpenUserCard,
  });

  final ChatSocialGateway? socialGateway;
  final ChatScanGateway? scanGateway;
  final String loginUid;
  final String loginName;

  final List<UiContact> contacts;
  final AppConfig? config;
  final Future<bool> Function(String groupNo)? onOpenGroupChat;
  final Future<UiGroup?> Function(List<UiContact> members)? onCreateGroup;

  final MomentNotificationGateway? momentMsgService;
  final AppRuntime? runtime;
  final WidgetBuilder scanPageBuilder;
  final OpenDiscoverUserCard onOpenUserCard;

  bool get _momentEnabled {
    final activeRuntime = runtime;
    if (activeRuntime == null) return true;
    return activeRuntime.registry
        .enabledFeatures(kind: FeatureKind.discoverItem)
        .any((feature) => feature.id == ModuleActionIds.discoverMoment);
  }

  void _openMomentTimeline(BuildContext context) {
    final activeRuntime = runtime ?? AppRuntime.current;
    final route = activeRuntime?.registry.featureById(ModuleRouteIds.moment);
    final value = route?.value;
    if (value is! ModuleRouteDescriptor) {
      MoyuToast.show(context, AppLocalizations.of(context).moduleUnsupported);
      return;
    }
    pushPage(
      context,
      value.build(
        context,
        ModuleRouteContext(
          socialGateway: socialGateway,
          config: config,
          loginUid: loginUid,
          extra: {
            'loginName': loginName,
            'contacts': contacts,
            'momentMsgService': momentMsgService,
            'runtime': activeRuntime,
            'onOpenUserCard': (String uid, String name) {
              onOpenUserCard(context, uid, name);
            },
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final headerInset = MediaQuery.viewPaddingOf(context).top + 60 + 12;
    final momentEnabled = _momentEnabled;
    return Semantics(
      identifier: 'moyu.discover.page',
      container: true,
      child: Stack(
        children: [
          ColoredBox(
            color: MoyuColors.of(context).background,
            child: Padding(
              padding: EdgeInsets.only(top: headerInset),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (momentEnabled) ...[
                    ValueListenableBuilder<int>(
                      valueListenable:
                          momentMsgService?.unreadCount ??
                          ValueNotifier<int>(0),
                      builder: (_, unread, _) => settingsFlatGroup(
                        context,
                        rows: [
                          PlainSettingRow(
                            leading: const Icon(FIcons.aperture),
                            title: t.momentTitle,
                            trailing: unread > 0
                                ? MoyuUnreadBadge(count: unread)
                                : null,
                            showChevron: true,
                            onTap: () => _openMomentTimeline(context),
                          ),
                        ],
                      ),
                    ),
                    settingsBlockGap(context),
                  ],
                  settingsFlatGroup(
                    context,
                    rows: [
                      PlainSettingRow(
                        leading: const Icon(FIcons.scan),
                        title: t.scanTitle,
                        showChevron: true,
                        onTap: () =>
                            pushPage(context, scanPageBuilder(context)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: MoyuGlass(
              borderRadius: BorderRadius.zero,
              showHairline: false,
              child: SafeArea(
                bottom: false,
                child: MoyuPageHeader(
                  title: AppLocalizations.of(context).pageDiscoverTitle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
