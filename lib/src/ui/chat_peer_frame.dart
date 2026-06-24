import 'package:flutter/material.dart';

import 'moyu_theme.dart';
import 'moyu_widgets.dart';

/// 群聊「对方消息」统一布局框架。
/// 收口头像槽 + 发送者名 + 气泡的左侧布局，让所有对方消息类型（文本 / 图片 /
/// 语音 / 视频 / 通话 / 名片 / 位置 / 合并转发 / 未知消息）共用同一套规则，
/// 消除原先散落在 `Bubble.left` / `CallBubble` / 名片外包 三处的拷贝，并把
/// 「本来没有头像槽」的位置 / 合并转发 / 未知消息一并纳入统一占位。
/// 规则（对齐 iOS `WKMessageCell.m` + Telegram）：
///   - 头像 32×32，streak 末条显示（`showAvatar = true`），中间 invisible
///     占位（`maintainSize`）保持气泡左缘对齐；1v1 不留槽
///     （`hasAvatarSlot = false`）。
///   - 头像与气泡 **底部对齐**（`CrossAxisAlignment.end`）——
///     对齐 iOS `avatar.lim_top = bubble.lim_bottom - avatar.height`，
///     不再用 `top: 22` 顶部对齐。
///   - 发送者名：streak 首条显示，12pt `textTertiary`，气泡上方、跟气泡
///     视觉左缘对齐（左 8pt = bubble margin）。
class MoyuPeerBubbleFrame extends StatelessWidget {
  const MoyuPeerBubbleFrame({
    super.key,
    required this.bubble,
    this.hasAvatarSlot = true,
    this.showAvatar = true,
    this.avatarUrl = '',
    this.avatarLabel = '',
    this.avatarColors = const [],
    this.senderName = '',
    this.footer,
  });

  /// 气泡本体（不含头像 / 名字）。必须是**非 Flexible** widget —— 本框架
  /// 内部用 `Flexible` 约束它的宽度。
  final Widget bubble;

  /// 是否保留头像槽位。1v1 个人会话传 false（对齐 iOS `isPersonChannel`
  /// 不占头像位）；群聊传 true。
  final bool hasAvatarSlot;

  /// 是否真画头像。配 `hasAvatarSlot = true` 使用：streak 末条 true 显头像，
  /// 中间 false 时槽位 invisible 但仍占位，保证连续气泡左缘对齐。
  final bool showAvatar;

  final String avatarUrl;
  final String avatarLabel;
  final List<Color> avatarColors;

  /// streak 首条的发送者名；空串表示不显示（1v1 或 streak 后续消息）。
  final String senderName;

  /// 气泡下方的 meta 行（时间 / 回执）—— 仅图片 / 语音 / 视频 / 贴纸等「无气泡
  /// 背景」的消息有（文本气泡的时间在气泡内，传 null）。
  ///
  /// **关键：footer 不参与头像底部对齐。** 头像只跟气泡本体底部对齐
  /// （`crossAxisAlignment.end`），footer 渲染在气泡本体下方、缩进对齐气泡
  /// 左缘。否则头像会被下方时间行拉低，跟气泡对不齐（图片/贴纸的 bug）。
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final body = senderName.isEmpty
        ? bubble
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Text(
                  senderName,
                  style: TextStyle(
                    fontSize: 12,
                    color: MoyuColors.of(context).textTertiary,
                  ),
                ),
              ),
              bubble,
            ],
          );

    // 头像只跟气泡本体底部对齐 —— footer 不进这个 Row。
    final row = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (hasAvatarSlot) ...[
          Visibility(
            visible: showAvatar,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: MoyuResolvedAvatar.raw(
              label: avatarLabel,
              size: 38,
              colors: avatarColors,
              online: false,
              imageUrl: avatarUrl.isEmpty ? null : avatarUrl,
            ),
          ),
          const SizedBox(width: 8),
        ],
        Flexible(child: body),
      ],
    );

    if (footer == null) return row;
    // footer（气泡下方时间行）渲染在气泡本体下方，缩进 40（= 头像 32 + gap 8）
    // 对齐气泡左缘；不参与上方 Row 的头像底部对齐。
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        row,
        Padding(
          padding: EdgeInsets.only(left: hasAvatarSlot ? 46.0 : 0.0),
          child: footer,
        ),
      ],
    );
  }
}
