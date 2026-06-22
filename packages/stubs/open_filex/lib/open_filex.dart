library;

enum ResultType { done, noAppToOpen, fileNotFound, permissionDenied, error }

class OpenResult {
  const OpenResult({required this.type, this.message = ''});

  final ResultType type;
  final String message;
}

class OpenFilex {
  const OpenFilex._();

  static Future<OpenResult> open(String path) async {
    return const OpenResult(type: ResultType.error, message: '当前版本不支持打开文件');
  }
}
