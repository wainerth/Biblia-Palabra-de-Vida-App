import 'package:biblia_palabra_de_vida_app/models/models.dart';

class CourseModel {
  final String id;
  final String title;
  final String color;
  final int status;
  final int? churchId;
  Img img;
  final String introduction;
  final int sectionCount;
  final int sectionCompletedCount;

  CourseModel({
    required this.id,
    required this.title,
    required this.color,
    required this.status,
    this.churchId,
    required this.img,
    required this.introduction,
    required this.sectionCount,
    required this.sectionCompletedCount,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      color: json['color'] as String,
      status: json['status'] as int,
      churchId: json['churchId'] as int?,
      img: Img.fromJson(json['img']),
      introduction: json['introduction'],
      sectionCount: json['sectionCount'],
      sectionCompletedCount: json['sectionCompletedCount'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['color'] = color;
    data['status'] = status;
    data['churchId'] = churchId;
    data['img'] = img.toJson();
    data['introduction'];
    data['sectionCount'];
    data['sectionCompletedCount'];
    return data;
  }
}

