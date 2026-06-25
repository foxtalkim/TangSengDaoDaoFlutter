import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';

import '../media/chat_media_service.dart';
import '../l10n/app_localizations.dart';
import '../settings/bubble_radius_controller.dart';
import '../settings/bubble_radius_store.dart';
import 'chat_bubble_quote.dart';
import 'chat_flame_badge.dart';
import 'chat_image_bubble.dart';
import 'chat_inline_text.dart';
import 'chat_message_status_widgets.dart';
import 'chat_module_bubble.dart';
import 'chat_peer_frame.dart';
import 'chat_reactions.dart';
import 'chat_typing_bottom_bubble.dart';
import 'chat_voice_bubble.dart';
import 'moyu_ink.dart';
import 'moyu_theme.dart';

class Bubble extends StatelessWidget {
  const Bubble.left({
    super.key,
    required this.avatarLabel,
    required this.text,
    required this.colors,
    this.avatarUrl = '',
    this.kind = ChatMediaKind.file,
    this.attachment,
    this.onTap,
    this.onAvatarTap,
    this.onLongPress,
    this.onLongPressAt,
    this.senderName = '',
    this.hasAvatarSlot = true,
    this.showAvatar = true,
    this.replyToSender = '',
    this.replyToText = '',
    this.replyToRevoked = false,
    this.onReplyTap,
    this.messageKey = '',
    this.edited = false,
    this.reactions = const [],
    this.onReactionTap,
    this.flameSecond = 0,
    this.flameExpiresAtMs = 0,
    this.mediaGateway,
    this.onMentionTap,
    this.mentionCandidates = const [],
    this.sensitiveTipText,
    this.voiceUnread = false,
    this.voiceSideAction,
    this.messageAddon,
    this.onSwipeReply,
    this.timeText = '',
    this.replyCount = 0,
    this.streamingPlaceholder = false,
  }) : isMine = false,
       status = null,
       onRetry = null,
       onDelete = null,
       onReceiptTap = null,
       // 对方文本不能编辑 (iOS 同款), 双击 left bubble 无 action.
       onDoubleTap = null,
       readed = false,
       readedCount = 0,
       unreadCount = 0,
       // Upload progress only applies to outgoing bubbles (left bubble
       // is a peer message we never uploaded). Hardcode null so the
       // _FileBubbleContent always renders without an overlay bar.
       uploadProgress = null;

  const Bubble.right({
    super.key,
    required this.text,
    this.kind = ChatMediaKind.file,
    this.attachment,
    this.status,
    this.onRetry,
    this.onDelete,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
    this.onLongPressAt,
    this.readed = false,
    this.readedCount = 0,
    this.unreadCount = 0,
    this.replyToSender = '',
    this.replyToText = '',
    this.replyToRevoked = false,
    this.onReplyTap,
    this.messageKey = '',
    this.edited = false,
    this.reactions = const [],
    this.onReactionTap,
    this.flameSecond = 0,
    this.flameExpiresAtMs = 0,
    this.mediaGateway,
    this.onMentionTap,
    this.mentionCandidates = const [],
    this.onReceiptTap,
    this.uploadProgress,
    this.voiceSideAction,
    this.messageAddon,
    this.onSwipeReply,
    this.timeText = '',
    this.replyCount = 0,
    this.streamingPlaceholder = false,
  }) : isMine = true,
       voiceUnread = false,
       avatarLabel = '',
       avatarUrl = '',
       colors = const [],
       senderName = '',
       hasAvatarSlot = false,
       showAvatar = false,
       onAvatarTap = null,
       // Outgoing bubbles never carry the sensitive-word warning row
       // (mirrors native iOS `!model.isSend` gate); hardcode null so
       // the build path's `showTip` is always false.
       sensitiveTipText = null;

  final bool isMine;
  final String avatarLabel;
  final String avatarUrl;
  final String text;
  final ChatMediaKind kind;
  final ChatMediaAttachment? attachment;
  final bool readed;
  final int readedCount;
  final int unreadCount;

  /// 被回复次数. 对方/群消息气泡末尾显示 Material `Icons.reply` + 数字
  /// (>0 才显), 自己气泡不显. 数据流: server `message_extra.reply_count` →
  /// SDK 本地表 → `WKMsgExtra.replyCount` → `ChatMessage.replyCount` → 这里.
  /// 跟时间一起排在 metaRow 末尾 (文本气泡 overlay 在右下角, 非文本气泡放
  /// 气泡下方一行).
  final int replyCount;
  final bool streamingPlaceholder;
  final List<Color> colors;
  final String? status;
  final VoidCallback? onRetry;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  /// Tap handler for the visible peer avatar on group left bubbles.
  /// Null keeps the avatar as a passive visual slot.
  final VoidCallback? onAvatarTap;

