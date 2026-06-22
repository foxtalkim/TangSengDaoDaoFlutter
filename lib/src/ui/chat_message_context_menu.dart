import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../chat/chat_message.dart';
import '../chat/chat_message_action.dart';
import '../l10n/app_localizations.dart';
import '../modules/module_ids.dart';
import 'chat_message_preview_bubble.dart';
import 'chat_reactions.dart';
import 'moyu_theme.dart';

/// Native-style long-press context menu: modal scrim with blurred background,
/// the original bubble preview anchored at the long-press position, and a
/// glass action menu beside it. Mirrors WKMessageLongMenusItem presentation
/// on iOS 13+.
class MessageContextMenu {
  static Future<void> show(
    BuildContext context, {
    required ChatMessage message,
    required bool isMine,
    required List<ChatMessageAction> actions,
    required ValueChanged<ChatMessageAction> onSelected,
    ValueChanged<String>? onPickReaction,
    Offset? anchor,
  }) async {
    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: AppLocalizations.of(context).actionCancel,
      barrierColor: Colors.transparent,
      // Matches iOS WKContextMenusVC's springDuration 0.52s — gives
      // the focused-bubble lift + menu fade enough time to feel
      // physical rather than snap-on. Combined with `Curves.easeOutCubic`
      // (high-damping spring approximation) we land close to iOS's
      // damping=110 critically-damped spring.
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, _, _) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, _, _) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return _MessageContextMenuOverlay(
          animation: curved,
          message: message,
          isMine: isMine,
          actions: actions,
          anchor: anchor,
          onSelected: (action) {
            Navigator.of(ctx).pop();
            onSelected(action);
          },
          onPickReaction: onPickReaction == null
              ? null
              : (emoji) {
                  Navigator.of(ctx).pop();
                  onPickReaction(emoji);
                },
        );
      },
    );
  }
}

class _MessageContextMenuOverlay extends StatelessWidget {
  const _MessageContextMenuOverlay({
    required this.animation,
    required this.message,
    required this.isMine,
    required this.actions,
    required this.onSelected,
    this.onPickReaction,
    this.anchor,
  });

  final Animation<double> animation;
  final ChatMessage message;
  final bool isMine;
  final List<ChatMessageAction> actions;
  final ValueChanged<ChatMessageAction> onSelected;
  final ValueChanged<String>? onPickReaction;
  final Offset? anchor;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenH = mq.size.height;
    final topSafe = mq.padding.top;
    final bottomSafe = mq.padding.bottom;
    final menuRowCount = actions.length;
    final menuHeight = (menuRowCount * 44.0) + 12;
    const menuWidth = 220.0;
    const previewMaxW = 260.0;
    // preview bubble 实际最大高度估算 — 图片消息长边 cap 192, 加 padding /
    // 文件消息含 fileName + 行高 + size 行约 80~120, merge-forward 多行可
    // 到 200+. 取 220 上限留 buffer. 之前固定 80 太小 → top 没正确 clamp →
    // menu 超出屏幕底被截断.
    const previewMaxH = 220.0;

    // When the quick-reactions bar is wired, the column stacks an extra
    // ~52pt (bar 44 + 8pt gap) above the bubble. Push the lower clamp
    // down by that allowance so the bar doesn't render off the top edge.
    final barAllowance = onPickReaction != null ? 52.0 : 0.0;
    // 下方留余: bottomSafe (iPhone home indicator) + 24pt gap + menu 高 +
    // preview 高. 之前 maxTop 减 200 (hardcoded) 没正确考虑 bottom safe
    // area + menu 实际高度 + preview 实际高度. iOS 16+ home indicator
    // 34pt, +24pt visual breathing room.
    final bottomReserve = bottomSafe + 24 + menuHeight + previewMaxH;

