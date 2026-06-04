import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  Future<String?> _getToken() async {
    // Implementa tu obtención de token
    String? userToken = await PreferencesManager().getUserToken();
    return userToken;
  }
}
