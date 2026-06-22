import 'package:flutter/widgets.dart';

import 'moyu_theme.dart';

/// 0.5px hairline used between rows inside flat settings groups.
/// The indent matches grouped-list cells so the divider starts after
/// the label gutter rather than spanning the full white panel.
class RowDivider extends StatelessWidget {
  const RowDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: const EdgeInsetsDirectional.only(start: 16),
      color: MoyuColors.of(context).line,
    );
  }
}

/// Edge-to-edge white panel with no card chrome. Used by settings-style
/// sub-pages so rows sit directly on the page background, separated only
/// by [RowDivider] and [settingsBlockGap].
Widget settingsFlatGroup(
  BuildContext context, {
  required List<Widget> rows,
  EdgeInsets padding = EdgeInsets.zero,
}) {
  return Container(
    width: double.infinity,
    color: MoyuColors.of(context).background,
    padding: padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    ),
  );
}

Widget settingsBlockGap(BuildContext context) =>
    Container(height: 12, color: MoyuColors.of(context).backgroundSoft);
