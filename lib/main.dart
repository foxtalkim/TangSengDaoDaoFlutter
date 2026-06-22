import 'src/app/app_bootstrap.dart';
import 'src/modules/app_modules.dart' as modules;

export 'src/app/chat_im_app.dart' show ChatImApp;

Future<void> main() {
  return runChatImApp(
    registerModules: modules.registerModules,
    serverProfileResolver: modules.serverProfileResolver,
    loginServerSwitchEnabled: modules.loginServerSwitchEnabled,
  );
}
