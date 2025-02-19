class SendScoreModel {
  final bool isLastLevel;
  final bool achievementUnlocked;

  SendScoreModel(
      {required this.isLastLevel, required this.achievementUnlocked});

  SendScoreModel copyWith(bool? isLastLevel, bool achievementUnlocked) {
    return SendScoreModel(
        isLastLevel: isLastLevel ?? this.isLastLevel,
        achievementUnlocked: achievementUnlocked);
  }

  factory SendScoreModel.fromJson(Map<String, dynamic> json) {
    return SendScoreModel(
        isLastLevel: json['isLastLevel'],
        achievementUnlocked: json['achievementUnlocked']);
  }

  Map<String, dynamic> toJson() {
    return {
      "isLastLevel": isLastLevel,
      'achievementUnlocked': achievementUnlocked
    };
  }
}
