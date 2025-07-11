import 'dart:async';
import 'dart:io';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/foundation.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<ResponseData> getProfileUser(token, idUser) async {
  final GraphQLClient client = createClient(authToken: token);
  final QueryOptions options = QueryOptions(
    operationName: 'GetOneProfileByUserId',
    document: gql(r'''
    query GetOneProfileByUserId($userId: ID) {
      getOneProfileByUserId(userId: $userId) {
        userId
        name
        lastname
        username
        email
        expTotalUser
        favoriteVerseId
        notifications
        username
        imgProfileUser {
          urlImg
        }
        profileAreaCode {
          id
          code
        }
        userChurch {
          id
          churchName
          status
        }
        createdAt
        achievementsReachedCount
        streakDaysCount
        preachingsCreatedCount
        country {
          id
          country
        }
        city
        birthdate
        gender
        identifier
        isBaptized
        phoneNumber
        energyPoints
        currentLeague {
          id
          name
          description
        }
      }
    }
'''),
    variables: <String, dynamic>{"userId": idUser},
    fetchPolicy: FetchPolicy.noCache,
  );

  try {
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get One Profile By User Id Timeout de conexión $e');
  } catch (e) {
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

Future<ResponseData> verifyToken(token) async {
  final GraphQLClient _client = createClient();
  final QueryOptions options = QueryOptions(
    operationName: 'VerifyToken',
    document: gql(r'''
       query VerifyToken($token: String!) {
          verifyToken(token: $token) {
            user {
              id
              email
              username
              handleTimeFeeling
              lastLogin
              createdAt
            }
            success
            isLogout
          }
          
        }
      '''),
    variables: <String, dynamic>{
      'token': token,
    },
    fetchPolicy: FetchPolicy.noCache,
  );

  try {
    final QueryResult result = await _client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['verifyToken'] == null) {
      print("No data returned");
      return ResponseData(data: false, error: "No data returned");
      // return false;
    }
    return ResponseData(data: data['verifyToken'], error: null);
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

Future<ResponseData> getAchievement(userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');
  final GraphQLClient client = createClient(authToken: userToken);
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
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get User Achievement Timeout de conexión $e');
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

Future<ResponseData> getUserTitle(userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');
  final GraphQLClient client = createClient(authToken: userToken);
  final QueryOptions options = QueryOptions(
    operationName: "GetUserTitle",
    document: gql(r'''
      query GetUserTitle($userId: ID) {
        getUserTitle(userId: $userId) {
          courseId
          description
          id
          img {
            urlImg
          }
          status
          title
          unLockTitle
        }
      }
    '''),
    variables: <String, dynamic>{"userId": userId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getUserTitle'] == null) {
      return ResponseData(
        data: null,
        error: 'get user title failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getUserTitle'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get User Title Timeout de conexión $e');
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

Future<ResponseData> getTitleForUser(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');
  final GraphQLClient client = createClient(authToken: userToken);
  final QueryOptions options = QueryOptions(
    operationName: "GetTitleForUser",
    document: gql(r'''
      query GetTitleForUser($userId: ID, $courseId: ID) {
        getTitleForUser(userId: $userId, courseId: $courseId) {
          data {
            id
            courseId
            title
            description
            img {
            urlImg 
            }
            unLockTitle
            status
          }
          message
        }
      }
    '''),
    variables: <String, dynamic>{"userId": userId, "courseId": courseId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data == null ||
        data['getTitleForUser'] == null ||
        data['getTitleForUser']["data"] == null) {
      return ResponseData(
        data: null,
        error: data?['getTitleForUser']["message"] ??
            'get title for user failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getTitleForUser']["data"],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get User for title Title Timeout de conexión $e');
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

Future<ResponseData> getPrizeWon(userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');
  final GraphQLClient client = createClient(authToken: userToken);
  final QueryOptions options = QueryOptions(
    operationName: "getPrizeByCourse",
    document: gql(r'''
    query getPrizeByCourse($courseId: ID) {
     getPrizeByCourse {
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
    variables: <String, dynamic>{"userId": userId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get User Achievement Timeout de conexión $e');
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

Future<ResponseData> getRewardObtained(sectionId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');
  final GraphQLClient client = createClient(authToken: userToken);
  final QueryOptions options = QueryOptions(
    operationName: "GetOneRewardBySection",
    document: gql(r'''
   query GetOneRewardBySection($sectionId: ID) {
      getOneRewardBySection(sectionId: $sectionId) {
        id
        sectionId
        title
        description
        earnedExperience
        earnedEnergy
        status
      }
      }
    '''),
    variables: <String, dynamic>{"sectionId": sectionId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (kDebugMode) {
      print(result.data);
    }
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getOneRewardBySection'] == null) {
      return ResponseData(
        data: null,
        error: 'Reward failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getOneRewardBySection'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get One reward Timeout de conexión $e');
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

Future getDataMember(token, userId) async {
  final GraphQLClient client = createClient(authToken: token);

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
    final QueryResult result = await client.query(query);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Member By Id Timeout de conexión $e');
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

Future loadCoursesByUserAndChurch(int? page,int? limit, String userId, String? churchId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetAllCourses",
    document: gql(r'''
     query GetAllCourses($churchId: ID, $userId: ID, $page: Int, $limit: Int) {
        getAllCourses(churchId: $churchId, userId: $userId, page: $page, limit: $limit ) {
            data {
              id
              title
              color
              introduction
              status
              img {
                urlImg
              }
              visibility
              statusContent
              sectionCount
              sectionCompletedCount
            }
            meta {
              currentPage
              totalPages
              itemsPerPage
              totalItems
              hasPreviousPage
              hasNextPage
            }
        }
      }
      '''),
    variables: <String, dynamic>{
      "churchId": churchId,
      "userId": userId,
      "page": page,
      "limit": limit,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
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
      data: data['getAllCourses']['data'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get all Courses Timeout de conexión $e');
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

Future loadOneCourse(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetOneCourse",
    document: gql(r'''
    query GetOneCourse($userId: ID, $courseId: ID) {
          getOneCourse(userId: $userId, courseId: $courseId) {
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
      "userId": userId,
      "courseId": courseId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get One Course Timeout de conexión $e');
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

Future loadStageById(sectionId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

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
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Section By Id Timeout de conexión $e');
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

Future loadStageByCourse(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetSections",
    document: gql(r'''
     query GetSections($userId: ID, $courseId: ID) {
      getSections(userId: $userId, courseId: $courseId) {
        data {
          id
          sectionName
          introduction
          unLockSection
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
        meta {
          currentPage
          totalPages
          itemsPerPage
          totalItems
          hasPreviousPage
          hasNextPage
        }
      }
    }
      '''),
    variables: <String, dynamic>{"userId": userId, "courseId": courseId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null ||
        data['getSections'] == null ||
        data['getSections']['data'] == null) {
      return ResponseData(
        data: null,
        error: 'get Sections By course failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getSections']['data'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Sections Timeout de conexión $e');
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

Future loadLevelsByCourse(userId, sectionId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

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
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
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

  final GraphQLClient client = createClient(authToken: userToken);

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
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Level Id Timeout de conexión $e');
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

Future loadStoriesByLevel(String levelId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

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
        audio {
          url
        }
        img {
          urlImg
        }
        video {
          url
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
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Story Level Id Timeout de conexión $e');
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

Future loadQuestionByStory(levelId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

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
            isOrdering
            status
            answers {
              id
              answer
              isCorrect
              correctOrder
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
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Question By Level Id Timeout de conexión $e');
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

Future getLastProgressUser(userId, courseId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

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
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get last progress User Timeout de conexión $e');
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

Future lastLevelProgressUser(userId, levelId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetProgressLevelUser",
    document: gql(r'''
   query GetProgressLevelUser($userId: ID, $levelId: ID) {
      getProgressLevelUser(userId: $userId, levelId: $levelId) {
        id
        score
        energy
        message {
          resultDescription
          resultTitle
          difficulty
        }
        newRecord
        user {
          username
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
    final QueryResult result = await client.query(options);
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
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get progress Level User Timeout de conexión $e');
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

Future getLeagueMembers(leagueId, userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetLeagueMembers",
    document: gql(r'''
          query GetLeagueMembers($leagueId: ID!, $userId: ID!) {
          getLeagueMembers(leagueId: $leagueId, userId: $userId) {
            userId
            currentPoints
            username
            profilePicture
          }
        }
      '''),
    variables: <String, dynamic>{
      "leagueId": leagueId,
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getLeagueMembers'] == null) {
      return ResponseData(
        data: null,
        error: 'get League Members failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getLeagueMembers'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'get League Members Timeout de conexión $e');
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

Future getAllPrize(page, limit, userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetAllPrize",
    document: gql(r'''
          query GetAllPrize($page: Int, $limit: Int, $userId: String) {
            getAllPrize(page: $page, limit: $limit, userId: $userId) {
              data {
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
                redeemed
                status
              }
              meta {
                currentPage
                totalPages
                itemsPerPage
                totalItems
                hasPreviousPage
                hasNextPage
              }
            }
          }
      '''),
    variables: <String, dynamic>{
      "page": page,
      "limit": limit,
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null ||
        data['getAllPrize'] == null ||
        data['getAllPrize']['data'] == null) {
      return ResponseData(
        data: null,
        error: 'get All Prize Members failed: No data returned',
      );
    }

    return ResponseData(
      data: removeTypename(data['getAllPrize']),
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'get League Members Timeout de conexión $e');
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

Future streaksCalendar(userId, month) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "StreakCalendarService",
    document: gql(r'''
         query StreakCalendarService($userId: ID, $month: Int) {
            streakCalendarService(userId: $userId, month: $month) {
              playDay
              protectedStreak
            }
          }
      '''),
    variables: <String, dynamic>{"userId": userId, "month": month},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['streakCalendarService'] == null) {
      return ResponseData(
        data: null,
        error: 'Streak Calendar Service failed: No data returned',
      );
    }

    return ResponseData(
      data: removeTypename(data['streakCalendarService']),
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Streak Calendar Service Timeout de conexión $e');
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

Future<ResponseData> getDailyWord() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetDailyWord",
    document: gql(r'''
         query GetDailyWord {
          getDailyWord {
            book {
              modernName
            }
            chapter {
              chapter
            }
            verse {
              verse
              text
            }
            img {
              urlImg
            }
          }
        }
      '''),
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getDailyWord'] == null) {
      return ResponseData(
        data: null,
        error: 'get Daily Word failed: No data returned',
      );
    }

    return ResponseData(
      data: removeTypename(data['getDailyWord']),
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'get Daily Word Timeout de conexión $e');
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

Future<ResponseData> getOneReflection() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
         query GetOneReflectionRandom {
            getOneReflectionRandom {
              id
              title
              url
              visibility
              statusContent
              type
              status
            }
          }
      '''),
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getOneReflectionRandom'] == null) {
      return ResponseData(
        data: null,
        error: 'get One Reflection Random failed: No data returned',
      );
    }

    return ResponseData(
      data: removeTypename(data['getOneReflectionRandom']),
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'get One Reflection Random Timeout de conexión $e');
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

Future<ResponseData> getDailyPromises(userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
         query GetDailyPromise($userId: ID) {
          getDailyPromise(userId: $userId) {
            id
            book {
              modernName
            }
            chapter {
              chapter
            }
            verse {
              verse
              text
            }
            hasViewed
            energyPoint
            status
          }
        }
      '''),
    fetchPolicy: FetchPolicy.noCache,
    variables: <String, dynamic>{"userId": userId},
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getDailyPromise'] == null) {
      return ResponseData(
        data: null,
        error: 'get Daily Promise failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getDailyPromise'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'get Daily Promise Timeout de conexión $e');
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

Future<ResponseData> getAllReflections(
    int page, int limit, String title) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
         query GetAllReflection($page: Int, $limit: Int, $title: String) {
          getAllReflection(page: $page, limit: $limit, title: $title) {
            data {
              id
              title
              url
              visibility
              statusContent
              type
              status
            }
            meta {
              currentPage
              totalPages
              itemsPerPage
              totalItems
              hasPreviousPage
              hasNextPage
            }
          }
        }
      '''),
    variables: <String, dynamic>{"page": page, "limit": limit, "title": title},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllReflection'] == null) {
      return ResponseData(
        data: null,
        error: 'get All Reflection failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getAllReflection'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'get All Reflection Timeout de conexión $e');
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

Future<ResponseData> getAllPreach(String userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
         query GetAllPreachesWithFavorite($userId: ID) {
        getAllPreachesWithFavorite(userId: $userId) {
          id
          title
          content
          preachers
          img {
            urlImg
          }
          video {
            url
            img {
              urlImg
            }
          }
          status
          isFavorite
          createdAt
          updatedAt
        }
      }
      '''),
    variables: <String, dynamic>{"userId": userId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllPreachesWithFavorite'] == null) {
      return ResponseData(
        data: null,
        error: 'get All Preaches With Favorite failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getAllPreachesWithFavorite'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null,
        error: 'get All Preaches With Favorite Timeout de conexión $e');
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

Future<ResponseData> getChapterWithVerses(String bookId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
         query Chapters($bookId: ID) {
          getOneBookByBookId(bookId: $bookId) {
            chapters {
              id
              bookId
              chapter
              status
              verses {
                id
                chapterId
                verse
                text
                colorHighlight
                getHighlighter
                status
              }
            }
          }
        }
      '''),
    variables: <String, dynamic>{"bookId": bookId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data == null ||
        data['getOneBookByBookId'] == null ||
        data['getOneBookByBookId']['chapters'] == null) {
      return ResponseData(
        data: null,
        error: 'get One Book By BookId  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getOneBookByBookId']['chapters'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'get One Book By BookId Timeout de conexión $e');
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

Future<ResponseData> getOneChapterWithVerses(String? chapterId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
         query GetOneChapterByChapterId($chapterId: ID) {
            getOneChapterByChapterId(chapterId: $chapterId) {
              id
              bookId
              chapter
              status
              verses {
                id
                chapterId
                verse
                text
                colorHighlight
                getHighlighter
                status
              }
            }
          }
      '''),
    variables: <String, dynamic>{"chapterId": chapterId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getOneChapterByChapterId'] == null) {
      return ResponseData(
        data: null,
        error: 'get One Chapter By ChapterId  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getOneChapterByChapterId'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null,
        error: 'get One Chapter By ChapterId Timeout de conexión $e');
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

Future<ResponseData> getAudioByChapter(String? chapterId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
         query GetAudioByChapter($chapterId: ID) {
        getAudioByChapter(chapterId: $chapterId) {
          audioUrl
          chapter
          id
        }
      }
      '''),
    variables: <String, dynamic>{"chapterId": chapterId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAudioByChapter'] == null) {
      return ResponseData(
        data: null,
        error: 'Get Audio By Chapter  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getAudioByChapter'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Audio By Chapter Timeout de conexión $e');
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

Future<ResponseData> getBooksByBibleId(String? versionId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
         query GetBooksByBibleId($getBooksByBibleIdId: ID) {
            getBooksByBibleId(id: $getBooksByBibleIdId) {
              id
              numberBook
              modernName
              newTestament
              bibleId
              status
              hasData
              chapters {
                id
                chapter
                verses {
                  id
                  verse
                }
              }
            }
          }
      '''),
    variables: <String, dynamic>{"getBooksByBibleIdId": versionId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getBooksByBibleId'] == null) {
      return ResponseData(
        data: null,
        error: 'Get Books By BibleId  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getBooksByBibleId'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Books By BibleId Timeout de conexión $e');
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

Future<ResponseData> getAllHighLighters(
    String userId, int versionId, String chapterId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
         query GetAllHighlighters($userId: ID, $bibleVersion: Int, $chapterId: ID) {
          getAllHighlighters(userId: $userId, bibleVersion: $bibleVersion, chapterId: $chapterId) {
            id
            startIndex
            endIndex
            verse {
              id
              verse
            }
            color
          }
        }
      '''),
    variables: <String, dynamic>{
      "userId": userId,
      "bibleVersion": versionId,
      "chapterId": chapterId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllHighlighters'] == null) {
      return ResponseData(
        data: null,
        error: 'Get All Highlighters  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getAllHighlighters'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get All Highlighters Timeout de conexión $e');
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

Future<ResponseData> getFavoriteVerseByUser(
  int? page,
  int? limit,
  String? versionId,
  String? chapterId,
  String userId,
) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
       query GetFavoriteVersesByChapterId($chapterId: ID, $versionId: ID, $userId: ID, $page: Int, $limit: Int) {
          getFavoriteVersesByChapterId(chapterId: $chapterId, versionId: $versionId, userId: $userId, page: $page, limit: $limit) {
            data {
              userId
              book {
                id
                bibleId
                numberBook
                modernName
                
              }
              chapter {
                id
                chapter
              }
              verse: favoriteVerseUser {
              id
                verse
                text
              }
            }
            meta {
              currentPage
              totalPages
              itemsPerPage
              totalItems
              hasPreviousPage
              hasNextPage
            }
          }
        }
      '''),
    variables: <String, dynamic>{
      "page": page,
      "limit": limit,
      "versionId": versionId,
      "chapterId": chapterId,
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getFavoriteVersesByChapterId'] == null) {
      return ResponseData(
        data: null,
        error: 'Get Favorite Verses By ChapterId  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getFavoriteVersesByChapterId'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null,
        error: 'Get Favorite Verses By ChapterId Timeout de conexión $e');
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

Future<ResponseData> getAllTeaching(
    int page, int limit, String title, String churchId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
        query GetAllTeaching($page: Int, $limit: Int, $title: String, $churchId: ID) {
        getAllTeaching(page: $page, limit: $limit, title: $title, churchId: $churchId) {
          data {
            id
            title
            description
            img {
              urlImg
            }
            orderCard
            mostClicked
            countCards
            status
          }
          meta {
            currentPage
            totalPages
            itemsPerPage
            totalItems
            hasPreviousPage
            hasNextPage
          }
        }
      }
      '''),
    variables: <String, dynamic>{
      "page": page,
      "limit": limit,
      "title": title,
      "churchId": churchId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllTeaching'] == null) {
      return ResponseData(
        data: null,
        error: 'Get All Teaching  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getAllTeaching'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get All Teaching Timeout de conexión $e');
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

Future<ResponseData> getAllCharacters(
    int page, int limit, String name, bool isNewTestament) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
        query GetCharacters($page: Int, $limit: Int, $name: String, $isNewTestament: Boolean) {
          getCharacters(page: $page, limit: $limit, name: $name, isNewTestament: $isNewTestament) {
            data {
              id
              name
              typeNameChar
              description
              meaningName
              haveMoreCharacters
              color
              img {
                urlImg
              }
              newTestament
              countCards
              status
              relatedCharacters {
                  img {
                  urlImg
                }
                id
                name
                description
                color
                countCards
                haveMoreCharacters
                meaningName
                newTestament
                typeNameChar
              }
            }
            meta {
              currentPage
              totalPages
              itemsPerPage
              totalItems
              hasPreviousPage
              hasNextPage
            }
          }
        }
      '''),
    variables: <String, dynamic>{
      "offset": page,
      "limit": limit,
      "name": name,
      "isNewTestament": isNewTestament,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getCharacters'] == null) {
      return ResponseData(
        data: null,
        error: 'Get Characters  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getCharacters'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Characters Timeout de conexión $e');
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

Future<ResponseData> getReferenceTeaching(String id) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
        query GetVersesForTeaching($id: ID) {
          getVersesForTeaching(id: $id) {
            id
            verse {
              verse
              text
              id
            }
            chapter {
              id
              chapter
            }
            book {
              bibleId
              id
              modernName
            }
            numberEndVerse
          }
        }
      '''),
    variables: <String, dynamic>{"id": id},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getVersesForTeaching'] == null) {
      return ResponseData(
        data: null,
        error: 'Get Verses For Teaching  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getVersesForTeaching'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get Verses For Teaching Timeout de conexión $e');
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

Future<ResponseData> getCharacterFirstAppearance(
    String getCharacterFirstAppearanceId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
        query GetCharacterFirstAppearance($getCharacterFirstAppearanceId: ID) {
          getCharacterFirstAppearance(id: $getCharacterFirstAppearanceId) {
            id
            verse {
              verse
              text
              id
            }
            chapter {
              id
              chapter
            }
            book {
              id
              modernName
              bibleId
            }
          }
      '''),
    variables: <String, dynamic>{
      "getCharacterFirstAppearanceId": getCharacterFirstAppearanceId
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getCharacterFirstAppearance'] == null) {
      return ResponseData(
        data: null,
        error: 'Get Character First Appearance  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getCharacterFirstAppearance'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null,
        error: 'Get Character First Appearance Timeout de conexión $e');
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

Future<ResponseData> getWordsConcordance(
    int page, int limit, String versionId, String searchWord) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
        query WordSearchConcordance($page: Int, $limit: Int, $versionId: ID, $searchWord: String) {
        wordSearchConcordance(page: $page, limit: $limit, versionId: $versionId, searchWord: $searchWord) {
          data {
            verse {
              id
              verse
              text
              occurrence {
                start
                end
              }
            }
            chapter {
              id
              chapter
            }
            book {
              id
              numberBook
              modernName
              newTestament
            }
          }
          meta {
            currentPage
            totalPages
            itemsPerPage
            totalItems
            hasPreviousPage
            hasNextPage
          }
        }
      }

      '''),
    variables: <String, dynamic>{
      "page": page,
      "limit": limit,
      "versionId": versionId,
      "searchWord": searchWord,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['wordSearchConcordance'] == null) {
      return ResponseData(
        data: null,
        error: 'Word Search Concordance  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['wordSearchConcordance'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Word Search Concordance Timeout de conexión $e');
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

Future<ResponseData> getAllNotification(
    int page, int limit, String userId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    // operationName: "GetOneReflectionRandom ",
    document: gql(r'''
        query GetAllNotificationsByUserId($page: Int, $limit: Int, $userId: ID) {
        getAllNotificationsByUserId(page: $page, limit: $limit, userId: $userId) {
          data {
           id
           title
           message
           img
           isRead
           action
           actionLabel
           notificationType
           notificationTypeName
           createdAt
          }
          meta {
            currentPage
            totalPages
            itemsPerPage
            totalItems
            hasPreviousPage
            hasNextPage
          }
        }
      }

      '''),
    variables: <String, dynamic>{
      "page": page,
      "limit": limit,
      "userId": userId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllNotificationsByUserId'] == null) {
      return ResponseData(
        data: null,
        error: 'Get All Notifications By UserId  failed: No data returned',
      );
    }

    return ResponseData(
      data: data['getAllNotificationsByUserId'],
      error: null,
    );
  } on TimeoutException catch (e) {
    if (kDebugMode) {
      print('Timeout: $e');
    }
    return ResponseData(
        data: null, error: 'Get All Notifications By UserId Timeout de conexión $e');
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

