import 'package:shared_preferences/shared_preferences.dart';

/// First-run onboarding completion flag.
/// This is a tiny app-level preference, so SharedPreferences is enough:
/// no account scope, no DB, and no SDK storage.
class OnboardingStore {
  const OnboardingStore._();

  static const String _key = 'foxtalk_onboarding_completed_v1';

  static Future<bool> isCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  static Future<void> markCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
