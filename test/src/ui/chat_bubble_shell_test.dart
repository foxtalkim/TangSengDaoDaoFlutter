import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forui/forui.dart';

import 'package:foxtalk/src/l10n/app_localizations.dart';
import 'package:foxtalk/src/settings/bubble_color_controller.dart';
import 'package:foxtalk/src/settings/bubble_color_store.dart';
import 'package:foxtalk/src/settings/bubble_radius_controller.dart';
import 'package:foxtalk/src/settings/bubble_radius_store.dart';
import 'package:foxtalk/src/ui/chat_bubble_shell.dart';
import 'package:foxtalk/src/ui/moyu_theme.dart';

void main() {
  testWidgets('left bubble avatar tap opens peer profile without bubble tap', (
    tester,
  ) async {
    var avatarTaps = 0;
    var bubbleTaps = 0;
    await tester.pumpWidget(
      _BubbleTestApp(
        child: SizedBox(
          width: 390,
          child: Bubble.left(
            messageKey: 'avatar-profile',
            avatarLabel: 'A',
            colors: const [Colors.blue, Colors.green],
            text: '点头像进资料',
            onTap: () => bubbleTaps += 1,
            onAvatarTap: () => avatarTaps += 1,
          ),
        ),
      ),
    );

    await tester.tap(
      find.byKey(const ValueKey('moyu.peerBubble.avatarTapTarget')),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 120));

    expect(avatarTaps, 1);
    expect(bubbleTaps, 0);
  });
}

class _BubbleTestApp extends StatelessWidget {
  const _BubbleTestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = MoyuTheme.forui();
    return MaterialApp(
      locale: const Locale('zh'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        ...AppLocalizations.localizationsDelegates,
        ...FLocalizations.localizationsDelegates,
      ],
      theme: theme.toApproximateMaterialTheme(),
      builder: (_, child) => FTheme(
        data: theme,
        child: BubbleRadiusController(
          current: BubbleRadiusStore.defaultRadius,
          change: (_) async {},
          child: BubbleColorController(
            current: BubbleColorStore.defaultPreference,
            change: (_) async {},
            child: child!,
          ),
        ),
      ),
      home: Scaffold(body: Center(child: child)),
    );
  }
}
