import 'src/app/app_bootstrap.dart';
import 'src/modules/module_profile_free.dart' as modules;

Future<void> main() {
  return runChatImApp(
    registerModules: modules.registerModules,
    loginServerSwitchEnabled: false,
  );
}
