// 聊天页底部 bot 命令面板 (Telegram bot command 同款). composer [/] 按钮点开,
// 列出该 bot 的命令, 点某条 → 发送 "/cmd" 文本。
//
// 跟 emoji / more / voice 面板同层 (chat_screen AnimatedSwitcher 一个分支),
// 高度跟它们对齐 (~260)。命令 type 固定 none, 点了就是发命令文本。
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../l10n/app_localizations.dart';
import '../social/social_service.dart' show BotCommand;
import 'moyu_theme.dart';

/// 输入框内左侧的小灰「/」命令入口 (FTextField prefixBuilder 用). 对方是 bot
/// 时显示, 点击弹命令面板。视觉: 灰色 18px slash, 紧凑, 不抢输入框主视觉。
class CommandPrefixButton extends StatelessWidget {
  const CommandPrefixButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // TG 风格: "/" 字符外包浅灰圆角方框 (视觉上的 [/]), 比裸字符更有按钮感.
    final colors = MoyuColors.of(context);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Container(
          width: 26,
          height: 26,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.backgroundSoft,
            border: Border.all(color: colors.textTertiary, width: 1.5),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '/',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              height: 1.0,
              color: colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class BotCommandPanel extends StatelessWidget {
  const BotCommandPanel({
    super.key,
    required this.commands,
    required this.loaded,
    required this.onSelect,
  });

  final List<BotCommand> commands;
  final bool loaded;

  /// 点某条命令 → 回传完整 "/cmd" 文本给上层发送.
  final void Function(String cmd) onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    final t = AppLocalizations.of(context);
    return Container(
      width: double.infinity,
      height: 260,
      color: colors.backgroundSoft,
      child: !loaded
          ? const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          : commands.isEmpty
          ? Center(
              child: Text(
                t.botCommandsEmpty,
                style: TextStyle(fontSize: 14, color: colors.textTertiary),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: commands.length,
              separatorBuilder: (_, __) => Divider(
                height: 0.5,
                thickness: 0.5,
                indent: 16,
                color: colors.line,
              ),
              itemBuilder: (context, i) {
                final c = commands[i];
                return FTappable(
                  onPress: () => onSelect(c.cmd),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Text(
                          c.cmd,
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w600,
                            color: colors.primary,
                          ),
                        ),
                        if (c.remark.isNotEmpty) ...[
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              c.remark,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                color: colors.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
