import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

import '../main.dart';

class AuthenticationProvider extends ChangeNotifier {
  final BuildContext context;
  String? token;
  bool isAuthenticated = false;
  bool _isCheckingAuth = false;
  bool _isLoading = false;

  AuthenticationProvider(this.context);
  bool get isLoading => _isLoading;

  Future<AuthCheckResult> checkAuthentication(BuildContext context) async {
    // evita múltiples verificaciones simultáneas
    if (_isCheckingAuth) {
      return AuthCheckResult.inProgress();
    }
    _isCheckingAuth = true;
    _isLoading = true;

    try {
      // Obtener datos almacenados
      String? userToken = await PreferencesManager().getUserToken();
      String? userDataString = await PreferencesManager().getUserData();

      // si no hay datos , el usuario no esta autenticado
      if (userToken == null || userDataString == null) {
        await _clearUserSession(context);
        return AuthCheckResult.notAuthenticated(
            reason: 'No hay sesión guardada');
      }

      // verificar token
      final tokenResponse = await verifyToken(userToken);

      if (tokenResponse.data == null || tokenResponse.error != null) {
        await _clearUserSession(context);
        return AuthCheckResult.notAuthenticated(
            reason: 'Error verificando token: ${tokenResponse.error}');
      }

      // validar respuesta del token
      if (!tokenResponse.data['success']) {
        final isVoluntaryLogout = tokenResponse.data!['isLogout'] == true;

        if (isVoluntaryLogout) {
          await _clearUserSession(context);
          return AuthCheckResult.notAuthenticated(reason: 'Logout Voluntario');
        } else {
          // Token expirado - mostrar diálogo
          await _showSessionExpiredDialog(context);
          return AuthCheckResult.notAuthenticated(reason: 'Sesión expirada');
        }
      }

      // token válido - configurar usuario
      token = userToken;
      isAuthenticated = true;

      final userData = LoginUser.fromJson(jsonDecode(userDataString));

      // configurar socket y estado del usuario
      await _setupAuthenticatedUser(context, userData, userToken);

      return AuthCheckResult.authenticated(user: userData);
    } catch (e, stackTrace) {
      debugPrint('⚠️ Error en checkAuthentication: $e');
      debugPrint('🔍 StackTrace: $stackTrace');

      // en caso de error, asumir no autenticado pero permitir continuar
      await _clearUserSession(context);
      return AuthCheckResult.error(
          error: _getUserFriendlyError(e),
          allowContinue: true // Permitir que la app continúe
          );
    } finally {
      _isCheckingAuth = false;
      _isLoading = false;
      // notifyListeners();
    }
  }

  /// configura el usuario autenticado
  Future<void> _setupAuthenticatedUser(
      BuildContext context, LoginUser user, String token) async {
    try {
      // configurar provider de usuario inmediatamente
      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);
      }

      // inicializar socket
      await _initializeSocket(context, user);

