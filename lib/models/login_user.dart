import 'package:biblia_palabra_de_vida_app/models/models.dart';

class UserChurch {
  final String id;
  final String? churchName;
  final bool status;
  UserChurch({required this.id, required this.churchName, required this.status});
  UserChurch copyWith({String? id, String? name, bool? status}) {
    return UserChurch(
        id: id ?? this.id,
        churchName: churchName ?? this.churchName,
        status: status ?? this.status);
  }

  factory UserChurch.fromJson(Map<String, dynamic> json) {
  
    return UserChurch(
      id: json['id'],
      churchName: json['churchName'],
      status: json['status'] is bool ? json['status'] : (json['status'] > 0 ? true : false)
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'churchName': churchName, 'status': status};
}
class LoginUser {
  final String userId;
  final String name;
  final String? lastname;
  final String? username;
  final String? email;
  final int expTotalUser;
  final int energyPoints;
  final Img? imgProfileUser;
  final AreaCode? profileAreaCode;
  final String? phoneNumber;
  final Country? country;
  final String? city;
  final String favoriteVerseId;
  final bool notifications;
  final String? birthdate;
  final String? identifier; //cédula
  final String? gender; // example M o F
  final bool? isBaptized;
  final League? currentLeague; //future ligue in ranking
  final String createdAt;
  final int achievementsReachedCount;
  final int streakDaysCount;
  final int preachingsCreatedCount;
  final int completedCourse;
  final List<UserChurch> userChurch;
  final List<UserTitle>? title;
  final UserRanking? league;

  LoginUser({
    required this.userId,
    required this.name,
    required this.username,
    required this.email,
    required this.expTotalUser,
    required this.energyPoints,
    required this.imgProfileUser,
    this.profileAreaCode,
    this.phoneNumber,
    required this.country,
    required this.favoriteVerseId,
    required this.notifications,
    required this.createdAt,
    required this.achievementsReachedCount,
    required this.streakDaysCount,
    required this.preachingsCreatedCount,
    required this.completedCourse,
    required this.userChurch,
    required this.title,
    required this.league,
    this.lastname,
    this.birthdate,
    this.identifier,
    this.gender,
    this.isBaptized,
    this.currentLeague,
    this.city,
  });

  LoginUser copyWith({
    String? userId,
    String? name,
    String? username,
    String? lastname,
    String? email,
    String? gender,
    int? expTotalUser,
    int? energyPoints,
    String? city,
    Img? imgProfileUser,
    String? birthdate,
    String? identifier,
    AreaCode? profileAreaCode,
    String? phoneNumber,
    Country? country,
    bool? isBaptized,
    List<UserChurch>? userChurch,
    String? favoriteVerseId,
    bool? notifications,
    String? createdAt,
    int? achievementsReachedCount,
    int? streakDaysCount,
    int? preachingsCreatedCount,
    int? completedCourse,
  }) {
    return LoginUser(
        userId: userId ?? this.userId,
        name: name ?? this.name,
        username: username ?? this.username,
        lastname: lastname ?? this.lastname,
        email: email ?? this.email,
        city: city ?? this.city,
        imgProfileUser: imgProfileUser ?? this.imgProfileUser,
        expTotalUser: expTotalUser ?? this.expTotalUser,
        energyPoints: energyPoints ?? this.energyPoints,
        country: country ?? this.country,
        profileAreaCode: profileAreaCode ?? this.profileAreaCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        favoriteVerseId: favoriteVerseId ?? this.favoriteVerseId,
        notifications: notifications ?? this.notifications,
        createdAt: createdAt ?? this.createdAt,
        achievementsReachedCount:
            achievementsReachedCount ?? this.achievementsReachedCount,
        streakDaysCount: streakDaysCount ?? this.streakDaysCount,
        preachingsCreatedCount:
            preachingsCreatedCount ?? this.preachingsCreatedCount,
        completedCourse: completedCourse ?? this.completedCourse,
        userChurch: userChurch ?? this.userChurch,
        title: title ?? this.title,
        league: league ?? this.league,
        birthdate: birthdate ?? this.birthdate,
        identifier: identifier ?? this.identifier,
        gender: gender ?? this.gender,
        isBaptized: isBaptized ?? this.isBaptized,
        currentLeague: currentLeague ?? this.currentLeague);
  }

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    List<UserTitle> title = [];
    if (json['title'] != null) {
      title =
          (json['title'] as List).map((i) => UserTitle.fromJson(i)).toList();
    }
    return LoginUser(
      userId: json['userId'],
      identifier: json['identifier'],
      name: json['name'],
      lastname: json['lastname'] ?? '',
      email: json['email'] ?? '',
      username: json['username'],
      gender: json['gender'] ?? '',
      birthdate: json['birthdate'] ?? '',
      isBaptized: json['isBaptized'] ?? false,
      expTotalUser: json['expTotalUser'],
      energyPoints: json['energyPoints'] ?? 0,
      imgProfileUser: json['imgProfileUser'] != null ? Img.fromJson(json['imgProfileUser']) : null,
      phoneNumber: json['phoneNumber'] ?? '',
      profileAreaCode: json['profileAreaCode'] != null ? AreaCode.fromJson(json['profileAreaCode']) : null,
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      city: json['city'],
      favoriteVerseId: json['favoriteVerseId'].toString(),
      notifications: json['notifications'] ?? false,
      createdAt: json['createdAt'],
      achievementsReachedCount: json['achievementsReachedCount'],
      streakDaysCount: json['streakDaysCount'],
      preachingsCreatedCount: json['preachingsCreatedCount'],
      completedCourse: json['completedCourse'] ?? 0,
      currentLeague: json['currentLeague'] != null ? League.fromJson(json['currentLeague']) : null,
      userChurch: json['userChurch'] != null
          ?  (json['userChurch'] as List)
          .map((i) => UserChurch.fromJson(i))
          .toList()
          : [],
      title: title,
      league:
          json['league'] != null ? UserRanking.fromJson(json['league']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'identifier': identifier,
        'name': name,
        'lastname': lastname,
        'email': email,
        'username': username,
        'gender': gender,
        'birthdate': birthdate,
        'isBaptized': isBaptized,
        'expTotalUser': expTotalUser,
        'energyPoints': energyPoints,
        'imgProfileUser': imgProfileUser?.toJson(),
        'profileAreaCode': profileAreaCode,
        'phoneNumber': phoneNumber,
        'country': country?.toJson(),
        'city': city,
        'favoriteVerseId': favoriteVerseId,
        'notifications': notifications,
        'createdAt': createdAt,
        'achievementsReachedCount': achievementsReachedCount,
        'streakDaysCount': streakDaysCount,
        'preachingsCreatedCount': preachingsCreatedCount,
        'completedCourse': completedCourse,
        'currentLeague': currentLeague?.toJson(),
        'userChurch': userChurch.map((e) => e.toJson()).toList(),
        'title': title,
        'league': league,
      };
}
