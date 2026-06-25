import 'package:flutter_test/flutter_test.dart';
import 'package:foxtalk/src/ui/pages/chat_screen_page.dart';

void main() {
  test(
    'live photo playback falls back to remote when persisted local file is missing',
    () {
      final selected = selectChatMediaPlaybackSourceForTesting(
        localSource:
            '/private/var/mobile/Containers/Data/Application/OLD/tmp/.video/live.MOV',
        remoteSource: '/v1/file/preview/chat/1/live.mov',
        resolveRemote: (raw) => 'https://api.example.com$raw',
      );

      expect(
        selected.url,
        'https://api.example.com/v1/file/preview/chat/1/live.mov',
      );
      expect(selected.isRemote, isTrue);
    },
  );

  test(
    'live photo playback prefers durable remote source over local temp file',
    () {
      final selected = selectChatMediaPlaybackSourceForTesting(
        localSource: 'file:///tmp/current-live.MOV',
        remoteSource: '/v1/file/preview/chat/1/live.mov',
        resolveRemote: (raw) => 'https://api.example.com$raw',
      );

      expect(
        selected.url,
        'https://api.example.com/v1/file/preview/chat/1/live.mov',
      );
      expect(selected.isRemote, isTrue);
    },
  );
}
