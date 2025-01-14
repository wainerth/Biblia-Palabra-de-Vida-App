
class Level {
  final String id;
  final String name;
  final bool unLockLevel;
  final String color;
  final Section section;
  final String img;
  final double score;

  Level({
    required this.id,
    required this.name,
    required this.unLockLevel,
    required this.color,
    required this.section,
    required this.img,
    this.score = 0.0,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      name: json['name'],
      unLockLevel: json['unLockLevel'],
      color: json['color'],
      section: Section.fromJson(json['section']),
      img:json['img'],
      score: json['score'],
    );
  }
}

class Section {
  final String sectionName;

  Section({required this.sectionName});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(sectionName: json['sectionName']);
  }
}

// class ImageView {
//   final String urlImg;

//   ImageView({required this.urlImg});

//   factory ImageView.fromJson(Map<String, dynamic> json) {
//     return  json['urlImg'];
//   }
// }

class LevelResponse {
  final List<Level> getAllLevelsBySectionId;

  LevelResponse({required this.getAllLevelsBySectionId});

  factory LevelResponse.fromJson(Map<String, dynamic> json) {
    return LevelResponse(
      getAllLevelsBySectionId: List<Level>.from(
        json['getAllLevelsBySectionId'].map((levelJson) => Level.fromJson(levelJson)),
      ),
    );
  }
}
