import 'package:biblia_palabra_de_vida_app/models/models.dart';

class LevelProgressUser {
  final String id;
  final int score;
  final int energy;
  final Message message;
  final bool newRecord;
  final InfoUser user;
  final int failedAttempts;
  final int scoreLastAttempt;
  final bool completed;
  final LevelUser level;
  final bool status;

  LevelProgressUser({
    required this.id,
    required this.score,
    required this.energy,
    required this.message,
    required this.newRecord,
    required this.user,
    required this.failedAttempts,
    required this.scoreLastAttempt,
    required this.completed,
    required this.level,
    required this.status,
  });
  LevelProgressUser copyWith({
    int? score,
    int? scoreLastAttempt,
    bool? newRecord
  }) {
    return LevelProgressUser(
      id: id,
      score: score ?? this.score,
      energy: energy,
      message: message,
      newRecord: newRecord ?? this.newRecord,
      user: user,
      failedAttempts: failedAttempts,
      scoreLastAttempt: scoreLastAttempt ?? this.scoreLastAttempt,
      completed: completed,
      level: level,
      status: status,
    );
  }

  factory LevelProgressUser.fromJson(Map<String, dynamic> json) {
    return LevelProgressUser(
      id: json['id'],
      score: json['score'] ?? 0,
      energy: json['energy'] ?? 0,
      message: Message.fromJson(json['message']),
      newRecord: json['newRecord'],
      user: InfoUser.fromJson(json['user']),
      failedAttempts: json['failedAttempts'] ?? 0, 
      scoreLastAttempt: json['scoreLastAttempt'] ?? 0,
      completed: json['completed'] ?? false,
      level: LevelUser.fromJson(json['level']),
      status: json['status'] > 0 ? true : false,
    );
  }
}

// class Message {
//   final String resultDescription;
//   final String resultTitle;
//   final String difficulty;

//   Message({
//     required this.resultDescription,
//     required this.resultTitle,
//     required this.difficulty,
//   });

//   factory Message.fromJson(Map<String, dynamic> json) {
//     return Message(
//       resultDescription: json['resultDescription'],
//       resultTitle: json['resultTitle'],
//       difficulty: json['difficulty'],
//     );
//   }
// }

class InfoUser {
  final String username;
  final int rolId;
  final String id;

  InfoUser({
    required this.username,
    required this.rolId,
    required this.id,
  });

  factory InfoUser.fromJson(Map<String, dynamic> json) {
    return InfoUser(
      username: json['username'],
      rolId: json['rolId'] ?? 0,
      id: json['id'],
    );
  }
}

class LevelUser {
  final int levelNumber;
  final String id;
  final String name;

  LevelUser({
    required this.levelNumber,
    required this.id,
    required this.name,
  });

  factory LevelUser.fromJson(Map<String, dynamic> json) {
    return LevelUser(
      levelNumber: json['levelNumber'],
      id: json['id'],
      name: json['name'],
    );
  }
}
