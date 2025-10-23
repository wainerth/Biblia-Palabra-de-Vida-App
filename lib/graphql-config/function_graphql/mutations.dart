import 'package:biblia_palabra_de_vida_app/class/RateLimiter.dart';
import 'package:biblia_palabra_de_vida_app/class/SecurityUtils.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:universal_io/io.dart';
import 'dart:async';

import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';

//   -------------Auth User

// Mutation Login with usernameOrEmail and password
String operationName = '';

Future<ResponseData> login(String email, String password) async {
  final GraphQLClient client = createClient();
  operationName = 'LoginUser';
  final MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
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
      "input": {"usernameOrEmail": email, "password": password}
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    if (RateLimiter.isRateLimited(email)) {
      return ResponseData(
        error: 'Demasiados intentos. Espere 15 minutos.',
        data: null,
      );
    }

    final sanitizedPassword = SecurityUtils.prepareInputForGraphQL(password);

    if (!SecurityUtils.isStrongPassword(sanitizedPassword)) {
      RateLimiter.recordAttempt(email);
      return ResponseData(
        data: null,
        error: 'La contraseña no cumple con los requisitos de seguridad',
      );
    }
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Login: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
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
    return handleGenericError(e, operationName);
  }
}

// Mutation Login whit credentials Google account