  /// 双击触发的回调 — 调用方决定具体行为（例如快速 reaction）。
  /// 仅在需要响应 double-tap 的消息上传入 non-null. null 时 GestureDetector
  /// 不会消耗 double-tap, 不影响其他手势.
  final VoidCallback? onDoubleTap;

  final VoidCallback? onLongPress;

  /// Long-press handler that receives the global tap position so the
  /// context menu can anchor near the actual gesture (mirrors native iOS
  /// UIContextMenu behavior).
  final void Function(Offset globalPosition)? onLongPressAt;

  /// Sender display name above the bubble — set on the first message of a
  /// streak in group chats; empty in 1:1 chats or for follow-up messages.
  final String senderName;

  /// When false, the avatar slot is rendered invisible (occupies the same
  /// horizontal space) so consecutive bubbles from the same sender stay
  /// aligned. Mirrors the `visibility:hidden` placeholder in prototype phone 2.
  final bool showAvatar;

  /// When false, the avatar slot is omitted entirely (no horizontal space
  /// reserved) — used in 1:1 personal chats where peer bubbles never show
  /// an avatar, matching native iOS `isPersonChannel` behavior.
  final bool hasAvatarSlot;

  /// Reply-quote header drawn inside the bubble above the message text.
  /// Both fields are empty when the message has no reply target.
  final String replyToSender;
  final String replyToText;

  /// True when the source message of an inline reply has been revoked.
  /// `BubbleQuote` swaps its body to `原消息已撤回` instead of the
  /// stale cached preview. Mirrors native iOS `WKReply.revoke == 1`
  /// branch in `WKTextMessageCell`. Defaults to false on outgoing
  /// bubbles and on messages without a reply-quote.
  final bool replyToRevoked;

  /// Tapped on the inline reply quote — chat scrolls the original
  /// message into view + flashes it. Null when the original isn't
  /// known locally (e.g., paginated out, or local optimistic placeholder).
  final VoidCallback? onReplyTap;

  /// Stable identifier used by the voice bubble to bind to the global
  /// VoicePlayer state (so the play icon and waveform progress can rebuild
  /// when this exact message starts/stops playing).
  final String messageKey;

  /// True when the bubble's text body has been edited via `message/edit`.
  /// The bubble appends a small "(已编辑)" suffix in the footer.
  final bool edited;

  /// Aggregated reactions for the bubble — each entry has `emoji`, `count`,
  /// `mine`. Renders as a chip strip below the bubble body.
  final List<Map<String, Object>> reactions;

  /// Tap callback for an existing reaction chip — toggles the reaction.
  final void Function(String emoji)? onReactionTap;

  /// When > 0 the bubble shows a small 🔥+秒数 badge in the top-right
  /// corner indicating the message will self-destruct after that many
  /// seconds. Mirrors native iOS WKMessageCell.flameNode footprint.
  final int flameSecond;

  /// Absolute deadline in unix-ms when the message will self-destruct.
  /// Lets the badge tick down per second instead of showing the static
  /// channel TTL on every bubble forever (flame-flow.md §6.6 KNOWN).
  /// Zero means "fall back to static `flameSecond` display".
  final int flameExpiresAtMs;

  /// Forwarded to image bubbles so they can fetch their thumbnails
  /// through the authenticated ApiClient when the server requires the
  /// `token` header for `file/upload`-served URLs. Null means
  /// unauthenticated `Image.network` is the only path.
  final ChatMediaGateway? mediaGateway;

  /// Tap handler invoked when a `@mention` span in the bubble's text
  /// body is tapped. The arg is the @-name without the leading `@`.
  /// Null means mentions render as styled text without tap action.
  final void Function(String name)? onMentionTap;

  /// Known display names that the inline parser should treat as
  /// candidate `@mention` targets. Lets the parser capture multi-word
  /// names like `John Doe` and names with characters outside the
  /// default mention class (e.g. emoji, accented letters). Sourced
  /// from group members + friend display labels at the chat-screen
  /// level. Order doesn't matter — the parser sorts longest-first.
  final List<String> mentionCandidates;

