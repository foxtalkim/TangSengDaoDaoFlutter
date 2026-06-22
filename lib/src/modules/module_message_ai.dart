import '../config/app_config.dart';
import '../network/api_client.dart';

typedef ModuleMessageAiGatewayFactory =
    ModuleMessageAiGateway Function({
      required AppConfig config,
      required String token,
    });

abstract interface class ModuleMessageAiGateway {
  Future<ModuleMessageAiResult> transcribe({
    required String channelId,
    required int channelType,
    required String messageId,
    required int messageSeq,
    String sourceLanguage,
  });

  Future<ModuleMessageAiResult> translate({
    required String channelId,
    required int channelType,
    required String messageId,
    required String text,
    String sourceLanguage,
    required String targetLanguage,
  });
}

final class ModuleMessageAiResult {
  const ModuleMessageAiResult({
    required this.text,
    required this.status,
    this.sourceLanguage = '',
    this.targetLanguage = '',
    this.provider = '',
    this.errorMessage = '',
  });

  final String text;
  final String status;
  final String sourceLanguage;
  final String targetLanguage;
  final String provider;
  final String errorMessage;

  bool get succeeded => status == 'succeeded' && text.trim().isNotEmpty;

  factory ModuleMessageAiResult.fromJson(Map<String, dynamic> json) {
    return ModuleMessageAiResult(
      text: _readString(json['text']),
      status: _readString(json['status']),
      sourceLanguage: _readString(json['source_language']),
      targetLanguage: _readString(json['target_language']),
      provider: _readString(json['provider']),
      errorMessage: _readString(json['error_message']),
    );
  }
}

final class ApiModuleMessageAiGateway implements ModuleMessageAiGateway {
  ApiModuleMessageAiGateway({
    required AppConfig config,
    required String token,
    ApiClient? client,
  }) : client = client ?? ApiClient(config: config) {
    this.client.token = token;
  }

  final ApiClient client;

  @override
  Future<ModuleMessageAiResult> transcribe({
    required String channelId,
    required int channelType,
    required String messageId,
    required int messageSeq,
    String sourceLanguage = 'auto',
  }) async {
    final data = await client.postJson('message-ai/transcribe', {
      'channel_id': channelId,
      'channel_type': channelType,
      'message_id': messageId,
      'message_seq': messageSeq,
      'source_language': sourceLanguage,
    });
    return ModuleMessageAiResult.fromJson(data);
  }

  @override
  Future<ModuleMessageAiResult> translate({
    required String channelId,
    required int channelType,
    required String messageId,
    required String text,
    String sourceLanguage = 'auto',
    required String targetLanguage,
  }) async {
    final data = await client.postJson('message-ai/translate', {
      'channel_id': channelId,
      'channel_type': channelType,
      'message_id': messageId,
      'text': text,
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
    });
    return ModuleMessageAiResult.fromJson(data);
  }
}

String _readString(Object? value) => value == null ? '' : value.toString();
