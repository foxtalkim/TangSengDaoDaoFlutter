import 'feature_registry.dart';

abstract interface class FeatureModule {
  String get id;

  void register(FeatureRegistry registry);
}