      // cargar el perfil en segundo plano
      _loadProfileInBackground(user.userId, token);
    } catch (e) {
      debugPrint('⚠️ Error en _setupAuthenticatedUser: $e');
    }
  }

  /// Inicializa conexión de socket
  Future<void> _initializeSocket(BuildContext context, LoginUser user) async {
    if (!context.mounted) return;

    try {
      final socketProvider = Provider.of<SocketClientProvider>(
        context,
        listen: false,
      );

      if (!socketProvider.isSocketInitialized) {
        socketProvider.connectSocket(
          userId: user.userId,
          username: user.username ?? '',
          email: user.email ?? '',
        );
      }
    } catch (e) {
      debugPrint('⚠️ Error inicializando socket: $e');
    }
  }

  /// Carga el perfil en segundo plano
  Future<void> _loadProfileInBackground(String userId, String token) async {
    try {
      final profileResponse = await loadProfileUser(userId, token);

      if (profileResponse.error != null && context.mounted) {
        // Mostrar error pero no bloquear
        _showBackgroundError('Error cargando perfil: ${profileResponse.error}');
      } else if (context.mounted) {
        // Actualizar usuario con datos frescos
        Provider.of<UserProvider>(context, listen: false)
            .setUser(LoginUser.fromJson(profileResponse.data!));
      }
    } catch (e) {
      debugPrint('⚠️ Error cargando perfil en background: $e');
    }
  }

  /// Muestra error en segundo plano (no bloqueante)
  void _showBackgroundError(String error) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (navigatorKey.currentContext != null) {
        showCustomDialog(
          navigatorKey.currentContext!,
          message: error,
          dialogType: DialogType.warning,
        );
      }
    });
  }

  /// Limpia la sesión del usuario
  Future<void> _clearUserSession(BuildContext context) async {
    try {
      token = null;
      isAuthenticated = false;

      if (context.mounted) {
        Provider.of<UserProvider>(context, listen: false).setUser(null);
      }

      // Limpiar socket si está disponible
      if (navigatorKey.currentContext != null &&
          navigatorKey.currentContext!.mounted) {
        final socketProvider = Provider.of<SocketClientProvider>(
            navigatorKey.currentContext!,
            listen: false);
        socketProvider.cleanNotification();
        socketProvider.cleanSocket();
      }
    } catch (e) {
      debugPrint('⚠️ Error en _clearUserSession: $e');
    }
  }

  /// Muestra diálogo de sesión expirada
  Future<void> _showSessionExpiredDialog(BuildContext context) async {
    if (!context.mounted) return;

    await showCustomDialogWithAction(
      context,
      message: "Tu sesión ha expirado. Por favor, inicia sesión nuevamente.",
      dialogType: DialogTypeAction.info,
      buttonOk: "Ok",
      actionCallbackOk: () async {
        await _clearUserSession(context);
        navigatorKey.currentState?.popUntil((route) => route.isFirst);
      },
    );
  }

  /// Obtiene mensaje de error amigable
  String _getUserFriendlyError(dynamic error) {
    if (error is SocketException) {
      return 'Error de conexión. Verifica tu internet.';
    } else if (error is TimeoutException) {
      return 'El servidor está tardando en responder.';
    } else if (error is FormatException) {
      return 'Error en los datos recibidos.';
    }
    return 'Ocurrió un error inesperado';
  }

  ///Creamos método para inicio de sesión
  Future loginUser(BuildContext context, String email, String password) async {
    try {
      // llamamos query de login
      final userResponse = await login(email, password);
      var error = userResponse.error;

      if (error != null) {
        return ResponseData(
            data: null,
            error: error,
            errorType: userResponse.errorType,
            userFriendlyError: userResponse.userFriendlyError);
      }
      if (userResponse.data == null) {
        return ResponseData(data: null, error: "no data result");
      }
      final userId = userResponse.data["id"];
      final token = userResponse.data["userJwtToken"]["token"];

      await PreferencesManager().setUserToken(token);

      // consultamos perfil del usuario
      final ResponseData response = await loadProfileUser(userId, token);
      error = response.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }

      return ResponseData(data: response.data, error: error);
    } catch (e) {
      return handleGenericError(e, "Login con usuario y contraseña");
    }
  }

  loadProfileUser(userId, token) async {
    String? error;
    final userProfile = await getProfileUser(token, userId);
    error = userProfile.error;
    if (error != null) {
      if (error.contains("No se encontró el usuario")) {
        await logoutUser(navigatorKey);
        return ResponseData(data: null, error: "No se encontró el usuario");
      }
      return ResponseData(data: null, error: error);
    }

    // llamamos a achievement
    final userTitle = await getUserTitle(userId);
    error = userTitle.error;
    if (userTitle.error != null) {
      return ResponseData(data: null, error: error);
    }
    userProfile.data['title'] = userTitle.data;

    // buscamos miembro si la liga es distinta de null
    if (userProfile.data["currentLeague"] != null) {
      final dataMemberResponse = await getDataMember(token, userId);
      error = dataMemberResponse.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }
      final userRanking = dataMemberResponse.data;
      userRanking["leagueId"] = userProfile.data["currentLeague"]["id"];
      userRanking['leagueName'] = userProfile.data["currentLeague"]["name"];

      userProfile.data["league"] = userRanking;
    } else {
      userProfile.data["league"] = null;
    }

    Provider.of<UserProvider>(context, listen: false)
        .setUser(LoginUser.fromJson(userProfile.data));
    // llamar conexión con el socket
    final socketProvider =
        Provider.of<SocketClientProvider>(context, listen: false);
    if (!socketProvider.isSocketInitialized) {
      socketProvider.connectSocket(
          userId: userProfile.data['userId'],
          username: userProfile.data['username'],
          email: userProfile.data['email']);
    }
    // leemos las notificaciones
    return ResponseData(data: userProfile, error: null);
  }

  Future<ResponseData> loginWithGoogle(BuildContext context) async {
    try {
      final userResponse = await loginGoogle();
      var error = userResponse.error;
      if (error != null) {
        return ResponseData(
            data: null,
            userFriendlyError: userResponse.userFriendlyError,
            error: error);
      }
      final userId = userResponse.data["id"];
      final token = userResponse.data["userJwtToken"]["token"];
      await PreferencesManager().setUserToken(token);
      // consultamos perfil del usuario
      final ResponseData response = await loadProfileUser(userId, token);
      error = response.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }
      return ResponseData(data: response.data, error: error);
    } catch (e) {
      return handleGenericError(e, "login con Google");
    }
  }

  Future<ResponseData> registerUser(SignupInput dataToRegister) async {
    String? error;
    try {
      // get to mutation  GraphQl
      final registerResponse = await initializedRegister(dataToRegister);
      if (registerResponse.error != null) {
        return ResponseData(
            data: null,
            userFriendlyError: registerResponse.userFriendlyError,
            error: registerResponse.error);
      }
      final data = ResponseInitializedRegister.fromJson(registerResponse.data);

      if (data.success &&
          (data.message.contains(
                  'Registro actualizado. Te hemos enviado un nuevo código de verificación.') ||
              data.message.contains(
                  'Registro exitoso. Te hemos enviado un código de verificación a tu correo.'))) {
        return ResponseData(
          data: VerificationResponse(
            userId: data.userId,
            showVerifyPinModal: true,
          ).toMap(),
          error: null,
        );
      } else {
        // seguimos flujo normal
        final userId = registerResponse.data["id"];
        final token = registerResponse.data["userJwtToken"]["token"];
        await PreferencesManager().setUserToken(token);

        // consultamos perfil del usuario
        final ResponseData response = await loadProfileUser(userId, token);
        error = response.error;
        if (error != null) {
          return ResponseData(
              data: null,
              error: error,
              userFriendlyError: response.userFriendlyError);
        }

        return ResponseData(data: response.data, error: error);
      }
    } catch (e) {
      return handleGenericError(e, "Registrar Usuario");
    }
  }

  Future<ResponseData> forgotUserPassword(email) async {
    String? error;
    try {
      final ResponseData response = await forgotPassword(email);
      error = response.error;
      if (error != null) {
        return ResponseData(
            data: null,
            userFriendlyError: response.userFriendlyError,
            error: error,
            errorType: response.errorType);
      }

      return ResponseData(data: response.data, error: error);
    } catch (e) {
      return handleGenericError(e, "Olvidé mi contraseña");
    }
  }

  Future<ResponseData> recoveryPassword(email, code, password) async {
    String? error;
    try {
      final ResponseData response = await verifyPinPassword(email, code);
      error = response.error;
      if (error != null) {
        return ResponseData(data: null,userFriendlyError: response.userFriendlyError, error: error);
      }
      final ResponseData recovery = await resetPassword(email, password);
      error = recovery.error;
      if (error != null) {
        return ResponseData(data: null,userFriendlyError: response.userFriendlyError, error: error);
      }
      return ResponseData(data: response.data, error: error);
    } catch (e) {
      return handleGenericError(e, "Recuperar Contraseña");
    }
  }

  Future logoutUser(context) async {
    final ResponseData result = await logout();
    if (result.error != null) {
      return false;
    }
    // limpio el socket
    if (navigatorKey.currentState != null) {
      Provider.of<SocketClientProvider>(navigatorKey.currentContext!,
              listen: false)
          .cleanNotification();
      Provider.of<SocketClientProvider>(navigatorKey.currentContext!,
              listen: false)
          .cleanSocket();
      navigatorKey.currentState!.popUntil((route) => route.isFirst);
      navigatorKey.currentState!.pushReplacementNamed('/homePage');

      // Accede a UserProvider usando el contexto del NavigatorKey
      final userProvider = Provider.of<UserProvider>(
          navigatorKey.currentContext!,
          listen: false);
      userProvider.dailyProverb = null;
      userProvider.setUser(null);
    }
    token = null;
    notifyListeners();
  }

  Future<ResponseData> verifyPinWithApi(String email, String pin) async {
    // llamamos a verificar pin
    final verifyPin = await verifyPinAndCompleteRegistration(email, pin);
    if (verifyPin.error != null) {
      return ResponseData(data: null, error: verifyPin.error);
    }

    // lamamos a leer perfil del usuario
    try {
      final userId = verifyPin.data["id"];
      final token = verifyPin.data["userJwtToken"]["token"];

      await PreferencesManager().setUserToken(token);

      // consultamos perfil del usuario
      final ResponseData response = await loadProfileUser(userId, token);

      if (response.error != null) {
        return ResponseData(data: null, error: response.error);
      }

      return ResponseData(data: response.data, error: null);
    } catch (e) {
      return handleGenericError(e, "Login con usuario y contraseña");
    }
  }

  Future<void> resendVerificationCode(email) async {}
}
