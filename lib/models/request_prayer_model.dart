import 'dart:io';

class RequestPrayerModel {
  final File? audio;
  final String description;
  final String prayerFor;
  final String prayerSubTypeId;
  final String userId;

  RequestPrayerModel({
    required this.audio,
    required this.description,
    required this.prayerFor,
    required this.prayerSubTypeId,
    required this.userId
  });

  factory RequestPrayerModel.fromJson(Map<String, dynamic> json ) {
    return RequestPrayerModel(
      audio: json['audio'],
      description: json['description'],
      prayerFor: json['prayerFor'],
      prayerSubTypeId: json['prayerSubTypeId'],
      userId: json['userId'],
      );
  }

  Map<String, dynamic> toJson() {
    return {
      // "audio": audio,
      "description":description,
      "prayerFor": prayerFor,
      "prayerSubTypeId":prayerSubTypeId,
      "userId":userId,
    };
  }

  
}