import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/models/response_data.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

Future login(email, password) async {
  final GraphQLClient _client = createClient();

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
      "input": {"username": email, "password": password}
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.mutate(options);
    print(result.hasException);
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
    return ResponseData(
      data: removeTypename(data['loginUser']),
      error: null,
    );
  } catch (e) {
    return ResponseData(
      data: null,
      error: 'Connection error: $e',
    );
  }
}

Future<ResponseData> loginGoogle() async {
  final GraphQLClient _client = createClient();

  final GoogleSignIn googleSignIn;
  if (Platform.isAndroid) {
    googleSignIn = GoogleSignIn();
  } else if(kIsWeb){

    googleSignIn = GoogleSignIn(
        clientId:
            "823422522259-lsaj5empb8t54pims7m727krgrcfu6lf.apps.googleusercontent.com",
        forceCodeForRefreshToken: true,
        scopes: ["email"]);

  } else {
    googleSignIn = GoogleSignIn(
        serverClientId:
            "214929717096-c669jpm1gb9q87cribgbknuteemuj8st.apps.googleusercontent.com",
        forceCodeForRefreshToken: true,
        scopes: ["email"]);
  }

  final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
  if (googleUser == null) {
    return ResponseData(
      data: null,
      error: 'User canceled the sign-in',
    );
  }

  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  final String? accessToken = googleAuth.accessToken;

  if (accessToken == null) {
    return ResponseData(
      data: null,
      error: 'Google Authentication: Failed to obtain Google tokens',
    );
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
  return ResponseData(
    data: removeTypename(data['signUpGoogle']),
    error: null,
  );
}

Future updateUserProfile(token, UserProfile data) async {
  final GraphQLClient _client = createClient(authToken: token);

  final MutationOptions mutateGql = MutationOptions(
      operationName: "UpdateDataProfileUsers",
      document: gql(r'''
      mutation UpdateDataProfileUsers($userId: ID, $dataProfiles: dataProfiles) {
      updateDataProfileUsers(userId: $userId, dataProfiles: $dataProfiles)
    }
 '''),
      variables: <String, dynamic>{
        "userId": data.userId,
        "dataProfiles": {
          "lastname": data.dataProfiles.lastname,
          "name": data.dataProfiles.name,
          "birthdate": data.dataProfiles.birthdate!.isEmpty
              ? null
              : data.dataProfiles.birthdate,
          "identifier": data.dataProfiles.identifier!.isEmpty
              ? null
              : data.dataProfiles.identifier,
          "phoneNumber": data.dataProfiles.phoneNumber!.isEmpty
              ? null
              : data.dataProfiles.phoneNumber,
          "countryId": data.dataProfiles.country?.id,
          "city":
              data.dataProfiles.city!.isEmpty ? null : data.dataProfiles.city,
          "gender": data.dataProfiles.gender!.isEmpty
              ? null
              : data.dataProfiles.gender,
          "isBaptized": data.dataProfiles.isBaptized.toString()
        }
      },
      fetchPolicy: FetchPolicy.noCache);

  try {
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      print(ResponseData.fromQueryResult(result));
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['updateDataProfileUsers'] == null) {
      print("No data returned");
      return ResponseData(data: false, error: "No data returned");
      // return false;
    }
    return ResponseData(data: data['updateDataProfileUsers'], error: null);
  } catch (e) {
    ResponseData(data: null, error: "connection error $e");
  }
}

Future updateChurchUser(token, userId, churchId) async {
  final GraphQLClient _client = createClient(authToken: token);
  final MutationOptions mutateGql = MutationOptions(
      operationName: "UpdateChurchUser",
      document: gql(r'''
      mutation UpdateChurchUser($userId: ID, $churchIds: [ID]) {
        updateChurchUser(userId: $userId, churchIds: $churchIds)
      }
      '''),
      variables: <String, dynamic>{"userId": userId, "churchIds": churchId},
      fetchPolicy: FetchPolicy.noCache);

  try {
    final QueryResult result = await _client.mutate(mutateGql);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;

    if (data == null || data['updateChurchUser'] == null) {
      return ResponseData(
        data: null,
        error: 'No data return ',
      );
    }

    return ResponseData(
      data: data['updateChurchUser'],
      error: null,
    );
  } catch (e) {}
}

