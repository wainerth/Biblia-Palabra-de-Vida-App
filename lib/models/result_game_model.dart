import 'package:biblia_palabra_de_vida_app/models/models.dart';

class ResultGameModel {
  final String id;
  final String day;
  final Message message;
  final double score;

  ResultGameModel(
      {required this.id,
      required this.day,
      required this.message,
      required this.score});

  factory ResultGameModel.fromJson(Map<String, dynamic> json) {
    return ResultGameModel(
        id: json['id'],
        day: json['day'],
        message: Message.fromJson(json['message']),
        score: json['score']);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "day": day, "message": message, "score": score};
  }
}
