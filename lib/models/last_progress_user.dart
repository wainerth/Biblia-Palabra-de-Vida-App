import 'dart:convert';

class ResponseProgress {
  final String message;
  final bool success;
  final LastProgressUser? data;

  ResponseProgress(
      {required this.message, required this.success, required this.data});

  factory ResponseProgress.fromJson(Map<String, dynamic> json) {
    return ResponseProgress(
      message: json['message'] ?? '',
      success: json['success'] ?? false,
      data:
          json['data'] != null ? LastProgressUser.fromJson(json['data']) : null,
    );
  }
}

class LastProgressUser {
  final String? courseId;
  final String? sectionId;
  final String? levelId;

  LastProgressUser({
    required this.courseId,
    required this.sectionId,
    required this.levelId,
  });

  // Método para convertir un objeto LastProgressUser a un Map (para guardar en SharedPreferences, por ejemplo)
  Map<String, dynamic> toMap() {
    return {
      'courseId': courseId,
      'sectionId': sectionId,
      'levelId': levelId,
    };
  }

  // Método para crear un objeto LastProgressUser desde un Map (para leer desde SharedPreferences, por ejemplo)
  factory LastProgressUser.fromMap(Map<String, dynamic> map) {
    return LastProgressUser(
      courseId: map['courseId'],
      sectionId: map['sectionId'],
      levelId: map['levelId'],
    );
  }

  // Método opcional para convertir a JSON
  String toJson() => json.encode(toMap());

  // Método opcional para crear desde JSON
  factory LastProgressUser.fromJson(Map<String, dynamic> json) {
    return LastProgressUser(
      courseId: json['courseId'],
      sectionId: json['sectionId'],
      levelId: json['levelId'],
    );
  }

  @override
  String toString() =>
      'LastProgressUser{courseId: $courseId, sectionId: $sectionId, levelId: $levelId}';
}
