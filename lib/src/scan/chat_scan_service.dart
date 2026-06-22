import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

abstract interface class ChatScanGateway {
  Future<String?> pickQrCodeFromAlbum();

  Future<String?> decodeQrImage(String imagePath);
}

class ChatScanService implements ChatScanGateway {
  ChatScanService({ImagePicker? imagePicker, MethodChannel? channel})
    : _imagePicker = imagePicker ?? ImagePicker(),
      _channel = channel ?? const MethodChannel('foxtalk/scan');

  final ImagePicker _imagePicker;
  final MethodChannel _channel;

  @override
  Future<String?> pickQrCodeFromAlbum() async {
    final file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
    );
    if (file == null) {
      return null;
    }
    return decodeQrImage(file.path);
  }

  @override
  Future<String?> decodeQrImage(String imagePath) async {
    final String? value;
    try {
      value = await _channel.invokeMethod<String>('decodeQrImage', {
        'path': imagePath,
      });
    } on MissingPluginException {
      return null;
    }
    final result = value?.trim();
    return result == null || result.isEmpty ? null : result;
  }
}
