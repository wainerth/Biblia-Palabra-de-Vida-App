import 'package:biblia_palabra_de_vida_app/models/models.dart';

class PrayerModel {
  final String requestId;
  final PrayerResponse? responser;
  final StatusRequest statusRequest;
  final Audio? audioPrayer;
  final String prayedFor;
  final PrayerTypeModel prayerCategory;
  final PrayerSubTypeModel prayerSubType;
  final String prayerDetails;
  final String requestDate;
  final String requestedBy;

  PrayerModel({
    required this.requestId,
    required this.responser,
    required this.statusRequest,
    required this.audioPrayer,
    required this.prayedFor,
    required this.prayerCategory,
    required this.prayerSubType,
    required this.prayerDetails,
    required this.requestDate,
    required this.requestedBy,
  });

  factory PrayerModel.fromJson(Map<String, dynamic> json) {
    return PrayerModel(
      requestId: json['requestId'],
      responser:
          json['responser'] != null ? PrayerResponse.fromJson(json['responser']) : null,
      statusRequest: StatusRequest.fromJson(json['statusRequest']),
      audioPrayer: json['audioPrayer'] != null
          ? Audio.fromJson(json['audioPrayer'])
          : null,
      prayedFor: json['prayedFor'],
      prayerCategory: PrayerTypeModel.fromJson(json['prayerCategory']),
      prayerSubType: PrayerSubTypeModel.fromJson(json['prayerSubType']),
      prayerDetails: json['prayerDetails'],
      requestDate: json['requestDate'],
      requestedBy: json['requestedBy'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "requestId": requestId,
      "responser": responser,
      "statusRequest": statusRequest,
      "audioPrayer": audioPrayer,
      "prayedFor": prayedFor,
      "prayerCategory": prayerCategory,
      "prayerSubType": prayerSubType,
      "prayerDetails": prayerDetails,
      "requestDate": requestDate,
      "requestedBy": requestedBy,
    };
  }
}

class StatusRequest {
  final String name;
  final MessageSystem? messageSystems;

  StatusRequest({required this.name, required this.messageSystems});

  factory StatusRequest.fromJson(Map<String, dynamic> json) {
    return StatusRequest(
      name: json['name'] ?? '',
      messageSystems: json['messageSystems'] != null
          ? MessageSystem.fromJson(json['messageSystems'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "messageSystems": messageSystems};
  }
}

class MessageSystem {
  final String message;
  MessageSystem({required this.message});

  factory MessageSystem.fromJson(Map<String, dynamic> json) {
    return MessageSystem(
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message};
  }
}

class PrayerResponse {
  final String id;
  final String message;
  final String responder;
  final String bookName;
  final String chapter;
  final String verse;
  final String text;
  final Audio? audioResponse;
  final String createdAt;

  PrayerResponse({
    required this.id,
    required this.message,
    required this.responder,
    required this.bookName,
    required this.text,
    required this.createdAt,
    required this.verse,
    required this.chapter,
    required this.audioResponse
  });

  factory PrayerResponse.fromJson(Map<String, dynamic> json) {
    return PrayerResponse(
      id: json['id'] ?? '',
      message: json['message'] ?? '',
      responder: json['responder'],
      bookName: json['bookName'],
      text: json['text'],
      verse: json['verse'],
      chapter: json['chapter'],
       audioResponse: json['audioResponse'] != null
          ? Audio.fromJson(json['audioResponse'])
          : null,
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "message": message,
      "responder": responder,
      "bookName": bookName,
      "text": text,
      "verse": verse,
      "chapter": chapter,
      "createdAt": createdAt
    };
  }
}
