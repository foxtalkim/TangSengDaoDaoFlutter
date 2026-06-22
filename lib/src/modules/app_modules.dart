import '../server/server_profile.dart';
import 'feature_registry.dart';
import 'module_profile_free.dart' as default_profile;

const serverProfileResolver = OpenSourceServerProfileResolver();
const loginServerSwitchEnabled = false;

void registerModules(FeatureRegistry registry) {
  default_profile.registerModules(registry);
}
