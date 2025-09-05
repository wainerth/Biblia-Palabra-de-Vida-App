class CurrencyModel {
  final String id;
  final String code;
  final String symbol;
  final String name;
  final String locale;

  CurrencyModel({
    required this.id,
    required this.code,
    required this.symbol,
    required this.name,
    required this.locale,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) {
    return CurrencyModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      symbol: json['symbol'],
      locale: json['locale'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "code": code, "name": name, "symbol": symbol, "locale": locale};
  }
}
