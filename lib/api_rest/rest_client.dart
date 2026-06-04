// lib/api_rest/clients/rest_client.dart
import 'package:biblia_palabra_de_vida_app/api_rest/interceptors/auth_interceptor.dart';
import 'package:biblia_palabra_de_vida_app/api_rest/interceptors/error_interceptor.dart';
import 'package:biblia_palabra_de_vida_app/api_rest/interceptors/logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:universal_io/universal_io.dart';
import '../../config/rest_config.dart';

class RestClient {
  static RestClient? _instance;
  late Dio _dio;

  RestClient._internal() {
    _initDio();
  }

  static RestClient get instance {
    _instance ??= RestClient._internal();
    return _instance!;
  }

  Dio get dio => _dio;

  void _initDio() {
    _dio = Dio(BaseOptions(
      baseUrl: RestConfig.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // Agregar interceptores
    _dio.interceptors.add(AuthInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
    _dio.interceptors.add(ErrorInterceptor());

    // Configurar para HTTPS con certificados personalizados si es necesario
    if (RestConfig.baseUrl.startsWith('https')) {
      (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback = (cert, host, port) => false;
        return client;
      };
    }
  }

  // Métodos genéricos
  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await _dio.get(path, queryParameters: queryParams);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await _dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await _dio.put(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) async {
    return await _dio.patch(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await _dio.delete(path);
  }
}
