import 'package:biblia_palabra_de_vida_app/models/models.dart';

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
  UserChurch copyWith({String? id, String? name, bool? status}) {
    return UserChurch(
        id: id ?? this.id,
        name: name ?? this.name,
        status: status ?? this.status);
  }

  factory UserChurch.fromJson(Map<String, dynamic> json) {
    var churchName = ChurchRelation.fromJson(
        json['churchRelation'] ?? {"name": json['name']});
    return UserChurch(
      id: json['churchId'] ?? json['id'],
      name: churchName.name,
      status: json['status'] is bool
          ? json['status']
          : json['status'] > 0
              ? true
              : false,
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
  User copyWith(
      {String? id,
      String? username,
      String? email,
      String? lastLogin,
      int? rolId,
      List<UserChurch>? userChurch}) {
    return User(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        lastLogin: lastLogin ?? this.lastLogin,
        rolId: rolId ?? this.rolId,
        userChurch: userChurch ?? this.userChurch);
  }

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
  final String? lastname;
  final int expTotalUser;
  final int energyPoints;
  final String imgProfileUser;
  final String? phoneNumber;
  final Country? country;
  final String? city;
  final String favoriteVerseId;
  final bool notifications;
  final String? birthdate;
  final String? identifier; //cédula
  final String? gender; // example M o F
  final bool? isBaptized;
  final String? currentLeagueId; //future ligue in ranking
  final String createdAt;
  final int achievementsReachedCount;
  final int streakDaysCount;
  final int preachingsCreatedCount;
  final User user;
  final List<UserTitle>? title;
  final UserRanking? league;

  LoginUser({
    required this.name,
    required this.expTotalUser,
    required this.energyPoints,
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
    required this.title,
    required this.league,
    this.lastname,
    this.birthdate,
    this.identifier,
    this.gender,
    this.isBaptized,
    this.currentLeagueId,
    this.city,
  });

  LoginUser copyWith(
      {String? name,
      String? lastname,
      String? gender,
      int? expTotalUser,
      int? energyPoints,
      String? city,
      String? email,
      String? imgProfileUser,
      String? birthdate,
      String? identifier,
      String? phoneNumber,
      Country? country,
      bool? isBaptized,
      User? user,
      String? favoriteVerseId,
      bool? notifications,
      String? createdAt,
      int? achievementsReachedCount,
      int? streakDaysCount,
      int? preachingsCreatedCount}) {
    return LoginUser(
        name: name ?? this.name,
        lastname: lastname ?? this.lastname,
        city: city ?? this.city,
        imgProfileUser: imgProfileUser ?? this.imgProfileUser,
        expTotalUser: expTotalUser ?? this.expTotalUser ,
        energyPoints: energyPoints ?? this.energyPoints,
        country: country ?? this.country,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        favoriteVerseId: favoriteVerseId ?? this.favoriteVerseId,
        notifications: notifications ?? this.notifications,
        createdAt: createdAt ?? this.createdAt,
        achievementsReachedCount: achievementsReachedCount ?? this.achievementsReachedCount,
        streakDaysCount: streakDaysCount ?? this.streakDaysCount,
        preachingsCreatedCount: preachingsCreatedCount ?? this.preachingsCreatedCount,
        user: user ?? this.user,
        title: title ?? this.title,
        league: league ?? this.league,
        birthdate: birthdate ?? this.birthdate,
        identifier: identifier ?? this.identifier,
        gender: gender ?? this.gender,
        isBaptized: isBaptized ?? this.isBaptized,
        currentLeagueId: currentLeagueId ?? this.currentLeagueId);
  }

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    List<UserTitle> title = [];
    if (json['title'] != null) {
      title = (json['title'] as List)
          .map((i) => UserTitle.fromJson(i))
          .toList();
    }
    return LoginUser(
      identifier: json['identifier'],
      name: json['name'],
      lastname: json['lastname'] ?? '',
      gender: json['gender'] ?? '',
      birthdate: json['birthdate'] ?? '',
      isBaptized: json['isBaptized'] ?? false,
      expTotalUser: json['expTotalUser'],
      energyPoints: json['energyPoints'] ?? 0,
      imgProfileUser: json['imgProfileUser'],
      phoneNumber: json['phoneNumber'] ?? '',
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      city: json['city'],
      favoriteVerseId: json['favoriteVerseId'].toString(),
      notifications: json['notifications'] ?? false,
      createdAt: json['createdAt'],
      achievementsReachedCount: json['achievementsReachedCount'],
      streakDaysCount: json['streakDaysCount'],
      preachingsCreatedCount: json['preachingsCreatedCount'],
      currentLeagueId: json['currentLeagueId'],
      user: User.fromJson(json['user']),
      title: title,
      league:
          json['league'] != null ? UserRanking.fromJson(json['league']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'identifier': identifier,
        'name': name,
        'lastname': lastname,
        'gender': gender,
        'birthdate': birthdate,
        'isBaptized': isBaptized,
        'expTotalUser': expTotalUser,
        'energyPoints': energyPoints,
        'imgProfileUser': imgProfileUser,
        'phoneNumber': phoneNumber,
        'country': country?.toJson(),
        'city': city,
        'favoriteVerseId': favoriteVerseId,
        'notifications': notifications,
        'createdAt': createdAt,
        'achievementsReachedCount': achievementsReachedCount,
        'streakDaysCount': streakDaysCount,
        'preachingsCreatedCount': preachingsCreatedCount,
        'currentLeagueId': currentLeagueId,
        'user': user.toJson(),
        'title': title,
        'league': league,
      };
}
