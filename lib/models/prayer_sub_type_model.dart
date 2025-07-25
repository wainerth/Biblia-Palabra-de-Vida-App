class PrayerSubTypeModel {
  final String id;
  final String name;
  final String description;
  final String prayerTypeId; // Puede ser un código HEX ("#FF0000") o nombre ("red")

  PrayerSubTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.prayerTypeId,
  });

  // Constructor desde JSON (para respuestas API)
  factory PrayerSubTypeModel.fromJson(Map<String, dynamic> json) {
    return PrayerSubTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      prayerTypeId: json['prayerTypeId'] ?? '',
    );
  }

  // Método para convertir a JSON (para enviar datos al backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'prayerTypeId': prayerTypeId,
    };
  }

  // Opcional: Sobrescribe toString() para debugging
  @override
  String toString() {
    return 'PrayerSubTypeModel(id: $id, name: $name, description: $description, prayerTypeId: $prayerTypeId)';
  }

  // Opcional: Implementa copyWith para actualizaciones inmutables
  PrayerSubTypeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? prayerTypeId,
  }) {
    return PrayerSubTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      prayerTypeId: prayerTypeId ?? this.prayerTypeId,
    );
  }
}
