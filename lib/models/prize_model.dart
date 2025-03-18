import 'package:biblia_palabra_de_vida_app/models/models.dart';

class PrizeModel {
  final String id;
  final String courseId;
  final String biblicalName;
  final String typeStone;
  final String description;
  final Img img;
  final double exchangeValue;
  final String unLockPrize;
  final int status;

  PrizeModel({
    required this.id,
    required this.courseId,
    required this.biblicalName,
    required this.typeStone,
    required this.description,
    required this.img,
    required this.exchangeValue,
    required this.unLockPrize,
    required this.status,
  });

  factory PrizeModel.fromJson(Map<String, dynamic> json) {
    return PrizeModel(
      id: json['id'],
      courseId: json['courseId'],
      biblicalName: json['biblicalName'] as String,
      typeStone: json['typeStone'] as String,
      description: json['description'] as String,
      img: Img.fromJson(json['img'] as Map<String, dynamic>),
      exchangeValue: (json['exchangeValue'] as num).toDouble(),
      unLockPrize: json['unLockPrize'] as String,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'biblicalName': biblicalName,
      'typeStone': typeStone,
      'description': description,
      'img': img.toJson(),
      'exchangeValue': exchangeValue,
      'unLockPrize': unLockPrize,
      'status': status,
    };
  }
}

