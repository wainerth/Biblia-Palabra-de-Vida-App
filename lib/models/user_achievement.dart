class UserAchievement {
  final String id;
  final String classification;
  final ImageInfo img;
  final bool unLockAchievement;
  final String title;
  final String description;
  final Requirement requirement;

  UserAchievement({
    required this.id,
    required this.classification,
    required this.img,
    required this.unLockAchievement,
    required this.title,
    required this.description,
    required this.requirement,
  });

  // Factory constructor para crear un objeto UserAchievement desde un mapa (JSON)
  factory UserAchievement.fromJson(Map<String, dynamic> json) {
    return UserAchievement(
      id: json['id'],
      classification: json['classification'],
      img: ImageInfo.fromJson(json['img']),
      unLockAchievement: json['unLockAchievement'],
      title: json['title'],
      description: json['description'],
      requirement: Requirement.fromJson(json['requirement']),
    );
  }

  // Método para convertir un objeto UserAchievement a un mapa (JSON)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classification': classification,
      'img': img.toJson(),
      'unLockAchievement': unLockAchievement,
      'title': title,
      'description': description,
      'requirement': requirement.toJson(),
    };
  }
}

class ImageInfo {
  final String urlImg;

  ImageInfo({required this.urlImg});

  factory ImageInfo.fromJson(Map<String, dynamic> json) {
    return ImageInfo(
      urlImg: json['urlImg'],
    );
  }

    Map<String, dynamic> toJson() {
    return {
      'urlImg': urlImg,
    };
  }
}

class Requirement {
  final String requirement;

  Requirement({required this.requirement});

  factory Requirement.fromJson(Map<String, dynamic> json) {
    return Requirement(
      requirement: json['requirement'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requirement': requirement,
    };
  }
}