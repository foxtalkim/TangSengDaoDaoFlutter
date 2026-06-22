import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../l10n/app_localizations.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';

class VoiceTranscribeButton extends StatelessWidget {
  const VoiceTranscribeButton({
    super.key,
    required this.loading,
    required this.done,
    required this.onTap,
  });

  final bool loading;
  final bool done;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final color = done ? MoyuColors.of(context).textTertiary : MoyuInk.blue;
    final child = Container(
      width: 54,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MoyuColors.of(context).background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: MoyuColors.of(context).line.withValues(alpha: 0.9),
        ),
      ),
      child: loading
          ? SizedBox(
              width: 13,
              height: 13,
              child: CircularProgressIndicator(strokeWidth: 1.6, color: color),
            )
          : Text(
              done ? t.messageAiTranscribedShort : t.chatActionTranscribe,
              maxLines: 1,
              style: TextStyle(
                fontSize: 11,
                height: 1,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
    );
    if (loading || onTap == null) return child;
    return FTappable(onPress: onTap!, child: child);
  }
}

class MessageAiResultPanel extends StatelessWidget {
  const MessageAiResultPanel({
    super.key,
    required this.text,
    this.translation = '',
    this.translating = false,
    this.onTranslate,
  });

  final String text;
  final String translation;
  final bool translating;
  final VoidCallback? onTranslate;

  @override
  Widget build(BuildContext context) {
    final hasTranslation = translation.trim().isNotEmpty;
    final displayText = hasTranslation ? translation.trim() : text.trim();
    final showTranslateAction = !hasTranslation && onTranslate != null;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 238),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
        decoration: BoxDecoration(
          color: MoyuColors.of(context).background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: MoyuColors.of(context).line.withValues(alpha: 0.75),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (displayText.isNotEmpty)
              Text(
                displayText,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.42,
                  color: MoyuColors.of(context).textPrimary,
                ),
              ),
            if (displayText.isNotEmpty && showTranslateAction)
              const SizedBox(height: 7),
            if (showTranslateAction)
              _TranslateAction(
                translating: translating,
                onTranslate: onTranslate,
              ),
          ],
        ),
      ),
    );
  }
}

class _TranslateAction extends StatelessWidget {
  const _TranslateAction({required this.translating, this.onTranslate});

  final bool translating;
  final VoidCallback? onTranslate;

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    final child = Text(
      translating ? t.messageAiTranslating : t.chatActionTranslate,
      style: TextStyle(
        fontSize: 12,
        height: 1,
        color: translating ? MoyuColors.of(context).textTertiary : MoyuInk.blue,
        fontWeight: FontWeight.w500,
      ),
    );
    if (translating || onTranslate == null) return child;
    return FTappable(onPress: onTranslate!, child: child);
  }
}
