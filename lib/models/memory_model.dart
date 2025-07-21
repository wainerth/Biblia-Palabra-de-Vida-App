import 'package:biblia_palabra_de_vida_app/models/img.dart';

class MemoryModel {
  final String id;
  final Img img;
  final int pair;
  final String cardStatus;
  final bool blocked;

  MemoryModel({
    required this.id,
    required this.img,
    required this.cardStatus,
    required this.pair,
    required this.blocked,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json['id'],
      img: Img.fromJson(json['img']),
      cardStatus: json['cardStatus'],
      pair: json['pair'],
      blocked: json['blocked'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "img": img,
      "cardStatus": cardStatus,
      "pair": pair,
      "blocked": blocked
    };
  }
}
