class SexModel {
  final String id;
  final String name;
  final String code;
  SexModel({required this.id, required this.name, required this.code});

  factory SexModel.fromJson(Map<String, dynamic> json) {
    return SexModel(id: json["id"], name: json["name"], code: json["code"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name, "code": code};
}
