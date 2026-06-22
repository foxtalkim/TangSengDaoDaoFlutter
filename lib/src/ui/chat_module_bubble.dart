import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../app/app_runtime.dart';
import '../l10n/app_localizations.dart';
import '../media/chat_media_service.dart';
import '../modules/feature_registry.dart';
import '../modules/module_message_bubble.dart';
import 'moyu_theme.dart';

Widget? renderModuleMessageBubble(
  BuildContext context, {
  required ChatMediaKind kind,
  required ChatMediaAttachment? attachment,
  required String fileName,
  required bool isMine,
  ValueListenable<double>? uploadProgress,
}) {
  final runtime = AppRuntime.current;
  if (runtime == null) return null;
  final data = ModuleMessageBubbleContext(
    kind: kind,
    attachment: attachment,
    fileName: fileName,
    isMine: isMine,
    uploadProgress: uploadProgress,
  );
  for (final feature in runtime.registry.enabledFeatures(
    kind: FeatureKind.messageBubbleRenderer,
  )) {
    final renderer = feature.value;
    if (renderer is! ModuleMessageBubbleRenderer) continue;
    if (!renderer.supports(data)) continue;
    return renderer.build(context, data);
  }
  return null;
}

class UnsupportedModuleBubble extends StatelessWidget {
  const UnsupportedModuleBubble({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).moduleUnsupported,
      style: TextStyle(
        fontSize: 14,
        height: 1.45,
        color: MoyuColors.of(context).textSecondary,
      ),
    );
  }
}