  /// When non-null and non-empty, render an inline yellow warning row
  /// directly under the bubble's body with this text. Used for
  /// received text messages that match a server-synced sensitive
  /// word. Mirrors native iOS `WKTipLabel` under `WKTextMessageCell`
  /// when `model.hasSensitiveWord && !model.isSend`. Null on:
  ///   * outgoing messages (own text never gets the warning)
  ///   * non-text bubbles
  ///   * received text that doesn't match any cached word
  final String? sensitiveTipText;

  /// Render the trailing red unread dot on a received voice bubble
  /// when the user hasn't played it yet. Set by the chat-screen
  /// based on `ChatMessage.voiceStatus == 0` for left bubbles.
  /// Always false on right (own) bubbles. Mirrors native iOS
  /// `WKVoiceMessageCell` red-dot indicator (voice-playback.md
  /// §2.7 / §6.6).
  final bool voiceUnread;

  /// Optional action rendered outside a voice bubble. Modules use this for
  /// actions such as "转文字" without expanding the bubble tap target.
  final Widget? voiceSideAction;

  /// Optional per-message add-on rendered below the bubble row while keeping
  /// receipt/status indicators vertically centered on the bubble itself.
  final Widget? messageAddon;

  /// Horizontal quick-reply gesture, Telegram-style. The chat screen wires this
  /// to the same reply composer state as the long-press "回复" action.
  final VoidCallback? onSwipeReply;

  /// Bare `HH:mm` send-time label shown in the bubble's bottom meta-row
  /// (Telegram-style). Empty for optimistic local messages without a
  /// server timestamp, in which case the clock is hidden until the real
  /// time arrives. The centered date divider above the streak is kept
  /// separately (DateStamp) — this is the per-bubble fixed clock line.
  final String timeText;

  /// Tap handler for the trailing-side `SendReceiptIndicator`.
  /// Wired only for own group bubbles by the chat-screen call site
  /// (`Bubble.right`); always null on `Bubble.left`. When non-null,
  /// the indicator becomes a tap target that surfaces the readed-
  /// list sheet. Mirrors native iOS `WKReadedListVC` push trigger
  /// (read-receipt-flow.md §6 P1).
  final VoidCallback? onReceiptTap;

  /// Per-message 0-1 upload progress feed. Owned by `_HomeShellState`
  /// (notifier created in `_uploadAndSendMedia`, disposed when upload
  /// completes), wired only into `_FileBubbleContent` to mirror iOS
  /// WKFileCell's UIProgressView bottom overlay (WKFileCell.m:120-155).
  /// Null on left bubble and on outgoing non-file bubbles.
  final ValueListenable<double>? uploadProgress;

