import 'package:biblia_palabra_de_vida_app/models/character_model.dart';
import 'package:biblia_palabra_de_vida_app/models/img.dart';

class GuessCharacter {
  final String id;
  final CharacterModel character;
  final String difficulty;
  final Img img;
  final List<Clue> clues;
  final int status;

  GuessCharacter({
    required this.id,
    required this.character,
    required this.difficulty,
    required this.img,
    required this.clues,
    required this.status,
  });

  factory GuessCharacter.fromJson(Map<String, dynamic> json) {
    return GuessCharacter(
      id: json['id'] ?? '',
      character: CharacterModel.fromJson(json['character'] ?? {}),
      difficulty: json['difficulty'] ?? 'medium',
      img: Img.fromJson(json['img'] ?? {}),
      clues: (json['clues'] as List? ?? [])
          .map((clue) => Clue.fromJson(clue))
          .toList(),
      status: json['status'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'character': character.toJson(),
        'difficulty': difficulty,
        'img': img.toJson(),
        'clues': clues.map((clue) => clue.toJson()).toList(),
        'status': status,
      };
}

class Clue {
  final String id;
  final String guessCharacterId;
  final String description;
  final int status;

  Clue({
    required this.id,
    required this.guessCharacterId,
    required this.description,
    required this.status,
  });

  factory Clue.fromJson(Map<String, dynamic> json) {
    return Clue(
      id: json['id'] ?? '',
      guessCharacterId: json['guessCharacterId'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'guessCharacterId': guessCharacterId,
        'description': description,
        'status': status,
      };
}
