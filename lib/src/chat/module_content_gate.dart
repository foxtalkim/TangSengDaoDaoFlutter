import '../app/app_runtime.dart';
import '../media/chat_media_service.dart';
import '../modules/feature_registry.dart';
import '../modules/module_ids.dart';
import '../modules/module_message_content_support.dart';
import 'chat_message.dart';

bool shouldRenderModuleContentFallback(
  ChatMessage message,
  AppRuntime? runtime,
) {
  if (message.isLocationMessage) {
    return !_hasEnabledContentSupport(runtime, message.contentType);
  }
  if (message.kind == ChatMediaKind.file && message.attachment != null) {
    return !_hasEnabledContentSupport(runtime, message.contentType);
  }
  if (message.kind == ChatMediaKind.video || message.contentType == 5) {
    return !_hasEnabledContentSupport(runtime, 5);
  }
  if (message.kind == ChatMediaKind.livePhoto) {
    return !_hasEnabledContentSupport(runtime, 5);
  }
  if (message.kind == ChatMediaKind.sticker) {
    final contentType = message.contentType;
    if (_isStickerContentType(contentType)) {
      return !_hasEnabledContentSupport(runtime, contentType);
    }
    return !_hasAnyEnabledContentSupport(runtime, const {
      ModuleMessageContentTypeIds.gifSticker,
      ModuleMessageContentTypeIds.lottieSticker,
      ModuleMessageContentTypeIds.emojiSticker,
    });
  }
  if (message.contentType == ModuleMessageContentTypeIds.gifSticker ||
      message.contentType == ModuleMessageContentTypeIds.lottieSticker ||
      message.contentType == ModuleMessageContentTypeIds.emojiSticker) {
    return !_hasEnabledContentSupport(runtime, message.contentType);
  }
  return false;
}

bool _isStickerContentType(int contentType) {
  return contentType == ModuleMessageContentTypeIds.gifSticker ||
      contentType == ModuleMessageContentTypeIds.lottieSticker ||
      contentType == ModuleMessageContentTypeIds.emojiSticker;
}

bool _hasAnyEnabledContentSupport(AppRuntime? runtime, Set<int> contentTypes) {
  final registry = runtime?.registry;
  if (registry == null) return false;
  return registry
      .enabledFeatures(kind: FeatureKind.messageContentHandler)
      .map((feature) => feature.value)
      .whereType<ModuleMessageContentSupport>()
      .any((support) => contentTypes.contains(support.contentType));
}

bool _hasEnabledContentSupport(AppRuntime? runtime, int contentType) {
  if (contentType <= 0) return false;
  final registry = runtime?.registry;
  if (registry == null) return false;
  return registry
      .enabledFeatures(kind: FeatureKind.messageContentHandler)
      .map((feature) => feature.value)
      .whereType<ModuleMessageContentSupport>()
      .any((support) => support.contentType == contentType);
}
