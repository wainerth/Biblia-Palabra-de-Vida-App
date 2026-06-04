
import 'package:dio/dio.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('➡️ ${options.method} ${options.path}');
    print('📦 Headers: ${options.headers}');
    print('📦 Body: ${options.data}');
    return handler.next(options);
  }
  
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('⬅️ ${response.statusCode} ${response.requestOptions.path}');
    print('📦 Response: ${response.data}');
    return handler.next(response);
  }
  
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print('❌ Error: ${err.message}');
    return handler.next(err);
  }
}

