import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  static const String baseUrl = 'http://45.129.87.38:6065';

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      contentType: 'application/json',
    ),
  )..interceptors.add(PrettyDioLogger(requestBody: true, requestHeader: true, responseBody: true));

  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  Options _authOptions() => Options(headers: {
    if (_token != null) 'Authorization': 'Bearer $_token',
  });

  Future<Response<T>> post<T>(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters, options: options ?? _authOptions());
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParameters, Options? options}) {
    return _dio.get<T>(path, queryParameters: queryParameters, options: options ?? _authOptions());
  }
}