    // Position the anchored stack so the bubble preview sits roughly where
    // the user pressed, with the menu list directly below; if there's no
    // room below, flip above.
    double top;
    if (anchor != null) {
      // Try to place the preview centered vertically on the press point.
      // Guard the upper clamp — when the menu has a lot of rows the
      // computed upper bound can fall below the lower bound on small
      // screens, which makes `.clamp` throw.
      final maxTop = (screenH - bottomReserve).clamp(
        topSafe + 8,
        double.infinity,
      );
      final minTop = topSafe + 8 + barAllowance;
      // Re-clamp the upper bound first if `barAllowance` would push minTop
      // past maxTop on a tiny screen, otherwise `clamp` throws.
      final lo = math.min(minTop, maxTop);
      top = (anchor!.dy - 24 - barAllowance).clamp(lo, maxTop);
    } else {
      top = screenH * 0.3;
    }
    // showBelow 判断 — 用 previewMaxH 220 (实际 preview 高度上限) 取代之前
    // hardcoded 80 (太短让长 preview + menu 超 screen 底).
    final showBelow =
        (top + previewMaxH + menuHeight + 24 + bottomSafe) < screenH;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).maybePop(),
      child: AnimatedBuilder(
        animation: animation,
        builder: (_, _) {
          final blur = 18.0 * animation.value;
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
            child: Container(
              color: Colors.black.withValues(alpha: 0.28 * animation.value),
              child: Stack(
                children: [
                  Positioned(
                    top: top,
                    left: isMine ? null : 16,
                    right: isMine ? 16 : null,
                    child: Column(
                      crossAxisAlignment: isMine
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!showBelow) ...[
                          Opacity(
                            opacity: animation.value,
                            child: _ContextMenuList(
                              width: menuWidth,
                              actions: actions,
                              onSelected: onSelected,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        // Quick-reactions bar — sits between the menu (when
                        // above) and the bubble preview, OR above the bubble
                        // when the menu is below. Mirrors native iOS layout:
                        // bar is always closest to the focused bubble.
                        if (onPickReaction != null) ...[
                          Opacity(
                            opacity: animation.value,
                            child: _QuickReactionsBar(
                              defaults: _kDefaultQuickReactions,
                              onPick: onPickReaction!,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        // iOS WKContextMenusVC's focused-bubble spring
                        // doesn't dramatically reposition the bubble
                        // (line 109: y - 0.0f). We add a subtle 8px
                        // lift + small scale so the bubble FEELS like
                        // it pops forward when the menu opens — same
                        // visual cue Telegram / WeChat use.
                        Transform.translate(
                          offset: Offset(0, 8 * (1 - animation.value)),
                          child: Transform.scale(
                            scale: 0.97 + 0.03 * animation.value,
                            alignment: isMine
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: previewMaxW,
                              ),
                              child: MessagePreviewBubble(
                                message: message,
                                isMine: isMine,
                              ),
                            ),
                          ),
                        ),
                        if (showBelow) ...[
                          const SizedBox(height: 8),
                          Opacity(
                            opacity: animation.value,
                            child: _ContextMenuList(
                              width: menuWidth,
                              actions: actions,
                              onSelected: onSelected,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Default 6 quick reactions surfaced above the long-press menu. Now uses
/// iOS-compatible names so Flutter ↔ iOS reactions are interchangeable.
/// Display side maps these to unicode via `reactionDisplayEmoji`.
const List<String> _kDefaultQuickReactions = [
  'like',
  'love',
  'haha',
  'celebrate',
  'please',
  'fire',
];

/// Pill-shaped reactions bar shown above the focused bubble in the long-press
/// menu. Fixed 6 default emojis (no `+` expand) so the bar never overflows
/// screen width. Tap any emoji → dismiss the menu and toggle that reaction on
/// the message.
class _QuickReactionsBar extends StatelessWidget {
  const _QuickReactionsBar({required this.defaults, required this.onPick});

  final List<String> defaults;
  final ValueChanged<String> onPick;

  static const double _itemSize = 36;
  static const double _itemSpacing = 4;

  @override
  Widget build(BuildContext context) {
    // Fixed 6 defaults — no "+" expand button. Adding extras here
    // overflowed the screen width and offered too many low-signal
    // reactions; the per-message reaction strip inside the bubble
    // already wraps to multiple lines for users who want variety.
    return ClipRRect(
      borderRadius: BorderRadius.circular(_itemSize / 2 + 6),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            // 快速 reaction 表情条 bg — 跟长按菜单容器同模式 dark tint.
            color:
                (Theme.of(context).brightness == Brightness.dark
                        ? MoyuColors.of(context).backgroundSoft
                        : MoyuColors.of(context).background)
                    .withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(_itemSize / 2 + 6),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < defaults.length; i++) ...[
                if (i > 0) const SizedBox(width: _itemSpacing),
                _QuickReactionTile(
                  emoji: defaults[i],
                  onTap: () {
                    // Light haptic — native iOS uses
                    // `UIImpactFeedbackGenerator(.light)` on tap.
                    HapticFeedback.lightImpact();
                    onPick(defaults[i]);
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickReactionTile extends StatelessWidget {
  const _QuickReactionTile({required this.emoji, required this.onTap});

  /// Canonical reaction name (iOS-compatible: "fire" / "love" / ...).
  /// The tile shows the matching unicode glyph via `reactionDisplayEmoji`;
  /// `onTap` still fires with this name so the gateway sends iOS-compatible
  /// reactions back to the server.
  final String emoji;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: MoyuColors.of(context).backgroundSoft,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(reactionDisplayEmoji(emoji), style: _emojiTextStyle),
      ),
    );
  }
}

/// Shared `TextStyle` for inline emoji rendering.
/// Why both `fontFamily` AND `fontFamilyFallback`:
/// On iOS sim builds (Skia/Impeller path) `fontFamilyFallback` alone
/// isn't always consulted when the ambient text style has no `fontFamily` set
/// — the engine renders the codepoint with the system default font and that
/// font has no glyph for U+1F44D etc, leaving a `?` box. Naming Apple Color
/// Emoji as the primary `fontFamily` forces the engine to pick the emoji face
/// first. The fallback chain then covers Android (Noto Color Emoji) and
/// Windows/Web (Segoe / Twemoji).
/// `inherit: false` is critical — without it, the surrounding default text
/// theme's `fontFamily` would override ours and the emoji face would never be
/// consulted at all.
const TextStyle _emojiTextStyle = TextStyle(
  inherit: false,
  fontSize: 22,
  color: Color(0xFF000000),
  fontFamily: 'Apple Color Emoji',
  fontFamilyFallback: [
    'Noto Color Emoji',
    'Segoe UI Emoji',
    'EmojiOne Color',
    'Twemoji Mozilla',
  ],
);

class _ContextMenuList extends StatelessWidget {
  const _ContextMenuList({
    required this.width,
    required this.actions,
    required this.onSelected,
  });

  final double width;
  final List<ChatMessageAction> actions;
  final ValueChanged<ChatMessageAction> onSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: width,
          decoration: BoxDecoration(
            // light = background #FFFFFF 0.94 (跟原 Colors.white.alpha 等价),
            // dark = backgroundSoft #1A1A1F 0.94 (比 page bg #0F0F12 浅一档).
            // 配合 BackdropFilter 24sigma blur 让背后内容朦胧透出, 跟 iOS
            // UIMenuController 弹出菜单视觉一致.
            color:
                (Theme.of(context).brightness == Brightness.dark
                        ? MoyuColors.of(context).backgroundSoft
                        : MoyuColors.of(context).background)
                    .withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < actions.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 0.5,
                    thickness: 0.5,
                    color: MoyuColors.of(context).line,
                  ),
                _ContextMenuRow(
                  action: actions[i],
                  destructive:
                      actions[i].id == 'message.delete' ||
                      actions[i].id == 'message.revoke',
                  onTap: () => onSelected(actions[i]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ContextMenuRow extends StatelessWidget {
  const _ContextMenuRow({
    required this.action,
    required this.onTap,
    required this.destructive,
  });

  final ChatMessageAction action;
  final bool destructive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = destructive
        ? MoyuColors.of(context).red
        : MoyuColors.of(context).textPrimary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        height: 44,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _localizedActionTitle(context, action),
                  style: TextStyle(
                    color: fg,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(action.icon, size: 16, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

String _localizedActionTitle(BuildContext context, ChatMessageAction action) {
  final t = AppLocalizations.of(context);
  return switch (action.id) {
    'message.reply' => t.chatActionReply,
    'message.copy' => t.chatActionCopy,
    'message.translate' => t.chatActionTranslate,
    'message.transcribe' => t.chatActionTranscribe,
    'message.forward' => t.chatActionForward,
    ModuleActionIds.messageFavorite => t.chatActionFavorite,
    ModuleActionIds.messagePin => t.chatActionPin,
    ModuleActionIds.messageUnpin => t.chatActionUnpin,
    'message.add_friend' => t.chatActionAddFriend,
    'message.multi_select' => t.chatActionMultiSelect,
    'message.edit' => t.chatActionEdit,
    ModuleActionIds.messageEditImage => t.chatActionEditImage,
    'message.revoke' => t.chatActionRevoke,
    'message.delete' => t.chatActionDelete,
    ModuleActionIds.messageReceipts => t.chatActionReadBy(
      _leadingCount(action.title),
    ),
    ModuleActionIds.messageReactions => t.chatActionReactedBy(
      _leadingCount(action.title),
    ),
    _ => action.title,
  };
}

int _leadingCount(String value) {
  final match = RegExp(r'^\s*(\d+)').firstMatch(value);
  return int.tryParse(match?.group(1) ?? '') ?? 0;
}
