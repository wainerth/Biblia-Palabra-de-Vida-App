class PrayerTypeModel {
  final String id;
  final String name;
  final String description;
  final String color; // Puede ser un código HEX ("#FF0000") o nombre ("red")

  PrayerTypeModel({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
  });

  // Constructor desde JSON (para respuestas API)
  factory PrayerTypeModel.fromJson(Map<String, dynamic> json) {
    return PrayerTypeModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      color: json['color'] ?? '',
    );
  }

  // Método para convertir a JSON (para enviar datos al backend)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
    };
  }

  // Opcional: Sobrescribe toString() para debugging
  @override
  String toString() {
    return 'PrayerTypeModel(id: $id, name: $name, description: $description, color: $color)';
  }

  // Opcional: Implementa copyWith para actualizaciones inmutables
  PrayerTypeModel copyWith({
    String? id,
    String? name,
    String? description,
    String? color,
  }) {
    return PrayerTypeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }
}
