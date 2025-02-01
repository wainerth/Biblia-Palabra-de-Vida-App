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
  final String churchId;
  final String churchName;

  UserChurch({
    required this.churchId,
    required this.churchName,
  });

  factory UserChurch.fromJson(Map<String, dynamic> json) {
    var churchName = ChurchRelation.fromJson(json['churchRelation']);
    return UserChurch(
      churchId: json['churchId'],
      churchName: churchName.name,
    );
  }

  Map<String, dynamic> toJson() => {
        'churchId': churchId,
        'churchName': churchName,
      };
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
  final int expTotalUser;
  final String imgProfileUser;
  final CountryUser country;
  final String favoriteVerseId;
  final bool notifications;
  final String createdAt;
  final int achievementsReachedCount;
  final int streakDaysCount;
  final int preachingsCreatedCount;
  final User user;

  LoginUser({
    required this.name,
    required this.expTotalUser,
    required this.imgProfileUser,
    required this.country,
    required this.favoriteVerseId,
    required this.notifications,
    required this.createdAt,
    required this.achievementsReachedCount,
    required this.streakDaysCount,
    required this.preachingsCreatedCount,
    required this.user,
  });

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    var user = User.fromJson(json['user']);

    return LoginUser(
      name: json['name'],
      expTotalUser: json['expTotalUser'],
      imgProfileUser: json['imgProfileUser'],
      country: CountryUser.fromJson(json['country']),
      favoriteVerseId: json['favoriteVerseId'].toString(),
      notifications: json['notifications'] ?? false,
      createdAt: json['createdAt'],
      achievementsReachedCount: json['achievementsReachedCount'],
      streakDaysCount: json['streakDaysCount'],
      preachingsCreatedCount: json['preachingsCreatedCount'],
      user: User.fromJson(json['user']),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'expTotalUser': expTotalUser,
    'imgProfileUser': imgProfileUser,
    'country': country.toJson(),
    'favoriteVerseId': favoriteVerseId,
    'notifications': notifications,
    'createdAt': createdAt,
    'achievementsReachedCount': achievementsReachedCount,
    'streakDaysCount': streakDaysCount,
    'preachingsCreatedCount': preachingsCreatedCount,
    'user': user.toJson(),
  };
  
}
