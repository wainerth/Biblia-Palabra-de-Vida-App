import 'package:biblia_palabra_de_vida_app/models/models.dart';

class PrayerModel {
  final String requestId;
  final VerseDetail? verse;
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
    required this.verse,
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
      verse: json['verse'] != null ? VerseDetail.fromJson(json['verse']) : null,
      statusRequest: StatusRequest.fromJson(json['statusRequest']),
      audioPrayer: json['audioPrayer'] != null
          ? Audio.fromJson(json['audioPrayer'])
          : null,
      prayedFor: json['prayedFor'],
      prayerCategory: PrayerTypeModel.fromJson(json['prayerCategory']),
      prayerSubType: PrayerSubTypeModel.fromJson(json['prayerSubType']),
      prayerDetails: json['prayerDetails'],
      requestDate: json['requestDate'],
      requestedBy: json['requestedBy'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "requestId": requestId,
      "verse": verse,
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

class VerseDetail {
  final VerseModel? verse;
  final ChapterModel? chapter;
  final BookModel? book;

  VerseDetail({
    required this.verse,
    required this.chapter,
    required this.book,
  });

  factory VerseDetail.fromJson(Map<String, dynamic> json) {
    return VerseDetail(
      verse: json['verse'] != null ? VerseModel.fromJson(json['verse']) : null,
      chapter: json['chapter'],
      book: json['book'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "verse": verse,
      "chapter": chapter,
      "book": book,
    };
  }
}
