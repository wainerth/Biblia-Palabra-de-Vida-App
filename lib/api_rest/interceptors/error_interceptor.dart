import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw Exception('Tiempo de conexión agotado');
      case DioExceptionType.badResponse:
        _handleBadResponse(err.response);
        break;
      case DioExceptionType.cancel:
        throw Exception('Petición cancelada');
      default:
        throw Exception('Error de conexión: ${err.message}');
    }
    return handler.next(err);
  }

  void _handleBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;
    String? errorMessage = null;
    if (data is Map) {
      // Prioridad: error > message > msg
      errorMessage = data['error'] ??
          data['message'] ??
          data['msg'] ??
          'Error del servidor';
    } else if (data is String) {
      errorMessage = data;
    }
    final message = errorMessage ?? 'Error desconocido';

    switch (statusCode) {
      case 400:
        throw Exception('Petición incorrecta: $message');
      case 401:
        throw Exception('No autorizado: $message');
      case 403:
        throw Exception('Acceso denegado: $message');
      case 404:
        throw Exception('Recurso no encontrado: $message');
      case 500:
        throw Exception('Error del servidor: $message');
      default:
        throw Exception('Error $statusCode: $message');
    }
  }
}
