import 'package:biblia_palabra_de_vida_app/models/models.dart';

class History {
  final String id;
  final String text;
  final int? countCards;
  final int orderCard;
  final IntermediateLevel level;
  final Img img;
  final int status;
  final String? audioUrl;

  History({
    required this.id,
    required this.text,
    this.countCards,
    required this.orderCard,
    required this.level,
    required this.img,
    required this.status,
    this.audioUrl,
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      text: json['text'],
      countCards: json['countCards'],
      orderCard: json['orderCard'],
      level: IntermediateLevel.fromJson(json['level']),
      img: Img.fromJson(json['img']),
      status: json['status'],
      audioUrl: json['audioUrl'],
    );
  }
}

class IntermediateLevel {
  final int levelNumber;
  final bool unLockLevel;
  final int? countLevelNumber;
  final int scoreForLevel;

  IntermediateLevel({
    required this.levelNumber,
    required this.unLockLevel,
    this.countLevelNumber,
    required this.scoreForLevel,
  });

  factory IntermediateLevel.fromJson(Map<String, dynamic> json) {
    return IntermediateLevel(
      levelNumber: json['levelNumber'],
      unLockLevel: json['unLockLevel'],
      countLevelNumber: json['countLevelNumber'],
      scoreForLevel: json['scoreForLevel'],
    );
  }
}
