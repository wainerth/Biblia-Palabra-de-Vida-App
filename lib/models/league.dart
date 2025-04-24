class League {
  final String id;
  final String name;
  final String description;
  final String? colorFront;
  final String? colorBack;
  final int? maxMembers;
  final String status;
  final ImageDetails img;

  League({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.img,
     this.maxMembers,
    this.colorFront, 
    this.colorBack, 
  });

  // Factory constructor to create a League object from a JSON map
  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      status: json['status'],
      colorFront: json['colorFront'],
      colorBack: json['colorBack'],
      maxMembers: json['maxMembers'] ?? 0,
      img: ImageDetails.fromJson(json['img']),
    );
  }

  // Method to convert a League object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'img': img.toJson(),
      'colorFront': colorFront,
      'colorBack': colorBack,
      'maxMembers': maxMembers,
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
