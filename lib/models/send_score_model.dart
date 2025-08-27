import 'package:biblia_palabra_de_vida_app/models/models.dart';

class SendScoreModel {
  final bool? isLastLevel;
  final bool isLastStage;
  final bool rewardObtained;
  final bool hasBeenPlayedSection;
  final bool hasBeenPlayedLevel;
  final bool prizeAwarded;
  final Reward? rewardData;
  final bool titleAwarded;
  final String? devMessageLevel;
  final String? devMessageSection;
  // final bool prizeWon;
  // final bool titleUnlocked;

  SendScoreModel(
      {required this.isLastLevel,
      required this.isLastStage,
      required this.rewardObtained,
      required this.hasBeenPlayedSection,
      required this.hasBeenPlayedLevel,
      required this.prizeAwarded,
      required this.rewardData,
      required this.titleAwarded,
      this.devMessageLevel = '',
      this.devMessageSection = '',
      });

  SendScoreModel copyWith(bool? isLastLevel, bool titleUnlocked) {
    return SendScoreModel(
      isLastLevel: isLastLevel ?? this.isLastLevel,
      // titleUnlocked: titleUnlocked,
      isLastStage: isLastStage,
      rewardObtained: rewardObtained,
      hasBeenPlayedSection: hasBeenPlayedSection,
      hasBeenPlayedLevel: hasBeenPlayedLevel,
      prizeAwarded: prizeAwarded,
      rewardData: rewardData,
      titleAwarded: titleAwarded,
      devMessageLevel: devMessageLevel,
      devMessageSection: devMessageSection,
    );
  }

  factory SendScoreModel.fromJson(Map<String, dynamic> json) {
    return SendScoreModel(
      isLastLevel: json['isLastLevel'] ?? false,
      isLastStage: json['isLastStage'],
      rewardObtained: json['rewardObtained'],
      hasBeenPlayedSection: json['hasBeenPlayedSection'],
      hasBeenPlayedLevel: json['hasBeenPlayedLevel'],
      prizeAwarded: json['prizeAwarded'],
      rewardData: json['rewardData'] != null
          ? Reward.fromJson(json['rewardData'])
          : null,
      titleAwarded: json['titleAwarded'],
      devMessageLevel: json['devMessageLevel'] ?? '',
      devMessageSection: json['devMessageSection'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "isLastLevel": isLastLevel,
      "isLastStage": isLastStage,
      "rewardObtained": rewardObtained,
      "hasBeenPlayedSection": hasBeenPlayedSection,
      "hasBeenPlayedLevel": hasBeenPlayedLevel,
      "prizeAwarded": prizeAwarded,
      "rewardData": rewardData,
      "titleAwarded": titleAwarded,
      "devMessageLevel": devMessageLevel,
      "devMessageSection": devMessageSection,
    };
  }
}
