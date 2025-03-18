class SendScoreModel {
  final bool isLastLevel;
  final bool isLastStage;
  final bool rewardObtained;
  // final bool prizeWon;
  // final bool titleUnlocked;

  SendScoreModel(
      {
      required this.isLastLevel,
      required this.isLastStage,
      required this.rewardObtained,
      // required this.prizeWon,
      // required this.titleUnlocked
      });

  SendScoreModel copyWith(bool? isLastLevel, bool titleUnlocked) {
    return SendScoreModel(
      isLastLevel: isLastLevel ?? this.isLastLevel,
      // titleUnlocked: titleUnlocked,
      isLastStage: isLastStage,
      rewardObtained: rewardObtained,
      // prizeWon: prizeWon,
    );
  }

  factory SendScoreModel.fromJson(Map<String, dynamic> json) {
    return SendScoreModel(
        isLastLevel: json['isLastLevel'],
        // titleUnlocked: json['titleUnlocked'],
        isLastStage: json['isLastStage'],
        rewardObtained: json['rewardObtained'],
        // prizeWon: json['prizeWon']
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "isLastLevel": isLastLevel,
      "isLastStage": isLastStage,
      "rewardObtained": rewardObtained,
      // "prizeWon": prizeWon,
      // 'titleUnlocked': titleUnlocked
    };
  }
}
