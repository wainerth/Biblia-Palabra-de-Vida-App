import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../graphql-config/function_graphql/mutations.dart';

class AuthenticationProvider extends ChangeNotifier {
  final CatalogueProvider _catalogueProvider;
  final BuildContext context;
  String? token;
  bool isAuthenticated = false;
  // LoginUser? currentUser;

  AuthenticationProvider(this.context, this._catalogueProvider) {
    checkAuthentication(context);
  }

  Future<void> checkAuthentication(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? userDataString = prefs.getString('userData');
    if (kDebugMode) {
      print(userToken);
    }
    if (userToken != null && userDataString != null) {
      isAuthenticated = true;
      token = userToken;
      Provider.of<UserProvider>(context, listen: false)
          .setUser(LoginUser.fromJson(jsonDecode(userDataString)));
    } else {
      isAuthenticated = false;
      token = userToken;
      Provider.of<UserProvider>(context, listen: false).setUser(null);
    }
    notifyListeners();
  }

  ///Creamos método para inicio de sesión
  Future loginUser(BuildContext context, String email, String password) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
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
      await prefs.setString("userToken", token);

      // consultamos perfil del usuario
      final ResponseData response = await loadProfileUser(userId, token);
      error = response.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }

      return ResponseData(data: response.data, error: error);
    } catch (e) {
      print(
          "Error during login: $e"); // Print the error for debugging.  Crucial!

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

  loadProfileUser(userId, token) async {
    String? error;
    final userProfile = await getProfileUser(token, userId);
    error = userProfile.error;
    if (error != null) {
      return ResponseData(data: null, error: error);
    }

    // llamamos a achievement
    final UserTitle = await getUserTitle( userId);
    error = UserTitle.error;
    if (UserTitle.error != null) {
      return ResponseData(data: null, error: error);
    }
    userProfile.data['title'] = UserTitle.data;
    // consultamos la liga
    if (userProfile.data["currentLeagueId"] == null) {
      userProfile.data["currentLeagueId"] = "0";
    }
    League? league = _catalogueProvider.allLeagues.firstWhere(
      (element) => element.id == userProfile.data["currentLeagueId"],
      orElse: () => League(
          id: "-1",
          name: "",
          minMembers: 0,
          maxMembers: 0,
          status: "0",
          img: ImageDetails(urlImg: "")),
    );

    // buscamos miembro
    final dataMemberResponse = await getDataMember(token, userId);
    error = dataMemberResponse.error;
    if (error != null) {
      return ResponseData(data: null, error: error);
    }
    final userRanking = dataMemberResponse.data;
    userRanking["leagueId"] = league.id;
    userRanking['leagueName'] = league.name;

    if (league.id != "-1") {
      userProfile.data["league"] = userRanking;
    }
    Provider.of<UserProvider>(context, listen: false)
        .setUser(LoginUser.fromJson(userProfile.data));

    return ResponseData(data: userProfile, error: null);
  }

  Future<ResponseData> loginWithGoogle(BuildContext context) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userResponse = await loginGoogle();
      var error = userResponse.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }
      final userId = userResponse.data["id"];
      final token = userResponse.data["userJwtToken"]["token"];
      await prefs.setString("userToken", token);
      // consultamos perfil del usuario
      final ResponseData response = await loadProfileUser(userId, token);
      error = response.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }
      return ResponseData(data: response.data, error: error);
    } catch (e) {
      print(
          "Error during login: $e"); // Print the error for debugging.  Crucial!

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

      // consultamos perfil del usuario
      final ResponseData response = await loadProfileUser(userId, token);
      error = response.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }

      return ResponseData(data: response.data, error: error);
    } catch (e) {
      print(
          "Error during Register User: $e"); // Print the error for debugging.  Crucial!

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
      print(
          "Error during forgot password: $e"); // Print the error for debugging.  Crucial!

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
      print(
          "Error during recovery Password  : $e"); // Print the error for debugging.  Crucial!

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
  // Future<bool> changePassword(String oldPassword, String newPassword) async {
  //   final MutationOptions options = MutationOptions(
  //     document: gql(r'''
  //       mutation ChangePassword($oldPassword: String!, $newPassword: String!) {
  //         changePassword(oldPassword: $oldPassword, newPassword: $newPassword)
  //       }
  //     '''),
  //     variables: <String, dynamic>{
  //       'oldPassword': oldPassword,
  //       'newPassword': newPassword,
  //     },
  //   );

  //   final QueryResult result = await _client.mutate(options);

  //   if (result.hasException) {
  //     throw Exception(result.exception.toString());
  //   }

  //   return result.data['changePassword'];
  // }

  Future logoutUser(context) async {
    final ResponseData result =  await logout();
    if( result.error != null) {
      return false;
    }
    
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.pushReplacementNamed(context, '/homePage');
    Provider.of<UserProvider>(context, listen: false).setUser(null);
    token = null;
    return true;
  }
}
