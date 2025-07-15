import 'package:biblia_palabra_de_vida_app/models/img.dart';

class Preach {
  String? id;
  String? title;
  String? content;
  String? preachers;
  VideoPreach? video;
  int? status;
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
    this.updatedAt,
  });

  factory Preach.fromJson(Map<String, dynamic> json) => Preach(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        preachers: json["preachers"],
        video: json["video"] == null ? null : VideoPreach.fromJson(json["video"]),
        status: json["status"],
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
