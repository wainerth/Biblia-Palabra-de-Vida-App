import 'dart:convert';

import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/material.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  late GraphQLClient _client;
  LoginUser? _user;

  LoginUser? get currentUser => _user;

  UserProvider() {
    _initializeClient();
  }

  Future<void> _initializeClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('userToken');
    _client = createClient(authToken: userToken);
  }

  void setUser(LoginUser? user) {
    _user = user;
    // actualizamos localStorage
    updateStorage(_user);
    notifyListeners();
  }

  Future<void> updateStorage(LoginUser? user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Guardar los datos actualizados en SharedPreferences
    await prefs.setString('userData', jsonEncode(user!.toJson()));
  }

  Future<ResponseData> updateAvatarUser(String userId, String toBase64) async {
    if (userId.isEmpty || toBase64.isEmpty) {
      return ResponseData(
        data: null,
        error: 'User ID or Image Data is empty',
      );
    }

    final MutationOptions options = MutationOptions(
      operationName: 'UpdateImageProfile',
      document: gql(r'''
        mutation UpdateImageProfile($userId: ID!, $images: String!) {
          updateImageProfile(userId: $userId, images: $images) {
            imgProfileUser
          }
        }
      '''),
      variables: {"userId": userId, "images": toBase64},
      fetchPolicy: FetchPolicy.noCache,
    );

    try {
      print(toBase64);
      final QueryResult result = await _client.mutate(options);

      if (result.hasException) {
        return ResponseData.fromQueryResult(result);
      }

      final data = result.data;
      if (data == null || data["updateImageProfile"] == null) {
        return ResponseData(
          data: null,
          error: 'Update Image Profile failed: No data returned',
        );
      }

      // Actualiza la imagen del usuario si la mutación fue exitosa
      _user = _user?.copyWith(
          imgProfileUser: data["updateImageProfile"]["imgProfileUser"]);
      notifyListeners();

      return ResponseData(data: data, error: null);
    } catch (e) {
      return ResponseData(
        data: null,
        error: 'Connection error: $e',
      );
    }
  }

  Future<ResponseData> updateProfile(data) async {
    //lógica para actualizar datos
    _user = _user?.copyWith(
        imgProfileUser: data["updateImageProfile"]["imgProfileUser"]);
    return ResponseData(data: null, error: null);
  }

}