  @override
  Widget build(BuildContext context) {
    // Image / video bubbles use white bg + tight 4px frame so the preview
    // fills the bubble. Other kinds get the chat ink gradient (mine) or
    // white (peer) with the standard 14/10 text padding.
    final isImage =
        kind == ChatMediaKind.image ||
        kind == ChatMediaKind.video ||
        kind == ChatMediaKind.sticker ||
        kind == ChatMediaKind.livePhoto;
    // File bubbles render their own fixed 250×66 card; let it own the
    // width / height — no extra horizontal padding squeezing it.
    final isFile = kind == ChatMediaKind.file && attachment != null;
    // 纯文本气泡 (非语音/图片/视频/sticker/文件) — 只有它把 time+回执放进气泡内
    // (overlay 右下角)。语音及其余媒体类型 meta 一律走气泡下方一行。
    final isText = !isImage && !isFile && kind != ChatMediaKind.voice;
    final tip = sensitiveTipText;
    final showTip = tip != null && tip.isNotEmpty;

    // 底部 meta 行 (Telegram 风): 时间 (HH:mm) + 已读回执 (✓✓, 仅自己气泡).
    // 顶部居中日期分隔 (DateStamp) 保留不变, 这是每条气泡固定一行的时分.
    // - 文本/语音/其他带背景的气泡: meta 行放进气泡 Column 末尾 (在 14/10
    //   padding 内), 颜色按 isMine 走 bubbleSendForeground / textTertiary.
    // - 图片/视频/sticker/文件 (无气泡背景, DESIGN §11.2): meta 行放气泡下方
    //   单独一行, 避免叠在媒体上破坏 hiddenBubble 裸渲染.
    final hasReceipt = isMine && status == '已发送';
    final hasClock = timeText.isNotEmpty;
    // 被回复计数 ⬅️N — 仅对方/群消息气泡末尾显示 (replyCount>0 才显).
    // 自己气泡不显 (发了不需要看自己被回复几次). 跟 readedCount/⌚ 同走
    // metaRow 排版, 文本气泡 overlay 右下角, 非文本气泡走气泡下方一行.
    final hasReplyCount = !isMine && replyCount > 0;
    final showMeta = hasClock || hasReceipt || hasReplyCount;
    // 气泡内 (深色渐变/白底) 的弱化前景色.
    final insideClockColor = isMine
        ? MoyuInk.bubbleSendForegroundOf(context).withValues(alpha: 0.7)
        : MoyuColors.of(context).textTertiary;
    // 图片/文件下方 (无气泡背景, 在聊天页底色上) 的时间色 — 统一弱灰.
    final belowClockColor = MoyuColors.of(context).textTertiary;

    // 构造 meta 行: [时间] [回执]. clockColor 按渲染位置传入 (气泡内 vs
    // 气泡下方). 自己气泡内回执用 bubbleSendForeground 保证深底可见.
    Widget? buildMetaRow({required Color clockColor, required bool inside}) {
      if (!showMeta) return null;
      final children = <Widget>[];
      // 顺序: reply 数量 → 时间 → 已读回执 (TG 风, 数量在前)。
      if (hasReplyCount) {
        children.add(Icon(Icons.reply, size: 12, color: clockColor));
        children.add(const SizedBox(width: 2));
        children.add(
          Text(
            '$replyCount',
            style: TextStyle(
              fontSize: 10.5,
              height: 1.0,
              color: clockColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        );
      }
      if (hasClock) {
        if (children.isNotEmpty) children.add(const SizedBox(width: 4));
        children.add(
          Text(
            timeText,
            style: TextStyle(
              fontSize: 10.5,
              height: 1.0,
              color: clockColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        );
      }
      if (hasReceipt) {
        if (children.isNotEmpty) children.add(const SizedBox(width: 4));
        children.add(
          SendReceiptIndicator(
            readed: readed,
            readedCount: readedCount,
            unreadCount: unreadCount,
            onTap: onReceiptTap,
            // 气泡内用 bubbleSendForeground 反相色 (深底白勾 / 浅底黑勾);
            // 气泡下方在页面底色上保持默认 blue/gray 方案.
            foreground: inside ? MoyuInk.bubbleSendForegroundOf(context) : null,
          ),
        );
      }
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: children,
      );
    }

    final insideMetaRow = buildMetaRow(
      clockColor: insideClockColor,
      inside: true,
    );
    final belowMetaRow = buildMetaRow(
      clockColor: belowClockColor,
      inside: false,
    );

    // 非文本气泡 (图片/视频/贴纸/语音/文件) 的 time+回执 overlay — 半透明黑
    // 胶囊 + 白字, 浮在气泡/媒体右下角。对齐 iOS WKImageMessageCell
    // bringSubviewToFront(trailingView) + Telegram。替代原「气泡下方一行」,
    // 修非文本时间「抽象」。图片/视频/贴纸叠在媒体上, 语音/文件叠在气泡内右下。
    final mediaMetaOverlay = (!isText && showMeta)
        ? DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.38),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: buildMetaRow(clockColor: Colors.white, inside: true),
            ),
          )
        : null;
    // 文本气泡 maxWidth 对齐 iOS WKAppConfig.m:62:
    //   原版是 screenW - 120；当前实现提升到约 80%，按常见手机宽度取 screenW - 80.
    // 大屏自动撑开 (iPhone 17 Pro Max 350, iPad 680+), 小屏退到 ~295.
    // 图片/文件保持固定缩略图框尺寸 (200/250), 但用 min 防小屏溢出.
    final screenW = MediaQuery.sizeOf(context).width;
    final dynamicMax = screenW - 80;
    final bubbleBox = ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: isImage
            ? (dynamicMax < 200 ? dynamicMax : 200)
            : isFile
            ? (dynamicMax < 250 ? dynamicMax : 250)
            : dynamicMax,
      ),
      child: Container(
        margin: EdgeInsets.only(left: isMine ? 0 : 8),
        // 图片/视频/sticker: 对齐 iOS WKImageMessageCell `+hiddenBubble = YES`,
        // 没有气泡背景框, 图片裸渲染 — zero padding, 不上 color/gradient/shadow.
        // 文件: 自渲染卡片, zero padding. 文本/语音/其他: 14/10 padding 不变.
        padding: isImage || isFile
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isImage
              ? null
              : (isMine ? null : MoyuColors.of(context).bubbleReceiveBg),
          gradient: (isMine && !isImage)
              ? MoyuInk.bubbleSendGradientOf(context)
              : null,
          borderRadius: _bubbleBorderRadius(context, isMine: isMine),
          // 不上 shadow — iOS WKMessageContentView 气泡不带阴影, 靠 bg +
          // radius 区分.
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // 非纯文本气泡: 引用 quote 在外层 Column 渲染 (跟原来一样)。
            // 纯文本气泡: 引用 quote 由下面 Builder 内的 Stack 接管 (使 Stack
            // 宽度 = max(quote, text), 时间 overlay 贴气泡右缘而非文本末尾)。
            if (!isText &&
                (replyToText.isNotEmpty ||
                    replyToSender.isNotEmpty ||
                    replyToRevoked)) ...[
              BubbleQuote(
                sender: replyToSender,
                text: replyToText,
                revoked: replyToRevoked,
                isMine: isMine,
                // Revoked sources have nothing to scroll to; suppress
                // the tap so the user doesn't get a no-op flash. Also
                // mirrors native iOS, where `WKReply.revoke == 1`
                // disables the cell-tap-to-scroll handler.
                onTap: replyToRevoked ? null : onReplyTap,
              ),
              const SizedBox(height: 6),
            ],
            if (kind == ChatMediaKind.voice)
              VoiceBubbleContent(
                attachment: attachment,
                isMine: isMine,
                messageKey: messageKey,
                unread: voiceUnread,
              )
            else if (kind == ChatMediaKind.image)
              ImageBubbleContent(
                text: text,
                attachment: attachment,
                captionColor: isMine
                    ? MoyuInk.bubbleSendForegroundOf(context)
                    : MoyuColors.of(context).textPrimary,
                mediaGateway: mediaGateway,
                uploadProgress: uploadProgress,
              )
            else if (kind == ChatMediaKind.video)
              renderModuleMessageBubble(
                    context,
                    kind: kind,
                    attachment: attachment,
                    fileName: text,
                    isMine: isMine,
                    uploadProgress: uploadProgress,
                  ) ??
                  const UnsupportedModuleBubble()
            else if (kind == ChatMediaKind.livePhoto)
              renderModuleMessageBubble(
                    context,
                    kind: kind,
                    attachment: attachment,
                    fileName: text,
                    isMine: isMine,
                    uploadProgress: uploadProgress,
                  ) ??
                  const UnsupportedModuleBubble()
            else if (kind == ChatMediaKind.sticker)
              renderModuleMessageBubble(
                    context,
                    kind: kind,
                    attachment: attachment,
                    fileName: text,
                    isMine: isMine,
                    uploadProgress: uploadProgress,
                  ) ??
                  const UnsupportedModuleBubble()
            else if (kind == ChatMediaKind.file && attachment != null)
              // `ChatMessage.left/right` defaults `kind` to
              // `ChatMediaKind.file` with `attachment == null` for
              // plain text bubbles. Gate on a real attachment so text
              // bubbles don't accidentally render as file cards. The
              // `!` is safe because of the null-check above; field
              // promotion doesn't carry into widget builders.
              renderModuleMessageBubble(
                    context,
                    kind: kind,
                    attachment: attachment,
                    fileName: attachment!.fileName.isEmpty
                        ? text
                        : attachment!.fileName,
                    isMine: isMine,
                    uploadProgress: uploadProgress,
                  ) ??
                  const UnsupportedModuleBubble()
            else if (streamingPlaceholder && text.trim().isEmpty)
              _StreamingBubblePlaceholder(isMine: isMine)
            else
              // 纯文本气泡: time+回执 overlay 在右下角; 文本末尾插一段等宽透明
              // 占位 (WidgetSpan) 让最后一行预留出 meta 的宽度 (TG 风) —— meta
              // 不单独成行, 气泡宽度按"文本 + 末行尾部 meta"自然排版, 短文本也
              // 只是末行容纳时间, 不会被撑成单独一整行。乐观消息 (timeText 空 →
              // insideMetaRow null) 退回纯文本不 overlay。
              Builder(
                builder: (context) {
                  final body = Text.rich(
                    TextSpan(
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: isMine
                            ? MoyuInk.bubbleSendForegroundOf(context)
                            : MoyuColors.of(context).textPrimary,
                      ),
                      children: [
                        ...parseMarkdownInline(
                          text,
                          isMine: isMine,
                          mentionTap: onMentionTap,
                          mentionCandidates: mentionCandidates,
                        ),
                        if (edited)
                          TextSpan(
                            text: AppLocalizations.of(context).chatEditedSuffix,
                            style: TextStyle(
                              fontSize: 11,
                              color:
                                  (isMine
                                          ? MoyuInk.bubbleSendForegroundOf(
                                              context,
                                            )
                                          : MoyuColors.of(context).textTertiary)
                                      .withValues(alpha: 0.7),
                            ),
                          ),
                        if (insideMetaRow != null)
                          WidgetSpan(
                            alignment: PlaceholderAlignment.bottom,
                            child: SizedBox(
                              // 文本末行 overlay 占位宽度:
                              //   时间 ≈ 34, +回执 +24, +reply icon+N ≈ 22.
                              //   多个组合时叠加, 让最后一行预留出足够宽度
                              //   避免 meta overlay 盖到文字. 没 meta 子项时为 0
                              //   (上面 insideMetaRow 已 null check).
                              width:
                                  (hasClock ? 34 : 0) +
                                  (hasReceipt ? 24 : 0) +
                                  (hasReplyCount ? 22 : 0),
                              height: 1,
                            ),
                          ),
                      ],
                    ),
                  );
                  // quote + body 包进 inner Column → Stack 宽度 = max(quote, text),
                  // Positioned(right:0) 贴气泡右缘而非文本末尾。bug 复现路径:
                  // 之前 quote 在外层 Column, Stack 只包 body, quote 比 text 宽
                  // 时 Stack 宽 = text 宽, 时间 overlay 贴 text 右缘 (气泡内中间)
                  // 而非气泡右缘。
                  final hasReplyQuote =
                      replyToText.isNotEmpty ||
                      replyToSender.isNotEmpty ||
                      replyToRevoked;
                  final content = hasReplyQuote
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BubbleQuote(
                              sender: replyToSender,
                              text: replyToText,
                              revoked: replyToRevoked,
                              isMine: isMine,
                              onTap: replyToRevoked ? null : onReplyTap,
                            ),
                            const SizedBox(height: 6),
                            body,
                          ],
                        )
                      : body;
                  if (insideMetaRow == null) return content;
                  return Stack(
                    children: [
                      content,
                      Positioned(right: 0, bottom: 0, child: insideMetaRow),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
    final tapTargetKey = messageKey.isEmpty
        ? null
        : ValueKey('moyu.bubble.tapTarget.$messageKey');
    final interactiveBubbleBox = Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      widthFactor: 1,
      heightFactor: 1,
      child: _BubbleSwipeReplySurface(
        key: tapTargetKey,
        isMine: isMine,
        onReply: onSwipeReply,
        child: GestureDetector(
          behavior: HitTestBehavior.deferToChild,
          onTap: onTap,
          // double-tap hit-test 只包气泡内容，避免同一水平行空白也触发
          // 图片预览 / 快速 reaction 等动作。
          onDoubleTap: onDoubleTap,
          onLongPress: onLongPressAt == null ? onLongPress : null,
          onLongPressStart: onLongPressAt == null
              ? null
              : (d) => onLongPressAt!(d.globalPosition),
          // isImage: time+回执 overlay 浮在媒体右下角 (mediaMetaOverlay);
          // 其余类型 bubbleBox 原样 (时间走气泡内 / 下方)。
          child: mediaMetaOverlay == null
              ? bubbleBox
              : Stack(
                  children: [
                    bubbleBox,
                    Positioned(right: 8, bottom: 8, child: mediaMetaOverlay),
                  ],
                ),
        ),
      ),
    );
    final sideAction = kind == ChatMediaKind.voice ? voiceSideAction : null;
    final interactiveCore = sideAction == null
        ? interactiveBubbleBox
        : Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: isMine
                ? [sideAction, const SizedBox(width: 6), interactiveBubbleBox]
                : [interactiveBubbleBox, const SizedBox(width: 6), sideAction],
          );
    final reactionStripKey = messageKey.isEmpty
        ? null
        : ValueKey('moyu.bubble.reactions.$messageKey');
    final reactionStrip = reactions.isEmpty
        ? null
        : Padding(
            padding: EdgeInsets.only(top: 4, left: isMine ? 0 : 8),
            child: ReactionStrip(
              key: reactionStripKey,
              reactions: reactions,
              isMine: isMine,
              onTap: onReactionTap,
            ),
          );
    final sensitiveTip = !showTip
        ? null
        : Padding(
            padding: EdgeInsets.only(
              top: 4,
              left: isMine ? 0 : 8,
              right: isMine ? 0 : 0,
            ),
            child: SensitiveWordTipRow(text: tip),
          );
    final addon = messageAddon == null
        ? null
        : Padding(
            padding: EdgeInsets.only(top: 5, left: isMine ? 0 : 8),
            child: messageAddon!,
          );

