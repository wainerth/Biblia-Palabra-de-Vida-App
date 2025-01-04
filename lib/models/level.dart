
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

List<Level> levels = List<Level>.from([
  {
      "id": "1",
      "name": "La Creación",
      "unLockLevel": true,
      "color": "3ae4e4",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl1.png"
      },
      "score":150.0
    },
    {
      "id": "2",
      "name": "Un Jardín",
      "unLockLevel": true,
      "color": "2eade4",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl2.png"
      },
      "score":150.0
    },
    {
      "id": "3",
      "name": "Hermanos",
      "unLockLevel": true,
      "color": "2958e4",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl3.png"
      },
      "score":150.0
    },
    {
      "id": "4",
      "name": "El Arca",
      "unLockLevel": true,
      "color": "2225c2",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl4.png"
      },
      "score":150.0
    },
    {
      "id": "5",
      "name": "Torre de Babel",
      "unLockLevel": true,
      "color": "7142e9",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl5.png"
      },
      "score":150.0
    },
    {
      "id": "6",
      "name": "Abram",
      "unLockLevel": true,
      "color": "8c31d6",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl6.png"
      },
      "score":150.0
    },
    {
      "id": "7",
      "name": "Destrucción",
      "unLockLevel": true,
      "color": "8a12a8",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl7.png"
      },
      "score":150.0
    },
    {
      "id": "8",
      "name": "Sacrificio",
      "unLockLevel": true,
      "color": "d835d8",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl8.png"
      },
      "score":150.0
    },
    {
      "id": "9",
      "name": "Esposa",
      "unLockLevel": true,
      "color": "fd30db",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl9.png"
      },
      "score":150.0
    },
    {
      "id": "10",
      "name": "Gemelos",
      "unLockLevel": true,
      "color": "f72989",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl10.png"
      },
      "score":150.0
    },
    {
      "id": "11",
      "name": "Huida",
      "unLockLevel": true,
      "color": "f7295c",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl11.png"
      },
      "score":150.0
    },
    {
      "id": "12",
      "name": "Viaje a Harán",
      "unLockLevel": true,
      "color": "e93131",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl12.png"
      },
      "score":150.0
    },
    {
      "id": "13",
      "name": "Trato con Labán",
      "unLockLevel": true,
      "color": "3ae4e4",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl13.png"
      },
      "score":150.0
    },
    {
      "id": "14",
      "name": "Combate Divino",
      "unLockLevel": true,
      "color": "2eade4",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl14.png"
      },
      "score":150.0
    },
    {
      "id": "15",
      "name": "Venganza",
      "unLockLevel": true,
      "color": "2958e4",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl15.png"
      },
      "score":150.0
    },
    {
      "id": "16",
      "name": "Hijo Favorito",
      "unLockLevel": true,
      "color": "2225c2",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl16.png"
      },
      "score":150.0
    },
    {
      "id": "17",
      "name": "Prisionero",
      "unLockLevel": true,
      "color": "7142e9",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl19.png"
      },
      "score":150.0
    },
    {
      "id": "18",
      "name": "Interpretador de Sueños",
      "unLockLevel": true,
      "color": "8c31d6",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl17.png"
      },
      "score":150.0
    },
    {
      "id": "19",
      "name": "Gobernador de Egipto",
      "unLockLevel": true,
      "color": "8a12a8",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl18.png"
      },
      "score":150.0
    },
    {
      "id": "20",
      "name": "Prueba de Hermanos",
      "unLockLevel": true,
      "color": "d835d8",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl20.png"
      },
      "score":150.0
    },
    {
      "id": "21",
      "name": "Reencuentro",
      "unLockLevel": true,
      "color": "fd30db",
      "section": {
        "sectionName": "Genesis"
      },
      "img": {
        "urlImg": "images/levels/lvl21.png"
      },
      "score":150.0
    }
].map((levelJson) => Level.fromJson(levelJson)).toList());