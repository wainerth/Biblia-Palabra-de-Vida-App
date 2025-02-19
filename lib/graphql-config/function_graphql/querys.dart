import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get One Profile By User Id Timeout de conexión $e');
  } catch (e) {
    return ResponseData(
      data: null,
      error: 'Connection error: $e',
    );
  }
}

Future<ResponseData> getAchievement(userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');
  final GraphQLClient _client = createClient(authToken: userToken);
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
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get User Achievement Timeout de conexión $e');
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
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get Member By Id Timeout de conexión $e');
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
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get all Courses Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future loadOneCourse(courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetOneCourse",
    document: gql(r'''
    query GetOneCourse($courseId: ID) {
          getOneCourse(courseId: $courseId) {
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
      "courseId": courseId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getOneCourse'] == null) {
      return ResponseData(
        data: null,
        error: 'get One Courses failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getOneCourse'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get One Course Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future loadStageById(sectionId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetSectionById",
    document: gql(r'''
    query GetSectionById($getSectionByIdId: ID) {
      getSectionById(id: $getSectionByIdId) {
        id
        sectionName
        introduction
        unLockSection
        orderCard
        color
        img {
          urlImg
        }
        status
        levelCount
        levelCompletedCount
        isChurchContent
        countCards
      }
    }
      '''),
    variables: <String, dynamic>{
      "getSectionByIdId": sectionId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getSectionById'] == null) {
      return ResponseData(
        data: null,
        error: 'get Section By Id failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getSectionById'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get Section By Id Timeout de conexión $e');
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
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get Sections Timeout de conexión $e');
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
            levelScore
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
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null,
        error: 'Get All Levels By Section Id Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future loadOneLevel(levelId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetLevelById",
    document: gql(r'''
    query GetLevelById($levelId: ID) {
          getLevelById(levelId: $levelId) {
            id
            name
            levelNumber
            levelScore
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
    variables: <String, dynamic>{
      "levelId": levelId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getLevelById'] == null) {
      return ResponseData(
        data: null,
        error: 'get One level failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getLevelById'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get Level Id Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future loadStoriesByLevel(String levelId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetStoryByLevelId",
    document: gql(r'''
    query GetStoryByLevelId($getStoryByLevelIdId: ID) {
      getStoryByLevelId(id: $getStoryByLevelIdId) {
        id
        text
        countCards
        orderCard
        level {
          levelNumber
          unLockLevel
          status
          img {
            urlImg
          }
          color
          section {
            sectionName
          }
          countLevelNumber
          name
          id
        }
        img {
          urlImg
        }
        status
        audioUrl
      }
    }
      '''),
    variables: <String, dynamic>{
      "getStoryByLevelIdId": levelId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getStoryByLevelId'] == null) {
      return ResponseData(
        data: null,
        error: 'get Stories By level failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getStoryByLevelId'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get Story Level Id Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future loadQuestionByStory(levelId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetQuestionsByLevelId",
    document: gql(r'''
    query GetQuestionsByLevelId($getQuestionsByLevelIdId: ID) {
      getQuestionsByLevelId(id: $getQuestionsByLevelIdId) {
        id
        question
        difficulty
        level {
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
        status
        answers {
          id
          answer
          isCorrect
          questionId
          status
        }
      }
    }
      '''),
    variables: <String, dynamic>{
      "getQuestionsByLevelIdId": levelId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getQuestionsByLevelId'] == null) {
      return ResponseData(
        data: null,
        error: 'get Question By level Id failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getQuestionsByLevelId'],
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get Question By Level Id Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future getLastProgressUser(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetLastProgressUser",
    document: gql(r'''
    query GetLastProgressUser($courseId: ID, $userId: ID) {
        getLastProgressUser(courseId: $courseId, userId: $userId) {
          message
          data {
            levelId
            sectionId
          courseId
          }
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
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getLastProgressUser'] == null) {
      return ResponseData(
        data: null,
        error: 'get last progress User failed: No data returned',
      );
    }

    return ResponseData(
      data: removeTypename(data['getLastProgressUser']),
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get last progress User Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}

Future lastLevelProgressUser(userId, levelId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient _client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetProgressLevelUser",
    document: gql(r'''
   query GetProgressLevelUser($userId: ID, $levelId: ID) {
      getProgressLevelUser(userId: $userId, levelId: $levelId) {
        id
        score
        message {
          resultDescription
          resultTitle
          difficulty
        }
        newRecord
        user {
          username
          rolId
          id
        }
        failedAttempts
        scoreLastAttempt
        completed
        level {
          levelNumber
          id
          name
        }
        status
      }
    }
      '''),
    variables: <String, dynamic>{
      "userId": userId,
      "levelId": levelId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getProgressLevelUser'] == null) {
      return ResponseData(
        data: null,
        error: 'get last progress level user failed: No data returned',
      );
    }

    return ResponseData(
      data: removeTypename(data['getProgressLevelUser']),
      error: null,
    );
  } on TimeoutException catch (e) {
    print('Timeout: $e');
    return ResponseData(
        data: null, error: 'Get progress Level User Timeout de conexión $e');
  } catch (e) {
    return ResponseData(data: null, error: "connection error $e");
  }
}
