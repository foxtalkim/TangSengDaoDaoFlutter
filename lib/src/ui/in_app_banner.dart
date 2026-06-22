// In-app banner — app 前台收 IM 消息时顶部下拉的小卡 (类似微信). 跟
// MoyuToast 同一套 OverlayEntry pattern: 全局 _current 单实例, 新 banner
// 来 → remove 旧 → insert 新 (replace-latest), 不堆叠. 自动 3s 消失,
// 上滑可手动 dismiss, tap 跳 chat (上层走 PushRouter).
//
// 跟 LocalNotificationCenter 互斥的边界 (home_shell `_applyRemoteMessage`):
//   - lifecycle == resumed (app 前台) → 这个 banner
//   - lifecycle != resumed (后台/锁屏 process 活) → LocalNotificationCenter
//   - app 杀进程 → server APNS / FCM 推 (跟 client 无关)
//
// iOS 原版没有这个 banner (前台是 chat list 红点提示), chatim 加这条对齐
// 微信 / WhatsApp UX. 不算违反原版对齐 SOP — 跟 dark mode / iOS 桌面 badge
// 同性质, 项目级 enhancement.

import 'dart:async';

import 'package:flutter/material.dart';

import 'moyu_theme.dart';
import 'moyu_widgets.dart' show MoyuResolvedAvatar;

class InAppBanner {
  const InAppBanner._();

  static OverlayEntry? _current;
  static _BannerControl? _currentControl;
  static Timer? _dismissTimer;

  /// 弹一条 banner. 同时只能有一条 (新的替换旧的). 不传 [onTap] 时点击
  /// 不做事但 banner 还是会 dismiss.
  static void show(
    BuildContext context, {
    required String title,
    required String body,
    String? avatarUrl,
    String? avatarLabel,
    VoidCallback? onTap,
    Duration duration = const Duration(seconds: 3),
  }) {
    // Replace-latest: 旧 banner 立即消失, 让新的 fresh 滑下来. 不用过渡
    // 动画 (微信也是直接替换, 不做 cross-fade).
    _dismiss(immediate: true);

    final overlay = Overlay.maybeOf(context);
    if (overlay == null) return;

    late OverlayEntry entry;
    final control = _BannerControl();

    entry = OverlayEntry(
      builder: (_) => _InAppBannerWidget(
        control: control,
        title: title,
        body: body,
        avatarUrl: avatarUrl,
        avatarLabel: avatarLabel,
        onTap: () {
          onTap?.call();
          _dismiss(immediate: false);
        },
        onSwipeUp: () => _dismiss(immediate: false),
      ),
    );

    overlay.insert(entry);
    _current = entry;
    _currentControl = control;
    _dismissTimer = Timer(duration, () => _dismiss(immediate: false));
  }

  static void _dismiss({required bool immediate}) {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    final entry = _current;
    final control = _currentControl;
    _current = null;
    _currentControl = null;
    if (entry == null) return;
    if (immediate || control == null) {
      entry.remove();
      return;
    }
    // Play 反向动画再 remove (用户体感更顺). control.dismiss 让 widget
    // 内的 AnimationController reverse, 完成时 entry.remove.
    control.dismiss(onComplete: () => entry.remove());
  }
}

/// 桥接 InAppBanner 静态层跟 widget 内部 AnimationController — banner 需要
/// 外部控制 (3s timer / 上滑 / tap) 触发反向动画.
class _BannerControl {
  void Function({required VoidCallback onComplete})? _dismissHandler;

  void attach(void Function({required VoidCallback onComplete}) handler) {
    _dismissHandler = handler;
  }

  void dismiss({required VoidCallback onComplete}) {
    final handler = _dismissHandler;
    if (handler != null) {
      handler(onComplete: onComplete);
    } else {
      onComplete();
    }
  }
}

class _InAppBannerWidget extends StatefulWidget {
  const _InAppBannerWidget({
    required this.control,
    required this.title,
    required this.body,
    required this.avatarUrl,
    required this.avatarLabel,
    required this.onTap,
    required this.onSwipeUp,
  });

  final _BannerControl control;
  final String title;
  final String body;
  final String? avatarUrl;
  final String? avatarLabel;
  final VoidCallback onTap;
  final VoidCallback onSwipeUp;

  @override
  State<_InAppBannerWidget> createState() => _InAppBannerWidgetState();
}

class _InAppBannerWidgetState extends State<_InAppBannerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  // 累计上滑距离 — > 16pt 触发 dismiss (类似 iOS 系统横幅手感, 不需要
  // 完整滑出 viewport).
  double _dragDy = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    widget.control.attach(_dismiss);
    _controller.forward();
  }

  void _dismiss({required VoidCallback onComplete}) {
    if (!mounted) {
      onComplete();
      return;
    }
    _controller.reverse().then((_) {
      onComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = MoyuColors.of(context);
    return SafeArea(
      bottom: false,
      child: Align(
        alignment: Alignment.topCenter,
        child: SlideTransition(
          position: _offset,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 6, 10, 0),
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTap,
                onVerticalDragStart: (_) => _dragDy = 0,
                onVerticalDragUpdate: (d) {
                  _dragDy += d.delta.dy;
                  if (_dragDy < -16) {
                    _dragDy = 0;
                    widget.onSwipeUp();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  decoration: BoxDecoration(
                    color: colors.background,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.line, width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MoyuResolvedAvatar.raw(
                        size: 40,
                        label: widget.avatarLabel ?? widget.title,
                        imageUrl: widget.avatarUrl,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: colors.textPrimary,
                                letterSpacing: -0.08,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.body,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.5,
                                color: colors.textSecondary,
                                height: 1.25,
                                letterSpacing: -0.08,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