    // 非纯文本气泡 (语音/图片/视频/sticker/文件): meta 行 (时间 + 回执) 走气泡
    // 下方单独一行。右对齐到"气泡右缘"由下面的内层 Column(crossAxis: end) 实现
    // (气泡比 meta 宽 → Column 宽=气泡宽 → meta 贴气泡右缘)。不能用 Align
    // centerRight, 否则会撑到屏幕最右 — 对方气泡靠左时时间就飘出气泡了。纯文本
    // 的 meta 已 overlay 在气泡内右下角, 这里不重复。
    // 所有非文本 (图片/视频/贴纸/语音/文件) 的 meta 改走右下 overlay
    // (mediaMetaOverlay), 不再走 sideMeta / belowMeta「下方一行」。
    const sideMeta = null;
    final belowMeta =
        (mediaMetaOverlay != null || isText || belowMetaRow == null)
        ? null
        : Padding(padding: const EdgeInsets.only(top: 3), child: belowMetaRow);

    // 气泡本体 (含 reaction / addon / tip, 但**不含** belowMeta) — 头像底部
    // 对齐它。belowMeta (图片/语音/视频/贴纸等下方的时间行) 走
    // MoyuPeerBubbleFrame 的 footer, 渲染在气泡下方, 不把头像往下拉。
    // reaction 移出 bubbleContent → 走 footer (跟 belowMeta 一起渲染在气泡下方),
    // 否则头像底部对齐含 reaction 的 Column, reaction 一出现头像被拉到 reaction
    // 下方 (对齐乱 bug)。bubbleContent 只含 addon/tip, 头像对齐气泡本体。
    final bubbleContent = showTip || addon != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [interactiveCore, ?addon, ?sensitiveTip],
          )
        : interactiveCore;

    // 发送中 / 发送失败 是瞬时发送状态, 仍渲染在气泡左侧 (spinner / 红叹号
    // 可点重试). 已读回执 (✓✓) 已挪进气泡末尾 meta 行 (TG 风), 不再走
    // leadingStatus.
    Widget? leadingStatus;
    if (isMine) {
      if (status == '发送失败') {
        leadingStatus = SendFailIconButton(
          onTap: () => showSendFailActionSheet(
            context,
            onRetry: onRetry,
            onDelete: onDelete,
          ),
        );
      } else if (status == '发送中') {
        leadingStatus = const SendingSpinner();
      }
    }

    final outgoingCoreRow = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leadingStatus != null) ...[leadingStatus, const SizedBox(width: 6)],
        if (sideMeta != null) ...[sideMeta, const SizedBox(width: 6)],
        interactiveCore,
      ],
    );
    // 气泡行 + 下方 meta 包一层 Column(end): belowMeta 右对齐到气泡右缘 (而非
    // 整列右缘, 防 reactionStrip 更宽时跑偏)。
    final outgoingCoreWithMeta = belowMeta == null
        ? outgoingCoreRow
        : Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [outgoingCoreRow, belowMeta],
          );
    final outgoingBubble = Flexible(
      child:
          showTip ||
              reactionStrip != null ||
              leadingStatus != null ||
              addon != null ||
              belowMeta != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                outgoingCoreWithMeta,
                ?addon,
                ?reactionStrip,
                ?sensitiveTip,
              ],
            )
          : interactiveCore,
    );

    // 群聊对方消息: 头像 + 名字 + 气泡的左侧布局收口到 MoyuPeerBubbleFrame
    // (头像底部对齐气泡 + 名字 12pt + invisible 占位), 对齐 iOS WKMessageCell
    // avatar.lim_top = bubble.lim_bottom - avatar.height + Telegram。
    // 自己消息保持右对齐, 无头像槽。
    final row = isMine
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [outgoingBubble],
          )
        : MoyuPeerBubbleFrame(
            bubble: bubbleContent,
            // belowMeta (时间下方行) + reaction 都走 footer, 渲染在气泡下方,
            // 不参与头像底部对齐。
            footer: (belowMeta == null && reactionStrip == null)
                ? null
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [?belowMeta, ?reactionStrip],
                  ),
            hasAvatarSlot: hasAvatarSlot,
            showAvatar: showAvatar,
            avatarUrl: avatarUrl,
            avatarLabel: avatarLabel,
            avatarColors: colors,
            senderName: senderName,
            onAvatarTap: onAvatarTap,
          );

    final hasFlame = flameSecond > 0;
    final rowWithFlame = hasFlame
        ? Stack(
            children: [
              row,
              Positioned(
                top: -2,
                right: isMine ? 0 : null,
                left: isMine ? null : 0,
                child: FlameBadge(
                  seconds: flameSecond,
                  expiresAtMs: flameExpiresAtMs,
                ),
              ),
            ],
          )
        : row;
    // Reactions are now rendered INSIDE the bubble (above), so no
    // separate reaction strip needs to be appended below the row.
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: rowWithFlame,
    );
  }
}

