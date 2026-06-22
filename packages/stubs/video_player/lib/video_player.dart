library;

import 'dart:io';

import 'package:flutter/widgets.dart';

class VideoPlayerController {
  VideoPlayerController.networkUrl(
    Uri url, {
    Map<String, String>? httpHeaders,
    VideoPlayerOptions? videoPlayerOptions,
  });

  VideoPlayerController.file(
    File file, {
    VideoPlayerOptions? videoPlayerOptions,
  });

  VideoPlayerController.contentUri(
    Uri contentUri, {
    VideoPlayerOptions? videoPlayerOptions,
  });

  VideoPlayerValue value = const VideoPlayerValue(aspectRatio: 1);

  void addListener(VoidCallback listener) {}

  void removeListener(VoidCallback listener) {}

  Future<void> initialize() async {}

  Future<void> setLooping(bool looping) async {}

  Future<void> play() async {}

  Future<void> pause() async {}

  Future<void> seekTo(Duration position) async {}

  Future<void> dispose() async {}
}

class VideoPlayerValue {
  const VideoPlayerValue({
    this.aspectRatio = 1,
    this.isPlaying = false,
    this.duration = Duration.zero,
    this.position = Duration.zero,
    this.size = Size.zero,
    this.isInitialized = false,
  });

  final double aspectRatio;
  final bool isPlaying;
  final Duration duration;
  final Duration position;
  final Size size;
  final bool isInitialized;
}

class VideoPlayerOptions {
  const VideoPlayerOptions({
    this.mixWithOthers = false,
    this.allowBackgroundPlayback = false,
  });

  final bool mixWithOthers;
  final bool allowBackgroundPlayback;
}

class VideoPlayer extends StatelessWidget {
  const VideoPlayer(this.controller, {super.key});

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
