import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ChatErrorLogService {
  ChatErrorLogService({Future<Directory> Function()? baseDirectory})
    : _baseDirectory = baseDirectory ?? getApplicationDocumentsDirectory;

  final Future<Directory> Function() _baseDirectory;

  Future<List<ChatErrorLogEntry>> loadLogs() async {
    final base = await _baseDirectory();
    final crashDir = Directory('${base.path}/wkCrash');
    if (!await crashDir.exists()) {
      return const [];
    }
    final entries = <ChatErrorLogEntry>[];
    await for (final entity in crashDir.list(followLinks: false)) {
      if (entity is! File) {
        continue;
      }
      final stat = await entity.stat();
      entries.add(
        ChatErrorLogEntry(
          name: entity.uri.pathSegments.last,
          path: entity.path,
          sizeBytes: stat.size,
          sizeLabel: formatSize(stat.size),
          modifiedAt: stat.modified,
          timeLabel: formatTime(stat.modified),
        ),
      );
    }
    entries.sort((a, b) => a.modifiedAt.compareTo(b.modifiedAt));
    return entries;
  }

  static String formatSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }
    final kb = bytes / 1024;
    if (kb < 1024) {
      return '${kb.toStringAsFixed(2)} KB';
    }
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(2)} MB';
  }

  static String formatTime(DateTime time) {
    String two(int value) => value.toString().padLeft(2, '0');
    return '${time.year}-${two(time.month)}-${two(time.day)} '
        '${two(time.hour)}:${two(time.minute)}';
  }
}

class ChatErrorLogEntry {
  const ChatErrorLogEntry({
    required this.name,
    required this.path,
    required this.sizeBytes,
    required this.sizeLabel,
    required this.modifiedAt,
    required this.timeLabel,
  });

  final String name;
  final String path;
  final int sizeBytes;
  final String sizeLabel;
  final DateTime modifiedAt;
  final String timeLabel;
}
