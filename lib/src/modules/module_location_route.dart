import 'package:flutter/widgets.dart';

import '../im/wukong_im_service.dart';

typedef ModuleLocationPicker =
    Future<ChatLocation?> Function(BuildContext context);

typedef ModuleLocationViewer =
    Future<void> Function(BuildContext context, ChatLocation location);