Future<ResponseData> loginGoogle() async {
  final GraphQLClient client = createClient();

  final GoogleSignIn googleSignIn;

  if (Platform.isAndroid) {
    googleSignIn = GoogleSignIn(
      scopes: [
        "email",
        "profile",
        // "https://www.googleapis.com/auth/user.birthday.read",
        // "https://www.googleapis.com/auth/user.gender.read",
      ],
    );
  } else if (kIsWeb) {
    googleSignIn = GoogleSignIn(
        clientId: GraphQLConfig.clientId,
        forceCodeForRefreshToken: true,
        scopes: ["email"]);
  } else {
    googleSignIn = GoogleSignIn(
        serverClientId: GraphQLConfig.serverClientId,
        forceCodeForRefreshToken: true,
        scopes: [
          "email",
          'https://www.googleapis.com/auth/user.birthday.read'
        ]);
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
  operationName = 'SignUpGoogle';

  final MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
        mutation SignUpGoogle($accessToken: String!) {
          signUpGoogle(accessToken: $accessToken) {
                id
                email
                username
                password
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

  final QueryResult result = await client.mutate(mutateGql);
  try {
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
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Register User
Future<ResponseData> register(SignupInput dataToRegister) async {
  final GraphQLClient client = createClient();
  operationName = 'RegisterUser';
  final MutationOptions mutateGql = MutationOptions(
      operationName: operationName,
      document: gql(r'''
    mutation RegisterUser($input: SignupInput!) {
        registerUser(input: $input) {
          id
          email
          username
          password
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
          "codeAreaId": dataToRegister.codeAreaId,
          "password": dataToRegister.password,
          "name": dataToRegister.name,
          "lastname": dataToRegister.lastname,
          "birthdate": dataToRegister.birthdate,
          "gender":
              dataToRegister.gender != null && dataToRegister.gender!.isNotEmpty
                  ? dataToRegister.gender!.toUpperCase()
                  : dataToRegister.gender,
          "phoneNumber": dataToRegister.phoneNumber,
          "countryId": dataToRegister.countryId,
          "cityId": dataToRegister.city,
          "identifier": dataToRegister.identifier,
          "isBaptized": dataToRegister.isBaptized
        },
      },
      fetchPolicy: FetchPolicy.noCache);

  try {
    final QueryResult result = await client.mutate(mutateGql);

    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Register User: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['registerUser'] == null) {
      return ResponseData(
        data: null,
        error: "Register User No data Result",
      );
    }

    return ResponseData(
      data: removeTypename(data['registerUser']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Update Profile User

Future<ResponseData> updateUserProfile(String token, UserProfile data) async {
  final GraphQLClient client = createClient(authToken: token);
  operationName = 'UpdateDataProfileUsers';
  final MutationOptions mutateGql = MutationOptions(
      operationName: operationName,
      document: gql(r'''
     mutation UpdateDataProfileUsers($userId: ID, $dataProfiles: DataProfiles) {
      updateDataProfileUsers(userId: $userId, dataProfiles: $dataProfiles){
      message
      success
      }
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
          "codeAreaId": data.dataProfiles.profileAreaCode?.id,
          "phoneNumber": data.dataProfiles.phoneNumber!.isEmpty
              ? null
              : data.dataProfiles.phoneNumber,
          "countryId": data.dataProfiles.country?.id,
          "stateId": data.dataProfiles.state?.id,
          "cityId": data.dataProfiles.city?.id,
          "gender": data.dataProfiles.gender!.isEmpty
              ? null
              : data.dataProfiles.gender,
          "isBaptized": data.dataProfiles.isBaptized
        }
      },
      fetchPolicy: FetchPolicy.noCache);

  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Update Data Profile Users: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['updateDataProfileUsers'] == null) {
      return ResponseData(
          data: false, error: "Update Data Profile Users No data returned");
    }
    return ResponseData(data: data['updateDataProfileUsers'], error: null);
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Update User Church

Future<ResponseData> updateChurchUser(
    String token, String userId, String churchId) async {
  final GraphQLClient client = createClient(authToken: token);
  operationName = 'UpdateChurchUser';
  final MutationOptions mutateGql = MutationOptions(
      operationName: operationName,
      document: gql(r'''
      mutation UpdateChurchUser($userId: ID, $churchId: ID) {
        updateChurchUser(userId: $userId, churchId: $churchId)
      }
      '''),
      variables: <String, dynamic>{"userId": userId, "churchId": churchId},
      fetchPolicy: FetchPolicy.noCache);

  try {
    final QueryResult result = await client.mutate(mutateGql);

    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Update Church User: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;

    if (data == null || data['updateChurchUser'] == null) {
      return ResponseData(
        data: null,
        error: 'Update Church User No data return ',
      );
    }

    return ResponseData(
      data: data['updateChurchUser'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation  Recovery Password

Future<ResponseData> forgotPassword(email) async {
  final GraphQLClient client = createClient();
  operationName = 'ForgotPassword';
  final MutationOptions mutateGql = MutationOptions(
      operationName: operationName,
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
    final QueryResult result = await client.mutate(mutateGql);

    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Forgot Password: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['forgotPassword'] == null) {
      return ResponseData(
        data: null,
        error: "Forgot Password No data Result",
      );
    }

    return ResponseData(
      data: removeTypename(data['forgotPassword']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Verify Pin Password

Future verifyPinPassword(email, code) async {
  final GraphQLClient client = createClient();
  operationName = 'verifyPinForPassword';
  final MutationOptions mutateGql = MutationOptions(
      operationName: operationName,
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
    final QueryResult result = await client.mutate(mutateGql);

    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Verify Pin For Password: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['verifyPinForPassword'] == null) {
      return ResponseData(
        data: null,
        error: "Verify Pin For Password No data Result",
      );
    }

    return ResponseData(
      data: removeTypename(data['verifyPinForPassword']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Reset Password

Future resetPassword(email, password) async {
  final GraphQLClient client = createClient();
  operationName = 'ResetPassword';
  final MutationOptions mutateGql = MutationOptions(
      operationName: operationName,
      document: gql(r'''
        mutation ResetPassword($email: String!, $password: String!) {
        resetPassword(email: $email, password: $password) {
          id
          email
          username
          password
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
    final QueryResult result = await client.mutate(mutateGql);

    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Reset Password: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['resetPassword'] == null) {
      return ResponseData(
        data: null,
        error: "Reset Password No data Result",
      );
    }

    return ResponseData(
      data: removeTypename(data['resetPassword']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Logout  User

Future logout() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  final deviceInfo = await PreferencesManager().getDeviceInfo();
  final String token = await PreferencesManager().getUserToken() ?? '';
  String userId = await PreferencesManager().getUserId();
  // eliminamos el dispositivo del usuario
  if (token.isNotEmpty && userId.isNotEmpty) {
    final responseDeleteDevice =
        await deleteDevice(userId, deviceInfo?['deviceId'] ?? '');

    if (responseDeleteDevice.error != null) {
      if (kDebugMode) {
        print('Error deleting device: ${responseDeleteDevice.error}');
      }
    }
  }

  await PreferencesManager().clearOne('userData');
  await PreferencesManager().clearOne('userToken');
  await PreferencesManager().clearOne("selectedBibleVersion");
  await PreferencesManager().clearOne("bookSelected");
  await PreferencesManager().clearOne("chapterSelected");
  await PreferencesManager().clearOne('current_custom_theme');
  return ResponseData(data: true, error: null);
}

// **** Interaction user

// Mutation  Send Score

Future<ResponseData> sendScoreUser(
    String userId, String courseId, String levelId, int failedIntents) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'SendScore';
  MutationOptions mutateGql = MutationOptions(
    operationName: "SendScore",
    document: gql(r'''
      mutation SendScore($userId: ID, $courseId: ID, $levelId: ID, $failedAttempts: Int) {
          sendScore(
            userId: $userId
            courseId: $courseId
            levelId: $levelId
            failedAttempts: $failedAttempts
          ) {
            rewardObtained
            hasBeenPlayedSection
            hasBeenPlayedLevel
            prizeAwarded
            devMessageLevel
            devMessageSection
            rewardData {
              description
              earnedEnergy
              earnedExperience
              id
              sectionId
              status
              title
            }
            titleAwarded
            isLastStage
            isLastLevel
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
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Send Score: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['sendScore'] == null) {
      return ResponseData(
        data: null,
        error: 'Send Score failed: No data returned',
      );
    }

    return ResponseData(
      data: data['sendScore'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null,
        error: '${mutateGql.operationName} Send score Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation redeemed Prize

Future<ResponseData> redeemedPrize(String prizeId, String userId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'RedeemPrize';
  MutationOptions mutateGql = MutationOptions(
    operationName: "RedeemPrize",
    document: gql(r'''
       mutation RedeemPrize($prizeId: ID) {
          redeemPrize(prizeId: $prizeId)
        }
      '''),
    variables: <String, dynamic>{
      "prizeId": prizeId,
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Redeem Prize: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['redeemPrize'] == null) {
      return ResponseData(
        data: null,
        error: 'Redeem Prize Failed: No data returned',
      );
    }

    return ResponseData(
      data: data['redeemPrize'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Redeem Prize Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation open One Promise

Future<ResponseData> openOnePromise(String userId, String promiseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'OpenOnePromise';
  MutationOptions mutateGql = MutationOptions(
    operationName: "OpenOnePromise",
    document: gql(r'''
      mutation OpenOnePromise($userId: ID,  $promiseId: ID) {
        openOnePromise(userId: $userId, promiseId: $promiseId)
      }
      '''),
    variables: <String, dynamic>{"userId": userId, "promiseId": promiseId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Open One Promise: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['openOnePromise'] == null) {
      return ResponseData(
        data: null,
        error: 'Open One Promise failed: No data returned',
      );
    }

    return ResponseData(
      data: data['openOnePromise'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Open One Promise Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation add Favorite Preach

Future<ResponseData> addToFavoritePreach(String userId, String preachId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'AddPreachToFavorite';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
      mutation AddPreachToFavorite($userId: ID, $preachId: ID) {
        addPreachToFavorite(userId: $userId, preachId: $preachId)
      }
      '''),
    variables: <String, dynamic>{"userId": userId, "preachId": preachId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Add Preach To Favorite: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['addPreachToFavorite'] == null) {
      return ResponseData(
        data: null,
        error: 'Add Preach To Favorite failed: No data returned',
      );
    }

    return ResponseData(
      data: data['addPreachToFavorite'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Add Preach To Favorite Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Remove favorite Preach
Future<ResponseData> removePreachFavorite(
    String userId, String preachId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'RemovePreachFavorite';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation RemovePreachFavorite($userId: ID, $preachId: ID) {
        removePreachFavorite(userId: $userId, preachId: $preachId)
      }
      '''),
    variables: <String, dynamic>{"userId": userId, "preachId": preachId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Remove Preach Favorite: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['removePreachFavorite'] == null) {
      return ResponseData(
        data: null,
        error: 'Remove Preach Favorite failed: No data returned',
      );
    }

    return ResponseData(
      data: data['removePreachFavorite'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: '${mutateGql.operationName} Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Create HightLighters

Future<ResponseData> crateHighLighters(List<HighlightRangeModel> input,
    String userId, int bibleVersion, String chapterId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  List<Map<String, dynamic>> dataMap = [];
  for (final lighter in input) {
    dataMap.add({
      "verse": lighter.verse,
      "startIndex": lighter.startIndex,
      "endIndex": lighter.endIndex,
      "color": lighter.color
    });
  }
  operationName = 'AppCreateHighlighter';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation AppCreateHighlighter($input: [HighlightInputApp], $chapterId: ID, $userId: ID, $bibleVersion: Int) {
        appCreateHighlighter(input: $input, chapterId: $chapterId, userId: $userId, bibleVersion: $bibleVersion) {
          id
          bibleVersion
          user {
            id
          }
          startIndex
          endIndex
          color
        }
      }
      '''),
    variables: <String, dynamic>{
      "input": dataMap,
      "userId": userId,
      "bibleVersion": bibleVersion,
      "chapterId": chapterId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'App Create Highlighter: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['appCreateHighlighter'] == null) {
      return ResponseData(
        data: null,
        error: 'App Create Highlighter failed: No data returned',
      );
    }

    return ResponseData(
      data: data['appCreateHighlighter'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: '${mutateGql.operationName} Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Remove HightLighters

Future<ResponseData> removeHighLighters(String verseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'RemoveHighlighter';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation RemoveHighlighter($verseId: ID) {
        removeHighlighter(verseId: $verseId)
      }
      '''),
    variables: <String, dynamic>{"verseId": verseId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Remove Highlighter: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['removeHighlighter'] == null) {
      return ResponseData(
        data: null,
        error: 'Remove Highlighter failed: No data returned',
      );
    }

    return ResponseData(
      data: data['removeHighlighter'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Remove Highlighter Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// mutation Update favorite Verse

Future<ResponseData> updateFavoriteVerse(String userId, String verseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'UpdateFavoriteVerse';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation UpdateFavoriteVerse($userId: ID, $verseId: ID) {
        updateFavoriteVerse(userId: $userId, verseId: $verseId)
      }
      '''),
    variables: <String, dynamic>{
      "verseId": verseId,
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Update Favorite Verse: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['updateFavoriteVerse'] == null) {
      return ResponseData(
        data: null,
        error: 'Update Favorite Verse failed: No data returned',
      );
    }

    return ResponseData(
      data: data['updateFavoriteVerse'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Update Favorite Verse Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Create New Favorite Verse
//
Future<ResponseData> createNewVerseFavoriteByUser(
    String userId, String verseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'CreateNewVerseFavoriteByUser';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation CreateNewVerseFavoriteByUser($userId: ID, $verseId: ID) {
        createNewVerseFavoriteByUser(userId: $userId, verseId: $verseId) {
          success
          message
        }
      }
      '''),
    variables: <String, dynamic>{
      "verseId": verseId,
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Create New Verse Favorite: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['createNewVerseFavoriteByUser'] == null) {
      return ResponseData(
        data: null,
        error: 'Create New Verse Favorite By User failed: No data returned',
      );
    }

    return ResponseData(
      data: data['createNewVerseFavoriteByUser'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null,
        error: 'Create New Verse Favorite By User Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Delete Favorite Verse

Future<ResponseData> deleteVerseFavorite(String userId, String verseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'DeleteVerseFavorite';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation DeleteVerseFavorite($userId: ID, $verseId: ID) {
        deleteVerseFavorite(userId: $userId, verseId: $verseId) {
          success
          message
        }
      }
      '''),
    variables: <String, dynamic>{
      "verseId": verseId,
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Delete Verse Favorite: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['deleteVerseFavorite'] == null) {
      return ResponseData(
        data: null,
        error: 'Delete Verse Favorite failed: No data returned',
      );
    }

    return ResponseData(
      data: data['deleteVerseFavorite'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Delete Verse Favorite Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Mark Read One Notification

Future<ResponseData> markAsReadOneNotification(String notificationId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'MarkAsReadNotification';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation MarkAsReadNotification($userStatusNotificationId: ID) {
        markAsReadNotification(userStatusNotificationId: $userStatusNotificationId) {
          success
          message
        }
      }
      '''),
    variables: <String, dynamic>{
      "userStatusNotificationId": notificationId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Mark As Read Notification: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['markAsReadNotification'] == null) {
      return ResponseData(
        data: null,
        error: 'Mark As Read Notification failed: No data returned',
      );
    }

    return ResponseData(
      data: data['markAsReadNotification'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Mark As Read Notification Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

Future<ResponseData> markAllAsReadNotifications(String userId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'MarkAllAsReadNotifications';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
      mutation MarkAllAsReadNotifications($userId: ID) {
        markAllAsReadNotifications(userId: $userId) {
          message
          success
        }
      }
      '''),
    variables: <String, dynamic>{
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Mark All As Read Notifications: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['markAllAsReadNotifications'] == null) {
      return ResponseData(
        data: null,
        error: 'Mark All As Read Notifications failed: No data returned',
      );
    }

    return ResponseData(
      data: data['markAllAsReadNotifications'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Mark All As Read Notifications Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

//**** Mutation para los juegos *****

// Mutation Save Result Play

Future<ResponseData> saveResultPlay(
    String userId, String difficulty, String category) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'SaveResultByUser';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation SaveResultByUser($userId: ID, $difficulty: String, $category: String) {
        saveResultByUser(userId: $userId, difficulty: $difficulty, category: $category) {
          achievementUnlocked
        }
      }
      '''),
    variables: <String, dynamic>{
      "userId": userId,
      "difficulty": difficulty,
      "category": category,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Save Result By User: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['saveResultByUser'] == null) {
      return ResponseData(
        data: null,
        error: 'Save Result By User failed: No data returned',
      );
    }

    return ResponseData(
      data: data['saveResultByUser'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Save Result By User Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// *** mutación para Prayer

// Mutation Send Request Prayer

Future<ResponseData> sendPrayerRequest(RequestPrayerModel prayer) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  final multipartFile = await MultipartFile.fromPath(
    'audio',
    prayer.audio.path,
    contentType: MediaType('audio', 'aac'),
  );
  operationName = 'CreateRequestPrayer';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation CreateRequestPrayer($inputData: OnePrayer!) {
        createRequestPrayer(inputData: $inputData) {
          successful
          message
          id
        }
      }
      '''),
    variables: <String, dynamic>{
      "inputData": {
        "audio": multipartFile,
        "description": prayer.description,
        "prayerFor": prayer.prayerFor,
        "prayerSubTypeId": prayer.prayerSubTypeId,
        "userId": prayer.userId
      }
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Create Request Prayer: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['createRequestPrayer'] == null) {
      return ResponseData(
        data: null,
        error: 'Create Request Prayer failed: No data returned',
      );
    }

    return ResponseData(
      data: data['createRequestPrayer'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Create Request Prayer Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation delete Request prayer

Future<ResponseData> deleteRequestPrayer(String prayerId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'DeleteRequestPrayer';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation DeleteRequestPrayer($prayerId: ID!) {
        deleteRequestPrayer(prayerId: $prayerId) {
          successful
          message
          id
        }
      }
      '''),
    variables: <String, dynamic>{"prayerId": prayerId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Delete Request Prayer: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['deleteRequestPrayer'] == null) {
      return ResponseData(
        data: null,
        error: 'Delete Request Prayer failed: No data returned',
      );
    }

    return ResponseData(
      data: data['deleteRequestPrayer'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Delete Request Prayer Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Answer Request prayer

Future<ResponseData> answerPrayerRequest(String? message, String requestId,
    String responderId, String? verseId, File? audio) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  //  Prepara el archivo como MultipartFile
  MultipartFile? multipartFile;
  if (audio != null) {
    multipartFile = await MultipartFile.fromPath(
      'audio',
      audio.path,
      contentType: MediaType('audio', 'aac'),
    );
  }
  operationName = 'AnswerPrayerRequest';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation AnswerPrayerRequest($input: AnswerPrayerInput!) {
        answerPrayerRequest(input: $input) {
          successful
          message
          id
        }
      }
      '''),
    variables: <String, dynamic>{
      "input": {
        "audio": multipartFile,
        "message": message,
        "requestId": requestId,
        "responderId": responderId,
        "verseId": verseId
      }
    },
    fetchPolicy: FetchPolicy.noCache,
  );

  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Answer Prayer Request: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['answerPrayerRequest'] == null) {
      return ResponseData(
        data: null,
        error: 'Answer Prayer Request failed: No data returned',
      );
    }

    return ResponseData(
      data: data['answerPrayerRequest'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Answer Prayer Request Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Change Status Request Prayer

Future<ResponseData> changeStatusRequest(
    String? prayerId, String statusLabel) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'ChangeStatusRequest';
  MutationOptions mutateGql = MutationOptions(
    operationName: "ChangeStatusRequest",
    document: gql(r'''
     mutation ChangeStatusRequest($prayerId: ID!, $statusLabel: String) {
      changeStatusRequest(prayerId: $prayerId, statusLabel: $statusLabel) {
          successful
          message
          id
        }
      }
      '''),
    variables: <String, dynamic>{
      "prayerId": prayerId,
      "statusLabel": statusLabel,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Change Status Request: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['changeStatusRequest'] == null) {
      return ResponseData(
        data: null,
        error: 'Change Status Request failed: No data returned',
      );
    }

    return ResponseData(
      data: data['changeStatusRequest'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Change Status Request Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

// Mutation Create Certificate

Future<ResponseData> createCertificate(String? userId, String courseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'CreateCertificate';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation CreateCertificate($userId: ID, $courseId: ID) {
        createCertificate(userId: $userId, courseId: $courseId) {
          success
          rutaArchivo
          nombreArchivo
          mensaje
        }
      }
      '''),
    variables: <String, dynamic>{
      "userId": userId,
      "courseId": courseId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Create Certificate: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['createCertificate'] == null) {
      return ResponseData(
        data: null,
        error: 'Create Certificate failed: No data returned',
      );
    }

    return ResponseData(
      data: data['createCertificate'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Create Certificate Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}

Future<ResponseData> deleteDevice(String userId, String deviceId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'DeleteUserDevice';
  MutationOptions mutateGql = MutationOptions(
    operationName: operationName,
    document: gql(r'''
     mutation DeleteUserDevice($userId: ID!, $deviceId: String!) {
        deleteUserDevice(userId:$userId, deviceId: $deviceId) {
          success
          message
        }
      }
      '''),
    variables: <String, dynamic>{
      "userId": userId,
      "deviceId": deviceId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Delete User Device: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['deleteUserDevice'] == null) {
      return ResponseData(
        data: null,
        error: 'Delete User Device failed: No data returned',
      );
    }

    return ResponseData(
      data: data['deleteUserDevice'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Delete User Device Timeout de conexión $e');
  } catch (e) {
    return handleGenericError(e, operationName);
  }
}
