import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
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
  final CatalogueProvider _catalogueProvider;
  final BuildContext context;
  String? token;
  bool isAuthenticated = false;

  AuthenticationProvider(this.context, this._catalogueProvider) {
    if (kDebugMode) {
      print(_catalogueProvider);
    }
  }

  Future<void> checkAuthentication(BuildContext context) async {
    String? userToken = await PreferencesManager().getUserToken();
    String? userDataString = await PreferencesManager().getUserData();

    try {
      if (userToken != null && userDataString != null) {
        final verifyTokenResponse = await verifyToken(userToken);
        if (verifyTokenResponse.data != null) {
          if (verifyTokenResponse.data["success"]) {
            isAuthenticated = true;
          } else if (!verifyTokenResponse.data["success"] &&
              verifyTokenResponse.data["isLogout"]) {
            //Logout voluntario → no mostrar modal
            isAuthenticated = false;
            logoutUser(navigatorKey.currentContext!);
            LoadingService().hideLoading();
            return;
          } else {
            isAuthenticated = false;
            LoadingService().hideLoading();
            await showCustomDialogWithAction(navigatorKey.currentContext!,
                message:
                    "Tu sesión ha expirado o fue cerrada. Por favor, inicia sesión nuevamente.",
                dialogType: DialogTypeAction.info,
                buttonOk: "Ok", actionCallbackOk: () async {
              await logoutUser(navigatorKey.currentContext!);
            });
            return;
          }
        }
        token = userToken;
        final dataUserLoad = LoginUser.fromJson(jsonDecode(userDataString));
        // llamar conexión con el socket
        final socketProvider =
            Provider.of<SocketClientProvider>(context, listen: false);
        final deviceInfo = await DeviceInfoPlugin().deviceInfo;
        if (!socketProvider.isInitialized) {
          socketProvider.connectSocket(
              deviceId: '856-32cd-89',
              userId: dataUserLoad.userId,
              username: dataUserLoad.username!,
              email: dataUserLoad.email!);
        }

        Provider.of<UserProvider>(context, listen: false)
            .setUser(LoginUser.fromJson(jsonDecode(userDataString)));
        final profileResponse =
            await loadProfileUser(dataUserLoad.userId, userToken);
        if (profileResponse.error != null) {
          await showCustomDialogWithAction(context,
              message: profileResponse.error!,
              dialogType: DialogTypeAction.error,
              buttonOk: "Reintentar", actionCallbackOk: () {
            checkAuthentication(context);
          });
        } else {
          if (kDebugMode) {
            print('cargo nueva data de perfil');
          }
        }
      } else {
        isAuthenticated = false;
        token = userToken;
        Provider.of<UserProvider>(context, listen: false).setUser(null);
        logoutUser(navigatorKey.currentContext!);
        LoadingService().hideLoading();
      }
    } catch (e, stackTrace) {
      debugPrint('⚠️ Error en auth: $e');
      debugPrint('🔍 StackTrace: $stackTrace'); // Para depuración

      // Mensaje más amigable:
      String errorMessage = 'Ocurrió un error inesperado';
      if (e is SocketException) {
        errorMessage = 'Error de conexión. Verifica tu internet.';
      } else if (e is TimeoutException) {
        errorMessage = 'Tiempo de espera agotado. Intenta nuevamente.';
      } else if (e is FormatException) {
        errorMessage = 'Error en los datos recibidos.';
      }

      await showCustomDialog(
        context,
        message: errorMessage,
        dialogType: DialogType.error,
      );
    }

    notifyListeners();
  }

  ///Creamos método para inicio de sesión
  Future loginUser(BuildContext context, String email, String password) async {
    try {
      // llamamos query de login
      final userResponse = await login(email, password);
      var error = userResponse.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
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
      if (e is TimeoutException) {
        return ResponseData(data: null, error: "Request timed out");
      } else if (e is SocketException) {
        return ResponseData(data: null, error: "No Internet Connection");
      } else if (e is FormatException) {
        // Example: JSON parsing error
        return ResponseData(data: null, error: "Invalid data format");
      } else {
        return ResponseData(
            data: null,
            error: "An unexpected error occurred: $e"); // Generic error
      }
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
    final deviceInfo = await DeviceInfoPlugin().deviceInfo;
    if (!socketProvider.isInitialized) {
      socketProvider.connectSocket(
          deviceId: '856-32cd-89',
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
        return ResponseData(data: null, error: error);
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
      if (kDebugMode) {
        print("Error during login: $e");
      } // Print the error for debugging.  Crucial!

      // More specific error handling if needed:
      if (e is TimeoutException) {
        return ResponseData(data: null, error: "Request timed out");
      } else if (e is SocketException) {
        return ResponseData(data: null, error: "No Internet Connection");
      } else if (e is FormatException) {
        // Example: JSON parsing error
        return ResponseData(data: null, error: "Invalid data format");
      } else {
        return ResponseData(
            data: null,
            error: "An unexpected error occurred: $e"); // Generic error
      }
    }
  }

  Future<ResponseData> registerUser(SignupInput dataToRegister) async {
    String? error;
    try {
      // get to mutation  GraphQl
      final registerResponse = await register(dataToRegister);
      if (registerResponse.error != null) {
        return ResponseData(data: null, error: registerResponse.error);
      }
      final userId = registerResponse.data["id"];
      final token = registerResponse.data["userJwtToken"]["token"];
      await PreferencesManager().setUserToken(token);

      // consultamos perfil del usuario
      final ResponseData response = await loadProfileUser(userId, token);
      error = response.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }

      return ResponseData(data: response.data, error: error);
    } catch (e) {
      if (kDebugMode) {
        print("Error during Register User: $e");
      } // Print the error for debugging.  Crucial!

      // More specific error handling if needed:
      if (e is TimeoutException) {
        return ResponseData(data: null, error: "Request timed out");
      } else if (e is SocketException) {
        return ResponseData(data: null, error: "No Internet Connection");
      } else if (e is FormatException) {
        // Example: JSON parsing error
        return ResponseData(data: null, error: "Invalid data format");
      } else {
        return ResponseData(
            data: null,
            error: "An unexpected error occurred: $e"); // Generic error
      }
    }
  }

  Future<ResponseData> forgotUserPassword(email) async {
    String? error;
    try {
      final ResponseData response = await forgotPassword(email);
      error = response.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }

      return ResponseData(data: response.data, error: error);
    } catch (e) {
      if (kDebugMode) {
        print("Error during forgot password: $e");
      } // Print the error for debugging.  Crucial!

      // More specific error handling if needed:
      if (e is TimeoutException) {
        return ResponseData(data: null, error: "Request timed out");
      } else if (e is SocketException) {
        return ResponseData(data: null, error: "No Internet Connection");
      } else if (e is FormatException) {
        // Example: JSON parsing error
        return ResponseData(data: null, error: "Invalid data format");
      } else {
        return ResponseData(
            data: null,
            error: "An unexpected error occurred: $e"); // Generic error
      }
    }
  }

  Future<ResponseData> recoveryPassword(email, code, password) async {
    String? error;
    try {
      final ResponseData response = await verifyPinPassword(email, code);
      error = response.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }
      final ResponseData recovery = await resetPassword(email, password);
      error = recovery.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }
      return ResponseData(data: response.data, error: error);
    } catch (e) {
      if (kDebugMode) {
        print("Error during recovery Password  : $e");
      } // Print the error for debugging.  Crucial!

      // More specific error handling if needed:
      if (e is TimeoutException) {
        return ResponseData(data: null, error: "Request timed out");
      } else if (e is SocketException) {
        return ResponseData(data: null, error: "No Internet Connection");
      } else if (e is FormatException) {
        // Example: JSON parsing error
        return ResponseData(data: null, error: "Invalid data format");
      } else {
        return ResponseData(
            data: null,
            error: "An unexpected error occurred: $e"); // Generic error
      }
    }
  }

  Future logoutUser(context) async {
    final ResponseData result = await logout();
    if (result.error != null) {
      return false;
    }
    Provider.of<SocketClientProvider>(context, listen: false)
        .cleanNotification();
    if (navigatorKey.currentState != null) {
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
}
