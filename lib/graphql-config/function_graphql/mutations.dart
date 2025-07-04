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
      "input": {"usernameOrEmail": email, "password": password}
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
    // return ResponseData(
    //   data: null,
    //   error: 'Connection error: $e',
    // );
  }
}

Future<ResponseData> loginGoogle() async {
  final GraphQLClient _client = createClient();

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
  final GraphQLClient _client = createClient(authToken: token);
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
            "gender": dataToRegister.gender != null && dataToRegister.gender.isNotEmpty
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
    // return ResponseData(
    //   data: null,
    //   error: 'Connection error: $e',
    // );
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
    // return ResponseData(
    //   data: null,
    //   error: 'Connection error: $e',
    // );
  }
}

Future logout() async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  await _googleSignIn.signOut();
  // delete credentials in the local stores
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('userData');
  await prefs.remove('userToken');
  await prefs.remove("selectedBibleVersion");
  await prefs.remove("bookSelected");
  await prefs.remove("chapterSelected");
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
    // return ResponseData(
    //   data: null,
    //   error: 'Connection error: $e',
    // );
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
    // return ResponseData(
    //   data: null,
    //   error: 'Connection error: $e',
    // );
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

Future<ResponseData> sendScoreUser(
    userId, courseId, levelId, failedIntents) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "SendScore",
    document: gql(r'''
      mutation SendScore($courseId: ID, $levelId: ID, $failedAttempts: Int, $userId: ID) {
        sendScore(courseId: $courseId, levelId: $levelId, failedAttempts: $failedAttempts, userId: $userId) {
          isLastLevel #es ultimo nivel se la sección
          isLastStage #es ultima etapa del curso
          #prizeWon #premio ganado
          #titleUnlocked #titulo ganado
          rewardObtained #recompensa ganada
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
  } on TimeoutException catch (e) {
    print('Timeout: $e');
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
    // return ResponseData(data: null, error: "connection error $e");
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
  } on TimeoutException catch (e) {
    print('Timeout: $e');
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
    // return ResponseData(data: null, error: "connection error $e");
  }
}

/// unlocked next section
Future<ResponseData> applyRewardToUser(userId, rewardId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

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
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['applyRewardToProfile'] == null) {
      return ResponseData(
        data: null,
        error: 'apply Reward To user failed: No data returned',
      );
    }

    return ResponseData(
      data: data['applyRewardToProfile'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'apply Reward To user Timeout de conexión $e');
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

Future<ResponseData> setTitleObtained(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

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
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['SetTitleToUser'] == null) {
      return ResponseData(
        data: null,
        error: 'set Title for user failed: No data returned',
      );
    }

    return ResponseData(
      data: data['SetTitleToUser'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'set Title for user Timeout de conexión $e');
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

Future<ResponseData> setPrizeObtained(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

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
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['setPrizeToUser'] == null) {
      return ResponseData(
        data: null,
        error: 'set Prize for user failed: No data returned',
      );
    }

    return ResponseData(
      data: data['setPrizeToUser'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'set Prize for user Timeout de conexión $e');
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

  final GraphQLClient _client = createClient(authToken: userToken);

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
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['redeemPrize'] == null) {
      return ResponseData(
        data: null,
        error: 'redeem Prize failed: No data returned',
      );
    }

    return ResponseData(
      data: data['redeemPrize'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'redeem Prize Timeout de conexión $e');
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

Future<ResponseData> openOnePromise(promiseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "OpenOnePromise",
    document: gql(r'''
      mutation OpenOnePromise($promiseId: ID) {
        openOnePromise(promiseId: $promiseId)
      }
      '''),
    variables: <String, dynamic>{"promiseId": promiseId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['openOnePromise'] == null) {
      return ResponseData(
        data: null,
        error: 'open One Promise failed: No data returned',
      );
    }

    return ResponseData(
      data: data['openOnePromise'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'open One Promise Timeout de conexión $e');
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

  final GraphQLClient _client = createClient(authToken: userToken);

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
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['addPredicateToFavorite'] == null) {
      return ResponseData(
        data: null,
        error: 'add Predicate To Favorite failed: No data returned',
      );
    }

    return ResponseData(
      data: data['addPredicateToFavorite'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'add Predicate To Favorite Timeout de conexión $e');
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

  final GraphQLClient _client = createClient(authToken: userToken);
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
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
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
    print('Timeout: $e');
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
Future<ResponseData>  removeHighLighters(String verseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  MutationOptions mutateGql = MutationOptions(
    operationName: "RemoveHighlighter",
    document: gql(r'''
     mutation RemoveHighlighter($verseId: ID) {
        removeHighlighter(verseId: $verseId)
      }
      '''),
    variables: <String, dynamic>{
      "verseId": verseId
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
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
    print('Timeout: $e');
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
Future<ResponseData>  updateFavoriteVerse(String userId ,String verseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

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
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
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
    print('Timeout: $e');
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
Future<ResponseData>  createNewVerseFavoriteByUser(String userId ,String verseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

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
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
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
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Create New Verse Favorite By User Timeout de conexión $e');
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
Future<ResponseData>  deleteVerseFavorite(String userId ,String verseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

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
    final QueryResult result = await _client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
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
    print('Timeout: $e');
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
