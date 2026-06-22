import 'package:wukongimfluttersdk/model/wk_message_content.dart';

import '../modules/module_message_content_support.dart';

typedef WkMessageContentDecoder = WKMessageContent Function(dynamic data);

class MessageContentRegistration implements ModuleMessageContentSupport {
  const MessageContentRegistration({
    required this.contentType,
    required this.decoder,
  });

  @override
  final int contentType;
  final WkMessageContentDecoder decoder;
}
