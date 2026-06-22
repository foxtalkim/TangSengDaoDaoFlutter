import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import 'server_profile.dart';

abstract final class ServerProfileStore {
  static const _activeServerBaseUrlKey = 'foxtalk.server.active_base_url.v1';

  static Future<ServerProfile> loadActive({
    ServerProfileResolver resolver = const OpenSourceServerProfileResolver(),
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_activeServerBaseUrlKey)?.trim() ?? '';
    final config = raw.isEmpty
        ? AppConfig.defaultConfig()
        : AppConfig.fromServerBaseUrl(raw);
    return resolver.resolve(config);
  }

  static Future<void> saveActive(ServerProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _activeServerBaseUrlKey,
      profile.config.serverBaseUrl,
    );
  }
}
