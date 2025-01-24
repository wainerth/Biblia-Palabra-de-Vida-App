import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final PageController _controllerPage = PageController();
  final ScrollController _scrollController = ScrollController();
  late ScrollController scrollController;
  double fontSizeText = 16.sp;
  double isPage = 0;

  Level level = Level(
    id: "1",
    name: "La creación",
    unLockLevel: true,
    color: "3ae4e4",
    section: Section(sectionName: "Genesis"),
    img: Img(urlImg: "assets/level.png"),
  );

  Stage stage = Stage(
      id: "1",
      sectionName: "Genesis",
      introduction:
          "¿Te gustaría conocer el origen de todo lo que existe, desde el universo hasta la humanidad? En Génesis encontrarás relatos fascinantes sobre la creación, el diluvio, la torre de Babel, la llamada de Abraham, el sacrificio de Isaac, la traición de Jacob, el sueño de José, y mucho más. También se demuestra el carácter de Dios, su amor, su justicia, su fidelidad y su poder. Este es solo el comienzo de grandes historias que continúan en el resto de la Biblia y que te motiva a ser parte de ella. Te invito a leerlo y a descubrir cómo Dios te habla a través de su palabra, ¿Estás listo?",
      unLockSection: true,
      orderCard: 1,
      color: "3ae4e4",
      img: Img(urlImg: "assets/assetStories.png"),
      levelCount: 12,
      levelCompleted: 0,
      status: 1);

  List<History> stories = [
    {
      "id": "1",
      "text":
          "La tierra, un lugar hermoso en el que hay cielo, tierra, mar, plantas, animales y, por supuesto, el ser humano. ¿Quién crearía tan maravilloso lugar? ¿Siempre fue \nasí? Bueno… ¡Aquí lo sabrás todo!",
      "countCards": null,
      "orderCard": 1,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "2",
      "text":
          "Hace mucho tiempo, la tierra estaba desordenada y vacía, y estaba cubierta de oscuridad. Entonces Dios decide comenzar el proceso de su gran creación, con una duración de 7 días.",
      "countCards": null,
      "orderCard": 2,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "3",
      "text":
          "Pero ahora te preguntarás ¿Quién es Dios? Existen muchas formas diferentes de explicarlo, pero en una descripción general, podemos decir que es el creador de todo lo que existe, el que nos dio la vida y nos ama sin límites. Él es el más grande, el más bueno, el más sabio, y el más poderoso. ",
      "countCards": null,
      "orderCard": 3,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "4",
      "text":
          "Él no tiene principio, ni fin, ni cuerpo, ni forma. Él está en todas partes y lo sabe todo. Él nos perdona cuando le pedimos, y nos ayuda cuando lo necesitamos. Él es nuestro amigo fiel, nuestro protector, y nuestro salvador. Él es Dios.",
      "countCards": null,
      "orderCard": 4,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "5",
      "text":
          "En el primer día, Dios creó la luz y lo separó de la oscuridad, generando así lo que hoy conocemos como día y noche.",
      "countCards": null,
      "orderCard": 5,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "6",
      "text":
          "En el segundo día, Dios hizo una expansión que separó las aguas y llamó a esa expansión cielo.",
      "countCards": null,
      "orderCard": 6,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "7",
      "text":
          "En el tercer día, Dios creó la tierra seca, y llamó a lo seco, tierra, y las aguas, mares. Seguidamente, hizo cubrir la tierra de todo tipo de hermosas plantas, arbustos y árboles.",
      "countCards": null,
      "orderCard": 7,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "8",
      "text":
          "En el cuarto día, Dios creó el sol para que brillara todo el día, y la luna y las estrellas para que brillaran toda la noche. De esta forma, se marcó las estaciones, los días y los años.",
      "countCards": null,
      "orderCard": 8,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "9",
      "text":
          "En el quinto día, Dios creó la vida tanto en el mar como el cielo, produciendo toda clase de especies marinas y aves. Además, los bendijo para que se multipliquen y llenen toda la tierra de ellos mismos.",
      "countCards": null,
      "orderCard": 9,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "10",
      "text":
          "En el sexto día, Dios hizo una gran cantidad de animales para la superficie de la tierra, tanto domésticos como salvajes. Posteriormente, creó al hombre a su imagen y semejanza, y lo puso por encima sobre todo aquel animal existente en la tierra.",
      "countCards": null,
      "orderCard": 10,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "11",
      "text":
          "Finalmente, en el séptimo día, Dios terminó su fantástica creación y santificó este día, debido a que pudo descansar.",
      "countCards": null,
      "orderCard": 11,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    },
    {
      "id": "12",
      "text":
          "Y así, Dios hizo todo lo que conocemos hoy en día en la tierra. Pero eso no es todo, para llegar a nuestra actualidad, la humanidad pasó por una enorme serie pruebas buenas y malas, que definió toda la historia que nos hizo llegar hasta aquí, y este es solo el comienzo de muchas historias.",
      "countCards": null,
      "orderCard": 12,
      "level": {
        "levelNumber": 1,
        "unLockLevel": true,
        "countLevelNumber": null,
        "scoreForLevel": 34
      },
      "img": {"urlImg": "assets/assetStories.png"},
      "status": 1,
      "audioUrl": null
    }
  ].map((historyJson) => History.fromJson(historyJson)).toList();

  @override
  void initState() {
    loadStories();
    scrollController = ScrollController();
    super.initState();
  }

  loadStories() {
    // here I call function to  provider of stories
  }

  @override
  Widget build(BuildContext context) {
    // final Map<String, dynamic> args =
    //     ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    // final String levelId = args['levelId'];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderNotDetailsStageWidget(
              title: "Conoce el Antiguo Testamento",
              stage: stage.id,
              subtitle: stage.sectionName,
              details: stage,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              padding: EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: StyleColor.orange,
                  borderRadius: BorderRadius.circular(8.0)),
              child: Text(
                "Paso ${isPage + 1} ${level.name}",
                style: StylesApp(context).textStyleBody5,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controllerPage,
                onPageChanged: (index) {
                  setState(() {
                    isPage = index.toDouble();
                  });
                },
                children: [
                  for (var story in stories)
                    SingleChildScrollView(
                      controller: scrollController,
                      child: _buildItemPageView(story, context),
                    ),
                ],
              ),
            ),
            SizedBox(
              height: 18.0,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 9),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Slider(
                      activeColor: Colors.blueGrey,
                      inactiveColor: Colors.grey,
                      thumbColor: StyleColor.turquoise,
                      min: 10.sp,
                      max: 20.sp,
                      value: fontSizeText,
                      onChanged: (value) {
                        setState(() {
                          fontSizeText = value;
                        });
                      },
                      secondaryTrackValue: 20.0,
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: Text(
                      "Aa",
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color: Colors.black,
                          ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 15.0),
              constraints: BoxConstraints(minHeight: 35),
              decoration: BoxDecoration(
                  color: Color(0XFF858585),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      width: 35,
                      height: 35.0,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        iconSize: 35.0,
                        onPressed: () {
                          _controllerPage.animateToPage(
                            0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                          setState(() {
                            isPage = 0;
                          });
                        },
                        icon: Icon(
                          Icons.skip_previous_outlined,
                          color: Colors.white,
                          size: 35.0,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 0,
                          child: SizedBox(
                            width: 45,
                            height: 45.0,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 45.0,
                              onPressed: isPage == 0
                                  ? null
                                  : () {
                                      _controllerPage.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeIn,
                                      );
                                      setState(() {
                                        isPage = _controllerPage.page!;
                                      });
                                    },
                              icon: Icon(
                                Icons.arrow_left_sharp,
                                color: Colors.white,
                                size: 45.0,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(6.0),
                            minHeight: 14.0,
                            value: isPage / (stories.length - 1),
                            backgroundColor: Color(0xFFC4C4C4),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0XFFF27728),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: SizedBox(
                            width: 45.0,
                            height: 45.0,
                            child: IconButton(
                              padding: EdgeInsets.all(0),
                              iconSize: 45.0,
                              onPressed: () {
                                _controllerPage.nextPage(
                                  duration: Duration(milliseconds: 350),
                                  curve: Curves.easeIn,
                                );
                                if (isPage < stories.length -1) {
                                  setState(() {
                                    isPage = _controllerPage.page! + 1;
                                  });
                                } else {
                                  Navigator.popAndPushNamed(
                                    context,
                                    "/questionDraggablePage",
                                    arguments: {"levelId": level.id},
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.arrow_right_sharp,
                                color: Colors.white,
                                size: 45.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      width: 30,
                      height: 30.0,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        iconSize: 25.0,
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                padding: EdgeInsets.all(16.0),
                                child: Row(
                                  spacing: 5,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ButtonThemeWidget(
                                        buttonStyle:
                                            StylesApp(context).btnWidgetSmall,
                                        onPressed: () {
                                          Navigator.popAndPushNamed(
                                            context,
                                            "/questionDraggablePage",
                                            arguments: {"levelId": level.id},
                                          );
                                        },
                                        text: "ordenamiento",
                                      ),
                                    ),
                                    Expanded(
                                      child: ButtonThemeWidget(
                                        buttonStyle:
                                            StylesApp(context).btnWidgetSmall,
                                        onPressed: () {
                                          Navigator.popAndPushNamed(
                                            context,
                                            "/questionPage",
                                            arguments: {"levelId": level.id},
                                          );
                                        },
                                        text: "responder Pregunta",
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );

                          // saltar a las preguntas
                        },
                        icon: Icon(
                          Icons.skip_next_outlined,
                          color: Colors.white,
                          size: 25.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }

  Container _buildItemPageView(History story, BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: 226.0),
            child: Image.asset(story.img.urlImg),
          ),
          SizedBox(
            height: 7.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo
              borderRadius: BorderRadius.circular(10), // Bordes redondeados
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3), // Sombra
                ),
              ],
            ),
            height: 248.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 7.0),
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 14.0, vertical: 15.0),
                constraints: BoxConstraints(
                  minHeight: 73.0,
                  maxHeight: 230.0,
                ),
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  thickness: 6.0,
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 21.0,
                        ),
                        Text(
                          story.text,
                          textAlign: TextAlign.left,
                          style: StylesApp(context).textStyleBody5.copyWith(
                                color: Colors.black,
                                fontSize: fontSizeText,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
