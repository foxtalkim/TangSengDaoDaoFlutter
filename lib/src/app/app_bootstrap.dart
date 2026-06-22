import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app_runtime.dart';
import '../modules/feature_registry.dart';
import '../modules/module_entitlement.dart';
import '../server/server_profile.dart';
import 'chat_im_app.dart';

typedef ModuleBundleRegistrar = void Function(FeatureRegistry registry);

AppRuntime? _activeRuntime;

AppRuntime get activeAppRuntime =>
    _activeRuntime ?? AppRuntime.fromIncludedModules(const {});

FeatureRegistry get activeFeatureRegistry => activeAppRuntime.registry;

Future<void> runChatImApp({
  required ModuleBundleRegistrar registerModules,
  ServerProfileResolver? serverProfileResolver,
  bool loginServerSwitchEnabled = true,
}) async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  // 保留 native splash 显示, 直到 chat_im_app `_bootRestoring` 翻 false
  // (session 恢复完, 见 _restorePersistedSession 末尾的 FlutterNativeSplash.remove)。
  // 消除 native splash 退场到 Dart 首帧之间的过渡白屏。
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final registry = FeatureRegistry();
  registerModules(registry);
  registry.setEntitlement(
    ModuleEntitlement.loading(cachedEnabled: registry.includedModules),
  );
  final runtime = AppRuntime(registry: registry);
  _activeRuntime = runtime;
  runApp(
    ChatImApp(
      runtime: runtime,
      serverProfileResolver: serverProfileResolver,
      loginServerSwitchEnabled: loginServerSwitchEnabled,
    ),
  );
}
