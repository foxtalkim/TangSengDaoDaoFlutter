import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../l10n/language_native_names.dart';

/// Persisted language preference for the app. Pickable values:
/// - `system`: defer to MaterialApp.localeResolutionCallback (system
///   locale, falling back to zh when unsupported).
/// - language or language_region tags: pin to a specific app-supported
///   locale regardless of OS setting.
/// Mirrors iOS WKApp.shared.config.langue's behavior (user picks in
/// 通用 → 语言, persists on next launch). Stored under
/// `chatim_app_locale` in SharedPreferences.
class LocaleStore {
  const LocaleStore._();

  static const String _key = 'chatim_app_locale';

  /// Sentinel value meaning "follow OS locale". Anything else stored
  /// is interpreted as a BCP-47-ish locale tag (`en`, `zh_TW`, `pt-BR`).
  static const String systemPreference = 'system';

  static const List<String> supportedPreferences = <String>[
    'zh',
    'en',
    'zh_TW',
    'ja',
    'ko',
    'es',
    'pt_BR',
    'fr',
    'de',
    'it',
    'nl',
    'ru',
    'ar',
    'tr',
    'id',
    'ms',
    'th',
    'vi',
    'hi',
  ];

  static Future<String> loadPreference() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    if (value == null || value.isEmpty) {
      return systemPreference;
    }
    return value;
  }

  static Future<void> savePreference(String value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value.isEmpty || value == systemPreference) {
      await prefs.remove(_key);
      return;
    }
    await prefs.setString(_key, normalizePreference(value));
  }

  static String normalizePreference(String preference) {
    final value = preference.trim();
    if (value.isEmpty || value == systemPreference) {
      return systemPreference;
    }
    final parts = value.replaceAll('-', '_').split('_');
    if (parts.length == 1) return parts.first.toLowerCase();
    return '${parts[0].toLowerCase()}_${parts[1].toUpperCase()}';
  }

  static String nativeLanguageName(String preference) {
    final normalized = normalizePreference(preference);
    return languageNativeNames[normalized] ?? normalized;
  }

  /// Resolve a preference string to a concrete `Locale?` for use as
  /// `MaterialApp.locale`. Returns `null` for `systemPreference` so
  /// MaterialApp falls back to its `localeResolutionCallback` and
  /// inherits the OS choice.
  static Locale? toLocale(String preference) {
    final normalized = normalizePreference(preference);
    if (normalized == systemPreference) {
      return null;
    }
    final parts = normalized.split('_');
    if (parts.length == 1) {
      return Locale(parts.first);
    }
    return Locale.fromSubtags(
      languageCode: parts[0],
      countryCode: parts[1].toUpperCase(),
    );
  }
}
