import 'package:biblia_palabra_de_vida_app/models/models.dart';

class CountryUser {
  final String id;
  final String country;
  final String countryCode;

  CountryUser({
    required this.id,
    required this.country,
    required this.countryCode,
  });

  factory CountryUser.fromJson(Map<String, dynamic> json) {
    return CountryUser(
      id: json['id'],
      country: json['country'],
      countryCode: json['country_code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'country': country,
        'country_code': countryCode,
      };
}

class ChurchRelation {
  final String name;

  ChurchRelation({
    required this.name,
  });

  factory ChurchRelation.fromJson(Map<String, dynamic> json) {
    return ChurchRelation(
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
      };
}

class UserChurch {
  final String id;
  final String name;
  final bool status;
  UserChurch({required this.id, required this.name, required this.status});

  factory UserChurch.fromJson(Map<String, dynamic> json) {
    var churchName = ChurchRelation.fromJson(json['churchRelation']);
    return UserChurch(
      id: json['churchId'],
      name: churchName.name,
      status: json['status'] > 0 ? true : false,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'status': status};
}

class User {
  final String id;
  final String username;
  final String email;
  final String lastLogin;
  final int rolId;
  final List<UserChurch> userChurch;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.lastLogin,
    required this.rolId,
    required this.userChurch,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    List<UserChurch> userChurch = [];
    if (json['userChurch'] != null) {
      userChurch = (json['userChurch'] as List)
          .map((i) => UserChurch.fromJson(i))
          .toList();
    }

    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      lastLogin: json['lastLogin'],
      rolId: json['rolId'],
      userChurch: userChurch,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'lastLogin': lastLogin,
        'rolId': rolId,
        'userChurch': userChurch.map((e) => e.toJson()).toList(),
      };
}

class LoginUser {
  final String name;
  final String? lastName;
  final int expTotalUser;
  final String imgProfileUser;
  final String? phoneNumber;
  final CountryUser? country;
  final String favoriteVerseId;
  final bool notifications;
  final String? birthday;
  final String? identifier; //cédula
  final String? gender; // example M o F
  final bool? isBaptized;
  final String? currentLeagueId; //future ligue in ranking
  final String createdAt;
  final int achievementsReachedCount;
  final int streakDaysCount;
  final int preachingsCreatedCount;
  final User user;
  final List<UserAchievement>? achievement;
  final UserRanking? league;

  LoginUser({
    required this.name,
    required this.expTotalUser,
    required this.imgProfileUser,
    this.phoneNumber,
    required this.country,
    required this.favoriteVerseId,
    required this.notifications,
    required this.createdAt,
    required this.achievementsReachedCount,
    required this.streakDaysCount,
    required this.preachingsCreatedCount,
    required this.user,
    required this.achievement,
    required this.league,
    this.lastName,
    this.birthday,
    this.identifier,
    this.gender,
    this.isBaptized,
    this.currentLeagueId,
  });

  LoginUser copyWith({
    String? name,
    String? email,
    String? imgProfileUser,
  }) {
    return LoginUser(
        name: name ?? this.name,
        imgProfileUser: imgProfileUser ?? this.imgProfileUser,
        expTotalUser: expTotalUser,
        country: country,
        phoneNumber: phoneNumber,
        favoriteVerseId: '',
        notifications: notifications,
        createdAt: '',
        achievementsReachedCount: achievementsReachedCount,
        streakDaysCount: streakDaysCount,
        preachingsCreatedCount: preachingsCreatedCount,
        user: user,
        achievement: achievement,
        league: league,
        lastName: lastName,
        birthday: birthday,
        identifier: identifier,
        gender: gender,
        isBaptized: isBaptized,
        currentLeagueId: currentLeagueId);
  }

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    List<UserAchievement> achievement = [];
    if (json['achievement'] != null) {
      achievement = (json['achievement'] as List)
          .map((i) => UserAchievement.fromJson(i))
          .toList();
    }
    return LoginUser(
      identifier: json['identifier'],
      name: json['name'],
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? '',
      isBaptized: json['isBaptized'] ?? false,
      expTotalUser: json['expTotalUser'],
      imgProfileUser: json['imgProfileUser'],
      phoneNumber: json['phoneNumber'] ?? '',
      country: json['country'] != null
          ? CountryUser.fromJson(json['country'])
          : null, // CountryUser.fromJson(json['country']),
      favoriteVerseId: json['favoriteVerseId'].toString(),
      notifications: json['notifications'] ?? false,
      createdAt: json['createdAt'],
      achievementsReachedCount: json['achievementsReachedCount'],
      streakDaysCount: json['streakDaysCount'],
      preachingsCreatedCount: json['preachingsCreatedCount'],
      currentLeagueId: json['currentLeagueId'],
      user: User.fromJson(json['user']),
      achievement: achievement,
      league: json['league'] != null ? UserRanking.fromJson(json['league']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'name': name,
        'lastName': lastName,
        'gender': gender,
        'birthday': birthday,
        'isBaptized': isBaptized,
        'expTotalUser': expTotalUser,
        'imgProfileUser': imgProfileUser,
        'phoneNumber': phoneNumber,
        'country': country?.toJson(),
        'favoriteVerseId': favoriteVerseId,
        'notifications': notifications,
        'createdAt': createdAt,
        'achievementsReachedCount': achievementsReachedCount,
        'streakDaysCount': streakDaysCount,
        'preachingsCreatedCount': preachingsCreatedCount,
        'currentLeagueId': currentLeagueId,
        'user': user.toJson(),
        'achievement': achievement,
        'league' : league,
      };
}
