import 'package:biblia_palabra_de_vida_app/models/models.dart';

class History {
  final String id;
  final String text;
  final int? countCards;
  final int orderCard;
  final IntermediateLevel level;
  final Img img;
  final Audio? audio;
  final Video? video;
  final int status;

  History({
    required this.id,
    required this.text,
    this.countCards,
    required this.orderCard,
    required this.level,
    required this.img,
    required this.audio,
    required this.video,
    required this.status
  });

  factory History.fromJson(Map<String, dynamic> json) {
    return History(
      id: json['id'],
      text: json['text'],
      countCards: json['countCards'],
      orderCard: json['orderCard'],
      level: IntermediateLevel.fromJson(json['level']),
      img: json['img'] != null ? Img.fromJson(json['img']) : Img(urlImg: ''),
      audio:json['audio'] != null ? Audio.fromJson(json['audio']) : null,
      video:json['video'] != null ? Video.fromJson(json['video']) : null,
      status: json['status']
    );
  }
}

class IntermediateLevel {
  final int levelNumber;
  final bool unLockLevel;
  final int? countLevelNumber;

  IntermediateLevel({
    required this.levelNumber,
    required this.unLockLevel,
    this.countLevelNumber,
  });

  factory IntermediateLevel.fromJson(Map<String, dynamic> json) {
    return IntermediateLevel(
      levelNumber: json['levelNumber'],
      unLockLevel: json['unLockLevel'],
      countLevelNumber: json['countLevelNumber'],
    );
  }
}
