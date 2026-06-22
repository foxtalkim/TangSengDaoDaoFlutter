library;

import 'dart:typed_data';

class ImageCropper {
  Future<CroppedFile?> cropImage({
    required String sourcePath,
    CropAspectRatio? aspectRatio,
    ImageCompressFormat? compressFormat,
    int? compressQuality,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    return null;
  }
}

class CroppedFile {
  const CroppedFile(this.path);

  final String path;

  Future<Uint8List> readAsBytes() async => Uint8List(0);
}

class CropAspectRatio {
  const CropAspectRatio({required this.ratioX, required this.ratioY});

  final double ratioX;
  final double ratioY;
}

enum ImageCompressFormat { jpg, png }

abstract class PlatformUiSettings {
  const PlatformUiSettings();
}

class AndroidUiSettings extends PlatformUiSettings {
  const AndroidUiSettings({
    this.toolbarTitle,
    this.hideBottomControls,
    this.lockAspectRatio,
  });

  final String? toolbarTitle;
  final bool? hideBottomControls;
  final bool? lockAspectRatio;
}

class IOSUiSettings extends PlatformUiSettings {
  const IOSUiSettings({
    this.title,
    this.aspectRatioLockEnabled,
    this.resetAspectRatioEnabled,
    this.aspectRatioPickerButtonHidden,
  });

  final String? title;
  final bool? aspectRatioLockEnabled;
  final bool? resetAspectRatioEnabled;
  final bool? aspectRatioPickerButtonHidden;
}
