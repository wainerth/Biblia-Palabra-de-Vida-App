import 'package:biblia_palabra_de_vida_app/models/img.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';

class TeachingModel {
  final String id;
  final String title;
  final String description;
  final Img img;
  final int orderCard;
  final int mostClicked;
  final int status;
  final Pagination meta;

  TeachingModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.img,
      required this.orderCard,
      required this.mostClicked,
      required this.status,
      required this.meta});

  factory TeachingModel.fromJson(Map<String, dynamic> json) {
    return TeachingModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      img: Img.fromJson(json['img']),
      orderCard: json['orderCard'],
      mostClicked: json['mostClicked'],
      status: json['status'],
      meta: Pagination.fromJson(json['meta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "img": img,
      "orderCard": orderCard,
      "mostClicked": mostClicked,
      "status": status,
      "meta": meta
    };
  }
}
