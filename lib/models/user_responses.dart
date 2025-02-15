class UserResponses {
  final String? userId;
  final String? answerId;
  final String? questionId;

  UserResponses({
    this.userId,
    this.answerId,
    this.questionId,
  });

  // Método para convertir un mapa (JSON) a un objeto UserResponses
  factory UserResponses.fromJson(Map<String, dynamic> json) {
    return UserResponses(
      userId: json['userId'],
      answerId: json['answerId'],
      questionId: json['questionId'],
    );
  }

  // Método para convertir un objeto UserResponses a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answerId': answerId,
      'questionId': questionId,
    };
  }

  // Método opcional para crear una copia del objeto con valores modificados
  UserResponses copyWith({
    String? userId,
    String? answerId,
    String? questionId,
  }) {
    return UserResponses(
      userId: userId ?? this.userId,
      answerId: answerId ?? this.answerId,
      questionId: questionId ?? this.questionId,
    );
  }


  @override
  String toString() {
    return 'UserResponses{userId: $userId, answerId: $answerId, questionId: $questionId}';
  }
}