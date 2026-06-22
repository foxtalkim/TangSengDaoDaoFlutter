import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';

typedef ImageEditorLauncher =
    Future<Uint8List?> Function(BuildContext context, File sourceFile);

typedef ImageCropLauncher =
    Future<String?> Function(BuildContext context, File sourceFile);
