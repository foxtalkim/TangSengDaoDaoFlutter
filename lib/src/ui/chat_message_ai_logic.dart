import '../media/chat_media_service.dart';

bool shouldShowVoiceTranscribeAction({
  required bool disabled,
  required bool isMine,
  required ChatMediaKind kind,
  required bool revoked,
  required String messageId,
  required bool moduleAvailable,
}) {
  return !disabled &&
      !isMine &&
      kind == ChatMediaKind.voice &&
      !revoked &&
      messageId.trim().isNotEmpty &&
      moduleAvailable;
}

String messageAiFailureText(Object error, {required String fallback}) {
  return fallback;
}

String messageAiLanguageCode({
  required String preference,
  required String effectiveLanguageCode,
}) {
  final pinned = _messageAiLanguageCodeOrNull(preference);
  if (pinned != null) return pinned;

  return _messageAiLanguageCodeOrNull(effectiveLanguageCode) ?? 'zh';
}

String? _messageAiLanguageCodeOrNull(String value) {
  final normalized = value.trim().replaceAll('_', '-').toLowerCase();
  if (normalized.isEmpty || normalized == 'system') return null;
  return switch (normalized) {
    'zh' || 'zh-cn' || 'zh-hans' => 'zh',
    'zh-tw' || 'zh-hant' => 'zh-TW',
    'pt' || 'pt-br' || 'pt-pt' => 'pt',
    'en' ||
    'ja' ||
    'ko' ||
    'es' ||
    'fr' ||
    'de' ||
    'it' ||
    'nl' ||
    'ru' ||
    'ar' ||
    'tr' ||
    'id' ||
    'ms' ||
    'th' ||
    'vi' ||
    'hi' => normalized,
    _ => null,
  };
}
