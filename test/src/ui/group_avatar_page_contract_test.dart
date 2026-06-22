import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'group avatar upload invalidates cache and updates settings preview',
    () {
      final groupPages = File(
        'lib/src/ui/pages/group_pages.dart',
      ).readAsStringSync();
      final settingsPages = File(
        'lib/src/ui/pages/chat_settings_pages.dart',
      ).readAsStringSync();

      expect(
        groupPages,
        contains(
          "import 'package:cached_network_image/cached_network_image.dart';",
        ),
      );
      expect(groupPages, contains('CachedNetworkImage.evictFromCache'));
      expect(
        groupPages,
        contains('Navigator.of(context).maybePop(_displayUrl)'),
      );

      final uploadMethodIndex = groupPages.indexOf(
        'Future<void> _pickAndUpload(ImageSource source)',
      );
      expect(uploadMethodIndex, isNot(-1));
      final previewUpdateIndex = groupPages.indexOf(
        'setState(() {\n'
        '        _uploading = false;\n'
        '        _cacheBuster = DateTime.now().millisecondsSinceEpoch;',
        uploadMethodIndex,
      );
      final refreshIndex = groupPages.indexOf(
        'widget.imGateway?.refreshChannel',
        uploadMethodIndex,
      );
      expect(previewUpdateIndex, isNot(-1));
      expect(refreshIndex, isNot(-1));
      expect(previewUpdateIndex, lessThan(refreshIndex));

      expect(settingsPages, contains('late String _groupAvatarUrl;'));
      expect(settingsPages, contains('imageUrl: _groupAvatarUrl'));
      expect(settingsPages, contains('Navigator.of(context).push<String>'));
      expect(settingsPages, contains('onAvatarUpdated: (updatedAvatarUrl)'));
      expect(settingsPages, contains('_groupAvatarUrl = updatedAvatarUrl'));
      expect(
        groupPages,
        contains('final ValueChanged<String>? onAvatarUpdated;'),
      );
      expect(groupPages, contains('widget.onAvatarUpdated?.call(_displayUrl)'));
    },
  );
}
