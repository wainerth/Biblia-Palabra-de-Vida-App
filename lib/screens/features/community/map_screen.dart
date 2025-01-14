import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';

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
    List<Level> levels = List<Level>.from([
      {
        "id": "1",
        "name": "La Creación",
        "unLockLevel": true,
        "color": "3ae4e4",
        "section": {"sectionName": "Genesis"},
        "img": "assets/level.png",
        "score": 150.0
      },
      {
        "id": "2",
        "name": "Un Jardín",
        "unLockLevel": true,
        "color": "2eade4",
        "section": {"sectionName": "Genesis"},
        "img": "",
        "score": 80.0
      },
      {
        "id": "3",
        "name": "Hermanos",
        "unLockLevel": true,
        "color": "2958e4",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 45.0
      },
      {
        "id": "4",
        "name": "El Arca",
        "unLockLevel": true,
        "color": "2225c2",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 20.0
      },
      {
        "id": "5",
        "name": "Torre de Babel",
        "unLockLevel": true,
        "color": "7142e9",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "6",
        "name": "Abram",
        "unLockLevel": false,
        "color": "8c31d6",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "7",
        "name": "Destrucción",
        "unLockLevel": false,
        "color": "8a12a8",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "8",
        "name": "Sacrificio",
        "unLockLevel": false,
        "color": "d835d8",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "9",
        "name": "Esposa",
        "unLockLevel": false,
        "color": "fd30db",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "10",
        "name": "Gemelos",
        "unLockLevel": false,
        "color": "f72989",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "11",
        "name": "Huida",
        "unLockLevel": false,
        "color": "f7295c",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "12",
        "name": "Viaje a Harán",
        "unLockLevel": false,
        "color": "e93131",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "13",
        "name": "Trato con Laban",
        "unLockLevel": false,
        "color": "3ae4e4",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "14",
        "name": "Combate Divino",
        "unLockLevel": false,
        "color": "2eade4",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "15",
        "name": "Venganza",
        "unLockLevel": false,
        "color": "2958e4",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "16",
        "name": "Hijo Favorito",
        "unLockLevel": false,
        "color": "2225c2",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "17",
        "name": "Prisionero",
        "unLockLevel": false,
        "color": "7142e9",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "18",
        "name": "Interpretador\n de Sueños",
        "unLockLevel": false,
        "color": "8c31d6",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "19",
        "name": "Gobernador de Egipto",
        "unLockLevel": false,
        "color": "8a12a8",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "20",
        "name": "Prueba de Hermanos",
        "unLockLevel": false,
        "color": "d835d8",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      },
      {
        "id": "21",
        "name": "Reencuentro",
        "unLockLevel": false,
        "color": "fd30db",
        "section": {"sectionName": "Genesis"},
        "img":"assets/level.png",
        "score": 0.0
      }
    ].map((levelJson) => Level.fromJson(levelJson)).toList());
    int i = 0;
    List coordATop = [0.02, 0.25, 0.48, 0.75];

    List coordALeft = [0.17, 0.50, 0.70, 0.65];

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
        child: Container(
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
                          if (index == 0)
                            _buildHeader(
                                context, scrollController, gruposDeNiveles),
                          Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                    minHeight: MediaQuery.sizeOf(context).height),
                                child: Image.asset(
                                  image,
                                  width: double.infinity,
                                  height:
                                      708, //MediaQuery.sizeOf(context).height,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              for (i = 0; i < grupo.length; i++) ...{
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
                                          child: _starStatus(
                                              context,
                                              grupo[i].score,
                                              StylesApp(context)
                                                  .sizeContainerLevel
                                                  .width),
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
                                                    width: StylesApp(context)
                                                        .sizeContainer
                                                        .width, // Ajusta el tamaño según tus necesidades
                                                    height: StylesApp(context)
                                                        .sizeContainer
                                                        .height,
                                                    decoration: BoxDecoration(
                                                        color: Color(int.tryParse(
                                                                '0xFF${grupo[i].color}') ??
                                                            0XFF000000),
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: Color.fromARGB(
                                                            100, // Opacidad: 50%
                                                            int.parse(
                                                                '0xFF${grupo[i].color}'
                                                                    .substring(2),
                                                                radix: 16),
                                                            int.parse(
                                                                '0xFF${grupo[i].color}'
                                                                    .substring(
                                                                        4, 6),
                                                                radix: 16),
                                                            int.parse(
                                                                '0xFF${grupo[i].color}'
                                                                    .substring(6),
                                                                radix: 16),
                                                          ),
                                                          width: 1,
                                                        ),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.black
                                                                  .withValues(
                                                                      alpha: 0.5),
                                                              offset:
                                                                  Offset(0, 8),
                                                              blurStyle:
                                                                  BlurStyle.outer)
                                                        ]),
                                                    child: Center(
                                                        child: _buildItemLevel(
                                                            context, grupo[i])),
                                                  ),
                                                  if (grupo[i].unLockLevel ==
                                                      false)
                                                    Positioned.fill(
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: const Color(
                                                                  0xFFA9B8BE)
                                                              .withValues(
                                                                  alpha:
                                                                      0.9), // Ajusta la opacidad
                                                        ),
                                                        width: StylesApp(context)
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
                              },
                              if (index == gruposDeNiveles.length - 1)
                                Container(
                                  height: 349,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage("assets/Felicitaciones.png"),
                                        fit: StylesApp(context).fitImage),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
}

