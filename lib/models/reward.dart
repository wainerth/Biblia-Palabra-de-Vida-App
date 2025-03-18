
class Reward {
  final String id;
  final String sectionId;
  final String title;
  final String description;
  final int earnedExperience;
  final int earnedEnergy;
  final int status;

  Reward({
    required this.id,
    required this.sectionId,
    required this.title,
    required this.description,
    required this.earnedExperience,
    required this.earnedEnergy,
    required this.status,
  });

  // Método para crear una instancia de Reward desde un mapa (JSON)
  factory Reward.fromJson(Map<String, dynamic> json) {
    return Reward(
      id: json['id'],
      sectionId: json['sectionId'],
      title: json['title'],
      description: json['description'],
      earnedExperience: json['earnedExperience'],
      earnedEnergy: json['earnedEnergy'],
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
      'earnedExperience': earnedExperience,
      'earnedEnergy': earnedEnergy,
      'status': status,
    };
  }
}
