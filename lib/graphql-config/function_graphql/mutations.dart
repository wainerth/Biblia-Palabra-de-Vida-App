import 'package:biblia_palabra_de_vida_app/class/rate_limiter.dart';
import 'package:biblia_palabra_de_vida_app/class/security_utils.dart';
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
        userFriendlyError:
            'Has excedido el número de intentos de inicio de sesión. Por favor, inténtalo de nuevo más tarde.',
        error: 'Demasiados intentos. Espere 15 minutos.',
        data: null,
      );
    }

    final sanitizedPassword = SecurityUtils.prepareInputForGraphQL(password);

    if (!SecurityUtils.isStrongPassword(sanitizedPassword)) {
      RateLimiter.recordAttempt(email);
      return ResponseData(
        data: null,
        userFriendlyError:
            'La contraseña no cumple con los requisitos de seguridad',
        error: 'La contraseña no cumple con los requisitos de seguridad',
        errorType: ErrorType.validation,
      );
    }
    final QueryResult result = await client.mutate(mutateGql);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }
    final data = result.data;
    if (data == null || data['loginUser'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudo iniciar sesión. Verifica tus credenciales.",
          error: 'Error de inicio de sesión: no se devolvieron datos',
          errorType: ErrorType.noData);
    }
    return ResponseData(
      data: removeTypename(data['loginUser']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Inicio de sesión");
  }
}

// Mutation Login whit credentials Google account

Future<ResponseData> loginGoogle() async {
  final GraphQLClient client = createClient();

  final GoogleSignIn googleSignIn;

  if (Platform.isAndroid) {
    googleSignIn = GoogleSignIn(
      // clientId: GraphQLConfig.serverClientId,
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
      userFriendlyError: "El inicio de sesión con Google fue cancelado.",
      error: 'El usuario canceló el inicio de sesión',
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
        userFriendlyError: "No se pudo iniciar sesión con Google.",
        error: 'registrarse google: Sin data retornada',
      );
    }
    return ResponseData(
      data: removeTypename(data['signUpGoogle']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Registrarse google");
  }
}

// Mutation Register User
Future<ResponseData> register(SignupInput dataToRegister) async {
  final GraphQLClient client = createClient();
  final timezone = await getDeviceTimeZone();
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
          "stateId": dataToRegister.state,
          "identifier": dataToRegister.identifier,
          "isBaptized": dataToRegister.isBaptized,
          "timezone": timezone
        },
      },
      fetchPolicy: FetchPolicy.noCache);

  try {
    final QueryResult result = await client.mutate(mutateGql);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['registerUser'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError: "No se pudo registrar el usuario.",
        error: "Registrar Usuario Sin datos Resultado",
      );
    }

    return ResponseData(
      data: removeTypename(data['registerUser']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Registrar Usuario");
  }
}

