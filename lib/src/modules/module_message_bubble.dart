import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../config/app_config.dart';
import '../media/chat_media_service.dart';
import '../social/social_service.dart';

final class ModuleMessageBubbleContext {
  const ModuleMessageBubbleContext({
    required this.kind,
    required this.attachment,
    required this.fileName,
    required this.isMine,
    this.uploadProgress,
  });

  final ChatMediaKind kind;
  final ChatMediaAttachment? attachment;
  final String fileName;
  final bool isMine;
  final ValueListenable<double>? uploadProgress;
}

abstract interface class ModuleMessageBubbleRenderer {
  bool supports(ModuleMessageBubbleContext data);

  Widget build(BuildContext context, ModuleMessageBubbleContext data);
}

typedef ModuleFileInfoPageBuilder =
    Widget Function({
      required String fileName,
      required int fileSize,
      required String localPath,
      required String remoteUrl,
      required String token,
    });

typedef ModuleVideoPlayerPageBuilder =
    Widget Function({required String url, required String token});

typedef ModuleLivePhotoViewerPageBuilder =
    Widget Function({
      required String stillUrl,
      required String videoUrl,
      required String token,
    });

typedef ModuleStickerThumbnailBuilder =
    Widget Function(
      BuildContext context,
      ChatSticker sticker,
      AppConfig config,
    );

typedef ModuleStickerStorePageBuilder =
    Widget Function({
      required AppConfig config,
      required ChatSocialGateway? socialGateway,
    });

typedef ModuleStickerManagerPageBuilder =
    Widget Function({
      required AppConfig config,
      required ChatSocialGateway? socialGateway,
      bool custom,
    });
