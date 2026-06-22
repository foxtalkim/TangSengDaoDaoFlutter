library;

import 'dart:typed_data';

import 'package:flutter/widgets.dart';

class FrameRate {
  const FrameRate._();

  static const max = FrameRate._();
}

class Lottie extends StatelessWidget {
  const Lottie._();

  static Widget network(
    String src, {
    double? width,
    double? height,
    BoxFit? fit,
    bool? repeat,
    FrameRate? frameRate,
    Widget Function(BuildContext context, Object error, StackTrace? stackTrace)?
    errorBuilder,
  }) {
    return SizedBox(width: width, height: height);
  }

  static Widget memory(
    Uint8List bytes, {
    double? width,
    double? height,
    BoxFit? fit,
    bool? repeat,
    FrameRate? frameRate,
    Widget Function(BuildContext context, Object error, StackTrace? stackTrace)?
    errorBuilder,
  }) {
    return SizedBox(width: width, height: height);
  }

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