_buildHeader(
    BuildContext context, ScrollController scroll, List<List<Level>> levels) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        decoration: BoxDecoration(
          color: Color(0XFF739EC7),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                Navigator.popAndPushNamed(context, '/layoutPage1');
              },
              icon: Icon(Icons.cancel_outlined),
              color: Colors.white,
            ),
            Center(
              child: Text(
                textAlign: TextAlign.center,
                'Antiguo Testamento',
                style: StylesApp(context).textStyleBody4.copyWith(
                      color: Colors.white,
                    ),
              ),
            ),
            IconButton(
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
              color: Colors.white,
              icon: Icon(Icons.info_outline),
            ),
          ],
        ),
      ),
      Container(
        constraints: BoxConstraints(
          minHeight: 79,
        ),
        decoration: BoxDecoration(
          color: Color(0XFF7688C2),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        margin: EdgeInsets.only(left: 6.0, right: 6.0, top: 6.0),
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 12.0, right: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 0.0,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Etapa 1',
                    style: StylesApp(context).textStyleBody4.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(
                    height: 30.0,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      // iconSize: 20.0,
                      onPressed: () {},
                      icon: Icon(Icons.chat_bubble),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    'Los Evangelio de Mateo',
                    style: StylesApp(context).textStyleBody4.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  SizedBox(
                    height: 30.0,
                    child: IconButton(
                      padding: EdgeInsets.all(0.0),
                      onPressed: () {
                        if (kDebugMode) {
                          print(levels);
                        }
                        final int lastUnlockedIndex = levels.lastIndexWhere(
                          (grupo) =>
                              grupo.any((level) => level.unLockLevel == false),
                        );
                        String? lastLockedId = levels.reversed
                            .expand((grupo) =>
                                grupo.reversed) // Recorremos desde el final
                            .lastWhere((level) => level.unLockLevel == false,
                                orElse: () => Level(
                                    id: '',
                                    name: '',
                                    unLockLevel: false,
                                    color: '',
                                    section: Section(sectionName: ''),
                                    img: '',
                                    score: 0))
                            .id;

                        if (lastUnlockedIndex != -1) {
                          scroll.animateTo(
                            int.parse(lastLockedId) *
                                100, // Ajusta según el tamaño del nivel
                            duration: Duration(seconds: 1),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: Icon(Icons.arrow_downward),
                      color: Colors.white,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    ],
  );
}

_starStatus(BuildContext context, double unLockLevel, double containerWidth) {
  final double starSize = 30.0; // Adjust star size as needed
  final double starSpacing = (containerWidth - (3.0 * starSize)) / 3.0;

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
              left: starSpacing + starSize + starSpacing,
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
  if (grupo.img.isNotEmpty) {
    return Image.asset(
      grupo.img,
      // width: StylesApp(context).sizeImage.width,
      // height: StylesApp(context).sizeImage.height,
      fit: StylesApp(context).fitImage,
    );
  } else {
    return Container(
      width: StylesApp(context)
          .sizeContainerSub
          .width, // Ajusta el tamaño según tus necesidades
      height: StylesApp(context).sizeContainerSub.height,
      padding: EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: Color.fromARGB(
          100, // Opacidad: 50%
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
                  fontSize: StylesApp(context).fontSizeBody5,
                  color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
