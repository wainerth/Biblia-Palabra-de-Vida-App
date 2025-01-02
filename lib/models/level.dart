
class Level {
  final String id;
  final String name;
  final bool unLockLevel;
  final String color;
  final Section section;
  final String img;

  Level({
    required this.id,
    required this.name,
    required this.unLockLevel,
    required this.color,
    required this.section,
    required this.img,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    return Level(
      id: json['id'],
      name: json['name'],
      unLockLevel: json['unLockLevel'],
      color: json['color'],
      section: Section.fromJson(json['section']),
      img:json['img'],
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
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
      }
    }
].map((levelJson) => Level.fromJson(levelJson)).toList());