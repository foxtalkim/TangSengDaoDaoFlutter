import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'user_session.dart';

/// On-device persistence for the logged-in session — mirrors iOS
/// `WKLoginInfo` (`save` / `load` / `clear`), which serialises uid +
/// token + imToken + extra into NSUserDefaults under key
/// `WKLoginInfo`. We use the same key so a single SharedPreferences
/// inspection on Android matches the iOS behaviour at parity.
class SessionStore {
  static const String _kKey = 'WKLoginInfo';

  static String _keyFor(String? serverScope) {
    final scope = serverScope?.trim() ?? '';
    if (scope.isEmpty) return _kKey;
    return '$_kKey::$scope';
  }

  /// Write the active session — call from the main login flow once
  /// `_activateSession` has wired up IM / social services. Later
  /// app launches read this back and skip the login screen.
  static Future<void> save(UserSession session, {String? serverScope}) async {
    if (!session.isValid) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(serverScope), jsonEncode(session.toJson()));
  }

  /// Returns the stored session if it parses cleanly and still has a
  /// non-empty token + imToken pair. Anything else (missing key,
  /// malformed JSON, partially-cleared payload) collapses to `null`
  /// so the caller falls through to the login screen.
  static Future<UserSession?> load({String? serverScope}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(serverScope));
    if (raw == null || raw.isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;
      final session = UserSession.fromJson(json);
      return session.isValid ? session : null;
    } catch (_) {
      return null;
    }
  }

  /// Drop the persisted session — invoked from the explicit logout
  /// path and from the kicked-by-other-device handler so the next
  /// launch returns to the login screen.
  static Future<void> clear({String? serverScope}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFor(serverScope));
  }
}
