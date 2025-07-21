import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class PlayModel {
  final String title;
  final String description;
  final String img;
  final String url;
  PlayModel(
      {required this.title, required this.description, required this.img, required this.url});

  factory PlayModel.fromJson(Map<String, dynamic> json) {
    return PlayModel(
        title: json['title'],
        description: json['description'],
        img: json['img'],
        url: json['url']
        );
  }

  Map<String, dynamic> toJson() {
    return {"title": title, "description": description, "img": img, "url": url};
  }
}

class PlayScreen extends StatefulWidget {
  const PlayScreen({super.key});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  List<PlayModel> plays = [
    PlayModel(
      title: "Memoria",
      description:
          "¿Qué tan buena es tu memoria visual? En este juego tendrás que encontrar los pares de imágenes que tiene diversas representaciones relacionadas con la Biblia. ¡Agudiza tu vista y tu memoria!",
      img: "assets/plays/memory.jpg",
      url: "/memoryPage"
    ),
    PlayModel(
      title: "Adivinanza",
      description:
          "¿Acaso eres un detective de la Biblia? Usa tu ingenio y conocimiento bíblico para descifrar las pistas y descubrir quién es el personaje que se esconde. ¡Prepárate para un desafío muy emocionante!",
      img: "assets/plays/riddle.jpg",
      url: "/reddlePage"
    ),
    PlayModel(
      title: "Quiz",
      description:
          "¿Eres un experto en la Biblia? En este juego podrás demostrarlo respondiendo a preguntas de diferentes categorías y niveles de dificultad. ¡Acepta el reto y aprende más sobre la Palabra de Dios!",
      img: "assets/plays/quiz.jpg",
      url: "/quizPage"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.turquoise,
        title: Text(
          'Juegos',
          style: StylesApp(context)
              .textStyleBody16
              .copyWith(color: StyleColor.white),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(color: Colors.white),
            child: ListView.separated(
              separatorBuilder: (__,_) => SizedBox(height: 20,),
              itemCount: plays.length,
              itemBuilder: (BuildContext context, index) {
                return Container(
                  padding: EdgeInsets.all(8.0),
                  margin: EdgeInsets.all(8.0),
                  width: MediaQuery.sizeOf(context).width * 0.8,
                  decoration: BoxDecoration(
                    color: StyleColor.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, -4),
                        color: StyleColor.black.withValues(alpha: 0.25),
                        blurRadius: 12
                      )
                    ]
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.sizeOf(context).width,
                        constraints: BoxConstraints(minHeight: 150, maxHeight: 150),
                        child: Image.asset(
                          plays[index].img,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        plays[index].title,
                        style: StylesApp(context).textStyleBody20.copyWith(
                          color: StyleColor.black
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        plays[index].description,
                        style: StylesApp(context).textStyleBody14.copyWith(
                          color: StyleColor.black
                        ),
                      ),
                      SizedBox(height: 10,),
                      ButtonThemeWidget(
                        text: "!Vamos¡",
                        width: 150,
                        buttonStyle: StylesApp(context).btnWidgetSmall,
                        onPressed: () {
                          Navigator.pushNamed(context, plays[index].url);
                        },
                      ),
                      SizedBox(height: 10,),
                    ],
                  ),
                );
              },
            )),
      ),
    );
  }
}
