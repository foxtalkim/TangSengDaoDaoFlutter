class AppConfig {
  const AppConfig({
    required this.serverBaseUrl,
    required this.apiBaseUrl,
    required this.webBaseUrl,
  });

  // Open-source builds should point at the deployer's own server.
  // Override with --dart-define=CHATIM_SERVER_BASE_URL=<your-server-base-url>.
  static const defaultServerBaseUrl = String.fromEnvironment(
    'CHATIM_SERVER_BASE_URL',
    defaultValue: 'localhost:8090',
  );

  final String serverBaseUrl;
  final String apiBaseUrl;
  final String webBaseUrl;

  factory AppConfig.defaultConfig() {
    return AppConfig.fromServerBaseUrl(defaultServerBaseUrl);
  }

  factory AppConfig.fromServerBaseUrl(String value) {
    final raw = _withScheme(
      value.trim().isEmpty ? defaultServerBaseUrl : value.trim(),
    );
    final inputUri = Uri.parse(raw);
    final originUri = Uri(
      scheme: inputUri.scheme,
      host: inputUri.host,
      port: inputUri.hasPort ? inputUri.port : null,
    );
    final origin = _withoutTrailingSlash(originUri.toString());
    final path = inputUri.path.replaceAll(RegExp(r'/+$'), '');
    final isApiPath = path == '/v1' || path.endsWith('/api/v1');
    final explicitApiUri = Uri(
      scheme: inputUri.scheme,
      host: inputUri.host,
      port: inputUri.hasPort ? inputUri.port : null,
      path: path,
    );
    final apiBase = isApiPath
        ? _withTrailingSlash(explicitApiUri.toString())
        : '$origin/v1/';

    return AppConfig(
      serverBaseUrl: origin,
      apiBaseUrl: apiBase,
      webBaseUrl: '$origin/web/',
    );
  }

  String avatarUrl(String uid) => '${apiBaseUrl}users/$uid/avatar';

  String showUrl(String value) {
    if (value.isEmpty ||
        value.startsWith('http://') ||
        value.startsWith('https://')) {
      return value;
    }
    final path = value.startsWith('/') ? value.substring(1) : value;
    return '$apiBaseUrl$path';
  }

  static String _withScheme(String value) {
    if (value.startsWith('http://') || value.startsWith('https://')) {
      return value;
    }
    return 'http://$value';
  }

  static String _withTrailingSlash(String value) {
    return value.endsWith('/') ? value : '$value/';
  }

  static String _withoutTrailingSlash(String value) {
    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }
}
