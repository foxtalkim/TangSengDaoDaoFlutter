import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../chat/chat_tool_action.dart';
import '../l10n/app_localizations.dart';
import 'moyu_theme.dart';

class ChatToolTile extends StatelessWidget {
  const ChatToolTile({super.key, required this.action, required this.onTap});

  final ChatToolAction action;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final title = chatToolActionTitle(AppLocalizations.of(context), action);
    // 微信"+"面板 tile 视觉: 60×60 浅灰底卡片 (无 shadow) + 30pt icon +
    // 13pt label, 间距由 panel 控制.
    return FTappable(
      onPress: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              // 比外层 panel 的 backgroundSoft 略深一点的灰让 tile 色块
              // 边界从 panel 背景凸显.
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF2A2A2F)
                  : const Color(0xFFEAEAEC),
              borderRadius: BorderRadius.circular(18),
            ),
            // 单色 icon — 不用 action.color 彩色, 对齐微信 + 面板 line icon 视觉.
            child: Icon(
              action.icon,
              color: MoyuColors.of(context).textPrimary,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: MoyuColors.of(context).textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
