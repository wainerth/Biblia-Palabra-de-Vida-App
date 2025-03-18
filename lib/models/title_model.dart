import 'package:biblia_palabra_de_vida_app/models/models.dart';

class TitleModel {
  final String id;
  final String courseId;
  final String title;
  final String description;
  final Img img;
  final bool unLockTitle;
  final int status;

  TitleModel({
    required this.id,
    required this.courseId,
    required this.title, 
    required this.description,
    required this.img,
    required this.unLockTitle,
    required this.status,
  });

  factory TitleModel.fromJson(Map<String, dynamic> json) {
    return TitleModel(
      id: json['id'],
      courseId: json['courseId'],
      description: json['description'],
      title: json["title"],
      img: Img.fromJson(json['img'] as Map<String, dynamic>),
      unLockTitle: json['unLockTitle'],
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'description': description,
      'title': title,
      'img': img.toJson(),
      'unLockPrize': unLockTitle,
      'status': status,
    };
  }
}

