import 'module_entitlement.dart';

typedef ModuleLifecycleCallback = void Function();

enum FeatureKind {
  generic,
  route,
  discoverItem,
  contactProfileRow,
  chatHeaderAction,
  composerPanelItem,
  messageBubbleRenderer,
  messageContentHandler,
  longPressAction,
  hydrationHook,
  cmdHandler,
  settingsRow,
  diagnosticContributor,
}

final class FeatureRegistration {
  const FeatureRegistration({
    required this.id,
    required this.moduleId,
    this.kind = FeatureKind.generic,
    this.value,
  });

  final String id;
  final String moduleId;
  final FeatureKind kind;
  final Object? value;
}

final class ModuleLifecycleRegistration {
  const ModuleLifecycleRegistration({
    required this.id,
    required this.moduleId,
    this.onActivate,
    this.onDeactivate,
  });

  final String id;
  final String moduleId;
  final ModuleLifecycleCallback? onActivate;
  final ModuleLifecycleCallback? onDeactivate;
}

final class FeatureRegistry {
  FeatureRegistry({
    Set<String> includedModules = const {},
    ModuleEntitlement? entitlement,
  }) : _includedModules = Set.of(includedModules),
       _entitlement =
           entitlement ?? ModuleEntitlement.loading(cachedEnabled: const {});

  final Set<String> _includedModules;
  final Map<String, FeatureRegistration> _features = {};
  final Map<String, ModuleLifecycleRegistration> _lifecycles = {};
  final Set<String> _activeLifecycleIds = {};
  ModuleEntitlement _entitlement;

  ModuleEntitlement get entitlement => _entitlement;

  Set<String> get includedModules => Set.unmodifiable(_includedModules);

  void includeModule(String moduleId) {
    _includedModules.add(moduleId);
  }

  void setEntitlement(ModuleEntitlement entitlement) {
    _entitlement = entitlement;
  }

  bool isModuleIncluded(String moduleId) {
    return _includedModules.contains(moduleId);
  }

  bool isModuleEnabled(String moduleId) {
    return isModuleIncluded(moduleId) &&
        _entitlement.enabled.contains(moduleId);
  }

  void registerFeature({
    required String id,
    required String moduleId,
    FeatureKind kind = FeatureKind.generic,
    Object? value,
    String? replaceById,
  }) {
    final stableId = replaceById ?? id;
    _features[stableId] = FeatureRegistration(
      id: stableId,
      moduleId: moduleId,
      kind: kind,
      value: value,
    );
  }

  void registerRoute({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.route,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerDiscoverItem({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.discoverItem,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerContactProfileRow({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.contactProfileRow,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerChatHeaderAction({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.chatHeaderAction,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerComposerPanelItem({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.composerPanelItem,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerMessageBubbleRenderer({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.messageBubbleRenderer,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerMessageContentHandler({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.messageContentHandler,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerLongPressAction({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.longPressAction,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerHydrationHook({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.hydrationHook,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerCmdHandler({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.cmdHandler,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerSettingsRow({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.settingsRow,
      value: value,
      replaceById: replaceById,
    );
  }

  void registerDiagnosticContributor({
    required String id,
    required String moduleId,
    Object? value,
    String? replaceById,
  }) {
    registerFeature(
      id: id,
      moduleId: moduleId,
      kind: FeatureKind.diagnosticContributor,
      value: value,
      replaceById: replaceById,
    );
  }

  FeatureRegistration? featureById(String id) {
    return _features[id];
  }

  Iterable<FeatureRegistration> enabledFeatures({FeatureKind? kind}) {
    return _features.values.where((feature) {
      if (!isModuleEnabled(feature.moduleId)) return false;
      if (kind != null && feature.kind != kind) return false;
      return true;
    });
  }

  void registerLifecycle({
    required String id,
    required String moduleId,
    ModuleLifecycleCallback? onActivate,
    ModuleLifecycleCallback? onDeactivate,
    String? replaceById,
  }) {
    final stableId = replaceById ?? id;
    _lifecycles[stableId] = ModuleLifecycleRegistration(
      id: stableId,
      moduleId: moduleId,
      onActivate: onActivate,
      onDeactivate: onDeactivate,
    );
  }

  void activateEnabledModules() {
    for (final lifecycle in _lifecycles.values) {
      if (!isModuleEnabled(lifecycle.moduleId)) continue;
      if (!_activeLifecycleIds.add(lifecycle.id)) continue;
      lifecycle.onActivate?.call();
    }
  }

  void deactivateModule(String moduleId) {
    for (final lifecycle in _lifecycles.values) {
      if (lifecycle.moduleId != moduleId) continue;
      if (!_activeLifecycleIds.remove(lifecycle.id)) continue;
      lifecycle.onDeactivate?.call();
    }
  }

  void deactivateAll() {
    final activeIds = List<String>.from(_activeLifecycleIds);
    for (final id in activeIds) {
      final lifecycle = _lifecycles[id];
      if (lifecycle == null) {
        _activeLifecycleIds.remove(id);
        continue;
      }
      deactivateModule(lifecycle.moduleId);
    }
  }
}
