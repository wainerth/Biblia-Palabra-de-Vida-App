import 'package:graphql_flutter/graphql_flutter.dart';

class ResponseData {
  final dynamic data;
  final String? error;
  final String? userFriendlyError;
  final ErrorType? errorType;

  ResponseData({
    required this.data,
    this.error,
    this.userFriendlyError,
    this.errorType,
  });

  bool get hasError => error != null;
  bool get hasData => data != null;

  factory ResponseData.fromQueryResult(QueryResult result) {
    final errorInfo = _extractErrorInfo(result);
    final userFriendlyMessage = _mapToUserFriendlyMessage(errorInfo);
    
    return ResponseData(
      data: _removeTypename(result.data),
      error: errorInfo.message,
      userFriendlyError: userFriendlyMessage,
      errorType: errorInfo.type,
    );
  }

  static ErrorInfo _extractErrorInfo(QueryResult result) {
    // Si no hay excepción, retornar sin error
    if (result.exception == null) {
      return ErrorInfo.noError();
    }

    final exception = result.exception!;
    String? errorMessage;
    ErrorType errorType = ErrorType.unknown;

    // 1. Verificar errores de GraphQL del servidor
    if (exception.graphqlErrors.isNotEmpty) {
      final firstError = exception.graphqlErrors.first;
      errorMessage = firstError.message;
      
      // Mapear tipos comunes de errores GraphQL
      if (firstError.message.contains('Unauthorized') || 
          firstError.message.contains('Authentication')) {
        errorType = ErrorType.unauthorized;
      } else if (firstError.message.contains('Validation')) {
        errorType = ErrorType.validation;
      } else if (firstError.message.contains('Not Found')) {
        errorType = ErrorType.notFound;
      } else if (firstError.message.contains('Server')) {
        errorType = ErrorType.server;
      } else {
        errorType = ErrorType.graphql;
      }
    }
    // 2. Verificar errores de enlace (conexión, timeout, etc.)
    else if (exception.linkException != null) {
      final linkException = exception.linkException.toString();
      errorMessage = linkException;
      
      // Detectar tipo de error de conexión
      if (linkException.contains('TimeoutException') || 
          linkException.contains('timed out') ||
          linkException.contains('0:00:05')) {
        errorType = ErrorType.timeout;
      } 
      else if (linkException.contains('SocketException') ||
               linkException.contains('Network') ||
               linkException.contains('Connection')) {
        errorType = ErrorType.network;
      }
      else if (linkException.contains('No stream event')) {
        errorType = ErrorType.noData;
      }
      else if (linkException.contains('UnknownException')) {
        errorType = ErrorType.unknown;
      }
    }
    // 3. Error general de la operación
    else {
      errorMessage = exception.toString();
      errorType = ErrorType.operation;
    }

    // Extraer mensaje más limpio si es posible
    final cleanedMessage = _cleanErrorMessage(errorMessage);
    
    return ErrorInfo(
      message: cleanedMessage,
      type: errorType,
      rawException: exception,
    );
  }

  static String _cleanErrorMessage(String errorMessage) {
    // Limpiar mensajes muy largos o con stack traces
    final patterns = [
      RegExp(r'stack:\s*>.*', dotAll: true), // Remover stack traces
      RegExp(r'\n\s*>'), // Remover líneas con >
      RegExp(r'hashCode\s*=\s*\w+'), // Remover hashCodes
      RegExp(r'runtimeType\s*=\s*\w+'), // Remover runtime types
    ];
    
    var cleaned = errorMessage;
    for (final pattern in patterns) {
      cleaned = cleaned.replaceAll(pattern, '');
    }
    
    // Tomar solo la primera línea si es muy largo
    if (cleaned.length > 200) {
      final firstLine = cleaned.split('\n').first;
      if (firstLine.length < 150) {
        cleaned = firstLine;
      } else {
        cleaned = '${cleaned.substring(0, 150)}...';
      }
    }
    
    return cleaned.trim();
  }

  static String _mapToUserFriendlyMessage(ErrorInfo errorInfo) {
    switch (errorInfo.type) {
      case ErrorType.timeout:
        return 'El servidor no respondió a tiempo. Verifica tu conexión a internet e intenta nuevamente.';
      
      case ErrorType.network:
        return 'Problema de conexión. Por favor, verifica tu conexión a internet.';
      
      case ErrorType.noData:
        return 'No se recibieron datos del servidor. El servicio podría estar temporalmente no disponible.';
      
      case ErrorType.unauthorized:
        return 'No tienes permiso para realizar esta acción. Por favor, inicia sesión nuevamente.';
      
      case ErrorType.validation:
        return 'Los datos enviados no son válidos. Por favor, verifica la información.';
      
      case ErrorType.notFound:
        return 'El recurso solicitado no fue encontrado.';
      
      case ErrorType.server:
        return 'Error del servidor. Por favor, intenta más tarde.';
      
      case ErrorType.graphql:
        // Intentar extraer mensaje útil del error GraphQL
        final msg = errorInfo.message.toLowerCase();
        if (msg.contains('invalid') || msg.contains('invalid input')) {
          return 'Datos inválidos. Por favor, revisa la información ingresada.';
        }
        if (msg.contains('already exists') || msg.contains('duplicate')) {
          return 'Este elemento ya existe.';
        }
        return 'Error al procesar la solicitud.';
      
      case ErrorType.operation:
        return 'Error en la operación. Por favor, intenta nuevamente.';
      
      case ErrorType.unknown:
      default:
        return 'Ocurrió un error inesperado. Por favor, intenta más tarde.';
    }
  }

  static dynamic _removeTypename(dynamic values) {
    if (values is Map<String, dynamic>) {
      values.removeWhere((key, value) => key == '__typename');
      values.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          _removeTypename(value);
        } else if (value is List) {
          for (var item in value) {
            if (item is Map<String, dynamic>) {
              _removeTypename(item);
            }
          }
        }
      });
    }
    return values;
  }
}

// Clases de soporte para mejor manejo de errores
enum ErrorType {
  timeout,
  network,
  noData,
  unauthorized,
  validation,
  notFound,
  server,
  graphql,
  operation,
  unknown,
  none,
}

class ErrorInfo {
  final String message;
  final ErrorType type;
  final OperationException? rawException;

  ErrorInfo({
    required this.message,
    required this.type,
    this.rawException,
  });

  factory ErrorInfo.noError() {
    return ErrorInfo(
      message: '',
      type: ErrorType.none,
    );
  }
}

// Método de extensión para fácil uso
extension QueryResultExtensions on QueryResult {
  ResponseData toResponseData() {
    return ResponseData.fromQueryResult(this);
  }
}