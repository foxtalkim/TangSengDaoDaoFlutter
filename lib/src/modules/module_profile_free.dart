import 'feature_registry.dart';
import 'module_ids.dart';

void registerModules(FeatureRegistry registry) {
  for (final moduleId in baseModuleIds) {
    registry.includeModule(moduleId);
  }
}

const baseModuleIds = {
  CoreModuleIds.auth,
  CoreModuleIds.chat,
  CoreModuleIds.contacts,
  CoreModuleIds.conversation,
  CoreModuleIds.groups,
  CoreModuleIds.im,
  CoreModuleIds.push,
  CoreModuleIds.settings,
};
