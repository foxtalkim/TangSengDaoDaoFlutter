library;

class FilePicker {
  const FilePicker._();

  static Future<FilePickerResult?> pickFiles({bool withData = false}) async {
    return null;
  }
}

class FilePickerResult {
  const FilePickerResult(this.files);

  final List<PlatformFile> files;
}

class PlatformFile {
  const PlatformFile({required this.name, required this.size, this.path});

  final String name;
  final int size;
  final String? path;
}
