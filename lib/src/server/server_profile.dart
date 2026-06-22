import '../config/app_config.dart';

enum ClientEdition { openSource }

abstract interface class ServerProfileResolver {
  Future<ServerProfile> resolve(AppConfig config);
}

final class OpenSourceServerProfileResolver implements ServerProfileResolver {
  const OpenSourceServerProfileResolver();

  @override
  Future<ServerProfile> resolve(AppConfig config) async {
    return ServerProfile.fromConfig(config);
  }
}

final class ServerProfile {
  const ServerProfile({
    required this.config,
    required this.storageScope,
    required this.edition,
    required this.displayName,
  });

  factory ServerProfile.fromServerBaseUrl(
    String value, {
    ClientEdition edition = ClientEdition.openSource,
    String? displayName,
  }) {
    return ServerProfile.fromConfig(
      AppConfig.fromServerBaseUrl(value),
      edition: edition,
      displayName: displayName,
    );
  }

  factory ServerProfile.fromConfig(
    AppConfig config, {
    ClientEdition edition = ClientEdition.openSource,
    String? displayName,
  }) {
    return ServerProfile(
      config: config,
      storageScope: serverStorageScope(config),
      edition: edition,
      displayName: displayName?.trim().isNotEmpty == true
          ? displayName!.trim()
          : _displayName(config),
    );
  }

  final AppConfig config;
  final String storageScope;
  final ClientEdition edition;
  final String displayName;

  bool get isOpenSource => edition == ClientEdition.openSource;
}

String serverStorageScope(AppConfig config) {
  final uri = Uri.parse(config.apiBaseUrl);
  final canonical = Uri(
    scheme: uri.scheme.toLowerCase(),
    host: uri.host.toLowerCase(),
    port: uri.hasPort ? uri.port : null,
    path: uri.path.replaceAll(RegExp(r'/+$'), ''),
  ).toString();
  final host = uri.host.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '_');
  final readable = host.isEmpty ? 'server' : host;
  return '${readable}_${_fnv1a32Hex(canonical)}';
}

String _displayName(AppConfig config) {
  final uri = Uri.tryParse(config.serverBaseUrl);
  final host = uri?.host ?? '';
  if (host.isNotEmpty) return host;
  return config.serverBaseUrl;
}

String _fnv1a32Hex(String value) {
  var hash = 0x811c9dc5;
  for (final unit in value.codeUnits) {
    hash ^= unit;
    hash = (hash * 0x01000193) & 0xffffffff;
  }
  return hash.toRadixString(16).padLeft(8, '0');
}
