enum ModuleEntitlementStatus { loading, ok, offlineStale }

final class ModuleEntitlement {
  const ModuleEntitlement._({
    required this.enabled,
    required this.status,
    this.fetchedAt,
  });

  factory ModuleEntitlement.ok({
    required Set<String> enabled,
    DateTime? fetchedAt,
  }) {
    return ModuleEntitlement._(
      enabled: Set.unmodifiable(enabled),
      status: ModuleEntitlementStatus.ok,
      fetchedAt: fetchedAt,
    );
  }

  factory ModuleEntitlement.loading({
    Set<String> cachedEnabled = const {},
    DateTime? fetchedAt,
  }) {
    return ModuleEntitlement._(
      enabled: Set.unmodifiable(cachedEnabled),
      status: ModuleEntitlementStatus.loading,
      fetchedAt: fetchedAt,
    );
  }

  factory ModuleEntitlement.offlineStale({
    required Set<String> cachedEnabled,
    DateTime? fetchedAt,
  }) {
    return ModuleEntitlement._(
      enabled: Set.unmodifiable(cachedEnabled),
      status: ModuleEntitlementStatus.offlineStale,
      fetchedAt: fetchedAt,
    );
  }

  final Set<String> enabled;
  final ModuleEntitlementStatus status;
  final DateTime? fetchedAt;

  bool get isStale => status == ModuleEntitlementStatus.offlineStale;
}
