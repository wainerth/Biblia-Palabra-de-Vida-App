import 'package:biblia_palabra_de_vida_app/models/img.dart';

class UserTitle {
  final String id;
  final String courseId;
  final Img img;
  final bool unLockTitle;
  final String title;
  final String description;

  UserTitle({
    required this.id,
    required this.courseId,
    required this.img,
    required this.unLockTitle,
    required this.title,
    required this.description,
  });

  // Factory constructor para crear un objeto UserTitle desde un mapa (JSON)
  factory UserTitle.fromJson(Map<String, dynamic> json) {
    return UserTitle(
      id: json['id'],
      courseId: json['courseId'],
      img: Img.fromJson(json['img']),
      unLockTitle: json['unLockTitle'],
      title: json['title'],
      description: json['description'],
    );
  }

  // Método para convertir un objeto UserTitle a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseId': courseId,
      'img': img.toJson(),
      'unLockTitle': unLockTitle,
      'title': title,
      'description': description,
    };
  }
}
