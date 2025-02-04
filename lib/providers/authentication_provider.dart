import 'dart:convert';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

class AuthenticationProvider extends ChangeNotifier {
  late GraphQLClient _client;
  bool isAuthenticated = false;
  LoginUser? currentUser;

  AuthenticationProvider() {
    checkAuthentication();
    _initClient();
  }

  _initClient() {
    _client = createClient();
  }

  Future<void> checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    String? userDataString = prefs.getString('userData');
    print(userToken);
    if (userToken != null && userDataString != null) {
      _client = createClient(authToken: userToken);
      isAuthenticated = true;
      currentUser = LoginUser.fromJson(jsonDecode(userDataString));
    } else {
      isAuthenticated = false;
      currentUser = null;
    }
    notifyListeners();
  }

  ///Creamos método para inicio de sesión
  Future loginUser(String email, String password) async {
    _client = createClient();
    var responseData = null;

    final MutationOptions options = MutationOptions(
      operationName: 'LoginUser',
      document: gql(r'''
        mutation LoginUser($input: LoginInput!) {
          loginUser(input: $input) {
            id
            userJwtToken {
              token
            }
          }
        }
      '''),
      variables: <String, dynamic>{
        "input": {"username": "Leonardog", "password": "123456"}
      },
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      final QueryResult result = await _client.mutate(options);
      if (result.hasException) {
        return ResponseData.fromQueryResult(result);
      }

      final data = result.data;
      if (data == null || data['loginUser'] == null) {
        return ResponseData(
          data: null,
          error: 'Login failed: No data returned',
        );
      }
      var dto = removeTypename(data['loginUser']);

      // consultamos ProfileServices
      _client = createClient(authToken: dto["userJwtToken"]["token"]);
      ResponseData profile = await getProfileUser(dto["id"]);
      if (profile.error != null) {
        return ResponseData(
          data: null,
          error: profile.error,
        );
      }

      // almacenamos en local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //  almacenamos la data
      currentUser = LoginUser.fromJson(profile.data);
      print(currentUser);
      await prefs.setString('userData', jsonEncode(currentUser!.toJson()));

      await prefs.setString('userToken', dto["userJwtToken"]["token"]);

// retornamos data
      return ResponseData(
        data: dto,
        error: null,
      );
    } catch (e) {
      return ResponseData(
        data: null,
        error: 'Connection error: $e',
      );
    }
  }

  Future<ResponseData> getProfileUser(idUser) async {
    final QueryOptions options = QueryOptions(
      operationName: 'GetOneProfileByUserId',
      document: gql(r'''
                  query GetOneProfileByUserId($userId: ID) {
                    getOneProfileByUserId(userId: $userId) {
                      name # nombre y apellido
                      expTotalUser #energia
                      imgProfileUser
                      phoneNumber
                      country {
                        id
                        country
                        country_code
                      }
                      favoriteVerseId # si asigna versiculo favorito
                      notifications # notification user
                        lastName 
                        birthday
                        identifier #cédula
                        gender
                        isBaptized
                        currentLeagueId #future ligue in ranking
                      createdAt # fecha registro
                      achievementsReachedCount #contador de logros
                      streakDaysCount # contador de dias 
                      preachingsCreatedCount # cantidad de predicas
                      user {
                        id
                        username
                        email
                        lastLogin
                        rolId
                        userChurch {
                        churchId
                        status
                          churchRelation {
                            name
                          }
                        }
                      }
                    }
                  }

'''),
      variables: <String, dynamic>{"userId": idUser},
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      final QueryResult result = await _client.query(options);
      if (result.hasException) {
        return ResponseData.fromQueryResult(result);
      }

      final data = result.data;
      if (data == null || data['getOneProfileByUserId'] == null) {
        return ResponseData(
          data: null,
          error: 'Profile User failed: No data returned',
        );
      }
      return ResponseData(
        data: removeTypename(data['getOneProfileByUserId']),
        error: null,
      );
    } catch (e) {
      return ResponseData(
        data: null,
        error: 'Connection error: $e',
      );
    }
  }

  Future<ResponseData> loginWithGoogle() async {
    _client = createClient();

    final GoogleSignIn googleSignIn;
    if (kIsWeb || Platform.isAndroid) {
      googleSignIn = GoogleSignIn();
    } else {
      googleSignIn = GoogleSignIn(
          serverClientId:
              "214929717096-c669jpm1gb9q87cribgbknuteemuj8st.apps.googleusercontent.com",
          forceCodeForRefreshToken: true,
          scopes: ["email"]);
    }
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return ResponseData(
          data: null,
          error: 'User canceled the sign-in',
        );
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? accessToken = googleAuth.accessToken;

      if (accessToken == null) {
        throw Exception('Failed to obtain Google tokens');
      }

      final MutationOptions options = MutationOptions(
        operationName: 'SignUpGoogle',
        document: gql(r'''
        mutation SignUpGoogle($accessToken: String!) {
          signUpGoogle(accessToken: $accessToken) {
                id
                email
                username
                password
                rolId
                imgProfileUser
                userJwtToken {
                  token
                }
          }
        }
      '''),
        variables: <String, dynamic>{
          'accessToken': accessToken,
        },
        fetchPolicy: FetchPolicy.noCache,
      );

      final QueryResult result = await _client.mutate(options);
      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final data = result.data;
      if (data == null || data['signUpGoogle'] == null) {
        return ResponseData(
          data: null,
          error: 'Login failed: No data returned',
        );
      }
      var dto = removeTypename(data['signUpGoogle']);
      // consultamos ProfileServices
      _client = createClient(authToken: dto["userJwtToken"]["token"]);
      ResponseData profile = await getProfileUser(dto["id"]);
      if (profile.error != null) {
        return ResponseData(
          data: null,
          error: profile.error,
        );
      }

      // almacenamos en local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //  almacenamos la data
      currentUser = LoginUser.fromJson(profile.data);
      print(currentUser);
      await prefs.setString('userData', jsonEncode(currentUser!.toJson()));

      await prefs.setString('userToken', dto["userJwtToken"]["token"]);
  
      return ResponseData(
        data: dto,
        error: null,
      );
    } catch (e) {
      return ResponseData(data: null, error: "Google sign-in failed: $e");
    }
  }

  loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDataString = prefs.getString('userData');

    if (userDataString != null) {
      return LoginUser.fromJson(jsonDecode(userDataString));
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