class _StreamingBubblePlaceholder extends StatelessWidget {
  const _StreamingBubblePlaceholder({required this.isMine});

  final bool isMine;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 20,
      child: Center(
        child: Opacity(opacity: isMine ? 0.9 : 1, child: const TypingDots()),
      ),
    );
  }
}

class _BubbleSwipeReplySurface extends StatefulWidget {
  const _BubbleSwipeReplySurface({
    super.key,
    required this.child,
    required this.isMine,
    required this.onReply,
  });

  final Widget child;
  final bool isMine;
  final VoidCallback? onReply;

  @override
  State<_BubbleSwipeReplySurface> createState() =>
      _BubbleSwipeReplySurfaceState();
}

class _BubbleSwipeReplySurfaceState extends State<_BubbleSwipeReplySurface> {
  static const double _triggerDistance = 92;
  static const double _maxBubbleOffset = 38;

  double _dragDx = 0;
  bool _armed = false;
  bool _hapticSent = false;

  bool get _enabled => widget.onReply != null;

  void _reset() {
    if (_dragDx == 0 && !_armed && !_hapticSent) return;
    setState(() {
      _dragDx = 0;
      _armed = false;
      _hapticSent = false;
    });
  }

  void _handleDragStart(DragStartDetails details) {
    if (!_enabled) return;
    setState(() {
      _dragDx = 0;
      _armed = false;
      _hapticSent = false;
    });
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_enabled) return;
    final next = (_dragDx + details.delta.dx).clamp(
      -_triggerDistance * 1.35,
      _triggerDistance * 1.35,
    );
    final armed = next.abs() >= _triggerDistance;
    if (armed && !_hapticSent) {
      HapticFeedback.selectionClick();
      _hapticSent = true;
    }
    setState(() {
      _dragDx = next.toDouble();
      _armed = armed;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_enabled) return;
    final shouldReply = _armed || (details.primaryVelocity ?? 0).abs() >= 720;
    final reply = widget.onReply;
    _reset();
    if (shouldReply && reply != null) {
      reply();
    }
  }

