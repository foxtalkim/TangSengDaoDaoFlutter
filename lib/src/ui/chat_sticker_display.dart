import '../social/social_service.dart';
import '../l10n/app_localizations.dart';

/// 对齐 iOS WKLottieStickerContent.conversationDigest = LLang("[贴图]"):
/// 固定 [贴图], 不读 sticker.placeholder. server 端 sticker.placeholder 字段
/// 实际是 SVG 字符串, 不是给文本展示用.
String stickerDisplayText(AppLocalizations t, ChatSticker sticker) =>
    t.chatStickerPlaceholder;
