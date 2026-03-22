import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioClient {
  late final Dio _dio;
  String? _baseUrl;
  String? _username;
  String? _password;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
          return handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
          return handler.next(error);
        },
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }
  }

  void updateCredentials({
    required String baseUrl,
    String? username,
    String? password,
  }) {
    _baseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    _username = username;
    _password = password;
  }

  String get baseUrl => _baseUrl ?? '';

  String get authKey {
    if (_username == null || _password == null) return '';
    // Generate auth key as md5(username+password) - standard Xtream auth
    return '${_username}_$_password';
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.get<T>(
      _buildFullUrl(path),
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return _dio.post<T>(
      _buildFullUrl(path),
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  String _buildFullUrl(String path) {
    if (_baseUrl == null) {
      throw Exception('Base URL not set. Call updateCredentials first.');
    }
    
    String fullUrl = '$_baseUrl$path';
    
    // Add auth credentials to query params for Xtream API
    if (_username != null && _password != null) {
      final separator = path.contains('?') ? '&' : '?';
      return '$fullUrl${separator}username=$_username&password=$_password';
    }
    
    return fullUrl;
  }

  String getStreamUrl(String type, String id) {
    if (_baseUrl == null || _username == null || _password == null) {
      throw Exception('Credentials not set');
    }
    
    String cleanBaseUrl = _baseUrl!;
    if (cleanBaseUrl.endsWith('/')) {
      cleanBaseUrl = cleanBaseUrl.substring(0, cleanBaseUrl.length - 1);
    }
    
    return '$cleanBaseUrl/$type/$id/$authKey/';
  }

  String getMovieStreamUrl(String movieId) {
    return getStreamUrl('movie', movieId);
  }

  String getSeriesStreamUrl(String seriesId, String season, String episode) {
    return getStreamUrl('series', '$seriesId/$season/$episode');
  }

  String getLiveStreamUrl(String channelId) {
    return getStreamUrl('live', channelId);
  }
}
