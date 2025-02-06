class UserRanking {
  final String id;
  final String groupId;
  final String userId;
  final int currentPoints;
  final int position;
  final bool promoted;

  // Nuevos campos para la información de la liga y los miembros
  final String leagueName; // Nombre de la liga
  final String leagueId;    // ID de la liga


  UserRanking({
    required this.id,
    required this.groupId,
    required this.userId,
    required this.currentPoints,
    required this.position,
    required this.promoted,
    required this.leagueName,
    required this.leagueId,
  
  });

  factory UserRanking.fromJson(Map<String, dynamic> json) {
    return UserRanking(
      id: json['id'],
      groupId: json['groupId'],
      userId: json['userId'],
      currentPoints: json['currentPoints'],
      position: json['position'],
      promoted: json['promoted'],
      leagueName: json['leagueName'], // Extrae el nombre de la liga del JSON
      leagueId: json['leagueId'],    // Extrae el ID de la liga del JSON

    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'groupId': groupId,
      'userId': userId,
      'currentPoints': currentPoints,
      'position': position,
      'promoted': promoted,
      'leagueName': leagueName,
      'leagueId': leagueId,

    };
  }

  @override
  String toString() {
    return 'UserRanking{id: $id, groupId: $groupId, userId: $userId, currentPoints: $currentPoints, position: $position, promoted: $promoted, leagueName: $leagueName, leagueId: $leagueId}';
  }

  UserRanking copyWith({
    String? id,
    String? groupId,
    String? userId,
    int? currentPoints,
    int? position,
    bool? promoted,
    String? leagueName,
    String? leagueId,

  }) {
    return UserRanking(
      id: id ?? this.id,
      groupId: groupId ?? this.groupId,
      userId: userId ?? this.userId,
      currentPoints: currentPoints ?? this.currentPoints,
      position: position ?? this.position,
      promoted: promoted ?? this.promoted,
      leagueName: leagueName ?? this.leagueName,
      leagueId: leagueId ?? this.leagueId,

    );
  }
}