import 'package:biblia_palabra_de_vida_app/models/models.dart';

class Reward {
  final String id;
  final String sectionId;
  final String title;
  final String description;
  final Img img; 
  final int earnedExperience;
  final int earnedEnergy;
  final bool unLockReward;
  final int status;

  Reward({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.description,
    required this.img,
    required this.earnedExperience,
    required this.earnedEnergy,
    required this.unLockReward,
    required this.status,
  });

  // Método para crear una instancia de Reward desde un mapa (JSON)
  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      sectionId: json['sectionId'],
      title: json['title'],
      description: json['description'],
      img: Img.fromJson(json['img']), // Usamos el factory del modelo ImageUrl
      earnedExperience: json['earnedExperience'],
      earnedEnergy: json['earnedEnergy'],
      unLockReward: json['unLockReward'],
      status: json['status'],
    );
  }

  // Método para convertir una instancia de Reward a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sectionId': sectionId,
      'title': title,
      'description': description,
      'img': img.toJson(), // Usamos el método toJson del modelo ImageUrl
      'earnedExperience': earnedExperience,
      'earnedEnergy': earnedEnergy,
      'unLockReward': unLockReward,
      'status': status,
    };
  }
}
