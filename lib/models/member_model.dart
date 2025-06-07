
class MemberModel {
  final String userId;
  final int currentPoints;
  final String username;
  final String profilePicture;

  MemberModel({
    required this.userId,
    required this.currentPoints,
    required this.username,
    required this.profilePicture,
  });

  // Método para convertir un objeto Member a un mapa (para JSON, por ejemplo)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'currentPoints': currentPoints,
      'username': username,
      'profilePicture': profilePicture,
    };
  }

  // Método para crear un objeto Member desde un mapa (desde JSON, por ejemplo)
  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      userId: json['userId'],
      currentPoints: json['currentPoints'],
      username: json['username'] ?? false,
      profilePicture: json['profilePicture'],
    );
  }
}