import '../network/api_client.dart';
import 'user_session.dart';

class AuthRepository {
  const AuthRepository({required this.client});

  final ApiClient client;

  Future<UserSession> login({
    required String username,
    required String password,
  }) async {
    final loginUsername = normalizeLoginUsername(username);
    final data = await _postLogin(loginUsername, password);
    final session = UserSession.fromJson(data);
    if (!session.isValid) {
      throw const ApiException('登录返回缺少 uid/token');
    }
    client.token = session.token;
    return session;
  }

  Future<Map<String, dynamic>> _postLogin(
    String username,
    String password,
  ) async {
    try {
      return await client.postJson('user/login', {
        'username': username,
        'password': password,
        'flag': 0,
        'device': {
          'device_id': await client.deviceId(),
          'device_name': 'Flutter',
          'device_model': 'Flutter',
        },
      });
    } on ApiException catch (error) {
      if (error.apiStatus == 110) {
        throw LoginVerificationRequiredException.fromApi(error);
      }
      rethrow;
    }
  }

  Future<void> sendLoginCheckCode({required String uid}) async {
    await client.postJson('user/sms/login_check_phone', {'uid': uid.trim()});
  }

  Future<UserSession> loginCheckPhone({
    required String uid,
    required String code,
  }) async {
    final data = await client.postJson('user/login/check_phone', {
      'uid': uid.trim(),
      'code': code.trim(),
    });
    final session = UserSession.fromJson(data);
    if (!session.isValid) {
      throw const ApiException('手机号验证登录返回缺少 uid/token');
    }
    client.token = session.token;
    return session;
  }

  Future<void> sendRegisterCode({
    required String phone,
    String zone = '0086',
  }) async {
    await client.postJson('user/sms/registercode', {
      'zone': zone,
      'phone': phone.trim(),
    });
  }

  Future<void> sendPasswordResetCode({
    required String phone,
    String zone = '0086',
  }) async {
    await client.postJson('user/sms/forgetpwd', {
      'zone': zone,
      'phone': phone.trim(),
    });
  }

  Future<void> resetPassword({
    required String phone,
    required String code,
    required String password,
    String zone = '0086',
  }) async {
    await client.postJson('user/pwdforget', {
      'zone': zone,
      'phone': phone.trim(),
      'code': code.trim(),
      'pwd': password,
    });
  }

  Future<ChatServerAppConfig> loadAppConfig() async {
    final data = await client.getJson('common/appconfig');
    return ChatServerAppConfig.fromJson(data);
  }

  Future<UserSession> register({
    required String phone,
    required String code,
    required String name,
    required String password,
    String zone = '0086',
    String inviteCode = '',
  }) async {
    final data = await client.postJson('user/register', {
      'code': code.trim(),
      'zone': zone,
      'name': name.trim(),
      'phone': phone.trim(),
      'password': password,
      'invite_code': inviteCode.trim(),
      'device': {
        'device_id': await client.deviceId(),
        'device_name': 'Flutter',
        'device_model': 'Flutter',
      },
    });
    final session = UserSession.fromJson(data);
    if (!session.isValid) {
      throw const ApiException('注册返回缺少 uid/token');
    }
    client.token = session.token;
    return session;
  }
}

class ChatServerAppConfig {
  const ChatServerAppConfig({
    this.version = 0,
    this.webUrl = '',
    this.phoneSearchOff = false,
    this.shortNoEditOff = false,
    this.revokeSecond = 0,
    this.registerInviteOn = false,
    this.sendWelcomeMessageOn = false,
    this.inviteSystemAccountJoinGroupOn = false,
    this.registerUserMustCompleteInfoOn = false,
    this.canModifyApiUrl = false,
    this.allowTypingInGroup = false,
  });

  factory ChatServerAppConfig.fromJson(Map<String, dynamic> json) {
    return ChatServerAppConfig(
      version: _readInt(json['version']),
      webUrl: '${json['web_url'] ?? ''}',
      phoneSearchOff: _readInt(json['phone_search_off']) == 1,
      shortNoEditOff: _readInt(json['shortno_edit_off']) == 1,
      revokeSecond: _readInt(json['revoke_second']),
      registerInviteOn: _readInt(json['register_invite_on']) == 1,
      sendWelcomeMessageOn: _readInt(json['send_welcome_message_on']) == 1,
      inviteSystemAccountJoinGroupOn:
          _readInt(json['invite_system_account_join_group_on']) == 1,
      registerUserMustCompleteInfoOn:
          _readInt(json['register_user_must_complete_info_on']) == 1,
      canModifyApiUrl: _readInt(json['can_modify_api_url']) == 1,
      // Server `app_config.typing_in_group` controls whether clients
      // emit t=101 in group channels. Defaults to false in this fork
      // (groups are large; per-keystroke broadcast would explode fan-
      // out). Native iOS `WKTypingManager` skips the emit when this
      // flag is off — see typing-flow.md §1.3.
      allowTypingInGroup: _readInt(json['typing_in_group']) == 1,
    );
  }

  final int version;
  final String webUrl;
  final bool phoneSearchOff;
  final bool shortNoEditOff;
  final int revokeSecond;
  final bool registerInviteOn;
  final bool sendWelcomeMessageOn;
  final bool inviteSystemAccountJoinGroupOn;
  final bool registerUserMustCompleteInfoOn;
  final bool canModifyApiUrl;

  /// When false, the chat composer skips typing emit in group
  /// channels (1:1 chats are unaffected). Mirrors the native fork's
  /// `app_config.typing_in_group = false` default.
  final bool allowTypingInGroup;
}

int _readInt(Object? value) {
  if (value is int) {
    return value;
  }
  if (value is num) {
    return value.toInt();
  }
  return int.tryParse('$value') ?? 0;
}

String normalizeLoginUsername(String input) {
  final value = input.trim();
  final digitsOnly = RegExp(r'^\d+$').hasMatch(value);
  if (digitsOnly && value.length == 11) {
    return '0086$value';
  }
  if (value.startsWith('+86') && value.length == 14) {
    return '0086${value.substring(3)}';
  }
  return value;
}

class LoginVerificationRequiredException extends ApiException {
  LoginVerificationRequiredException({
    required this.uid,
    required this.phone,
    String message = '需要验证手机号码！',
    int? statusCode,
  }) : super(message, statusCode: statusCode, apiStatus: 110);

  factory LoginVerificationRequiredException.fromApi(ApiException error) {
    final data = error.data ?? const {};
    return LoginVerificationRequiredException(
      uid: '${data['uid'] ?? ''}',
      phone: '${data['phone'] ?? ''}',
      message: error.message,
      statusCode: error.statusCode,
    );
  }

  final String uid;
  final String phone;
}
