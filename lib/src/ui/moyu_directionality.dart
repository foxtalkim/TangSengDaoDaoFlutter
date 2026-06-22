import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

bool moyuIsRtl(BuildContext context) =>
    Directionality.of(context) == TextDirection.rtl;

IconData moyuBackChevronIcon(BuildContext context) =>
    moyuIsRtl(context) ? FIcons.chevronRight : FIcons.chevronLeft;

IconData moyuForwardChevronIcon(BuildContext context) =>
    moyuIsRtl(context) ? FIcons.chevronLeft : FIcons.chevronRight;
