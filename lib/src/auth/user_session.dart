class UserSession {
  const UserSession({
    required this.token,
    required this.uid,
    required this.username,
    required this.name,
    required this.imToken,
    required this.shortNo,
    required this.avatar,
    required this.msgExpireSecond,
    this.shortStatus = 0,
    this.sex = -1,
    this.chatPwd = '',
    this.lockAfterMinute = 0,
    this.lockScreenPwd = '',
    this.settings = const {},
  });

  /// 当前全局登录会话 — _HomeShellState initState 时 set, dispose 清空.
  /// 给那些没法走 widget tree 透传 loginName/loginUid 的入口用 (例如
  /// top-level helper / 9 个 _ContactDetailPage 调用站点不可能每个都 thread).
  /// 跟 MomentMsgService.current 同模式. 没有 Provider/InheritedWidget 是为
  /// 改动面最小 — 1 个 app session 只有一个 UserSession, 单例语义本来就成立.
  static UserSession? current;

  final String token;
  final String uid;
  final String username;
  final String name;
  final String imToken;
  final String shortNo;
  final String avatar;
  final int msgExpireSecond;
  final int shortStatus;
  final int sex;
  final String chatPwd;
  final int lockAfterMinute;

  /// Server-issued md5 digest of the lock-screen password (digest =
  /// md5(password + uid)). Empty when the user hasn't enabled lock-
  /// screen protection. Mirrors iOS `WKApp.loginInfo.extra['lock_screen_pwd']`;
  /// the LockScreenGuard reads this on resume to decide whether to
  /// prompt for re-entry, comparing it against the user's input digest
  /// rather than round-tripping to the server.
  final String lockScreenPwd;

  final Map<String, Object?> settings;

  factory UserSession.fromJson(Map<String, dynamic> json) {
    final token = _string(json['token']);
    return UserSession(
      token: token,
      uid: _string(json['uid']),
      username: _string(json['username']),
      name: _string(json['name']),
      imToken: _string(json['im_token']).isNotEmpty
          ? _string(json['im_token'])
          : token,
      shortNo: _string(json['short_no']),
      avatar: _string(json['avatar']),
      msgExpireSecond: _int(json['msg_expire_second']),
      shortStatus: _int(
        json['short_status'] ?? _map(json['extra'])['short_status'],
      ),
      sex: _int(json['sex'], fallback: -1),
      chatPwd: _string(json['chat_pwd']),
      lockAfterMinute: _int(json['lock_after_minute']),
      lockScreenPwd: _string(json['lock_screen_pwd']),
      settings: _settings(
        json['setting'] ?? json['settings'] ?? _map(json['extra'])['setting'],
      ),
    );
  }

  String get displayName {
    if (name.isNotEmpty) return name;
    if (username.isNotEmpty) return username;
    return uid;
  }

  bool get isValid => token.isNotEmpty && uid.isNotEmpty && imToken.isNotEmpty;

  UserSession copyWith({
    String? token,
    String? uid,
    String? username,
    String? name,
    String? imToken,
    String? shortNo,
    String? avatar,
    int? msgExpireSecond,
    int? shortStatus,
    int? sex,
    String? chatPwd,
    int? lockAfterMinute,
    String? lockScreenPwd,
    Map<String, Object?>? settings,
  }) {
    return UserSession(
      token: token ?? this.token,
      uid: uid ?? this.uid,
      username: username ?? this.username,
      name: name ?? this.name,
      imToken: imToken ?? this.imToken,
      shortNo: shortNo ?? this.shortNo,
      avatar: avatar ?? this.avatar,
      msgExpireSecond: msgExpireSecond ?? this.msgExpireSecond,
      shortStatus: shortStatus ?? this.shortStatus,
      sex: sex ?? this.sex,
      chatPwd: chatPwd ?? this.chatPwd,
      lockAfterMinute: lockAfterMinute ?? this.lockAfterMinute,
      lockScreenPwd: lockScreenPwd ?? this.lockScreenPwd,
      settings: settings ?? this.settings,
    );
  }

  String get sexLabel {
    if (sex == 1) return '1';
    if (sex == 0) return '0';
    return '';
  }

  String get displayPhone => displayLoginPhone(username);

  bool settingEnabled(String key, {bool defaultValue = false}) {
    final value = settings[key];
    if (value is bool) return value;
    if (value is num) return value.toInt() == 1;
    final text = value?.toString().trim().toLowerCase();
    if (text == null || text.isEmpty) return defaultValue;
    return text == '1' || text == 'true';
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'uid': uid,
      'username': username,
      'name': name,
      'im_token': imToken,
      'short_no': shortNo,
      'avatar': avatar,
      'msg_expire_second': msgExpireSecond,
      'short_status': shortStatus,
      'sex': sex,
      'chat_pwd': chatPwd,
      'lock_after_minute': lockAfterMinute,
      'lock_screen_pwd': lockScreenPwd,
      'setting': settings,
    };
  }

  static String _string(Object? value) => value?.toString() ?? '';

  static int _int(Object? value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? fallback;
  }

  static Map<String, Object?> _settings(Object? value) {
    if (value is Map) {
      return value.map((key, value) => MapEntry(key.toString(), value));
    }
    return const {};
  }

  static Map<String, Object?> _map(Object? value) => _settings(value);
}

String displayLoginPhone(String input) {
  final value = input.trim();
  final chinaZonePhone = RegExp(r'^0086(1\d{10})$').firstMatch(value);
  if (chinaZonePhone != null) {
    return chinaZonePhone.group(1)!;
  }
  final plusChinaPhone = RegExp(r'^\+86(1\d{10})$').firstMatch(value);
  if (plusChinaPhone != null) {
    return plusChinaPhone.group(1)!;
  }
  return value;
}
