import 'package:biblia_palabra_de_vida_app/models/img.dart';

class CharacterModel {
  final String id;
  final String name;
  final bool newTestament;
  final bool haveMoreCharacters;
  final String color;
  final Img img;
  final List<RelatedCharacters> relatedCharacters;

  CharacterModel(
      {required this.id,
      required this.name,
      required this.newTestament,
      required this.haveMoreCharacters,
      required this.color,
      required this.img,
      required this.relatedCharacters});

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
        id: json['id'],
        name: json['name'],
        newTestament: json['newTestament'],
        haveMoreCharacters: json['haveMoreCharacters'],
        color: json['color'],
        img: Img.fromJson(json['img']),
        relatedCharacters: json['relatedCharacters'] != null && json['relatedCharacters'].isNotEmpty
            ? (json['relatedCharacters'] as List)
                .map((ralated) => RelatedCharacters.fromJson(ralated))
                .toList()
            : [],
            // RelatedCharacters.fromJson(json['relatedCharacters'])
          );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "newTestament": newTestament,
      "haveMoreCharacters": haveMoreCharacters,
      "color": color,
      "img": img,
      "relatedCharacters": relatedCharacters
    };
  }
}

class RelatedCharacters {
  final String id;
  final String name;
  final String color;
  final typeNameChar;
  final Img img;

  RelatedCharacters(
      {required this.id,
      required this.name,
      required this.color,
      required this.img,
      required this.typeNameChar});

  factory RelatedCharacters.fromJson(Map<String, dynamic> json) {
    return RelatedCharacters(
      id: json['id'],
      name: json['name'],
      color: json['color'],
      img: Img.fromJson(json['img']),
      typeNameChar: json['typeNameChar'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "color": color,
      "img": img,
      "typeNameChar": typeNameChar,
    };
  }
}
