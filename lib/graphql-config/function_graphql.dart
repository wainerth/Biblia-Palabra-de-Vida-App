import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
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
                      lastname
                      expTotalUser #energia
                      imgProfileUser
                      phoneNumber
                       city
                      gender
                      country {
                        id
                        country
                        country_code
                      }
                      favoriteVerseId # si asigna versiculo favorito
                      notifications # notification user
                      birthdate
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

Future loadCoursesByUserAndChurch(userId, churchId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetAllCourses",
    document: gql(r'''
     query GetAllCourses($churchId: ID, $userId: ID) {
        getAllCourses(churchId: $churchId, userId: $userId) {
          id
          title
          color
          introduction
          status
          img {
            urlImg
          }
          sectionCount
          sectionCompletedCount
        }
      }
      '''),
    variables: <String, dynamic>{
      "churchId": churchId,
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getAllCourses'] == null) {
      return ResponseData(
        data: null,
        error: 'get Courses By User Id and church failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getAllCourses'],
      error: null,
    );
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future loadStageByCourse(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetSections",
    document: gql(r'''
     query GetSections( $courseId: ID, $userId: ID) {
        getSections(courseId: $courseId, userId: $userId) {
          id
          sectionName
          introduction
          unLockSection
          isChurchContent
          levelCount
          levelCompletedCount
          countCards
          orderCard
          color
          img {
            urlImg
          }
          status
        }
      }
      '''),
    variables: <String, dynamic>{"userId": userId, "courseId": courseId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getSections'] == null) {
      return ResponseData(
        data: null,
        error: 'get Sections By course failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getSections'],
      error: null,
    );
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future loadLevelsByCourse(userId, sectionId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetAllLevelsBySectionId",
    document: gql(r'''
    query GetAllLevelsBySectionId($sectionId: ID, $userId: ID) {
          getAllLevelsBySectionId(sectionId: $sectionId, userId: $userId) {
            id
            name
            levelNumber
            countLevelNumber
            unLockLevel
            color
            section {
              sectionName
            }
            img {
              urlImg
            }
            status
          }
        }
      '''),
    variables: <String, dynamic>{"sectionId": sectionId, "userId": userId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getAllLevelsBySectionId'] == null) {
      return ResponseData(
        data: null,
        error: 'get Levels By Stage failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getAllLevelsBySectionId'],
      error: null,
    );
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
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
