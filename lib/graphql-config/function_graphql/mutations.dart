import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_io/io.dart';

Future login(email, password) async {
  final GraphQLClient client = createClient();

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
      "input": {"usernameOrEmail": email, "password": password}
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.mutate(options);
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
        clientId:
            "823422522259-lsaj5empb8t54pims7m727krgrcfu6lf.apps.googleusercontent.com",
        forceCodeForRefreshToken: true,
        scopes: ["email"]);
  } else {
    googleSignIn = GoogleSignIn(
        serverClientId:
            "214929717096-c669jpm1gb9q87cribgbknuteemuj8st.apps.googleusercontent.com",
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

  final MutationOptions options = MutationOptions(
    operationName: 'SignUpGoogle',
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

  final QueryResult result = await client.mutate(options);
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
  final GraphQLClient client = createClient(authToken: token);

  final MutationOptions mutateGql = MutationOptions(
      operationName: "UpdateDataProfileUsers",
      document: gql(r'''
     mutation UpdateDataProfileUsers($userId: ID, $dataProfiles: DataProfiles) {
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
          "codeAreaId": data.dataProfiles.profileAreaCode?.id,
          "phoneNumber": data.dataProfiles.phoneNumber!.isEmpty
              ? null
              : data.dataProfiles.phoneNumber,
          "countryId": data.dataProfiles.country?.id,
          "city":
              data.dataProfiles.city!.isEmpty ? null : data.dataProfiles.city,
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
    // ResponseData(data: null, error: "connection error $e");
  }
}

Future updateChurchUser(token, userId, churchId) async {
  final GraphQLClient client = createClient(authToken: token);
  final MutationOptions mutateGql = MutationOptions(
      operationName: "UpdateChurchUser",
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

Future register(dataToRegister) async {
  final GraphQLClient client = createClient();

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
              dataToRegister.gender != null && dataToRegister.gender.isNotEmpty
                  ? dataToRegister.gender.toUpperCase()
                  : dataToRegister.gender,
          "phoneNumber": dataToRegister.phoneNumber,
          "countryId": dataToRegister.countryId,
          "city": dataToRegister.city,
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

Future<ResponseData> forgotPassword(email) async {
  final GraphQLClient client = createClient();
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

Future logout() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
  // delete credentials in the local stores
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userData');
  await prefs.remove('userToken');
  await prefs.remove("selectedBibleVersion");
  await prefs.remove("bookSelected");
  await prefs.remove("chapterSelected");
  await prefs.remove('current_custom_theme');
  return ResponseData(data: true, error: null);
}

Future verifyPinPassword(email, code) async {
  final GraphQLClient client = createClient();
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

Future resetPassword(email, password) async {
  final GraphQLClient client = createClient();
  final MutationOptions mutateGql = MutationOptions(
      operationName: "ResetPassword",
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

Future<ResponseData> sendResponsesUser(List responses) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

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
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      if (kDebugMode) {
        return ResponseData.fromQueryResult(result);
      } else {
        return ResponseData(
          data: null,
          error:
              'Send Responses User: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['sendResponsesUser'] == null) {
      return ResponseData(
        data: null,
        error: 'Send Responses User failed: No data returned',
      );
    }

    return ResponseData(
      data: data['sendResponsesUser'],
      error: null,
    );
  } catch (e) {
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> sendScoreUser(
    userId, courseId, levelId, failedIntents) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  // mutation SendScore($courseId: ID, $levelId: ID, $failedAttempts: Int, $userId: ID) {
  //   sendScore(courseId: $courseId, levelId: $levelId, failedAttempts: $failedAttempts, userId: $userId) {
  //     isLastLevel #es ultimo nivel se la sección
  //     isLastStage #es ultima etapa del curso
  //     #prizeWon #premio ganado
  //     #titleUnlocked #titulo ganado
  //     rewardObtained #recompensa ganada
  //   }
  // }
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
    return ResponseData(data: null, error: 'Send score Timeout de conexión $e');
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

/// unlocked next section
Future<ResponseData> unlockedNextSection(userId, sectionId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "UnlockNextSection",
    document: gql(r'''
      mutation UnlockNextSection($userId: ID, $sectionId: ID) {
        unlockNextSection(userId: $userId, sectionId: $sectionId){
        successful
        nextSectionId
        }
      }
      '''),
    variables: <String, dynamic>{"userId": userId, "sectionId": sectionId},
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
              'Unlock Next Section: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['unlockNextSection'] == null) {
      return ResponseData(
        data: null,
        error: 'Unlock Next Section failed: No data returned',
      );
    }

    return ResponseData(
      data: data['unlockNextSection'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'unlock Next Section Timeout de conexión $e');
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

/// unlocked next section
Future<ResponseData> applyRewardToUser(userId, rewardId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "ApplyRewardToProfile",
    document: gql(r'''
        mutation ApplyRewardToProfile($userId: ID, $rewardId: ID) {
          applyRewardToProfile(userId: $userId, rewardId: $rewardId) {
            earnedEnergy
            earnedExperience
          }
        }
      '''),
    variables: <String, dynamic>{"userId": userId, "rewardId": rewardId},
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
              'Apply Reward To User: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['applyRewardToProfile'] == null) {
      return ResponseData(
        data: null,
        error: 'Apply Reward To User failed: No data returned',
      );
    }

    return ResponseData(
      data: data['applyRewardToProfile'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Apply Reward To User Timeout de conexión $e');
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

Future<ResponseData> setTitleObtained(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "SetTitleToUser",
    document: gql(r'''
        mutation SetTitleToUser($userId: ID, $courseId: ID) {
          setTitleToUser(userId: $userId, courseId: $courseId) {
            id
            courseId
            description
            img {
              urlImg
            }
            unLockTitle
            status
          }
        }
      '''),
    variables: <String, dynamic>{"userId": userId, "courseId": courseId},
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
              'Set Title For User: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['SetTitleToUser'] == null) {
      return ResponseData(
        data: null,
        error: 'Set Title For User failed: No data returned',
      );
    }

    return ResponseData(
      data: data['SetTitleToUser'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Set Title For User Timeout de conexión $e');
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

Future<ResponseData> setPrizeObtained(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "SetPrizeToUser",
    document: gql(r'''
        mutation SetPrizeToUser($userId: ID, $courseId: ID) {
        setPrizeToUser(userId: $userId, courseId: $courseId) {
          id
          courseId
          biblicalName
          typeStone
          description
          img {
            urlImg
          }
          exchangeValue
          unLockPrize
          status
          }
        }
      '''),
    variables: <String, dynamic>{"userId": userId, "courseId": courseId},
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
              'Set Prize For User: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['setPrizeToUser'] == null) {
      return ResponseData(
        data: null,
        error: 'Set Prize For User failed: No data returned',
      );
    }

    return ResponseData(
      data: data['setPrizeToUser'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Set Prize For User Timeout de conexión $e');
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
    // return ResponseData(data: null, error: "connection error $e");
  }
}

Future<ResponseData> redeemedPrize(prizeId, userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

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

Future<ResponseData> openOnePromise(String userId, String promiseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

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
    // return ResponseData(data: null, error: "connection error $e");
  }
}

Future<ResponseData> addToFavoritePreach(userId, preachId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "AddPredicateToFavorite",
    document: gql(r'''
     mutation AddPredicateToFavorite($userId: ID, $preachId: ID) {
        addPredicateToFavorite(userId: $userId, preachId: $preachId)
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
              'Add Predicate To Favorite: Ocurrió un error inesperado. Nuestro equipo ya está trabajando para solucionarlo.',
        );
      }
    }

    final data = result.data;
    if (data == null || data['addPredicateToFavorite'] == null) {
      return ResponseData(
        data: null,
        error: 'Add Predicate To Favorite failed: No data returned',
      );
    }

    return ResponseData(
      data: data['addPredicateToFavorite'],
      error: null,
    );
  } on TimeoutException catch (e) {
    return ResponseData(
        data: null, error: 'Add Predicate To Favorite Timeout de conexión $e');
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
    // return ResponseData(data: null, error: "connection error $e");
  }
}

Future<ResponseData> crateHighLighters(List<HighlightRangeModel> input,
    String userId, int bibleVersion, String chapterId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

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

  MutationOptions mutateGql = MutationOptions(
    operationName: "AppCreateHighlighter",
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
        data: null, error: 'App Create Highlighter Timeout de conexión $e');
  } catch (e) {
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> removeHighLighters(String verseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "RemoveHighlighter",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> updateFavoriteVerse(String userId, String verseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "UpdateFavoriteVerse",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> createNewVerseFavoriteByUser(
    String userId, String verseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "CreateNewVerseFavoriteByUser",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> deleteVerseFavorite(String userId, String verseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "DeleteVerseFavorite",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> markAsReadOneNotification(String notificationId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "MarkAsReadNotification",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

/// Mutation para los juegos
Future<ResponseData> saveResultPlay(
    String userId, String difficulty, String category) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "SaveResultByUser",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

// mutación para Prayer
Future<ResponseData> sendPrayerRequest(RequestPrayerModel prayer) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);
  //  Prepara el archivo como MultipartFile
  final multipartFile = await MultipartFile.fromPath(
    'audio', // Nombre del campo en GraphQL (mutation)
    prayer.audio.path,
    contentType: MediaType('audio', 'aac'), // Ajusta según tu formato
  );

  MutationOptions mutateGql = MutationOptions(
    operationName: "CreateRequestPrayer",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> deleteRequestPrayer(String prayerId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "DeleteRequestPrayer",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> answerPrayerRequest(String? message, String requestId,
    String responderId, String? verseId, File? audio) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);
  //  Prepara el archivo como MultipartFile
  MultipartFile? multipartFile;
  if (audio != null) {
    multipartFile = await MultipartFile.fromPath(
      'audio', // Nombre del campo en GraphQL (mutation)
      audio.path,
      contentType: MediaType('audio', 'aac'), // Ajusta según tu formato
    );
  }

  MutationOptions mutateGql = MutationOptions(
    operationName: "AnswerPrayerRequest",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> changeStatusRequest(
    String? prayerId, String statusLabel) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}

Future<ResponseData> createCertificate(String? userId, String courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "CreateCertificate",
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
    if (e is TimeoutException) {
      return ResponseData(data: null, error: "Request timed out");
    } else if (e is SocketException) {
      return ResponseData(data: null, error: "No Internet Connection");
    } else if (e is FormatException) {
      return ResponseData(data: null, error: "Invalid data format");
    } else {
      return ResponseData(
          data: null,
          error: "An unexpected error occurred: $e"); // Generic error
    }
  }
}
