class Country {
  final String id;
  final String country;
  final AreaCode? countryCode;
  Country({
    required this.id,
    required this.country,
    required this.countryCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json['id'] as String,
        country: json['country'] as String,
        countryCode: json['areaCodeCountry'] != null
            ? AreaCode.fromJson(json['areaCodeCountry'])
            : null,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'country': country,
        'areaCodeCountry': countryCode?.toJson(),
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
