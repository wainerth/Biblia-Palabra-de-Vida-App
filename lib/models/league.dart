class League {
  final String id;
  final String name;
  final int minMembers;
  final String? colorFront;
  final String? colorBack;
  final int maxMembers;
  final String status;
  final ImageDetails img;

  League({
    required this.id,
    required this.name,
    required this.minMembers,
    required this.maxMembers,
    required this.status,
    required this.img,
    this.colorFront, 
    this.colorBack, 
  });

  // Factory constructor to create a League object from a JSON map
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      minMembers: json['minMembers'],
      maxMembers: json['maxMembers'],
      status: json['status'],
      colorFront: json['colorFront'],
      colorBack: json['colorBack'],
      img: ImageDetails.fromJson(json['img']),
    );
  }

  // Method to convert a League object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'minMembers': minMembers,
      'maxMembers': maxMembers,
      'img': img.toJson(),
      'colorFront': colorFront,
      'colorBack': colorBack,
      'status': status,
    };
  }
}
class ImageDetails {
  final String urlImg;

  ImageDetails({required this.urlImg});

  factory ImageDetails.fromJson(Map<String, dynamic> json) {
    return ImageDetails(
      urlImg: json['urlImg'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'urlImg': urlImg,
    };
  }
}
