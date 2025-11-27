import 'package:biblia_palabra_de_vida_app/models/login_user.dart';

class AuthCheckResult {
  final bool isAuthenticated;
  final bool isInProgress;
  final bool hasError;
  final String? error;
  final String? reason;
  final bool allowContinue;
  final LoginUser? user;

  AuthCheckResult._({
    required this.isAuthenticated,
    required this.isInProgress,
    required this.hasError,
    this.error,
    this.reason,
    this.allowContinue = false,
    this.user,
  });

  factory AuthCheckResult.authenticated({required LoginUser user}) =>
      AuthCheckResult._(
        isAuthenticated: true,
        isInProgress: false,
        hasError: false,
        user: user,
      );

  factory AuthCheckResult.notAuthenticated({String? reason}) =>
      AuthCheckResult._(
        isAuthenticated: false,
        isInProgress: false,
        hasError: false,
        reason: reason,
      );

  factory AuthCheckResult.error(
          {required String error, bool allowContinue = false}) =>
      AuthCheckResult._(
        isAuthenticated: false,
        isInProgress: false,
        hasError: true,
        error: error,
        allowContinue: allowContinue,
      );

  factory AuthCheckResult.inProgress() => AuthCheckResult._(
        isAuthenticated: false,
        isInProgress: true,
        hasError: false,
      );
}
