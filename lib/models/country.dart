class Country {
  final String id;
  final String country;
  final String countryCode;

  Country({
    required this.id,
    required this.country,
    required this.countryCode,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json['id'] as String,
        country: json['country'] as String,
        countryCode: json['country_code'] as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'country': country,
        'country_code': countryCode,
      };
}