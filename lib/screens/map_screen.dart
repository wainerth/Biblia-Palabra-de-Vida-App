import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';

class MapScreen extends StatelessWidget {
  final List<Level> levels;
  final List<String> imagePaths = [
    '/mapa1.png',
    '/mapa2.png',
  ];
  MapScreen({super.key, required this.levels});

  @override
  Widget build(BuildContext context) {
    List coordATop = [20.0, 140.0, 330.0, 550.0];

    List coordALeft = [80.0, 204.0, 270.0, 290.0];

    List coordBTop = [0.0, 150.0, 350.0, 520.0];
    List coordBLeft = [130.0, 65.0, 5.0, 15.0];

    List<Level> levels = List<Level>.from([
      {
        "id": "1",
        "name": "La Creación",
        "unLockLevel": true,
        "color": "3ae4e4",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl1.png"
      },
      {
        "id": "2",
        "name": "Un Jardín",
        "unLockLevel": true,
        "color": "2eade4",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl2.png"
      },
      {
        "id": "3",
        "name": "Hermanos",
        "unLockLevel": true,
        "color": "2958e4",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl3.png"
      },
      {
        "id": "4",
        "name": "El Arca",
        "unLockLevel": true,
        "color": "2225c2",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl4.png"
      },
      {
        "id": "5",
        "name": "Torre de Babel",
        "unLockLevel": true,
        "color": "7142e9",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl5.png"
      },
      {
        "id": "6",
        "name": "Abram",
        "unLockLevel": true,
        "color": "8c31d6",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl6.png"
      },
      {
        "id": "7",
        "name": "Destrucción",
        "unLockLevel": true,
        "color": "8a12a8",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl7.png"
      },
      {
        "id": "8",
        "name": "Sacrificio",
        "unLockLevel": true,
        "color": "d835d8",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl8.png"
      },
      {
        "id": "9",
        "name": "Esposa",
        "unLockLevel": true,
        "color": "fd30db",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl9.png"
      },
      {
        "id": "10",
        "name": "Gemelos",
        "unLockLevel": true,
        "color": "f72989",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl10.png"
      },
      {
        "id": "11",
        "name": "Huida",
        "unLockLevel": true,
        "color": "f7295c",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl11.png"
      },
      {
        "id": "12",
        "name": "Viaje a Harán",
        "unLockLevel": true,
        "color": "e93131",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl12.png"
      },
      {
        "id": "13",
        "name": "Trato con Labán",
        "unLockLevel": true,
        "color": "3ae4e4",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl13.png"
      },
      {
        "id": "14",
        "name": "Combate Divino",
        "unLockLevel": true,
        "color": "2eade4",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl14.png"
      },
      {
        "id": "15",
        "name": "Venganza",
        "unLockLevel": true,
        "color": "2958e4",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl15.png"
      },
      {
        "id": "16",
        "name": "Hijo Favorito",
        "unLockLevel": true,
        "color": "2225c2",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl16.png"
      },
      {
        "id": "17",
        "name": "Prisionero",
        "unLockLevel": true,
        "color": "7142e9",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl19.png"
      },
      {
        "id": "18",
        "name": "Interpretador\n de Sueños",
        "unLockLevel": true,
        "color": "8c31d6",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl17.png"
      },
      {
        "id": "19",
        "name": "Gobernador de Egipto",
        "unLockLevel": true,
        "color": "8a12a8",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl18.png"
      },
      {
        "id": "20",
        "name": "Prueba de Hermanos",
        "unLockLevel": true,
        "color": "d835d8",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl20.png"
      },
      {
        "id": "21",
        "name": "Reencuentro",
        "unLockLevel": true,
        "color": "fd30db",
        "section": {"sectionName": "Genesis"},
        "img": "images/levels/lvl21.png"
      }
    ].map((levelJson) => Level.fromJson(levelJson)).toList());
    int i = 0;
    int level = 1;
    List<List<T>> _chunked<T>(List<T> list, int chunkSize) {
      List<List<T>> chunks = [];
      for (var i = 0; i < list.length; i += chunkSize) {
        chunks.add(list.sublist(
            i, i + chunkSize > list.length ? list.length : i + chunkSize));
      }
      return chunks;
    }

    List<List<Level>> gruposDeNiveles = _chunked(levels, 4);

    return Scaffold(
      body: ListView.builder(
        itemCount: gruposDeNiveles
            .length, // Dividimos por 4 para obtener el número de grupos de niveles
        itemBuilder: (context, index) {
          List<Level> grupo = gruposDeNiveles[index];
          String image = index % 2 == 0 ? imagePaths[0] : imagePaths[1];
          return Stack(
            alignment: Alignment.center,
            children: [
              Container(
                constraints: BoxConstraints(minHeight: 708),
                child: Image.asset(
                  image,
                  width: double.infinity,
                  height: 708, //MediaQuery.sizeOf(context).height,
                  fit: BoxFit.fill,
                ),
              ),
              for (i = 0; i < grupo.length; i++) ...{
                Positioned(
                  top: index % 2 == 0
                      ? coordATop[i]
                      : coordBTop[i], // Ajusta la posición vertical
                  left: index % 2 == 0 ? coordALeft[i] : coordBLeft[i],
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: StylesApp(context).sizeContainerLevel.width,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: StylesApp(context)
                              .sizeContainer
                              .width, // Ajusta el tamaño según tus necesidades
                          height: StylesApp(context).sizeContainer.height,
                          decoration: BoxDecoration(
                              color: Color(
                                  int.tryParse('0xFF${grupo[i].color}') ??
                                      0XFF000000),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(
                                  100, // Opacidad: 50%
                                  int.parse('0xFF${grupo[i].color}'.substring(2),
                                      radix: 16),
                                  int.parse(
                                      '0xFF${grupo[i].color}'.substring(4, 6),
                                      radix: 16),
                                  int.parse('0xFF${grupo[i].color}'.substring(6),
                                      radix: 16),
                                ),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    offset: Offset(0, 8),
                                    blurStyle: BlurStyle.outer)
                              ]),
                          child: Center(
                            child: Container(
                              width: StylesApp(context)
                                  .sizeContainerSub
                                  .width, // Ajusta el tamaño según tus necesidades
                              height: StylesApp(context).sizeContainerSub.height,
                              padding: EdgeInsets.all(0.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                  100, // Opacidad: 50%
                                  int.parse('0xFF${grupo[i].color}'.substring(2),
                                      radix: 16),
                                  int.parse(
                                      '0xFF${grupo[i].color}'.substring(4, 6),
                                      radix: 16),
                                  int.parse('0xFF${grupo[i].color}'.substring(6),
                                      radix: 16),
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
                                    grupo[i].id,
                                    style: StylesApp(context)
                                        .textStyleLevelNumber
                                        .copyWith(
                                          height: 1,
                                          color: Colors.white,
                                        ),
                                  ),
                                  Text(
                                    "paso",
                                    style: StylesApp(context)
                                        .textStyleLevelNumber
                                        .copyWith(
                                            fontSize:
                                                StylesApp(context).fontSizeBody5,
                                            color: Colors.white),
                                  )
                                ],
                              )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          "${grupo[i].id} ${grupo[i].name}",
                          style: StylesApp(context).textStyNameNumber.copyWith(
                                color: Colors.white,
                              ),
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
                        image: AssetImage("/Felicitaciones.png"),
                        fit: StylesApp(context).fitImage),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 60,),
                        Text(
                          textAlign: TextAlign.center,
                          'Felicidades',
                          style: StylesApp(context)
                              .textStyCompleteLevelTitle
                              .copyWith(
                                color: Color(0XFF12CBC4),
                              ),
                        ),
                        SizedBox(height: 7,),
                        Text(
                          textAlign: TextAlign.center,
                          'Culminaste la Etapa 1/27',
                          style: StylesApp(context)
                              .textStyCompleteLevelBody
                              .copyWith(
                                color: Color(0XFF12CBC4),
                              ),
                        ),
                        SizedBox(height: 17,),
                        Text(
                          textAlign: TextAlign.center,
                          'Introducción al Antiguo\n  Testamento',
                          style:  StylesApp(context)
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
          );
        },
      ),
    );
  }
}
