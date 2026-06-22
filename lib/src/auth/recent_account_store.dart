import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'user_session.dart';

/// 最近登录账号展示信息. 只存 uid/name/loginId/avatar, 不存 token/imToken/password.
/// 切换账号先回登录页重新认证, 避免多 token 切换引入跨账号状态残留。
class RecentAccount {
  const RecentAccount({
    required this.uid,
    required this.name,
    required this.loginId,
    required this.avatar,
    required this.lastLoginAt,
  });

  final String uid;
  final String name;
  final String loginId;
  final String avatar;
  final int lastLoginAt;

  factory RecentAccount.fromSession(UserSession session, {int? lastLoginAt}) {
    final loginId = _loginIdFromUsername(session.username);
    final avatar = session.avatar.trim();
    return RecentAccount(
      uid: session.uid,
      name: session.displayName,
      loginId: loginId.isNotEmpty ? loginId : session.uid,
      avatar: avatar.isEmpty ? 'users/${session.uid}/avatar' : avatar,
      lastLoginAt: lastLoginAt ?? DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
  }

  factory RecentAccount.fromJson(Map<String, dynamic> json) {
    return RecentAccount(
      uid: '${json['uid'] ?? ''}',
      name: '${json['name'] ?? ''}',
      loginId: '${json['login_id'] ?? ''}',
      avatar: '${json['avatar'] ?? ''}',
      lastLoginAt: int.tryParse('${json['last_login_at'] ?? ''}') ?? 0,
    );
  }

  String get displayName {
    if (name.isNotEmpty) return name;
    if (loginId.isNotEmpty) return loginId;
    return uid;
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'login_id': loginId,
      'avatar': avatar,
      'last_login_at': lastLoginAt,
    };
  }

  static String _loginIdFromUsername(String username) {
    final value = username.trim();
    if (value.startsWith('0086') && value.length == 15) {
      return value.substring(4);
    }
    if (value.startsWith('+86') && value.length == 14) {
      return value.substring(3);
    }
    return value;
  }
}

class RecentAccountStore {
  const RecentAccountStore._();

  static const _accountsKey = 'foxtalk.login.recent_accounts.v1';
  static const _loginPrefillKey = 'foxtalk.login.prefill_phone';
  static const _maxAccounts = 5;

  static String _scopedKey(String key, String? serverScope) {
    final scope = serverScope?.trim() ?? '';
    if (scope.isEmpty) return key;
    return '$key::$scope';
  }

  static Future<List<RecentAccount>> load({String? serverScope}) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_scopedKey(_accountsKey, serverScope));
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      final accounts = decoded
          .whereType<Map>()
          .map(
            (entry) => RecentAccount.fromJson(Map<String, dynamic>.from(entry)),
          )
          .where((account) => account.uid.isNotEmpty)
          .toList();
      accounts.sort((a, b) => b.lastLoginAt.compareTo(a.lastLoginAt));
      return accounts;
    } catch (_) {
      return const [];
    }
  }

  static Future<void> saveFromSession(
    UserSession session, {
    String? serverScope,
  }) async {
    if (!session.isValid) return;
    final current = RecentAccount.fromSession(session);
    final next = [
      current,
      for (final account in await load(serverScope: serverScope))
        if (account.uid != current.uid) account,
    ].take(_maxAccounts).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _scopedKey(_accountsKey, serverScope),
      jsonEncode([for (final account in next) account.toJson()]),
    );
  }

  static Future<void> setLoginPrefill(
    String loginId, {
    String? serverScope,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _scopedKey(_loginPrefillKey, serverScope),
      loginId.trim(),
    );
  }

  static Future<String?> consumeLoginPrefill({String? serverScope}) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _scopedKey(_loginPrefillKey, serverScope);
    if (!prefs.containsKey(key)) return null;
    final value = prefs.getString(key) ?? '';
    await prefs.remove(key);
    return value;
  }
}
