class Country {
  final String id;
  final String name;
  final AreaCode? countryCode;
  final String? isoCode;
  Country({
    required this.id,
    required this.name,
    required this.countryCode,
    this.isoCode
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json['id'] as String,
        name: json['name'] as String,
        countryCode: json['areaCodeCountry'] != null
            ? AreaCode.fromJson(json['areaCodeCountry'])
            : null,
            isoCode: json["isoCode"]
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'areaCodeCountry': countryCode?.toJson(),
        "isoCode": isoCode
      };
}

class StateModel {
  final String id;
  final String name;
  StateModel({
    required this.id,
    required this.name,
  });

  factory StateModel.fromJson(Map<String, dynamic> json) => StateModel(
        id: json['id'] as String,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}

class CityModel {
  final String id;
  final String name;
  CityModel({
    required this.id,
    required this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        id: json['id'] as String,
        name: json['name'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}

class AreaCode {
  final String id;
  final String code;
  AreaCode({required this.id, required this.code});

  factory AreaCode.fromJson(Map<String, dynamic> json) => AreaCode(
        id: json['id'],
        code: json['code'],
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'code': code,
      };
}
