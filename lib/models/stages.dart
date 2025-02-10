import 'package:biblia_palabra_de_vida_app/models/models.dart';

class Stage {
  String id;
  String sectionName;
  String introduction;
  bool unLockSection;
  int? countCards;
  int orderCard;
  String color;
  Img img;
  String? churchId;
  int status;
  int levelCount;
  int levelCompletedCount;

  Stage({
    required this.id,
    required this.sectionName,
    required this.introduction,
    required this.unLockSection,
    this.countCards,
    required this.orderCard,
    required this.color,
    required this.img,
    this.churchId,
    required this.levelCount,
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
      orderCard: json['orderCard'],
      color: json['color'],
      img: Img.fromJson(json['img']),
      churchId: json['churchId'],
      levelCount: json["levelCount"],
      levelCompletedCount: json["levelCompletedCount"],
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
    data['orderCard'] = orderCard;
    data['color'] = color;
    data['img'] = img.toJson();
    data['churchId'] = churchId;
    data['levelCount'] = levelCount;
    data['levelCompletedCount'] = levelCompletedCount;
    data['status'] = status;
    return data;
  }
}