Future register(dataToRegister) async {
  final GraphQLClient _client = createClient();

  // var data = dataToRegister.toJson();
  final MutationOptions mutateGql = MutationOptions(
      operationName: "RegisterUser",
      document: gql(r'''
    mutation RegisterUser($input: SignupInput!) {
        registerUser(input: $input) {
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
        "input": {
          "username": dataToRegister.username,
          "email": dataToRegister.email,
          "countryCode": dataToRegister.countryCode,
          "password": dataToRegister.password,
          "name": dataToRegister.name,
          "lastname": dataToRegister.lastname,
          "birthdate": dataToRegister.birthdate,
          "gender": dataToRegister.gender,
          "phoneNumber": dataToRegister.phoneNumber,
          "countryId": dataToRegister.countryId,
          "city": dataToRegister.city,
          "identifier": dataToRegister.identifier,
          "isBaptized": dataToRegister.isBaptized
        },
      },
      fetchPolicy: FetchPolicy.noCache);

  try {
    final QueryResult result = await _client.mutate(mutateGql);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['registerUser'] == null) {
      return ResponseData(
        data: null,
        error: "No data Result",
      );
    }

    return ResponseData(
      data: removeTypename(data['registerUser']),
      error: null,
    );
  } catch (e) {
    return ResponseData(
      data: null,
      error: 'Connection error: $e',
    );
  }
}

Future<ResponseData> forgotPassword(email) async {
  final GraphQLClient _client = createClient();
  final MutationOptions mutateGql = MutationOptions(
      operationName: "ForgotPassword",
      document: gql(r'''
      mutation ForgotPassword($email: String!) {
        forgotPassword(email: $email) {
          message
        }
      }
'''),
      variables: <String, dynamic>{'email': email},
      fetchPolicy: FetchPolicy.noCache);
  try {
    final QueryResult result = await _client.mutate(mutateGql);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['forgotPassword'] == null) {
      return ResponseData(
        data: null,
        error: "No data Result",
      );
    }

    return ResponseData(
      data: removeTypename(data['forgotPassword']),
      error: null,
    );
  } catch (e) {
    return ResponseData(
      data: null,
      error: 'Connection error: $e',
    );
  }
}

Future logout() async {
  // delete credentials in the local stores
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userData');
  await prefs.remove('userToken');
  return ResponseData(data: true, error: null);
}

Future verifyPinPassword(email, code) async {
  final GraphQLClient _client = createClient();
  final MutationOptions mutateGql = MutationOptions(
      operationName: "VerifyPinForPassword",
      document: gql(r'''
        mutation VerifyPinForPassword($email: String, $code: String) {
        verifyPinForPassword(email: $email, code: $code) {
          token
          message
          success
        }
      }
'''),
      variables: <String, dynamic>{'email': email, 'code': code},
      fetchPolicy: FetchPolicy.noCache);
  try {
    final QueryResult result = await _client.mutate(mutateGql);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['verifyPinForPassword'] == null) {
      return ResponseData(
        data: null,
        error: "No data Result",
      );
    }

    return ResponseData(
      data: removeTypename(data['verifyPinForPassword']),
      error: null,
    );
  } catch (e) {
    return ResponseData(
      data: null,
      error: 'Connection error: $e',
    );
  }
}

Future resetPassword(email, password) async {
  final GraphQLClient _client = createClient();
  final MutationOptions mutateGql = MutationOptions(
      operationName: "ResetPassword",
      document: gql(r'''
        mutation ResetPassword($email: String!, $password: String!) {
        resetPassword(email: $email, password: $password) {
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
      variables: <String, dynamic>{'email': email, 'password': password},
      fetchPolicy: FetchPolicy.noCache);
  try {
    final QueryResult result = await _client.mutate(mutateGql);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['resetPassword'] == null) {
      return ResponseData(
        data: null,
        error: "No data Result",
      );
    }

    return ResponseData(
      data: removeTypename(data['resetPassword']),
      error: null,
    );
  } catch (e) {
    return ResponseData(
      data: null,
      error: 'Connection error: $e',
    );
  }
}

Future<ResponseData> sendResponsesUser(List responses) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "SendResponsesUser",
    document: gql(r'''
    mutation SendResponsesUser($input: ResponseInput) {
  sendResponsesUser(input: $input) {
    id
    userId
    answerId
  }
}
      '''),
    variables: <String, dynamic>{
      "input": {"arrayResponse": responses},
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['sendResponsesUser'] == null) {
      return ResponseData(
        data: null,
        error: 'send responses user failed: No data returned',
      );
    }

    return ResponseData(
      data: data['sendResponsesUser'],
      error: null,
    );
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future<ResponseData> sendScoreUser(userId, courseId, levelId, failedIntents) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "SendScore",
    document: gql(r'''
      mutation SendScore($courseId: ID, $levelId: ID, $failedAttempts: Int, $userId: ID) {
        sendScore(courseId: $courseId, levelId: $levelId, failedAttempts: $failedAttempts, userId: $userId) {
          isLastLevel
          isLastStage
          prizeWon
          titleUnlocked
          rewardObtained
        }
      }
      '''),
    variables: <String, dynamic>{
      "userId": userId,
      "courseId": courseId,
      "levelId": levelId,
      "failedAttempts": failedIntents
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['sendScore'] == null) {
      return ResponseData(
        data: null,
        error: 'send score failed: No data returned',
      );
    }

    return ResponseData(
      data: data['sendScore'],
      error: null,
    );
  }  on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Send score Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

/// unlocked next section
Future<ResponseData> unlockedNextSection(userId, sectionId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "UnlockNextSection",
    document: gql(r'''
      mutation UnlockNextSection($userId: ID, $sectionId: ID) {
        unlockNextSection(userId: $userId, sectionId: $sectionId)
      }
      '''),
    variables: <String, dynamic>{
      "userId": userId,
      "sectionId": sectionId
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['unlockNextSection'] == null) {
      return ResponseData(
        data: null,
        error: 'unlock Next Section failed: No data returned',
      );
    }

    return ResponseData(
      data: data['unlockNextSection'],
      error: null,
    );
  }  on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'unlock Next Section Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}