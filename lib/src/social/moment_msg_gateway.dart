import 'package:flutter/foundation.dart';

import '../app/app_runtime.dart';
import '../im/wukong_im_service.dart';
import '../modules/module_ids.dart';

abstract interface class MomentNotificationGateway {
  ValueListenable<int> get unreadCount;

  Future<void> start(ChatImGateway? imGateway);

  Future<void> dispose();
}

typedef MomentNotificationGatewayFactory =
    MomentNotificationGateway Function(String loginUid);

MomentNotificationGateway? createMomentNotificationGateway(String loginUid) {
  final feature = AppRuntime.current?.registry.featureById(
    ModuleFeatureIds.momentNotificationGatewayFactory,
  );
  final value = feature?.value;
  if (value is MomentNotificationGatewayFactory) {
    return value(loginUid);
  }
  return null;
}
