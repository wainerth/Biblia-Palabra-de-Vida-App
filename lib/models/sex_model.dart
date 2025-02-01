class SexModel {
  final String id;
  final String name;
  SexModel({required this.id, required this.name});

  factory SexModel.fromJson(Map<String, dynamic> json) {
    return SexModel(id: json["id"], name: json["name"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "name": name};
}
