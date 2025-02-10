import 'package:biblia_palabra_de_vida_app/models/models.dart';

class UserProfile {
  final String userId;
  final UpdateDataProfile dataProfiles;


  UserProfile({
    required this.userId,
    required this.dataProfiles,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        userId: json["userId"],
        dataProfiles: UpdateDataProfile.fromJson(json["dataProfiles"]),
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "dataProfiles": dataProfiles.toJson(),
      };

  // Método para imprimir el objeto de manera legible (opcional)
  @override
  String toString() {
    return 'User{userId: $userId, dataProfiles: $dataProfiles}';
  }
}

class UpdateDataProfile {
  final String? lastname;
  final String? name;
  final String? birthdate;
  final String? identifier;
  final String? phoneNumber;
  final Country? country;
  final String? city;
  final String? gender;
  final bool? isBaptized;
  final UserChurch? church;

  UpdateDataProfile( {
    this.lastname,
    this.name,
    this.birthdate,
    this.identifier,
    this.phoneNumber,
    this.country,
    this.city,
    this.gender,
    this.isBaptized,
    this.church,
  });

  UpdateDataProfile copyWith({
    String? lastname,
    String? name,
    String? birthdate,
    String? identifier,
    String? phoneNumber,
    Country? country,
    String? city,
    String? gender,
    bool? isBaptized,
    UserChurch? church,
  }) {
    return UpdateDataProfile(
        identifier: identifier,
        name: name,
        lastname: lastname ?? '',
        birthdate: birthdate,
        city: city,
        country: country,
        gender: gender,
        isBaptized: isBaptized,
        phoneNumber: phoneNumber,
        church:church
        );
  }

  factory UpdateDataProfile.fromJson(Map<String, dynamic> json) =>
      UpdateDataProfile(
        lastname: json["lastname"],
        name: json["name"],
        birthdate: json["birthdate"],
        identifier: json["identifier"],
        phoneNumber: json["phoneNumber"],
        country: json["country"],
        city: json["city"],
        gender: json["gender"],
        isBaptized: json["isBaptized"],
        church: json['church']
      );

  Map<String, dynamic> toJson() => {
        "lastname": lastname,
        "name": name,
        "birthdate": birthdate,
        "identifier": identifier,
        "phoneNumber": phoneNumber,
        "country": country,
        "city": city,
        "gender": gender,
        "isBaptized": isBaptized,
        "church":church
      };

  @override
  String toString() {
    return 'DataProfiles{lastname: $lastname, name: $name, birthdate: $birthdate, identifier: $identifier, phoneNumber: $phoneNumber, country: $country, city: $city, gender: $gender, isBaptized: $isBaptized, church: $church}';
  }
}
