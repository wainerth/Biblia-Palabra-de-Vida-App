import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:async';

import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_client.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';

String operationName = '';

// Query to get user profile by user ID

Future<ResponseData> getProfileUser(String token, String idUser) async {
  final GraphQLClient client = createClient(authToken: token);
  operationName = 'GetOneProfileByUserId';
  final QueryOptions options = QueryOptions(
    operationName: operationName,
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
        country {
          id
          name
        }
        state {
          id
          name
        }
        city {
          id
          name
        }
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
        userFriendlyError: 'No se pudo obtener el perfil del usuario.',
        error: 'Error en el perfil de usuario: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }
    return ResponseData(
      data: removeTypename(data['getOneProfileByUserId']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener perfil de usuario");
  }
}

Future<ResponseData> verifyToken(String token) async {
  final GraphQLClient client = createClient();
  operationName = 'VerifyToken';
  final QueryOptions options = QueryOptions(
    operationName: operationName,
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
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['verifyToken'] == null) {
      return ResponseData(
        data: false,
        userFriendlyError: 'No se pudo verificar el token.',
        error: "No se devolvieron datos",
        errorType: ErrorType.noData,
      );
    }
    return ResponseData(data: data['verifyToken'], error: null);
  } catch (e) {
    return handleGenericError(e, "Verificar token");
  }
}

Future<ResponseData> getUserTitle(String userId) async {
  String? userToken = await PreferencesManager().getUserToken();
  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetUserTitle';
  final QueryOptions options = QueryOptions(
    operationName: operationName,
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
        userFriendlyError: 'No se pudo obtener los títulos del usuario.',
        error:
            'Error al obtener los título del usuario: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getUserTitle'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener títulos del usuario");
  }
}

Future<ResponseData> getTitleForUser(String userId, String courseId) async {
  String? userToken = await PreferencesManager().getUserToken();
  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetTitleForUser';
  final QueryOptions options = QueryOptions(
    operationName: operationName,
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
    if (data['getTitleForUser'] == null ||
        data['getTitleForUser']["data"] == null) {
      return ResponseData(
          data: null,
          userFriendlyError: 'No se pudo obtener el título para el usuario.',
          error: data['getTitleForUser']["message"] ??
              'Error al obtener el título del usuario: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getTitleForUser']["data"],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener título para el usuario");
  }
}

Future<ResponseData> getPrizeWon(String userId) async {
  String? userToken = await PreferencesManager().getUserToken();
  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'getPrizeByCourse';
  final QueryOptions options = QueryOptions(
    operationName: operationName,
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
    if (data == null || data['getPrizeByCourse'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError: 'No se pudo obtener los premios ganados.',
        error: 'Error al obtener premio por curso: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getPrizeByCourse'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener premios ganados");
  }
}

Future<ResponseData> getNextSectionUnlocked(
    String userId, String sectionId) async {
  String? userToken = await PreferencesManager().getUserToken();
  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetProgressSectionUser';
  final QueryOptions options = QueryOptions(
    operationName: operationName,
    document: gql(r'''
   query GetProgressSectionUser($userId: ID, $sectionId: ID) {
      getProgressSectionUser(userId: $userId, sectionId: $sectionId) {
        unlockedSectionId
      }
    }
    '''),
    variables: <String, dynamic>{"userId": userId, "sectionId": sectionId},
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudo obtener la siguiente sección desbloqueada.',
          error:
              'Error en Obtener siguiente sección desbloqueada: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getProgressSectionUser'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener siguiente sección desbloqueada");
  }
}

Future<ResponseData> getRewardObtained(String sectionId) async {
  String? userToken = await PreferencesManager().getUserToken();
  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetOneRewardBySection';
  final QueryOptions options = QueryOptions(
    operationName: operationName,
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
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = result.data;
    if (data == null || data['getOneRewardBySection'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError: 'No se pudo obtener la recompensa obtenida.',
          error: 'Recompensa fallida: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getOneRewardBySection'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Recompensa obtenida");
  }
}

Future<ResponseData> getPrizeByUserId(String userId, String courseId) async {
  String? userToken = await PreferencesManager().getUserToken();
  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetPrizeByUserId';

  final QueryOptions options = QueryOptions(
    operationName: operationName,
    document: gql(r'''
      query GetPrizeByUserId($userId: ID, $courseId: ID) {
          getPrizeByUserId(userId: $userId, courseId: $courseId) {
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
    if (data == null || data['getPrizeByUserId'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError: 'No se pudo obtener el premio por ID de usuario.',
        error:
            'Error al obtener premio por ID de usuario: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getPrizeByUserId'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener premio por ID de usuario");
  }
}

Future getDataMember(String token, String userId) async {
  final GraphQLClient client = createClient(authToken: token);
  operationName = 'GetMemberByUserId';
  final QueryOptions query = QueryOptions(
      operationName: operationName,
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
        userFriendlyError: 'No se pudo obtener los datos del miembro.',
        error:
            'Error al obtener miembro por Id. de usuario: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
        data: removeTypename(data['getMemberByUserId']), error: null);
  } catch (e) {
    return handleGenericError(e, "Obtener Miembro por ID de usuario");
  }
}

Future loadCoursesByUserAndChurch(
    int? page, int? limit, String userId, String? churchId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetAllCourses';
  QueryOptions options = QueryOptions(
    document: gql(r'''
     query GetAllCourses($churchId: ID, $userId: ID, $page: Int, $limit: Int) {
      getAllCourses(churchId: $churchId, userId: $userId, page: $page, limit: $limit) {
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
          numberOfSections
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
        userFriendlyError:
            'No se pudieron cargar los cursos por usuario y iglesia.',
        error:
            'Obtener todos los cursos por ID de usuario e iglesia falló: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getAllCourses'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(
        e, "Obtener todos los cursos por ID de usuario e iglesia");
  }
}

Future loadOneCourse(String userId, String courseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetOneCourse';
  QueryOptions options = QueryOptions(
    operationName: operationName,
    document: gql(r'''
    query GetOneCourse($userId: ID, $courseId: ID) {
          getOneCourse(userId: $userId, courseId: $courseId) {
            id
            titleCourse
            color
            introduction
            imgCourseUrl
            titleDescription
            titleImgId
            titleImgUrl
            titleName
            sectionCount
            sectionCompletedCount
            numberOfSections
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
          userFriendlyError: 'No se pudo cargar el curso.',
          error: 'Obtener un curso falló: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getOneCourse'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener un curso");
  }
}

Future loadStageById(String sectionId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetSectionById';
  QueryOptions options = QueryOptions(
    operationName: operationName,
    document: gql(r'''
    query GetSectionById($getSectionByIdId: ID) {
      getSectionById(id: $getSectionByIdId) {
        id
        sectionName
        introduction
        unLockSection
        sectionNumber
        color
        img {
          urlImg
        }
        status
        levelCount
        levelCompletedCount
        countCards
        numberOfLevels
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
        userFriendlyError: 'No se pudo cargar la sección por ID.',
        error: 'Error al obtener la sección por Id: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getSectionById'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener sección por ID");
  }
}

Future loadStageByCourse(String userId, String courseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetSections';
  QueryOptions options = QueryOptions(
    operationName: operationName,
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
          sectionNumber
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
        userFriendlyError: 'No se pudo cargar las secciones por curso.',
        error: 'Error al obtener secciones por curso: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getSections']['data'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener secciones por curso");
  }
}

Future loadLevelsByCourse(String userId, String sectionId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetAllLevelsBySectionId';
  QueryOptions options = QueryOptions(
    operationName: operationName,
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
        userFriendlyError: 'No se pudieron cargar los niveles por sección.',
        error:
            'Error al obtener todos los niveles por sección: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getAllLevelsBySectionId'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todos los niveles por sección");
  }
}

Future loadOneLevel(String levelId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetLevelById';
  QueryOptions options = QueryOptions(
    operationName: operationName,
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
        userFriendlyError: 'No se pudo cargar el nivel.',
        error: 'Obtener un nivel fallo: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getLevelById'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener un nivel");
  }
}

Future loadStoriesByLevel(String levelId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetStoryByLevelId';

  QueryOptions options = QueryOptions(
    operationName: operationName,
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
        userFriendlyError: 'No se pudo cargar las historias por nivel.',
        error: 'Error al obtener historias por nivel: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getStoryByLevelId'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener historias por nivel");
  }
}

Future loadQuestionByStory(String levelId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetQuestionsByLevelId';
  QueryOptions? options = QueryOptions(
    operationName: operationName,
    document: gql(r'''
      query GetQuestionsByLevelId($levelId: ID) {
          getQuestionsByLevelId(levelId: $levelId) {
            id
            question
            difficulty
            isOrdering
            status
            answers {
              id
              answer
              isCorrect
              questionId
              status
            }
            timeline {
              id
              questionId
              answer:eventText
              correctOrder
              status
            }
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
    if (data == null || data['getQuestionsByLevelId'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError: 'No se pudieron cargar las preguntas por nivel.',
        error: 'Obtener pregunta por nivel Id falló: No se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: data['getQuestionsByLevelId'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener preguntas por nivel");
  }
}

Future getLastProgressUser(String userId, String? courseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetLastProgressUser';
  QueryOptions options = QueryOptions(
    operationName: operationName,
    document: gql(r'''
    query GetLastProgressUser($courseId: ID, $userId: ID) {
        getLastProgressUser(courseId: $courseId, userId: $userId) {
          message
          success
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
        userFriendlyError: 'No se pudo obtener el último progreso del usuario.',
        error:
            'Obtener último progreso Error del usuario: no se devolvieron datos',
        errorType: ErrorType.noData,
      );
    }

    return ResponseData(
      data: removeTypename(data['getLastProgressUser']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener último progreso del usuario");
  }
}

Future lastLevelProgressUser(String userId, String levelId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetProgressLevelUser';
  QueryOptions options = QueryOptions(
    operationName: operationName,
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
          userFriendlyError:
              'No se pudo obtener el nivel de progreso del usuario.',
          error:
              'Error al obtener el nivel de progreso del usuario: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: removeTypename(data['getProgressLevelUser']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener nivel de progreso del usuario");
  }
}

Future getLeagueMembers(String leagueId, String userId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetLeagueMembers';
  QueryOptions options = QueryOptions(
    operationName: operationName,
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
          userFriendlyError: 'No se pudieron obtener los miembros de la liga.',
          error:
              'Error al obtener miembros de la liga: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getLeagueMembers'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener miembros de la liga");
  }
}

Future getAllPrize(int? page, int? limit, String userId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetAllPrize';
  QueryOptions options = QueryOptions(
    operationName: operationName,
    document: gql(r'''
          query GetAllPrize($page: Int, $limit: Int, $userId: String) {
            getAllPrize(page: $page, limit: $limit, userId: $userId) {
              data {
                id
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
          userFriendlyError: 'No se pudieron obtener todos los premios.',
          error: 'Error al obtener todos los premios: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: removeTypename(data['getAllPrize']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todos los premios");
  }
}

Future streaksCalendar(String userId, int month) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'StreakCalendarService';
  QueryOptions options = QueryOptions(
    operationName: operationName,
    document: gql(r'''
         query StreakCalendarService($userId: ID, $month: Int) {
            streakCalendarService(userId: $userId, month: $month) {
              playDay
              protectedStreak
              longestStreak
              currentStreak
              lostStreak
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
          userFriendlyError: 'No se pudo obtener el calendario de rachas.',
          error: 'Calendario Racha falló: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: removeTypename(data['streakCalendarService']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Calendario de rachas");
  }
}

Future<ResponseData> getDailyWord() async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetDailyWord';
  QueryOptions options = QueryOptions(
    operationName: operationName,
    document: gql(r'''
         query GetDailyWord {
          getDailyWord {
            book {
              modernName
              id
              bibleId
            }
            chapter {
              chapter
              id
            }
            verse {
            id
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
          userFriendlyError: 'No se pudo obtener la palabra diaria.',
          error: 'Error al obtener Palabra Diaria: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: removeTypename(data['getDailyWord']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener palabra diaria");
  }
}

Future<ResponseData> getOneReflection() async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetOneReflectionRandom';
  QueryOptions options = QueryOptions(
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
          userFriendlyError: 'No se pudo obtener una reflexión.',
          error:
              'Obtener una reflexión aleatoria falló: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: removeTypename(data['getOneReflectionRandom']),
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener una reflexión aleatoria");
  }
}

Future<ResponseData> getDailyPromises(String userId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  operationName = "GetOneReflectionRandom ";
  QueryOptions options = QueryOptions(
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
          userFriendlyError: 'No se pudo obtener la promesa diaria.',
          error: 'Error en la promesa diaria: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getDailyPromise'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener promesas diarias ");
  }
}

Future<ResponseData> getAllReflections(
    int page, int limit, String title) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  operationName = "GetOneReflectionRandom ";
  QueryOptions options = QueryOptions(
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
          userFriendlyError: 'No se pudieron obtener todas las reflexiones.',
          error:
              'Error al obtener todas las reflexiones: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllReflection'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todas las reflexiones");
  }
}

Future<ResponseData> getAllPreach(String userId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  operationName = "GetOneReflectionRandom ";
  QueryOptions options = QueryOptions(
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
          references {
            book {
              id
              modernName
              bibleId
            }
            chapter {
              id
              chapter
            }
            verse {
              id
              verse
              text
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
          userFriendlyError: 'No se pudieron obtener todas las predicaciones.',
          error:
              'Error al obtener todas las predicaciones con favoritos: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllPreachesWithFavorite'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(
        e, "Obtener todas las predicaciones con favoritos");
  }
}

Future<ResponseData> getChapterWithVerses(String bookId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  operationName = "GetOneReflectionRandom ";
  QueryOptions options = QueryOptions(
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
    if (data['getOneBookByBookId'] == null ||
        data['getOneBookByBookId']['chapters'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener los capítulos con versículos.',
          error: 'Error al obtener un libro por BookId: no se devolvieron dato',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getOneBookByBookId']['chapters'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener Un libro");
  }
}

Future<ResponseData> getOneChapterWithVerses(String? chapterId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  operationName = "GetOneReflectionRandom ";

  QueryOptions options = QueryOptions(
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
          userFriendlyError: 'No se pudo obtener un capítulo por ChapterId.',
          error:
              'Error al obtener un capítulo por ChapterId: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getOneChapterByChapterId'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener un capítulo");
  }
}

Future<ResponseData> getAudioByChapter(String? chapterId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  operationName = "GetOneReflectionRandom ";
  QueryOptions options = QueryOptions(
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
          userFriendlyError: 'No se pudo obtener el audio por capítulo.',
          error: 'Get Audio By Chapter  failed: No data returned',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAudioByChapter'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener audio por capítulo");
  }
}

Future<ResponseData> getVideoByChapter(String? chapterId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);
  operationName = 'GetVideoByChapter';
  QueryOptions options = QueryOptions(
    document: gql(r'''
         query GetVideoByChapter($chapterId: ID) {
        getVideoByChapter(chapterId: $chapterId) {
          id
          chapter
          url
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
    if (data['getVideoByChapter'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError: 'No se pudo obtener el video por capítulo.',
          error:
              'Error al obtener el video por capítulo: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getVideoByChapter'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener video por capítulo");
  }
}

Future<ResponseData> getBooksByBibleId(String? versionId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  operationName = "GetBooksByBibleId ";
  QueryOptions options = QueryOptions(
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
          userFriendlyError: 'No se pudieron obtener los libros por BibleId.',
          error: 'Error al obtener libros por BibleId: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getBooksByBibleId'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener libros por BibleId");
  }
}

Future<ResponseData> getAllHighLighters(
    String userId, int versionId, String chapterId) async {
  String? userToken = await PreferencesManager().getUserToken();

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
          userFriendlyError:
              'No se pudieron obtener todos los Versículos resaltados.',
          error:
              'Error al obtener todos los Versículos resaltados: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllHighlighters'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener Versículos Resaltados");
  }
}

Future<ResponseData> getFavoriteVerseByUser(
  int? page,
  int? limit,
  String? versionId,
  String? chapterId,
  String userId,
) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
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
          userFriendlyError:
              'No se pudieron obtener los versículos favoritos por ChapterId.',
          error:
              'Error al obtener versículos favoritos por ChapterId: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getFavoriteVersesByChapterId'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener versículos favoritos por ChapterId");
  }
}

Future<ResponseData> getAllTeaching(
    int page, int limit, String title, String churchId) async {
  String? userToken = await PreferencesManager().getUserToken();

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
          userFriendlyError: 'No se pudieron obtener todas las enseñanzas.',
          error: 'Error al obtener toda la enseñanza: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllTeaching'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todas las enseñanzas");
  }
}

Future<ResponseData> getAllCharacters(
    int page, int limit, String name, bool isNewTestament) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
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
          userFriendlyError: 'No se pudieron obtener todos los personajes.',
          error: 'Error al obtener caracteres: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getCharacters'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todos los personajes");
  }
}

Future<ResponseData> getReferenceTeaching(String id) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
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
          userFriendlyError:
              'No se pudieron obtener los versículos para la enseñanza.',
          error:
              'Error al obtener Versos para la Enseñanza: No se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getVersesForTeaching'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(
        e, "Obtener todos los Versículos para la enseñanza");
  }
}

Future<ResponseData> getCharacterFirstAppearance(
    String getCharacterFirstAppearanceId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
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
          userFriendlyError:
              'No se pudo obtener la primera aparición del personaje.',
          error:
              'Error al obtener la primera aparición del personaje: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getCharacterFirstAppearance'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener la primera aparición del personaje");
  }
}

Future<ResponseData> getWordsConcordance(
    int page, int limit, String versionId, String searchWord) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
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
          userFriendlyError: 'No se pudo obtener la concordancia de palabras.',
          error:
              'Error en la concordancia de búsqueda de palabras: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['wordSearchConcordance'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener concordancia de palabras");
  }
}

Future<ResponseData> getAllNotification(
    int page, int? limit, String userId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    document: gql(r'''
        query GetAllNotificationsByUserId($page: Int, $limit: Int, $userId: ID) {
        getAllNotificationsByUserId(page: $page, limit: $limit, userId: $userId) {
          data {
           id
           title
           message
           isRead
           action
           actionLabel
           notificationType
           notificationTypeName
           variables
           model
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
          userFriendlyError:
              'No se pudieron obtener todas las notificaciones por UserId.',
          error:
              'Error al obtener todas las notificaciones por ID de usuario: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllNotificationsByUserId'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todas las notificaciones");
  }
}

Future<ResponseData> getMemory() async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetMemory",
    document: gql(r'''
      query GetMemory {
        getMemory {
          id
          pair
          img {
            urlImg
          }
          cardStatus
          blocked
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

    final data = removeTypename(result.data);
    if (data['getMemory'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError: 'No se pudo obtener la memoria.',
          error: 'Error al obtener Cartas de memoria: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getMemory'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener cartas de memoria");
  }
}

Future<ResponseData> getAllGuessCharacters(
    int? page, int? limit, String difficulty, String? name) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetAllGuessCharacters",
    document: gql(r'''
     query GetAllGuessCharacters($page: Int, $limit: Int, $difficulty: String, $name: String) {
        getAllGuessCharacters(page: $page, limit: $limit, difficulty: $difficulty, name: $name) {
          data {
            id
            character {
            id
              name
               img {
              urlImg
            }
            }
            difficulty
            img {
              urlImg
            }
            clues {
              id
              guessCharacterId
              description
              status
            }
            status
          }
        }
      }
      '''),
    variables: <String, dynamic>{
      "page": page,
      "limit": limit,
      "difficulty": difficulty,
      "name": name
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllGuessCharacters'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener todos los personajes de adivinanza.',
          error:
              'Error al obtener todos los caracteres: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllGuessCharacters'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todos los personajes de adivinanza");
  }
}

// query  for games
Future<ResponseData> getAllResultGame(String? userId, String category) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "ResultByUser",
    document: gql(r'''
     query ResultByUser($userId: ID, $category: String) {
        resultByUser(userId: $userId, category: $category) {
          category
          day
          difficulty
          id
          message {
            id
            resultTitle
            resultDescription
            category
            difficulty
            status
          }
          score
          user {
            id
            username
          }
        }
      }
      '''),
    variables: <String, dynamic>{
      "userId": userId,
      "category": category,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['resultByUser'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError: 'No se pudo obtener el resultado por usuario.',
          error: 'Resultado Por Usuario fallido: No se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['resultByUser'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener resultado por usuario");
  }
}

Future<ResponseData> getQuestionGameDifficulty(String difficulty) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetQuestionsByDifficulty",
    document: gql(r'''
     query GetQuestionsByDifficulty($difficulty: String) {
        getQuestionsByDifficulty(difficulty: $difficulty) {
          id
          question
          difficulty
          answers {
            id
            answer
            isCorrect
            questionId
          }
          timeline {
          id
          questionId
          answer:eventText,
          correctOrder
          }
          isOrdering
        }
      }
      '''),
    variables: <String, dynamic>{
      "difficulty": difficulty,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getQuestionsByDifficulty'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener las preguntas por dificultad.',
          error:
              'Obtener preguntas por dificultad falló: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getQuestionsByDifficulty'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener preguntas por dificultad");
  }
}

/// Queries de prayer
// Obtener tipos de Pedidos de Oración
Future<ResponseData> getAllPrayerRequestTypes() async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetAllPrayerRequestTypes",
    document: gql(r'''
      query GetAllPrayerRequestTypes {
        getAllPrayerRequestTypes {
          id
          name
          description
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

    final data = removeTypename(result.data);
    if (data['getAllPrayerRequestTypes'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener todos los tipos de solicitudes de oración.',
          error:
              'Error al obtener todos los tipos de solicitudes de oración: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllPrayerRequestTypes'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(
        e, "Obtener todos los tipos de solicitudes de oración");
  }
}

// obtener los sub tipos de un tipo de pedido de oración
Future<ResponseData> getAllPrayerRequestSubTypes(String prayerTypeId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetAllPrayerSubType",
    document: gql(r'''
      query GetAllPrayerSubType($prayerTypeId: ID!) {
        getAllPrayerSubType(prayerTypeId: $prayerTypeId) {
          id
          name
          description
          prayerTypeId
        }
      }
      '''),
    variables: <String, dynamic>{
      "prayerTypeId": prayerTypeId,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllPrayerSubType'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener todos los subtipos de oración.',
          error:
              'Error al obtener todos los subtipos de oración: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllPrayerSubType'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todos los subtipos de oración");
  }
}

// saber si el usuario forma parte de un grupo de oración
Future<ResponseData> isMemberPrayerGroup(String userId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "IsUserPrayerGroupMember",
    document: gql(r'''
      query IsUserPrayerGroupMember($userId: ID!) {
        isUserPrayerGroupMember(userId: $userId){
          successful
          message
          id
        }
      }
      '''),
    variables: <String, dynamic>{
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
    if (data['isUserPrayerGroupMember'] == null) {
      return ResponseData(
        data: null,
        userFriendlyError:
            'No se pudo verificar si el usuario es miembro del grupo de oración.',
        error:
            'Falló la membresía del grupo de oración del usuario; No se devolvieron datos',
      );
    }

    return ResponseData(
      data: data['isUserPrayerGroupMember'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(
        e, "Verificar membresía del grupo de oración del usuario");
  }
}

// Obtener las solicitudes de Oración de asignadas a un grupo de oración
Future<ResponseData> getAllRequestPrayerByGroupId(
    int? page, int? limit, String? groupId, String? text) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetPrayerRequestByPrayerGroup",
    document: gql(r'''
     query GetPrayerRequestByPrayerGroup($page: Int, $limit: Int, $prayerGroupId: ID, $text: String) {
        getPrayerRequestByPrayerGroup(page: $page, limit: $limit, prayerGroupId: $prayerGroupId, text: $text) {
          data {
            requestId
            requestDate
            requestedBy
            prayedFor
            prayerCategory {
              name
              id
            }
            prayerSubType {
              name
              id
            }
            prayerDetails
            statusRequest {
              name
              messageSystems {
                message
              }
            }
            audioPrayer {
              url
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
      "prayerGroupId": groupId,
      "text": text
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getPrayerRequestByPrayerGroup'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener todas las solicitudes de oración por grupo de oración.',
          error:
              'Error al obtener una solicitud de oración por grupo de oración: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getPrayerRequestByPrayerGroup'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(
        e, "Obtener todas las solicitudes de oración por grupo de oración");
  }
}

// Obtener las solicitudes de Oración de asignadas a un grupo de oración
Future<ResponseData> getAllRequestPrayerByUser(
    String? userId, int? page, int? limit, String? filter) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetPrayerRequestByUserId",
    document: gql(r'''
     query GetPrayerRequestByUserId($page: Int, $limit: Int, $userId: ID, $text: String) {
        getPrayerRequestByUserId(page: $page, limit: $limit, userId: $userId, text: $text) {
          data {
            requestId
            requestDate
            requestedBy
            prayedFor
            prayerCategory {
              id
              name
            }
            prayerSubType {
              id
              name
            }
            prayerDetails
            statusRequest {
              name
              messageSystems {
                message
              }
            }
            audioPrayer {
              url
            }
            responser {
              id
              message
              responder
              bookName
              chapter
              verse
              text
              audioResponse {
                url
              }
              createdAt
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
      "userId": userId,
      "page": page,
      "limit": limit,
      "text": filter
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getPrayerRequestByUserId'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener todas las solicitudes de oración por UserId.',
          error:
              'Error al obtener una solicitud de oración por ID de usuario: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getPrayerRequestByUserId'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(
        e, "Obtener todas las solicitudes de oración por UserId");
  }
}

Future<ResponseData> getReferencesBibleByName(
    String? bibleReferencePattern, String? version) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetVerseByChapterBookNameAndCodeBible",
    document: gql(r'''
     query GetVerseByChapterBookNameAndCodeBible($bibleReferencePattern: String, $version: String) {
        getVerseByChapterBookNameAndCodeBible(bibleReferencePattern: $bibleReferencePattern, version: $version) {
          bibleName
          bookName
          chapterNumber
          verses {
            verse
            text
            id
          }
        }
      }
      '''),
    variables: <String, dynamic>{
      "bibleReferencePattern": bibleReferencePattern,
      "version": version,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getVerseByChapterBookNameAndCodeBible'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener los versículos por nombre de libro y código de biblia.',
          error:
              'Error al obtener versículo por capítulo, nombre del libro y código de la Biblia: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getVerseByChapterBookNameAndCodeBible'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(
        e, "Obtener versículos por nombre de libro y código de biblia");
  }
}

Future<ResponseData> getUrlCertificate(String userId, String? courseId) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetUrlCertificateByUser",
    document: gql(r'''
     query GetUrlCertificateByUser($userId: ID!, $courseId: ID!) {
      getUrlCertificateByUser(userId: $userId, courseId: $courseId) {
          url
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

    final data = removeTypename(result.data);
    if (data['getUrlCertificateByUser'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudo obtener la URL del certificado por usuario.',
          error:
              'Error al obtener el certificado de URL por usuario: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getUrlCertificateByUser'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener URL del certificado por usuario");
  }
}

Future<ResponseData> getStatesByCountry(
    String countryId, int? limit, int? offset, String? search) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetAllStatesByCountry",
    document: gql(r'''
     query GetAllStatesByCountry($countryId: ID!, $limit: Int, $offset: Int, $search: String) {
        getAllStatesByCountry(countryId: $countryId, limit: $limit, offset: $offset, search: $search) {
          id
          name
        }
      }
      '''),
    variables: <String, dynamic>{
      "countryId": countryId,
      "limit": limit,
      "offset": offset,
      "search": search,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllStatesByCountry'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener todos los estados por país.',
          error:
              'Error al obtener todos los estados por país: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllStatesByCountry'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todos los estados por país");
  }
}

Future<ResponseData> getCitiesByState(
    String stateId, int? limit, int? offset, String? search) async {
  String? userToken = await PreferencesManager().getUserToken();

  final GraphQLClient client = createClient(authToken: userToken);

  QueryOptions options = QueryOptions(
    operationName: "GetAllCitiesByState",
    document: gql(r'''
     query GetAllCitiesByState($stateId: ID!, $limit: Int, $offset: Int, $search: String) {
        getAllCitiesByState(stateId: $stateId, limit: $limit, offset: $offset, search: $search) {
          name
          id
        }
      }
      '''),
    variables: <String, dynamic>{
      "stateId": stateId,
      "limit": limit,
      "offset": offset,
      "search": search,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllCitiesByState'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener todas las ciudades por estado.',
          error:
              'Error al obtener todas las ciudades por estado: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllCitiesByState'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todas las ciudades por estado");
  }
}

Future<ResponseData> getCountries({
  String query = '',
  int page = 1,
  int limit = 20,
}) async {
  final offset = (page - 1) * limit;
  final GraphQLClient client = createClient();
  final options = QueryOptions(
    operationName: "GetAllCountryWithCodeAreas",
    document: gql(r'''
          query GetAllCountryWithCodeAreas($limit: Int, $offset: Int, $search: String) {
            getAllCountryWithCodeAreas(limit: $limit, offset: $offset, search: $search) {
              id

              
              name
              areaCodeCountry {
                id
                code
              }
            }
          }
        '''),
    variables: <String, dynamic>{
      "limit": limit,
      "offset": offset,
      "search": query,
    },
    fetchPolicy: FetchPolicy.noCache,
  );
  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllCountryWithCodeAreas'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener todas las ciudades por estado.',
          error:
              'Error al obtener todas las ciudades por estado: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllCountryWithCodeAreas'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todas las ciudades por estado");
  }
}

Future<ResponseData> getCodeAreas({
  String query = '',
  int page = 1,
  int limit = 20,
}) async {
  final offset = (page - 1) * limit;
  final GraphQLClient client = createClient();
  final options = QueryOptions(
    operationName: "GetAllAreaCodes",
    document: gql(r'''
         query GetAllAreaCodes($limit: Int, $offset: Int, $search: String) {
            getAllAreaCodes(limit: $limit, offset: $offset, search: $search) {
              id
              code
            }
          }
        '''),
    variables: <String, dynamic>{
      "limit": limit,
      "offset": offset,
      "search": query
    },
    fetchPolicy: FetchPolicy.noCache,
  );

  try {
    final QueryResult result = await client.query(options);
    if (result.hasException) {
      return ResponseData.fromQueryResult(result);
    }

    final data = removeTypename(result.data);
    if (data['getAllAreaCodes'] == null) {
      return ResponseData(
          data: null,
          userFriendlyError:
              'No se pudieron obtener tLos codigos de area.',
          error:
              'Error al obtener todas las ciudades por estado: no se devolvieron datos',
          errorType: ErrorType.noData);
    }

    return ResponseData(
      data: data['getAllAreaCodes'],
      error: null,
    );
  } catch (e) {
    return handleGenericError(e, "Obtener todas las ciudades por estado");
  }
}
