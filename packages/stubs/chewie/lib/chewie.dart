library;

import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class ChewieController {
  ChewieController({
    required this.videoPlayerController,
    this.autoPlay = false,
    this.looping = false,
    this.allowFullScreen = true,
    this.materialProgressColors,
  });

  final VideoPlayerController videoPlayerController;
  final bool autoPlay;
  final bool looping;
  final bool allowFullScreen;
  final Object? materialProgressColors;

  void dispose() {}
}

class Chewie extends StatelessWidget {
  const Chewie({super.key, required this.controller});

  final ChewieController controller;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
