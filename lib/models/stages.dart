import 'package:biblia_palabra_de_vida_app/models/models.dart';

class Stage {
  String id;
  String sectionName;
  String introduction;
  bool unLockSection;
  int? countCards;
  int sectionNumber;
  String color;
  Img? img;
  String? churchId;
  int status;
  int? numberOfLevels;
  int levelCount;
  int levelCompletedCount;

  Stage({
    required this.id,
    required this.sectionName,
    required this.introduction,
    required this.unLockSection,
    this.countCards,
    required this.sectionNumber,
    required this.color,
    required this.img,
    this.churchId,
    required this.levelCount,
    this.numberOfLevels = 0,
    required this.levelCompletedCount,
    required this.status,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'],
      sectionName: json['sectionName'],
      introduction: json['introduction'],
      unLockSection: json['unLockSection'],
      countCards: json['countCards'],
      sectionNumber: json['sectionNumber'] ?? 0,
      color: json['color'],
      img: json['img'] != null ? Img.fromJson(json['img']) : null,
      churchId: json['churchId'],
      levelCount: json["levelCount"] ?? 0,
      numberOfLevels: json["numberOfLevels"] ?? 0,
      levelCompletedCount: json["levelCompletedCount"] ?? 0,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sectionName'] = sectionName;
    data['introduction'] = introduction;
    data['unLockSection'] = unLockSection;
    data['countCards'] = countCards;
    data['sectionNumber'] = sectionNumber;
    data['color'] = color;
    data['img'] = img;
    data['churchId'] = churchId;
    data['levelCount'] = levelCount;
    data['numberOfLevels'] = numberOfLevels;
    data['levelCompletedCount'] = levelCompletedCount;
    data['status'] = status;
    return data;
  }
}
