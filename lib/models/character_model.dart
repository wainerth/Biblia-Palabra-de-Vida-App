
import 'package:biblia_palabra_de_vida_app/models/models.dart';

class CharacterModel {
  final String id;
  final String name;
  final String description;
  final bool newTestament;
  final bool haveMoreCharacters;
  final String typeNameChar;
  final String color;
  final Img img;
  final List<RelatedCharacters> relatedCharacters;

  CharacterModel(
      {required this.id,
      required this.name,
      required this.description,
      required this.newTestament,
      required this.haveMoreCharacters,
      required this.color,
      required this.img,
      required this.typeNameChar,
      required this.relatedCharacters});

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'],
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      newTestament: json['newTestament'] ?? false,
      haveMoreCharacters: json['haveMoreCharacters'] ?? false,
      color: json['color'] ?? '',
      img: Img.fromJson(json['img']),
      typeNameChar: json['typeNameChar'] ?? '',
      relatedCharacters: json['relatedCharacters'] != null
          ? json['relatedCharacters'].isNotEmpty
              ? (json['relatedCharacters'] as List)
                  .map((ralated) => RelatedCharacters.fromJson(ralated))
                  .toList()
              : []
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "newTestament": newTestament,
      "haveMoreCharacters": haveMoreCharacters,
      "color": color,
      "img": img,
      "typeNameChar": typeNameChar,
      "relatedCharacters": relatedCharacters
    };
  }
}

class RelatedCharacters {
  final String id;
  final String name;
  final String description;
  final bool haveMoreCharacters;
  final String color;
  final String typeNameChar;
  final Img img;

  RelatedCharacters(
      {required this.id,
      required this.name,
      required this.description,
      required this.haveMoreCharacters,
      required this.color,
      required this.img,
      required this.typeNameChar});

  factory RelatedCharacters.fromJson(Map<String, dynamic> json) {
    return RelatedCharacters(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      haveMoreCharacters: json['haveMoreCharacters'],
      color: json['color'],
      img: Img.fromJson(json['img']),
      typeNameChar: json['typeNameChar'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "description": description,
      "haveMoreCharacters": haveMoreCharacters,
      "color": color,
      "img": img,
      "typeNameChar": typeNameChar,
    };
  }
}
