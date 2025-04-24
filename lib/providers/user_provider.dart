import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:flutter/material.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  LoginUser? _user;
  LastProgressUser? _progressUser;
  LoginUser? get currentUser => _user;
  DailyWord? dailyProverb;
  DailyWord? get  getDailyProverb => dailyProverb;

  LastProgressUser? get progressUser => _progressUser;

  UserProvider() {
    _initializeClient();
  }

  Future<void> _initializeClient() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getString('userToken');
  }

  void setUser(LoginUser? user) {
    _user = user;
    // actualizamos localStorage
    if (_user != null) {
      updateStorage(_user);
    }
    notifyListeners();
  }

  void setProgressUser(LastProgressUser? progress) {
    _progressUser = progress;
    // actualizamos localStorage
    notifyListeners();
  }

  Future<void> updateStorage(LoginUser? user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Guardar los datos actualizados en SharedPreferences
    await prefs.setString('userData', jsonEncode(user!.toJson()));
  }

  Future<ResponseData> updateAvatarUser(String userId, String toBase64) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('userToken');
      final GraphQLClient client = createClient(authToken: userToken);
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
      final QueryResult result = await client.mutate(options);

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
      setUser(_user);
      notifyListeners();

      return ResponseData(data: data, error: null);
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

  Future<ResponseData> updateProfile(UserProfile data) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('userToken');
      final response = await updateUserProfile(userToken, data);
      if (response.error != null) {
        return ResponseData(data: null, error: response.error);
      }
      _user = _user?.copyWith(
          name: data.dataProfiles.name,
          lastname: data.dataProfiles.lastname,
          city: data.dataProfiles.city,
          gender: data.dataProfiles.gender,
          birthdate: data.dataProfiles.birthdate,
          identifier: data.dataProfiles.identifier,
          phoneNumber: data.dataProfiles.phoneNumber,
          country: data.dataProfiles.country,
          isBaptized: data.dataProfiles.isBaptized);
      setUser(_user);
      return ResponseData(data: response.data, error: null);
    } catch (e) {
      print(
          "Error Update profile : $e"); // Print the error for debugging.  Crucial!

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

  Future updateUserChurch(userId, churchId, churches) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userToken = prefs.getString('userToken');
      final response = await updateChurchUser(userToken, userId, churchId);
      if (response.error != null) {
        return ResponseData(data: null, error: null);
      }
      var current = currentUser!.user;
      if (current.userChurch.isEmpty) {
        // add church
        final findChurch = churches.firstWhere((ch) => ch.id == churchId);
        List<UserChurch> newChurch = [];
        newChurch.add(UserChurch(
            id: findChurch.id, name: findChurch!.name, status: true));
        current = current.copyWith(userChurch: newChurch);
      } else {
        // search churches and set value status in false and church selected en true
        List<UserChurch> newChurch = List.from(current.userChurch);
        for (int i = 0; i < newChurch.length; i++) {
          newChurch[i] = newChurch[i].copyWith(status: false);
        }

        bool iglesiaEncontrada =
            false; // Variable para controlar si la iglesia ya existe

        // 2. Buscar la iglesia y actualizar su estado o agregarla
        for (int i = 0; i < newChurch.length; i++) {
          if (newChurch[i].id == churchId) {
            newChurch[i] =
                newChurch[i].copyWith(status: true); // Actualizar el estado
            iglesiaEncontrada = true;
            break; // Salir del bucle, ya se encontró la iglesia
          }
        }

        if (!iglesiaEncontrada) {
          final findChurch = churches.firstWhere((ch) => ch.id == churchId);
          // La iglesia no existe, agregarla a la lista
          newChurch.add(UserChurch(
              id: findChurch.id,
              name: findChurch.name,
              status: true)); // Agregar nueva iglesia
        }
        current = current.copyWith(userChurch: newChurch);
      }

      _user = _user?.copyWith(
          name: _user?.name,
          lastname: _user?.lastname,
          city: _user?.city,
          gender: _user?.gender,
          birthdate: _user?.birthdate,
          identifier: _user?.identifier,
          phoneNumber: _user?.phoneNumber,
          country: _user?.country,
          isBaptized: _user?.isBaptized,
          createdAt: _user?.createdAt,
          achievementsReachedCount: _user?.achievementsReachedCount,
          favoriteVerseId: _user?.favoriteVerseId,
          notifications: _user?.notifications,
          preachingsCreatedCount: _user?.preachingsCreatedCount,
          streakDaysCount: _user?.streakDaysCount,
          user: current);
      setUser(_user);
      return ResponseData(data: response.data, error: null);
    } catch (e) {
      print(
          "Error during update church: $e"); // Print the error for debugging.  Crucial!

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

  Future<ResponseData?> getProgressUser(userId, courseId) async {
    LastProgressUser? userProgress;
    final progress = await getLastProgressUser(userId, courseId);
    if (progress.error != null) {
      return ResponseData(error: progress.error, data: null);
    }

    if (progress.data == null || progress.data['data'] == null) {
       return ResponseData(error: null, data: null);
    } else {
      userProgress = LastProgressUser.fromMap(progress.data['data']);
      setProgressUser(userProgress);
      return ResponseData(error: null, data: userProgress);
    }
  }
}
