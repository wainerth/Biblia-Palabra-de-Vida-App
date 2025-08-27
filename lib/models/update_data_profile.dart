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
  final AreaCode? profileAreaCode;
  final String? phoneNumber;
  final Country? country;
  final StateModel? state;
  final CityModel? city;
  final String? gender;
  final bool? isBaptized;
  final UserChurch? church;

  UpdateDataProfile({
    this.lastname,
    this.name,
    this.birthdate,
    this.identifier,
    this.profileAreaCode,
    this.phoneNumber,
    this.country,
    this.city,
    this.state,
    this.gender,
    this.isBaptized,
    this.church,
  });

  UpdateDataProfile copyWith({
    String? lastname,
    String? name,
    String? birthdate,
    String? identifier,
    AreaCode? profileAreaCode,
    String? phoneNumber,
    Country? country,
    StateModel? state,
    CityModel? city,
    String? gender,
    bool? isBaptized,
    UserChurch? church,
  }) {
    return UpdateDataProfile(
        identifier: identifier,
        name: name,
        lastname: lastname ?? '',
        birthdate: birthdate,
        state: state,
        city: city,
        country: country,
        gender: gender,
        isBaptized: isBaptized,
        profileAreaCode: profileAreaCode,
        phoneNumber: phoneNumber,
        church: church);
  }

  factory UpdateDataProfile.fromJson(Map<String, dynamic> json) =>
      UpdateDataProfile(
          lastname: json["lastname"],
          name: json["name"],
          birthdate: json["birthdate"],
          identifier: json["identifier"],
          profileAreaCode: AreaCode.fromJson(json['profileAreaCode']),
          phoneNumber: json["phoneNumber"],
          country: json['country'] != null ?  Country.fromJson(json["country"]) : null,
          state: json["state"] != null ?  StateModel.fromJson(json["state"]) : null,
          city: json["city"] != null ? CityModel.fromJson(json["city"]) : null,
          gender: json["gender"],
          isBaptized: json["isBaptized"],
          church: json['church']);

  Map<String, dynamic> toJson() => {
        "lastname": lastname,
        "name": name,
        "birthdate": birthdate,
        "identifier": identifier,
        'profileAreaCode': profileAreaCode,
        "phoneNumber": phoneNumber,
        "country": country?.toJson(),
        "state": state?.toJson(),
        "city": city?.toJson(),
        "gender": gender,
        "isBaptized": isBaptized,
        "church": church
      };

  @override
  String toString() {
    return 'DataProfiles{lastname: $lastname, name: $name, birthdate: $birthdate, identifier: $identifier, profileAreaCode: $profileAreaCode, phoneNumber: $phoneNumber, country: $country, state: $state,city: $city, gender: $gender, isBaptized: $isBaptized, church: $church}';
  }
}
