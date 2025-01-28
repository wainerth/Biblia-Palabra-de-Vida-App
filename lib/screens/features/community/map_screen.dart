import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late ScrollController scrollController;
  // int _selectedIndex = 0;
  final List<String> imagePaths = [
    'assets/mapa1.png',
    'assets/mapa2.png',
  ];
  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
  }

  // int _selectedIndex = 0;

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //     if (_selectedIndex == 0) {
  //       Navigator.pushNamed(context, '/layoutPage');
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final course = CourseModel(
      color: "3ae4e4",
      id: "1",
      status: 1,
      title: "Antiguo Testamento",
      img: Img(urlImg: "assets/newTestament.png"),
      introduction:
          "¿Alguna vez te has preguntado sobre los inicios del mundo y las historias épicas de héroes antiguos? El Antiguo Testamento es como una caja del tesoro llena de relatos asombrosos y enseñanzas que han impactado a millones de personas a lo largo de los siglos. Desde la creación del universo hasta las aventuras de personajes como Moisés, David y Salomón, estos \nlibros te llevan en un viaje fascinante a través de la historia, la fe y la moral. Encontrarás milagros impresionantes, batallas épicas y sabiduría atemporal. Es un lugar donde los sueños, las promesas y las luchas de la humanidad cobran vida, ofreciendo valiosas lecciones que resuenan incluso en el mundo moderno.\n",
      sectionCount: 27,
      sectionCompleted: 27,
    );
    List<Level> levels = List<Level>.from([
      {
        "id": "1",
        "name": "La Creación",
        "unLockLevel": true,
        "color": "3ae4e4",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 150.0
      },
      {
        "id": "2",
        "name": "Un Jardín",
        "unLockLevel": true,
        "color": "2eade4",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": ""},
        "score": 80.0
      },
      {
        "id": "3",
        "name": "Hermanos",
        "unLockLevel": true,
        "color": "2958e4",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 45.0
      },
      {
        "id": "4",
        "name": "El Arca",
        "unLockLevel": true,
        "color": "2225c2",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 20.0
      },
      {
        "id": "5",
        "name": "Torre de Babel",
        "unLockLevel": true,
        "color": "7142e9",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "6",
        "name": "Abram",
        "unLockLevel": false,
        "color": "8c31d6",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "7",
        "name": "Destrucción",
        "unLockLevel": false,
        "color": "8a12a8",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "8",
        "name": "Sacrificio",
        "unLockLevel": false,
        "color": "d835d8",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "9",
        "name": "Esposa",
        "unLockLevel": false,
        "color": "fd30db",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "10",
        "name": "Gemelos",
        "unLockLevel": false,
        "color": "f72989",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "11",
        "name": "Huida",
        "unLockLevel": false,
        "color": "f7295c",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "12",
        "name": "Viaje a Harán",
        "unLockLevel": false,
        "color": "e93131",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "13",
        "name": "Trato con Laban",
        "unLockLevel": false,
        "color": "3ae4e4",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "14",
        "name": "Combate Divino",
        "unLockLevel": false,
        "color": "2eade4",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "15",
        "name": "Venganza",
        "unLockLevel": false,
        "color": "2958e4",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "16",
        "name": "Hijo Favorito",
        "unLockLevel": false,
        "color": "2225c2",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "17",
        "name": "Prisionero",
        "unLockLevel": false,
        "color": "7142e9",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "18",
        "name": "Interpretador\n de Sueños",
        "unLockLevel": false,
        "color": "8c31d6",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "19",
        "name": "Gobernador de Egipto",
        "unLockLevel": false,
        "color": "8a12a8",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "20",
        "name": "Prueba de Hermanos",
        "unLockLevel": false,
        "color": "d835d8",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      },
      {
        "id": "21",
        "name": "Reencuentro",
        "unLockLevel": false,
        "color": "fd30db",
        "section": {"sectionName": "Genesis"},
        "img": {"urlImg": "assets/level.png"},
        "score": 0.0
      }
    ].map((levelJson) => Level.fromJson(levelJson)).toList());
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
    // int i = 0;
    List coordATop = [0.00, 0.25, 0.48, 0.75];

    List coordALeft = [0.17, 0.50, 0.65, 0.65];

    List coordBTop = [0.0, 0.25, 0.50, 0.75];
    List coordBLeft = [0.30, 0.17, 0.05, 0.05];

    List<List<T>> chunked<T>(List<T> list, int chunkSize) {
      List<List<T>> chunks = [];
      for (var i = 0; i < list.length; i += chunkSize) {
        chunks.add(list.sublist(
            i, i + chunkSize > list.length ? list.length : i + chunkSize));
      }
      return chunks;
    }

    List<List<Level>> gruposDeNiveles = chunked(levels, 4);

    return Scaffold(
      body: SafeArea(
        child: OrientationBuilder(
          builder: (BuildContext context, Orientation orientation) {
            return Container(
              decoration: BoxDecoration(
                color: Color(0XFF12CBC4),
              ),
              height: MediaQuery.sizeOf(context).height,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 0,
                  children: [
                    HeadScoreWidget(
                      onRoute: () {
                        Navigator.popAndPushNamed(context, '/profilePage');
                      },
                    ),
                    HeaderMapWidget(
                      title: '${course.title}',
                      subtitleStage: '${stage.sectionName}',
                      indexStage: 1, //stage.id,
                      onRouteBack: () {
                        Navigator.popAndPushNamed(context, '/layoutPage1');
                      },
                      onShowInfoCourse: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return CustomModalWidget(
                              title: course.title,
                              content: course.introduction,
                              buttonText: 'Aceptar',
                              id: course.id,
                              showSubtitle: false,
                              itemCount: 0,
                              itemsCompleted: 0,
                            );
                          },
                        );
                      },
                      onShowInfoStage: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return CustomModalWidget(
                              title: stage.sectionName,
                              content: stage.introduction,
                              buttonText: 'Aceptar',
                              id: stage.id,
                              itemCount: stage.levelCount,
                              itemsCompleted: stage.levelCompleted,
                            );
                          },
                        );
                      },
                      onScroller: () {
                        if (kDebugMode) {
                          print(levels);
                        }
                        final int lastUnlockedIndex =
                            gruposDeNiveles.lastIndexWhere(
                          (grupo) =>
                              grupo.any((level) => level.unLockLevel == false),
                        );
                        String? lastLockedId = gruposDeNiveles.reversed
                            .expand((grupo) =>
                                grupo.reversed) // Recorremos desde el final
                            .lastWhere((level) => level.unLockLevel == false,
                                orElse: () => Level(
                                    id: '',
                                    name: '',
                                    unLockLevel: false,
                                    color: '',
                                    section: Section(sectionName: ''),
                                    img: Img(urlImg: ''),
                                    score: 0))
                            .id;

                        if (lastUnlockedIndex != -1) {
                          scrollController.animateTo(
                            int.parse(lastLockedId) *
                                100, // Ajusta según el tamaño del nivel
                            duration: Duration(seconds: 1),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: gruposDeNiveles
                            .length, // Dividimos por 4 para obtener el número de grupos de niveles
                        itemBuilder: (context, index) {
                          List<Level> grupo = gruposDeNiveles[index];
                          String image =
                              index % 2 == 0 ? imagePaths[0] : imagePaths[1];
                          return Column(
                            children: [
                              // if (index == 0) ...{

                              // },
                              Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(
                                        minHeight:
                                            MediaQuery.sizeOf(context).height),
                                    child: Image.asset(
                                      image,
                                      width: double.infinity,
                                      height: MediaQuery.sizeOf(context).height,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  for (var i = 0; i < grupo.length; i++) ...{
                                    Positioned(
                                      key: Key(grupo[i].id),
                                      top: index % 2 == 0
                                          ? StylesApp(context)
                                              .positionedLevels(coordATop[i])
                                              .dy
                                          : StylesApp(context)
                                              .positionedLevels(coordBTop[i])
                                              .dy, // Ajusta la posición vertical
                                      left: index % 2 == 0
                                          ? StylesApp(context)
                                              .positionedLevels(coordALeft[i])
                                              .dx
                                          : StylesApp(context)
                                              .positionedLevels(coordBLeft[i])
                                              .dx,
                                      child: GestureDetector(
                                        key: Key("${index}-${i}"),
                                        onTap: grupo[i].unLockLevel == false
                                            ? null
                                            : () {
                                                Navigator.pushNamed(
                                                  context,
                                                  '/historyPage',
                                                  arguments: {
                                                    'levelId': grupo[i].id
                                                  },
                                                );
                                              },
                                        child: Container(
                                          // decoration: BoxDecoration(border: Border.all(color: Colors.white)),
                                          constraints: BoxConstraints(
                                            maxWidth: StylesApp(context)
                                                .sizeContainerLevel
                                                .width,
                                          ),
                                          child: Stack(
                                            children: [
                                              Center(
                                                child: StarStatusWidget(
                                                  containerWidth:
                                                      StylesApp(context)
                                                          .sizeContainerLevel
                                                          .width,
                                                  unLockLevel: grupo[i].score,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  Center(
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width: StylesApp(
                                                                  context)
                                                              .sizeContainer
                                                              .width, // Ajusta el tamaño según tus necesidades
                                                          height:
                                                              StylesApp(context)
                                                                  .sizeContainer
                                                                  .height,
                                                          decoration:
                                                              BoxDecoration(
                                                                  color: Color(grupo[i]
                                                                              .score >
                                                                          0
                                                                      ? getColorItem(grupo[
                                                                              i]
                                                                          .score)
                                                                      : int.tryParse(
                                                                              '0xFF${grupo[i].color}') ??
                                                                          0XFF000000),
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  border: Border
                                                                      .all(
                                                                    color:grupo[i]
                                                                              .score >
                                                                          0
                                                                      ? Color(getColorItem(grupo[
                                                                              i]
                                                                          .score))
                                                                      : Color
                                                                        .fromARGB(
                                                                      100, // Opacidad: 50%
                                                                      int.parse(
                                                                          '0xFF${grupo[i].color}'.substring(
                                                                              2),
                                                                          radix:
                                                                              16),
                                                                      int.parse(
                                                                          '0xFF${grupo[i].color}'.substring(
                                                                              4,
                                                                              6),
                                                                          radix:
                                                                              16),
                                                                      int.parse(
                                                                          '0xFF${grupo[i].color}'.substring(
                                                                              6),
                                                                          radix:
                                                                              16),
                                                                    ),
                                                                    width: 1,
                                                                  ),
                                                                  boxShadow: [
                                                                BoxShadow(
                                                                    color: grupo[i].score >
                                                                            0
                                                                        ? Color(getColorShadow(grupo[i].score)).withValues(
                                                                            alpha:
                                                                                0.5)
                                                                        : Colors.black.withValues(
                                                                            alpha:
                                                                                0.5),
                                                                    offset:
                                                                        Offset(
                                                                            0,
                                                                            8),
                                                                    blurStyle:
                                                                        BlurStyle
                                                                            .outer)
                                                              ]),
                                                          child: Center(
                                                              child:
                                                                  _buildItemLevel(
                                                                      context,
                                                                      grupo[
                                                                          i])),
                                                        ),
                                                        if (grupo[i]
                                                                .unLockLevel ==
                                                            false)
                                                          Positioned.fill(
                                                            child: Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: const Color(
                                                                        0xFFA9B8BE)
                                                                    .withValues(
                                                                        alpha:
                                                                            0.9), // Ajusta la opacidad
                                                              ),
                                                              width: StylesApp(
                                                                      context)
                                                                  .sizeContainer
                                                                  .width,

                                                              // color: Colors.black.withOpacity(
                                                              //     0.5), // Ajusta la opacidad
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    textAlign: TextAlign.center,
                                                    "${grupo[i].id} ${grupo[i].name}",
                                                    style: StylesApp(context)
                                                        .textStyNameNumber
                                                        .copyWith(
                                                          color: Colors.white,
                                                        ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  },
                                  if (index == gruposDeNiveles.length - 1)
                                    Container(
                                      height: 349,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/Felicitaciones.png"),
                                            fit: StylesApp(context).fitImage),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 60,
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              'Felicidades',
                                              style: StylesApp(context)
                                                  .textStyCompleteLevelTitle
                                                  .copyWith(
                                                    color: Color(0XFF12CBC4),
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              'Culminaste la Etapa 1/27',
                                              style: StylesApp(context)
                                                  .textStyCompleteLevelBody
                                                  .copyWith(
                                                    color: Color(0XFF12CBC4),
                                                  ),
                                            ),
                                            SizedBox(
                                              height: 17,
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              'Introducción al Antiguo\n  Testamento',
                                              style: StylesApp(context)
                                                  .textStyCompleteLevelBody
                                                  .copyWith(
                                                    color: Color(0XFF12CBC4),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      // bottomNavigationBar: CustomBottomNavigationBarWidget(
      //   type: BottomNavigationBarType.fixed,
      //   showUnselectedLabels: true,
      //   backgroundColor: Color(0XFF7D7878),
      //   selectedItemColor: Color(0XFF12CBC4),
      //   unselectedItemColor: Colors.white,
      //   selectedLabelStyle: StylesApp(context).textStyleBody10,
      //   unselectedLabelStyle: StylesApp(context).textStyleBody10,
      //   items:items
      //       .map((item) => BottomNavigationBarItem(
      //             icon: Icon(
      //               item.icon,
      //               size: 40.0,
      //             ),
      //             label: item.title,
      //           ))
      //       .toList(),
      //   currentIndex: _selectedIndex,
      //   onTap: _onItemTapped,
      // ),
    );
  }

  int getColorShadow(double score) {
    if (score > 100) {
      return 0XFFBE9D27;
    } else if (score > 50 && score < 99) {
      return 0XFFA5A7A1;
    } else {
      return 0XFFD5886B;
    }
  }

  int getColorItem(double score) {
    if (score > 100) {
      return 0XFFFCD859;
    } else if (score > 50 && score < 99) {
      return 0XFFE4E0E0;
    } else {
      return 0XFFD5886B;
    }
  }
}

_starStatus(BuildContext context, double unLockLevel, double containerWidth) {
  final double starSize = 30.sp; // Adjust star size as needed
  final double starSpacing = (containerWidth - (3.sp * starSize)) / 3.sp;

  return Center(
    child: SizedBox(
      height: 50.0,
      child: Stack(
        children: [
          if (unLockLevel > 99.0) ...[
            Positioned(
              top: starSpacing,
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
              top: starSpacing,
              left: starSpacing + (2 * starSize) + (2 * starSpacing),
              child: Image.asset(
                "assets/star_complete.png",
                width: starSize,
                height: starSize,
              ),
            ),
          ] else if (unLockLevel > 50.0) ...[
            Positioned(
              top: starSpacing,
              left: 0.0,
              child: Image.asset(
                "assets/star_disabled.png",
                width: starSize,
                height: starSize,
              ),
            ),
            Positioned(
              top: 0,
              left: starSpacing + starSize,
              child: Image.asset(
                "assets/star_disabled.png",
                width: starSize,
                height: starSize,
              ),
            ),
          ] else if (unLockLevel > 0.0) ...[
            Positioned(
              top: starSpacing,
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

_buildItemLevel(BuildContext context, Level grupo) {
  if (grupo.img.urlImg.isNotEmpty) {
    return Container(
          width: StylesApp(context)
          .sizeContainerSub
          .width, // Ajusta el tamaño según tus necesidades
      height: StylesApp(context).sizeContainerSub.height,
      decoration:  BoxDecoration(
        color: grupo.score > 0
            ? Color(getColorInner(grupo.score))
            : Color.fromARGB(
                100,
                int.parse('0xFF${grupo.color}'.substring(2), radix: 16),
                int.parse('0xFF${grupo.color}'.substring(4, 6), radix: 16),
                int.parse('0xFF${grupo.color}'.substring(6), radix: 16),
              ),
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        grupo.img.urlImg,
        // width: StylesApp(context).sizeImage.width,
        // height: StylesApp(context).sizeImage.height,
        fit: StylesApp(context).fitImage,
      ),
    );
  } else {
    return Container(
      width: StylesApp(context)
          .sizeContainerSub
          .width, // Ajusta el tamaño según tus necesidades
      height: StylesApp(context).sizeContainerSub.height,
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: grupo.score > 0
            ? Color(getColorInner(grupo.score))
            : Color.fromARGB(
                100,
                int.parse('0xFF${grupo.color}'.substring(2), radix: 16),
                int.parse('0xFF${grupo.color}'.substring(4, 6), radix: 16),
                int.parse('0xFF${grupo.color}'.substring(6), radix: 16),
              ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              textAlign: TextAlign.center,
              grupo.id,
              style: StylesApp(context).textStyleLevelNumber.copyWith(
                    height: 1,
                    color: Colors.white,
                  ),
            ),
            Text(
              "paso",
              style: StylesApp(context).textStyleLevelNumber.copyWith(
                  fontSize: StylesApp(context).fontSizeBody10,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

int getColorInner(double score) {
  if (score > 100) {
    return 0XFFDDAC17;
  } else if (score > 50 && score < 99) {
    return 0XFFA5A7A1;
  } else {
    return 0XFFB05E3C;
  }
}
