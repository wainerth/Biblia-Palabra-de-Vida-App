import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class AventureScreen extends StatefulWidget {
  const AventureScreen({super.key});

  @override
  State<AventureScreen> createState() => _AventureScreenState();
}

class _AventureScreenState extends State<AventureScreen> {
  List<CourseModel> courses = [];
  @override
  void initState() {
    _generateData();
    super.initState();
  }

  void _generateData() {
    courses = [
      CourseModel(
          color: "3ae4e4",
          id: "1",
          status: 1,
          title: "Antiguo Testamento",
          img: "assets/newTestament.png"),
      CourseModel(
          color: "2eade4",
          id: "2",
          status: 1,
          title: "Nuevo Testamento",
          img: "assets/newTestament.png"),
      CourseModel(
          color: "B184EA",
          id: "3",
          status: 1,
          title: "Discipulado caminando con Cristo",
          img: "assets/aventura.png"),
      CourseModel(
          color: "9579B9",
          id: "4",
          status: 1,
          title: "Discipulado 2 Guiado por el Espiritu Santo",
          img: "assets/imagen2.png"),
      CourseModel(
          color: "64E8FC",
          id: "5",
          status: 1,
          title: "Armas de los Guerreros En Cristo",
          img: "assets/imagen3.png"),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(),
              listViewCardAventure(),
            ],
          ),
        ),
      ),
    );
  }

  listViewCardAventure() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height-30,
            child: ListView.builder(
              padding: EdgeInsets.only(bottom: 40.0),
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return   Column(
                  children: [
                    Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 9.0, vertical: 6.0),
                            margin: EdgeInsets.symmetric(
                                horizontal: 9.0, vertical: 5.0),
                            constraints: BoxConstraints(minHeight: 112.0),
                            decoration: BoxDecoration(
                                color:
                                    Color(int.parse('0XFF${courses[index].color}')),
                                borderRadius: BorderRadius.circular(12.0)),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(),
                                          constraints: BoxConstraints(
                                              maxWidth: 79.0, minHeight: 112.0),
                                          width: 79.0,
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  Center(
                                                    child: _starStatus(
                                                      context,
                                                      60,
                                                      79.0,
                                                    ),
                                                  ),
                                                  Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 27.0,
                                                      ),
                                                      Container(
                                                        width: 60.0,
                                                        height: 60.0,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  100.0),
                                                          image: DecorationImage(
                                                            image: AssetImage(
                                                                courses[index].img),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8.0),
                                                      Center(
                                                        child: Container(
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                  horizontal: 5),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          28.0),
                                                              color: Color(
                                                                  0XFFFDE754)),
                                                          child: Text(
                                                            "27 / 27",
                                                            textAlign:
                                                                TextAlign.center,
                                                            style:
                                                                StylesApp(context)
                                                                    .chipLevels,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            courses[index].title,
                                            style:
                                                StylesApp(context).textStyleBody5,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 37.0,
                                        )
                                      ],
                                    ),
                                    Positioned(
                                      top: -10,
                                      right: -10,
                                      child: IconButton(
                                        constraints:
                                            BoxConstraints(maxHeight: 50.0),
                                        padding: EdgeInsets.all(0),
                                        iconSize: 30.0,
                                        onPressed: () {
                                          showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CustomModalWidget(
                                                title: 'Conoce el nuevo testamento',
                                                content:
                                                    'Este sesión tiene como objetivo hacer una introducción del nuevo testamento, identificar los libros que lo componen y brindar información de entorno cronológico geopolítico de los hechos.',
                                                buttonText: 'Aceptar',
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(
                                          size: 20.0,
                                          Icons.info_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 6,
                                      right: 0,
                                      child: ButtonThemeWidget(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/mapPage');
                                        },
                                        textStyle: StylesApp(context)
                                            .chipLevels
                                            .copyWith(color: Colors.white),
                                        buttonStyle:
                                            StylesApp(context).btnWidgetSmall,
                                        text: "Ir a aventura",
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          if(index == courses.length-1) ...{
                          SizedBox(height: 160.0,)
    
                          }
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _starStatus(BuildContext context, double unLockLevel, containerWidth) {
    final starSize = 30.0; // Adjust star size as needed
    final starSpacing = (containerWidth - (3 * starSize)) / 3;

    return Center(
      child: SizedBox(
        height: 50.0,
        child: Stack(
          children: [
            if (unLockLevel > 99) ...[
              Positioned(
                top: 10,
                left: 0.0,
                child: Image.asset(
                  "assets/star_complete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
              Positioned(
                top: 0,
                left: starSpacing + starSize + starSpacing,
                child: Image.asset(
                  "assets/star_complete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
              Positioned(
                top: 10,
                left: starSpacing + (2 * starSize) + (2 * starSpacing),
                child: Image.asset(
                  "assets/star_complete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
            ] else if (unLockLevel > 50) ...[
              Positioned(
                top: 10,
                left: 0.0,
                child: Image.asset(
                  "assets/star_disabled.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
              Positioned(
                top: 0,
                left: starSpacing + starSize + starSpacing,
                child: Image.asset(
                  "assets/star_disabled.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
            ] else if (unLockLevel > 0) ...[
              Positioned(
                top: 10,
                left: 0.0,
                child: Image.asset(
                  "assets/star_incomplete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
