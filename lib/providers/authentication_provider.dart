import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  final CatalogueProvider _catalogueProvider;
  final BuildContext context;
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
      Provider.of<UserProvider>(context, listen: false)
          .setUser(LoginUser.fromJson(jsonDecode(userDataString)));
    } else {
      isAuthenticated = false;
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
      final userProfile = await getProfileUser(token, userId);
      error = userProfile.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }

      // llamamos a achievement
      final userAchievement = await getAchievement(token, userId);
      error = userAchievement.error;
      if (userAchievement.error != null) {
        return ResponseData(data: null, error: error);
      }
      userProfile.data['achievement'] = userAchievement.data;
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

      return ResponseData(data: userProfile, error: error);
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
      final userProfile = await getProfileUser(token, userId);
      error = userProfile.error;
      if (error != null) {
        return ResponseData(data: null, error: error);
      }

      // llamamos a achievement
      final userAchievement = await getAchievement(token, userId);
      error = userAchievement.error;
      if (userAchievement.error != null) {
        return ResponseData(data: null, error: error);
      }
      userProfile.data['achievement'] = userAchievement.data;
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

      return ResponseData(data: userProfile, error: error);
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

  // Future<Map<String, dynamic>> registerUser(
  //     String email, String password) async {
  //   final MutationOptions options = MutationOptions(
  //     document: gql(r'''
  //       mutation Register($email: String!, $password: String!) {
  //         register(email: $email, password: $password) {
  //           token
  //           user {
  //             id
  //             email
  //           }
  //         }
  //       }
  //     '''),
  //     variables: <String, dynamic>{
  //       'email': email,
  //       'password': password,
  //     },
  //   );

  //   final QueryResult result = await _client.mutate(options);

  //   if (result.hasException) {
  //     throw Exception(result.exception.toString());
  //   }

  //   return result.data['register'];
  // }

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

  // logoutUser() async {
  //   return true;
  // }
}
