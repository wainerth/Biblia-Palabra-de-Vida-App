import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class PlayModel {
  final String title;
  final String description;
  final String img;
  final String url;
  PlayModel(
      {required this.title,
      required this.description,
      required this.img,
      required this.url});

  factory PlayModel.fromJson(Map<String, dynamic> json) {
    return PlayModel(
        title: json['title'],
        description: json['description'],
        img: json['img'],
        url: json['url']);
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
        url: "/memoryPage"),
    PlayModel(
        title: "Adivinanza",
        description:
            "¿Acaso eres un detective de la Biblia? Usa tu ingenio y conocimiento bíblico para descifrar las pistas y descubrir quién es el personaje que se esconde. ¡Prepárate para un desafío muy emocionante!",
        img: "assets/plays/riddle.jpg",
        url: "/reddlePage"),
    PlayModel(
        title: "Quiz",
        description:
            "¿Eres un experto en la Biblia? En este juego podrás demostrarlo respondiendo a preguntas de diferentes categorías y niveles de dificultad. ¡Acepta el reto y aprende más sobre la Palabra de Dios!",
        img: "assets/plays/quiz.jpg",
        url: "/quizPage"),
  ];

  // Función para determinar si es tablet
  bool get isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 600; // Consideramos tablet a partir de 600px de ancho
  }

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
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 24.0 : 8.0, // Más padding en tablet
            vertical: isTablet ? 16.0 : 0.0,
          ),
          decoration: BoxDecoration(color: Colors.white),
          child: isTablet
              ? _buildTabletLayout() // Layout para tablet
              : _buildMobileLayout(), // Layout original para móvil
        ),
      ),
    );
  }

  // Layout para móvil (igual al original)
  Widget _buildMobileLayout() {
    return ListView.separated(
      separatorBuilder: (__, _) => SizedBox(
        height: 20,
      ),
      itemCount: plays.length,
      itemBuilder: (BuildContext context, index) {
        return _buildGameCard(context, plays[index], isTablet: false);
      },
    );
  }

  // Layout para tablet
  Widget _buildTabletLayout() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Dos columnas en tablet
        crossAxisSpacing: 24.0, // Espacio entre columnas
        mainAxisSpacing: 24.0, // Espacio entre filas
        childAspectRatio: 1.2, // Relación aspecto para cards más anchas
      ),
      itemCount: plays.length,
      itemBuilder: (BuildContext context, index) {
        return _buildGameCard(context, plays[index], isTablet: true);
      },
    );
  }

  // Widget para construir la tarjeta de juego (compartido entre móvil y tablet)
  Widget _buildGameCard(BuildContext context, PlayModel play,
      {required bool isTablet}) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 16.0 : 8.0),
      margin: EdgeInsets.all(isTablet ? 0 : 8.0),
      decoration: BoxDecoration(
        color: StyleColor.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            color: StyleColor.black.withValues(alpha: 0.15),
            blurRadius: 16,
            spreadRadius: 0.5,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // CLAVE: Esto evita el conflicto
        children: [
          // Imagen
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              play.img,
              width: double.infinity,
              height: isTablet ? 200 : 150,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: isTablet ? 16.0 : 10.0),

          // Título
          Text(
            play.title,
            style: isTablet
                ? StylesApp(context).textStyleBody20.copyWith(
                      color: StyleColor.black,
                      fontWeight: FontWeight.bold,
                    )
                : StylesApp(context)
                    .textStyleBody20
                    .copyWith(color: StyleColor.black),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: isTablet ? 12.0 : 10.0),

          // Descripción - Con altura fija y scroll
          Container(
            height: isTablet ? null : 100, // Altura fija para scroll
            child: SingleChildScrollView(
              child: Text(
                play.description,
                style: isTablet
                    ? StylesApp(context).textStyleBody14.copyWith(
                          color: StyleColor.black,
                          height: 1.4,
                        )
                    : StylesApp(context)
                        .textStyleBody14
                        .copyWith(color: StyleColor.black),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: isTablet ? 16.0 : 10.0),

          // Botón
          ButtonThemeWidget(
            text: "¡Vamos!",
            width: isTablet ? 200 : 150,
            buttonStyle: StylesApp(context).btnWidgetSmall,
            onPressed: () {
              Navigator.pushNamed(context, play.url);
            },
          ),

          SizedBox(height: isTablet ? 0 : 10.0),
        ],
      ),
    );
  }
}
