import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../config/app_config.dart';

class ApiClient {
  static const appIdentity = 'com.chatim.foxtalk';

  ApiClient({required this.config})
    : dio = Dio(
        BaseOptions(
          baseUrl: config.apiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'os': 'Flutter',
            'appid': appIdentity,
            'package': appIdentity,
          },
        ),
      );

  final AppConfig config;
  final Dio dio;
  String? token;

  Future<Map<String, dynamic>> getJson(String path) async {
    return _request(() => dio.get(path, options: _options()));
  }

  Future<Object?> getAny(String path) async {
    return _requestAny(() => dio.get(path, options: _options()));
  }

  Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _request(() => dio.post(path, data: body, options: _options()));
  }

  Future<Map<String, dynamic>> uploadFile(
    String path,
    String filePath, {
    String fieldName = 'file',
    ProgressCallback? onSendProgress,
  }) async {
    final form = FormData.fromMap({
      fieldName: await MultipartFile.fromFile(filePath),
    });
    // FormData generates its own `multipart/form-data; boundary=...`
    // header — pass an empty Options.contentType so dio derives it
    // from the FormData instead of using the JSON default.
    return _request(
      () => dio.post(
        path,
        data: form,
        options: Options(
          headers: token == null || token!.isEmpty ? null : {'token': token},
        ),
        onSendProgress: onSendProgress,
      ),
    );
  }

  Future<List<int>> downloadBytes(String path) async {
    try {
      final response = await dio.get<List<int>>(
        path,
        options: _options(responseType: ResponseType.bytes),
      );
      return response.data ?? const [];
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<Object?> postAny(String path, Object body) async {
    return _requestAny(
      () => dio.post(
        path,
        data: body,
        options: _options(contentType: Headers.jsonContentType),
      ),
    );
  }

  Future<Map<String, dynamic>> putJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    return _request(() => dio.put(path, data: body, options: _options()));
  }

  Future<Map<String, dynamic>> deleteJson(String path, {Object? body}) async {
    return _request(() => dio.delete(path, data: body, options: _options()));
  }

  Future<Object?> deleteAny(String path, {Object? body}) async {
    return _requestAny(
      () => dio.delete(
        path,
        data: body,
        options: _options(contentType: Headers.jsonContentType),
      ),
    );
  }

  Future<String> deviceId() async {
    final preferences = await SharedPreferences.getInstance();
    final existing = preferences.getString('chatim_device_id');
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final next = const Uuid().v4();
    await preferences.setString('chatim_device_id', next);
    return next;
  }

  Options _options({ResponseType? responseType, String? contentType}) {
    // Default to `application/json` so the Go backend's `c.BindJSON`
    // succeeds whether the body is a Map or a List. dio's auto-pick
    // is ambiguous for List payloads (e.g. POST /groups/<no>/managers
    // takes a JSON array) — we tripped that on the manager-add 400
    // earlier. Callers can still override via the `contentType` arg
    // for FormData uploads.
    return Options(
      headers: token == null || token!.isEmpty ? null : {'token': token},
      responseType: responseType,
      contentType: contentType ?? Headers.jsonContentType,
    );
  }

  Future<Map<String, dynamic>> _request(
    Future<Response<dynamic>> Function() run,
  ) async {
    final data = await _requestAny(run);
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    throw const ApiException('接口返回格式异常');
  }

  Future<Object?> _requestAny(Future<Response<dynamic>> Function() run) async {
    try {
      final response = await run();
      return response.data;
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }
}

class ApiException implements Exception {
  const ApiException(
    this.message, {
    this.statusCode,
    this.apiStatus,
    this.data,
  });

  final String message;
  final int? statusCode;
  final int? apiStatus;
  final Map<String, dynamic>? data;

  factory ApiException.fromDio(DioException error) {
    final data = error.response?.data;
    String message = error.message ?? '网络请求失败';
    Map<String, dynamic>? responseData;
    int? apiStatus;
    if (data is Map) {
      responseData = Map<String, dynamic>.from(data);
      if (responseData['msg'] != null) {
        message = responseData['msg'].toString();
      }
      apiStatus = int.tryParse('${responseData['status'] ?? ''}');
    }
    return ApiException(
      message,
      statusCode: error.response?.statusCode,
      apiStatus: apiStatus,
      data: responseData,
    );
  }

  @override
  String toString() => message;
}
