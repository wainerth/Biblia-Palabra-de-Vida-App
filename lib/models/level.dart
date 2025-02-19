import 'package:biblia_palabra_de_vida_app/models/models.dart';

class Level {
  final String id;
  final String name;
  final bool unLockLevel;
  final int levelNumber;
  final int levelScore;
  final String color;
  final Section section;
  Img img;
  final double score;
  final int status;

  Level(
      {required this.id,
      required this.name,
      required this.unLockLevel,
      required this.color,
      required this.section,
      required this.img,
      required this.levelScore,
      this.levelNumber = 0,
      this.score = 0.0,
      this.status = 0});

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
        id: json['id'],
        name: json['name'],
        unLockLevel: json['unLockLevel'],
        color: json['color'],
        section: Section.fromJson(json['section']),
        img: Img.fromJson(json['img']),
        score: json['score'] ?? 0,
        status: json["status"], 
        levelScore:json['levelScore'] ?? 0,
        levelNumber:json['levelNumber']
        );
  }
}

class Section {
  final String sectionName;

  Section({required this.sectionName});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(sectionName: json['sectionName']);
  }
}

