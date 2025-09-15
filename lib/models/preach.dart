import 'package:biblia_palabra_de_vida_app/models/img.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';

class ReferenceModel {
  final BookModel? book;
  final ChapterModel? chapter;
  final VerseModel? verse;

  ReferenceModel({
    required this.book,
    required this.chapter,
    required this.verse,
  });

  factory ReferenceModel.fromJson(Map<String, dynamic> json) {
    return ReferenceModel(
      book: json['book'] != null ? BookModel.fromJson(json['book']) : null,
      chapter: json['chapter'] != null
          ? ChapterModel.fromJson(json['chapter'])
          : null,
      verse: json['verse'] != null ? VerseModel.fromJson(json['verse']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "book": book?.toJson(),
      "chapter": chapter?.toJson(),
      "verse": verse?.toJson(),
    };
  }
}

class Preach {
  String? id;
  String? title;
  String? content;
  String? preachers;
  VideoPreach? video;
  int? status;
  List<ReferenceModel>? references;
  bool? isFavorite;
  String? createdAt;
  String? updatedAt;

  Preach({
    this.id,
    this.title,
    this.content,
    this.preachers,
    this.video,
    this.status,
    this.isFavorite,
    this.createdAt,
    this.references,
    this.updatedAt,
  });

  factory Preach.fromJson(Map<String, dynamic> json) => Preach(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        preachers: json["preachers"],
        video:
            json["video"] == null ? null : VideoPreach.fromJson(json["video"]),
        status: json["status"],
        references: json["references"] != null ? 
        (json['references'] as List).map((refer) => 
                      ReferenceModel.fromJson(refer)).toList() 
        : [],
        isFavorite: json["isFavorite"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "content": content,
        "preachers": preachers,
        "video": video?.toJson(),
        "status": status,
        "references" : references,
        "isFavorite": isFavorite,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };

  Map<String, dynamic> toDatabaseJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'preachers': preachers,
      'video': video?.toJson(), // Convert Video object to Map
      'status': status,
      'isFavorite': isFavorite,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

class VideoPreach {
  String? url;
  Img? img;

  VideoPreach({
    this.url,
    this.img,
  });

  factory VideoPreach.fromJson(Map<String, dynamic> json) => VideoPreach(
        url: json["url"],
        img: json["img"] == null ? null : Img.fromJson(json["img"]),
      );

  Map<String, dynamic> toJson() => {
        "url": url,
        "img": img,
      };
}
