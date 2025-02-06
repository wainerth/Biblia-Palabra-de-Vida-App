import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
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
  if (kIsWeb || Platform.isAndroid) {
    googleSignIn = GoogleSignIn();
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

Future<ResponseData> getProfileUser(token, idUser) async {
  final GraphQLClient _client = createClient(authToken: token);
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

Future<ResponseData> getAchievement(token, userId) async {
  final GraphQLClient _client = createClient(authToken: token);
  final QueryOptions options = QueryOptions(
    operationName: "GetUserAchievement",
    document: gql(r'''
    query GetUserAchievement($userId: ID) {
      getUserAchievement(userId: $userId) {
        id
        classification
        img {
          urlImg
        }
        unLockAchievement
        title
        description
        requirement {
          requirement
        }
      }
    }
    '''),
    variables: <String, dynamic>{"userId": userId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getUserAchievement'] == null) {
      return ResponseData(
        data: null,
        error: 'Achievement failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getUserAchievement'],
      error: null,
    );
  } catch (e) {
    return ResponseData(
      data: null,
      error: 'Connection error: $e',
    );
  }
}

Future getDataMember(token, userId) async {
  final GraphQLClient _client = createClient(authToken: token);

  final QueryOptions query = QueryOptions(
      operationName: "GetMemberByUserId",
      document: gql(r'''
      query GetMemberByUserId($userId: ID) {
        getMemberByUserId(userId: $userId) {
          id
          groupId
          userId
          currentPoints
          position
          promoted
        }
      }
 '''),
      variables: <String, dynamic>{"userId": userId},
      fetchPolicy: FetchPolicy.noCache);

  try {
    final QueryResult result = await _client.query(query);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data["getMemberByUserId"] == null) {
      return ResponseData(
        data: null,
        error: 'get Member By User Id failed: No data returned',
      );
    }

    return ResponseData(
        data: removeTypename(data['getMemberByUserId']), error: null);
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}
