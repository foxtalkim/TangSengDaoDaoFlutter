import 'package:flutter/widgets.dart';

import '../config/app_config.dart';
import '../im/wukong_im_service.dart';
import '../social/social_service.dart';

typedef ModuleRouteWidgetBuilder =
    Widget Function(BuildContext context, ModuleRouteContext routeContext);

typedef ModuleContactPicker =
    Future<ModuleContactTarget?> Function(BuildContext context);

final class ModuleContactTarget {
  const ModuleContactTarget({
    required this.channelId,
    required this.displayName,
  });

  final String channelId;
  final String displayName;
}

final class ModuleRouteContact {
  const ModuleRouteContact({
    required this.channelId,
    required this.uid,
    required this.name,
    required this.avatarPath,
  });

  final String channelId;
  final String uid;
  final String name;
  final String avatarPath;
}

final class ModuleRouteGroup {
  const ModuleRouteGroup({
    required this.groupNo,
    required this.name,
    required this.avatarLabel,
    required this.avatarPath,
    required this.color,
  });

  final String groupNo;
  final String name;
  final String avatarLabel;
  final String avatarPath;
  final Color color;
}

final class ModuleRouteContext {
  const ModuleRouteContext({
    this.socialGateway,
    this.imGateway,
    this.config,
    this.loginUid = '',
    this.pickContactTarget,
    this.contacts = const [],
    this.groups = const [],
    this.extra = const {},
  });

  final ChatSocialGateway? socialGateway;
  final ChatImGateway? imGateway;
  final AppConfig? config;
  final String loginUid;
  final ModuleContactPicker? pickContactTarget;
  final List<ModuleRouteContact> contacts;
  final List<ModuleRouteGroup> groups;
  final Map<String, Object?> extra;
}

final class ModuleRouteDescriptor {
  const ModuleRouteDescriptor({
    required this.id,
    required this.title,
    required this.builder,
  });

  final String id;
  final String title;
  final ModuleRouteWidgetBuilder builder;

  Widget build(BuildContext context, ModuleRouteContext routeContext) {
    return builder(context, routeContext);
  }
}
