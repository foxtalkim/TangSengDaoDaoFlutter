import '../foundation/route_fallbacks.dart';
import '../modules/feature_registry.dart';
import '../modules/module_entitlement.dart';
import '../modules/module_profile_free.dart' as free_profile;
import '../server/server_profile.dart';

typedef ModuleRegistrar = void Function(FeatureRegistry registry);

final class AppRuntime {
  AppRuntime({required this.registry});

  /// Current app runtime for secondary pages reached through legacy `part`
  /// call paths that do not yet thread runtime explicitly.
  static AppRuntime? current;

  factory AppRuntime.fromIncludedModules(Set<String> includedModules) {
    return AppRuntime(
      registry: FeatureRegistry(
        includedModules: includedModules,
        entitlement: ModuleEntitlement.loading(cachedEnabled: includedModules),
      ),
    );
  }

  factory AppRuntime.fromRegistrar(ModuleRegistrar registerModules) {
    final registry = FeatureRegistry();
    registerModules(registry);
    registry.setEntitlement(
      ModuleEntitlement.loading(cachedEnabled: registry.includedModules),
    );
    return AppRuntime(registry: registry);
  }

  final FeatureRegistry registry;

  ModuleEntitlement get entitlement => registry.entitlement;

  void applyEntitlement(ModuleEntitlement entitlement) {
    registry.setEntitlement(entitlement);
  }

  void applyServerProfile(ServerProfile profile) {
    final enabled = registry.includedModules.intersection(
      free_profile.baseModuleIds,
    );
    registry.setEntitlement(ModuleEntitlement.ok(enabled: enabled));
  }

  bool isModuleEnabled(String moduleId) {
    return registry.isModuleEnabled(moduleId);
  }

  ModuleRouteFallback? fallbackFor(String moduleId) {
    if (!registry.isModuleIncluded(moduleId)) {
      return ModuleRouteFallback.notIncluded(moduleId: moduleId);
    }
    if (registry.isModuleEnabled(moduleId)) {
      return null;
    }
    return switch (registry.entitlement.status) {
      ModuleEntitlementStatus.loading => ModuleRouteFallback.loading(
        moduleId: moduleId,
      ),
      ModuleEntitlementStatus.offlineStale => ModuleRouteFallback.offlineStale(
        moduleId: moduleId,
      ),
      ModuleEntitlementStatus.ok => ModuleRouteFallback.disabled(
        moduleId: moduleId,
      ),
    };
  }
}