// Mutation Register User
Future<ResponseData> initializedRegister(SignupInput dataToRegister) async {
  final GraphQLClient client = createClient();
  final timezone = await getDeviceTimeZone();
  operationName = 'InitializeRegisterUser';
  final MutationOptions mutateGql = MutationOptions(
      operationName: operationName,
      document: gql(r'''
        mutation InitializeRegisterUser($input: initializeRegisterUserInput!) {
          initializeRegisterUser(input: $input) {
            success
            message
            userId
          }
        }
    '''),
      variables: <String, dynamic>{
        "input": {
          "username": dataToRegister.username,
          "email": dataToRegister.email,
          "password": dataToRegister.password,
          "name": dataToRegister.name,
          "lastname": dataToRegister.lastname,
          "birthdate": dataToRegister.birthdate,
          "gender": dataToRegister.gender!.toUpperCase(),
          "phoneNumber": dataToRegister.phoneNumber,
          "countryId": dataToRegister.countryId,
          "stateId": dataToRegister.state,
          "cityId": dataToRegister.city,
          "codeAreaId": dataToRegister.codeAreaId,
          "identifier": dataToRegister.identifier,
          "isBaptized": dataToRegister.isBaptized,
          "timezone": timezone
        }
      },
      fetchPolicy: FetchPolicy.noCache);

  try {
    final QueryResult result = await client.mutate(mutateGql);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['initializeRegisterUser'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError: "No se pudo registrar el usuario.",
        error: "inicializar Registro de Usuario Sin datos Resultado",
      );
    }

    return ResponseData(
      data: removeTypename(data['initializeRegisterUser']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "inicializar Registro de Usuario");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['updateDataProfileUsers'] == null) {
      return ResponseData(
          data: false,
          userFriendlyError: "No se pudo actualizar el perfil del usuario.",
          error: "Actualizar perfil de datos Usuarios No se devolvieron datos",
          errorType: ErrorType.noData);
    }
    return ResponseData(data: data['updateDataProfileUsers'], error: null);
  } catch (e) {
    return handleGenericError(e, "Actualizar perfil de usuario");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;

    if (data == null || data['updateChurchUser'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError: "No se pudo actualizar la iglesia del usuario.",
          error: 'Actualizar Iglesia de Usuario No devolvió datos ',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['updateChurchUser'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Actualizar Iglesia de Usuario");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['forgotPassword'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            "No se pudo enviar el correo de recuperación. Inténtalo nuevamente.",
        error: "Olvidé mi contraseña No hay datos Resultado",
      );
    }

    return ResponseData(
      data: removeTypename(data['forgotPassword']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Has olvidado tu contraseña");
  }
}

// Mutation Verify Pin Password

Future verifyPinPassword(email, code) async {
  final GraphQLClient client = createClient();
  operationName = 'VerifyPinForPassword';
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['verifyPinForPassword'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudo verificar el código de recuperación. Inténtalo nuevamente.",
          error: "Verificar PIN para contraseña Sin datos Resultado",
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: removeTypename(data['verifyPinForPassword']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Verificar PIN");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['resetPassword'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            "No se pudo restablecer la contraseña. Inténtalo nuevamente.",
        error: "Restablecer contraseña Sin datos Resultado",
      );
    }

    return ResponseData(
      data: removeTypename(data['resetPassword']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Restablecer contraseña");
  }
}

// Mutation Logout  User

Future logout() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  // if (googleSignIn != null) {
  await googleSignIn.signOut();
  // }
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['sendScore'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudo enviar la puntuación. Inténtalo nuevamente.",
          error: 'Error en el envío de puntuación: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['sendScore'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Error en el envío de puntuación");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['redeemPrize'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            "No se pudo canjear el premio. Inténtalo nuevamente.",
        error: 'Canjear premio fallido: no se devolvieron datos',
      );
    }

    return ResponseData(
      data: data['redeemPrize'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Canjear premio");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['openOnePromise'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError: "No se pudo abrir la promesa. Inténtalo nuevamente.",
        error: 'Error al abrir una promesa: no se devolvieron datos',
      );
    }

    return ResponseData(
      data: data['openOnePromise'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Abrir una promesa");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['addPreachToFavorite'] == null) {
      return ResponseData(
        data: null,
        errorType: ErrorType.noData,
        userFriendlyError:
            "No se pudo agregar la predicación a favoritos. Inténtalo nuevamente.",
        error:
            'Error al agregar predicación a favoritos: no se devolvieron datos',
      );
    }

    return ResponseData(
      data: data['addPreachToFavorite'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Agregar predicación a favoritos");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['removePreachFavorite'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            "No se pudo eliminar la predicación de favoritos. Inténtalo nuevamente.",
        error:
            'Error al eliminar Predicación de Favoritos: no se devolvieron datos',
      );
    }

    return ResponseData(
      data: data['removePreachFavorite'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Eliminar predicación de favoritos");
  }
}

// Mutation Create HightLighters

Future<ResponseData> createHighLighters(List<HighlightRangeModel> input,
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['appCreateHighlighter'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            "No se pudo crear el resaltado. Inténtalo nuevamente.",
        error:
            'Error al crear resaltado de la aplicación: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['appCreateHighlighter'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Resaltado de la aplicación");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['removeHighlighter'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            "No se pudo eliminar el resaltado. Inténtalo nuevamente.",
        error: 'Error al eliminar el resaltado: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['removeHighlighter'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Eliminar resaltado");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['updateFavoriteVerse'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudo actualizar el versículo favorito. Inténtalo nuevamente.",
          error:
              'Error al actualizar el versículo favorito: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['updateFavoriteVerse'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Actualizar versículo favorito");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['createNewVerseFavoriteByUser'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            "No se pudo crear el versículo favorito. Inténtalo nuevamente.",
        error:
            'Error al crear un nuevo versículo favorito por usuario: no se devolvieron datos',
      );
    }

    return ResponseData(
      data: data['createNewVerseFavoriteByUser'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Crear nuevo versículo favorito por usuario");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['deleteVerseFavorite'] == null) {
      return ResponseData(
        data: null,
        errorType: ErrorType.noData,
        userFriendlyError:
            "No se pudo eliminar el versículo favorito. Inténtalo nuevamente.",
        error: 'Error al eliminar Verso Favorito: No se devolvieron datos',
      );
    }

    return ResponseData(
      data: data['deleteVerseFavorite'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Eliminar versículo favorito");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['markAsReadNotification'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            "No se pudo marcar la notificación como leída. Inténtalo nuevamente.",
        error:
            'Notificación de marcar como leído fallida: no se devolvieron datos',
      );
    }

    return ResponseData(
      data: data['markAsReadNotification'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Marcar notificación como leída");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['markAllAsReadNotifications'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudieron marcar todas las notificaciones como leídas. Inténtalo nuevamente.",
          error:
              'Marcar todo como leído Las notificaciones fallaron: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['markAllAsReadNotifications'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Marcar todo como leído las notificaciones");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['saveResultByUser'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudo guardar el resultado. Inténtalo nuevamente.",
          error:
              'Error al guardar resultado por usuario: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['saveResultByUser'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Guardar resultado por usuario");
  }
}

// *** mutación para Prayer

// Mutation Send Request Prayer

Future<ResponseData> sendPrayerRequest(RequestPrayerModel prayer) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  MultipartFile? multipartFile;
  if (prayer.audio != null) {
    multipartFile = await MultipartFile.fromPath(
      'audio',
      prayer.audio!.path,
      contentType: MediaType('audio', 'aac'),
    );
  }
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['createRequestPrayer'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudo crear la solicitud de oración. Inténtalo nuevamente.",
          error: 'Error al crear solicitud de oración: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['createRequestPrayer'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Crear solicitud de oración");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['deleteRequestPrayer'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            "No se pudo eliminar la solicitud de oración. Inténtalo nuevamente.",
        error:
            'Error al eliminar solicitud de oración: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['deleteRequestPrayer'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Eliminar solicitud de oración");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['answerPrayerRequest'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudo responder la solicitud de oración. Inténtalo nuevamente.",
          error: 'La solicitud de oración falló: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['answerPrayerRequest'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Responder solicitud de oración");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['changeStatusRequest'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudo cambiar el estado de la solicitud. Inténtalo nuevamente.',
          error:
              'Solicitud de cambio de estado fallida: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['changeStatusRequest'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Cambio de estado de la solicitud");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['createCertificate'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudo crear el certificado. Inténtalo nuevamente.",
          error: 'Error al crear el certificado: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['createCertificate'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Crear certificado");
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
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['deleteUserDevice'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              "No se pudo eliminar el dispositivo del usuario. Inténtalo nuevamente.",
          error:
              'Error al eliminar el dispositivo del usuario: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['deleteUserDevice'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Eliminar dispositivo del usuario");
  }
}

/// Mutation para Stripe
///
Future<ResponseData> createStripePaymentIntent({
  required double amount,
  required String donorName,
  required String donorEmail,
  String? donorPhone,
  String currency = 'USD',
  String? project,
  String? notes,
}) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  final MutationOptions options = MutationOptions(
    operationName: 'CreateStripePaymentIntent',
    document: gql(r'''
        mutation CreateStripePaymentIntent($input: DonationInput!) {
      createStripePaymentIntent(input: $input) {
        clientSecret
        paymentIntentId
        donationId
      }
    }
        '''),
    variables: {
      'input': {
        'amount': amount,
        'donorName': donorName,
        'donorEmail': donorEmail,
        'donorPhone': donorPhone,
        'currency': currency,
        'project': project,
        'notes': notes,
      },
    },
  );
  try {
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['deleteUserDevice'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            'No se pudo crear el intento de pago. Inténtalo nuevamente.',
        error:
            'Error al crear la intención de pago de Stripe: no se devolvieron datos',
      );
    }

    return ResponseData(
      data: data['createStripePaymentIntent'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Crear intención de pago de Stripe");
  }
}

Future<ResponseData> confirmPaymentWithBackend({
  required String paymentIntentId,
  required String donationId,
}) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  final MutationOptions options = MutationOptions(
    document: gql(r'''
        mutation ConfirmStripePayment($paymentIntentId: String!,$donationId: ID!) {
              confirmStripePayment(paymentIntentId: $paymentIntentId, donationId: $donationId) {
                success
                status
                donation {
                  id
                  paymentStatus
                }
              }
            }
      '''),
    variables: {
      'paymentIntentId': paymentIntentId,
      'donationId': donationId,
    },
  );

  try {
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['confirmStripePayment'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            'No se pudo confirmar el pago. Inténtalo nuevamente.',
        error:
            'Confirmación de pago de Stripe fallida: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['confirmStripePayment'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Confirmar intención de pago de Stripe");
  }
}

Future<ResponseData> verifyPinAndCompleteRegistration(
    String email, String verificationCode) async {
  final GraphQLClient client = createClient();

  final MutationOptions options = MutationOptions(
    operationName: "VerifyPinAndCompleteRegistration",
    document: gql(r'''
        mutation VerifyPinAndCompleteRegistration($input: verifyPinAndCompleteRegistrationInput!) {
        verifyPinAndCompleteRegistration(input: $input) {
          id
          email
          username
          password
          imgProfileUser
          isDeveloperMode
          userJwtToken {
          token 
          }
        }
      }
    '''),
    variables: {
      "input": {"email": email, "verificationCode": verificationCode}
    },
  );

  try {
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['verifyPinAndCompleteRegistration'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            'No se pudo enviar de código de verificación. Inténtalo nuevamente.',
        error:
            'envió de código de verificación  fallida: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['verifyPinAndCompleteRegistration'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "envió de código de verificación");
  }
}

Future<ResponseData> resendVerificationCode(
    String email, String timeZone) async {
  final GraphQLClient client = createClient();

  final MutationOptions options = MutationOptions(
    operationName:"ResendEmailVerificationCode",
    document: gql(r'''
        mutation ResendEmailVerificationCode($email: String!, $timezone: String) {
          resendEmailVerificationCode(email: $email, timezone: $timezone)
        }
              '''),
    variables: {
      'email': email,
      'timezone': timeZone,
    },
  );

  try {
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['resendEmailVerificationCode'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            'No se pudo enviar de código de verificación. Inténtalo nuevamente.',
        error:
            'Reenvió de código de verificación  fallida: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['resendEmailVerificationCode'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Reenvió de código de verificación");
  }
}

Future<ResponseData> saveWhatsAppConfig(String userId, bool isActivatedSendWhatsApp,List<String> scheduleHours ) async {
  final GraphQLClient client = createClient();

  final MutationOptions options = MutationOptions(
    operationName:"UpdatePreferencesWhatsapp",
    document: gql(r'''
       mutation UpdatePreferencesWhatsapp($userId: ID!, $isActiveSendWhatsapp: Boolean!, $scheduleHours: [String!]) {
          updatePreferencesWhatsapp(user_id: $userId, is_active_send_whatsapp: $isActiveSendWhatsapp, , scheduleHours: $scheduleHours) {
            userPreferences {
              is_active_send_whatsapp
              activated_at_send_whatsapp
            }
          }
        }
              '''),
    variables: {
      'userId': userId,
      'isActiveSendWhatsapp': isActivatedSendWhatsApp,
      'scheduleHours':scheduleHours
    },
  );

  try {
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['updatePreferencesWhatsapp'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            'No se pudo enviar actualizar Preferencias del usuario. Inténtalo nuevamente.',
        error:
            'Reenvió actualizar Preferencias del usuario  fallida: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['updatePreferencesWhatsapp'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Actualizar preferncias de usuario");
  }
}