  void _handleDragCancel() {
    if (!_enabled) return;
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    if (!_enabled) return widget.child;

    final colors = MoyuColors.of(context);
    final progress = (_dragDx.abs() / _triggerDistance).clamp(0.0, 1.0);
    final direction = _dragDx == 0
        ? (widget.isMine ? -1.0 : 1.0)
        : _dragDx.sign;
    final bubbleOffset =
        direction * _maxBubbleOffset * Curves.easeOut.transform(progress);
    final iconSide = direction < 0
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final iconScale = 0.72 + 0.28 * progress;

    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onHorizontalDragStart: _handleDragStart,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      onHorizontalDragCancel: _handleDragCancel,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Align(
              alignment: iconSide,
              child: Opacity(
                opacity: progress,
                child: Transform.scale(
                  scale: iconScale,
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: colors.background,
                      shape: BoxShape.circle,
                      border: Border.all(color: colors.line, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      FIcons.reply,
                      size: 18,
                      color: _armed ? colors.primary : colors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(bubbleOffset, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// 算聊天气泡 4 角圆角 — 读 BubbleRadiusController.of(context).current
/// 拿主圆角值 (用户在外观 → 信息框圆角 Slider 设的, 默认 18, 范围 4-24),
/// tail 一侧 (isMine bottomRight / !isMine bottomLeft) 用 tailRadiusFor
/// 算副圆角 (主-12 但 >=4). 所有气泡 widget build 用这个 helper 而不是
/// 直接 hardcode 18/6 让用户调 Slider 时全局气泡同步 rebuild.
BorderRadius _bubbleBorderRadius(BuildContext context, {required bool isMine}) {
  final r = BubbleRadiusController.of(context).current;
  final tail = BubbleRadiusStore.tailRadiusFor(r);
  return BorderRadius.only(
    topLeft: Radius.circular(r),
    topRight: Radius.circular(r),
    bottomLeft: Radius.circular(isMine ? r : tail),
    bottomRight: Radius.circular(isMine ? tail : r),
  );
}
