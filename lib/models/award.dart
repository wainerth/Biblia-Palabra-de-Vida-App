import 'package:biblia_palabra_de_vida_app/models/img.dart';

class Award {
  final String id;
  final String courseId;
  final String biblicalName;
  final String typeStone;
  final String description;
  final Img img;
  final double exchangeValue;
  final bool unLockPrize;
  final bool redeemed;
  final int status;

  Award({
    required this.id,
    required this.courseId,
    required this.biblicalName,
    required this.typeStone,
    required this.description,
    required this.img,
    required this.exchangeValue,
    required this.unLockPrize,
    required this.redeemed,
    required this.status,
  });

  // Factory method to create an Award object from a JSON map
  factory Award.fromJson(Map<String, dynamic> json) {
    return Award(
      id: json['id'],
      courseId: json['courseId'] ?? '',
      biblicalName: json['biblicalName'] as String,
      typeStone: json['typeStone'] as String,
      description: json['description'] as String,
      img: Img.fromJson(json['img'] as Map<String, dynamic>),
      exchangeValue: (json['exchangeValue'] as num).toDouble(),
      unLockPrize: json['unLockPrize'] ?? false,
      redeemed: json['redeemed'] ?? false,
      status: json['status'],
    );
  }

  // Method to convert an Award object to a JSON map
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
      'redeemed': redeemed,
      'status': status,
    };
  }
}

