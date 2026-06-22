enum ModuleRouteFallbackReason { notIncluded, disabled, loading, offlineStale }

const kUnsupportedModuleMessage = 'module.unsupported';

final class ModuleRouteFallback {
  const ModuleRouteFallback._({
    required this.moduleId,
    required this.reason,
    required this.userMessage,
  });

  const ModuleRouteFallback.notIncluded({required String moduleId})
    : this._(
        moduleId: moduleId,
        reason: ModuleRouteFallbackReason.notIncluded,
        userMessage: kUnsupportedModuleMessage,
      );

  const ModuleRouteFallback.disabled({required String moduleId})
    : this._(
        moduleId: moduleId,
        reason: ModuleRouteFallbackReason.disabled,
        userMessage: kUnsupportedModuleMessage,
      );

  const ModuleRouteFallback.loading({required String moduleId})
    : this._(
        moduleId: moduleId,
        reason: ModuleRouteFallbackReason.loading,
        userMessage: 'module.loading',
      );

  const ModuleRouteFallback.offlineStale({required String moduleId})
    : this._(
        moduleId: moduleId,
        reason: ModuleRouteFallbackReason.offlineStale,
        userMessage: 'module.offline_stale',
      );

  final String moduleId;
  final ModuleRouteFallbackReason reason;
  final String userMessage;
}
