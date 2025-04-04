import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  State<BibleScreen> createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  int _ultimoVersiculoLeido = 0;
  ScrollController _scrollController = ScrollController();
  static const String iconFont = 'MaterialIcons';
  static const String? iconFontPackage = null;
  List<Map<String, dynamic>> verses = [
    {
      "id": "1",
      "chapterId": 1,
      "verse": 1,
      "text": "En el principio crió Dios los cielos y la tierra.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "2",
      "chapterId": 1,
      "verse": 2,
      "text":
          "Y la tierra estaba desordenada y vacía, y las tinieblas estaban sobre la haz del abismo, y el Espíritu de Dios se movía sobre la haz de las aguas.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "3",
      "chapterId": 1,
      "verse": 3,
      "text": "Y dijo Dios: Sea la luz: y fue la luz.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "4",
      "chapterId": 1,
      "verse": 4,
      "text":
          "Y vio Dios que la luz era buena: y apartó Dios la luz de las tinieblas.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "5",
      "chapterId": 1,
      "verse": 5,
      "text":
          "Y llamó Dios a la luz Día, y a las tinieblas llamó Noche: y fue la tarde y la mañana un día.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "6",
      "chapterId": 1,
      "verse": 6,
      "text":
          "Y dijo Dios: Haya expansión en medio de las aguas, y separe las aguas de las aguas.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "7",
      "chapterId": 1,
      "verse": 7,
      "text":
          "E hizo Dios la expansión, y apartó las aguas que estaban debajo de la expansión, de las aguas que estaban sobre la expansión: y fue así.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "8",
      "chapterId": 1,
      "verse": 8,
      "text":
          "Y llamó Dios a la expansión Cielos: y fue la tarde y la mañana el día segundo.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "9",
      "chapterId": 1,
      "verse": 9,
      "text":
          "Y dijo Dios: Júntense las aguas que están debajo de los cielos en un lugar, y descúbrase la seca: y fue así.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "10",
      "chapterId": 1,
      "verse": 10,
      "text":
          "Y llamó Dios a la seca Tierra, y a la reunión de las aguas llamó Mares: y vio Dios que era bueno.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "11",
      "chapterId": 1,
      "verse": 11,
      "text":
          "Y dijo Dios: Produzca la tierra hierba verde, hierba que dé simiente; árbol de fruto que dé fruto según su género, que su simiente esté en él, sobre la tierra: y fue así.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "12",
      "chapterId": 1,
      "verse": 12,
      "text":
          "Y produjo la tierra hierba verde, hierba que da simiente según su naturaleza, y árbol que da fruto, cuya simiente está en él, según su género: y vio Dios que era bueno.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "13",
      "chapterId": 1,
      "verse": 13,
      "text": "Y fue la tarde y la mañana el día tercero.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "14",
      "chapterId": 1,
      "verse": 14,
      "text":
          "Y dijo Dios: Sean lumbreras en la expansión de los cielos para apartar el día y la noche: y sean por señales, y para las estaciones, y para días y años;",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "15",
      "chapterId": 1,
      "verse": 15,
      "text":
          "Y sean por lumbreras en la expansión de los cielos para alumbrar sobre la tierra: y fue.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "16",
      "chapterId": 1,
      "verse": 16,
      "text":
          "E hizo Dios las dos grandes lumbreras; la lumbrera mayor para que señorease en el día, y la lumbrera menor para que señorease en la noche: hizo también las estrellas.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "17",
      "chapterId": 1,
      "verse": 17,
      "text":
          "Y púsolas Dios en la expansión de los cielos, para alumbrar sobre la tierra,",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "18",
      "chapterId": 1,
      "verse": 18,
      "text":
          "Y para señorear en el día y en la noche, y para apartar la luz y las tinieblas: y vio Dios que era bueno.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "19",
      "chapterId": 1,
      "verse": 19,
      "text": "Y fue la tarde y la mañana el día cuarto.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "20",
      "chapterId": 1,
      "verse": 20,
      "text":
          "Y dijo Dios: Produzcan las aguas reptil de ánima viviente, y aves que vuelen sobre la tierra, en la abierta expansión de los cielos.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "21",
      "chapterId": 1,
      "verse": 21,
      "text":
          "Y crió Dios las grandes ballenas, y toda cosa viva que anda arrastrando, que las aguas produjeron según su género, y toda ave alada según su especie: y vio Dios que era bueno.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "22",
      "chapterId": 1,
      "verse": 22,
      "text":
          "Y Dios los bendijo diciendo: Fructificad y multiplicad, y henchid las aguas en los mares, y las aves se multipliquen en la tierra.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "23",
      "chapterId": 1,
      "verse": 23,
      "text": "Y fue la tarde y la mañana el día quinto.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "24",
      "chapterId": 1,
      "verse": 24,
      "text":
          "Y dijo Dios: Produzca la tierra seres vivientes según su género, bestias y serpientes y animales de la tierra según su especie: y fue así.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "25",
      "chapterId": 1,
      "verse": 25,
      "text":
          "E hizo Dios animales de la tierra según su género, y ganado según su género, y todo animal que anda arrastrando sobre la tierra según su especie: y vio Dios que era bueno.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "26",
      "chapterId": 1,
      "verse": 26,
      "text":
          "Y dijo Dios: Hagamos al hombre a nuestra imagen, conforme a nuestra semejanza; y señoree en los peces de la mar, y en las aves de los cielos, y en las bestias, y en toda la tierra, y en todo animal que anda arrastrando sobre la tierra.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "27",
      "chapterId": 1,
      "verse": 27,
      "text":
          "Y crió Dios al hombre a su imagen, a imagen de Dios lo crió; varón y hembra los crió.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "28",
      "chapterId": 1,
      "verse": 28,
      "text":
          "Y los bendijo Dios; y díjoles Dios: Fructificad y multiplicad, y henchid la tierra, y sojuzgadla, y señoread en los peces de la mar, y en las aves de los cielos, y en todas las bestias que se mueven sobre la tierra.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "29",
      "chapterId": 1,
      "verse": 29,
      "text":
          "Y dijo Dios: He aquí que os he dado toda hierba que da simiente, que está sobre la haz de toda la tierra; y todo árbol en que hay fruto de árbol que da simiente, seros ha para comer.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "30",
      "chapterId": 1,
      "verse": 30,
      "text":
          "Y a toda bestia de la tierra, y a todas las aves de los cielos, y a todo lo que se mueve sobre la tierra, en que hay vida, toda hierba verde les será para comer: y fue así.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    },
    {
      "id": "31",
      "chapterId": 1,
      "verse": 31,
      "text":
          "Y vio Dios todo lo que había hecho, y he aquí que era bueno en gran manera. Y fue la tarde y la mañana el día sexto.",
      "colorHighlight": null,
      "getHighlighter": null,
      "status": 1
    }
  ];

  List tabs = [
    {
      "title": 'Mensaje',
      "placeholder": 'Mensaje a buscar',
    },
    {
      "title": 'Predicador',
      "placeholder": 'Nombre del predicador a buscar',
    },
    {
      "title": 'Favoritas',
      "placeholder": 'Favorito a buscar',
    }
  ];
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/elipsisTopColor.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 10,
                    left: 15,
                    child: Container(
                        height: 35.0,
                        width: 35.0,
                        decoration: BoxDecoration(
                            color: Color(0XFFFD8C43),
                            borderRadius: BorderRadius.circular(35.0)),
                        child: IconButton(
                            constraints: BoxConstraints(maxHeight: 35.0),
                            padding: EdgeInsets.all(0),
                            iconSize: 35.0,
                            color: Colors.white,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              size: 35.0,
                            ))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: ButtonThemeWidget(
                          width: 150.0,
                          height: 27.0,
                          text: "RVR 1960",
                          buttonStyle: StylesApp(context).btnWidgetSmall,
                          onPressed: () {
                            _showBibleVersion(context);
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "S. juan",
                          style: StylesApp(context)
                              .textStyleTitleWithe
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "22",
                          style: StylesApp(context)
                              .textStyleTitleWithe
                              .copyWith(fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    right: 15,
                    child: Column(
                      children: [
                        IconButton(
                          constraints: BoxConstraints(maxHeight: 35.0),
                          padding: EdgeInsets.all(0),
                          iconSize: 35.0,
                          color: Colors.white,
                          onPressed: () {},
                          icon: Icon(
                            Icons.volume_up_outlined,
                            size: 35.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: Stack(
                  children: [
                    // body
                    Scrollbar(
                      controller: _scrollController,
                      thumbVisibility: true,
                      thickness: 6.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  controller: _scrollController,
                                  itemCount: verses.length,
                                  itemBuilder: (BuildContext context, index) {
                                    if (index == 0) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 40),
                                          Text(
                                            "Las bodas de Caná",
                                            style: StylesApp(context)
                                                .textStyleBodyRoboto24
                                                .copyWith(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          SizedBox(
                                            height: 42.0,
                                          ),
                                          Text.rich(
                                            TextSpan(
                                              style: StylesApp(context)
                                                  .textStyleBodyRoboto20
                                                  .copyWith(
                                                    color: Colors.black,
                                                  ),
                                              children: [
                                                TextSpan(
                                                    text:
                                                        "${verses[index]['verse']} ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                TextSpan(
                                                    text:
                                                        "${verses[index]['text']}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Text.rich(
                                        TextSpan(
                                          style: StylesApp(context)
                                              .textStyleBodyRoboto20
                                              .copyWith(
                                                color: Colors.black,
                                              ),
                                          children: [
                                            TextSpan(
                                                text:
                                                    "${verses[index]['verse']} ",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            TextSpan(
                                                text:
                                                    "${verses[index]['text']}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal)),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white),
                        // width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 25.0,
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return modalTextFormatSizeWidget();
                                      });
                                },
                                icon: Icon(
                                  CupertinoIcons.textformat_size,
                                  color: StyleColor.turquoise,
                                )),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 25.0,
                              onPressed: () async {
                                Clipboard.setData(ClipboardData(
                                    text:
                                        "Proverbios 3:4\n Y hallarás gracia y buena opinión En los ojos de Dios y de los hombres."));
                                await showCustomDialog(
                                  context,
                                  message:
                                      "El capitulo S. Juan 22\n se copiado con éxito al\n portapapeles",
                                  dialogType: DialogType.info,
                                );
                              },
                              icon: Icon(
                                Icons.file_copy_rounded,
                                color: StyleColor.turquoise,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 25.0,
                              onPressed: () async {
                                await Share.share(
                                  "Las bodas de Caná\n 1 Al tercer día hicieron unas bodas en Caná de Galilea; y estaba allí la madre de Jesús. 2 Y fueron también invitados a  las bodas Jseús y sus dicípulos. 3 Y faltando el vino, la madre de Jesús le dijo: No tienen vino. 4 Jesús le fijo : ¿Qué tienes conmigo, mujer? Aún no ha venido mi hora. 5 Su madre dijo a los que servian:  Haced todo lo que os dijere. 6 Y estaban allí seis tinajas de piedra para agua, conforme al rito de  la purificación de los judíos, en  cas una de las cuales  cabian dos o tres càntaros.",
                                  subject: "S. Juan 22",
                                );
                              },
                              icon: Icon(
                                Icons.share_rounded,
                                color: StyleColor.turquoise,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              iconSize: 25.0,
                              onPressed: () {
                                showModalBottomSheet(
                                  isDismissible: false,
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SearchBibleWidget();
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.search_rounded,
                                color: StyleColor.turquoise,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 7.0),
                        width: MediaQuery.sizeOf(context).width,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: StyleColor.turquoise,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  alignment: Alignment.center,
                                  iconSize: 35,
                                  color: StyleColor.turquoise,
                                  onPressed: () {
                                    print("anterior");
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_left_rounded,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 35,
                              height: 35,
                              decoration: BoxDecoration(
                                  color: StyleColor.turquoise,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Center(
                                child: IconButton(
                                  padding: EdgeInsets.all(0),
                                  alignment: Alignment.center,
                                  iconSize: 35,
                                  onPressed: () {
                                    print("siguiente");
                                  },
                                  icon: Icon(
                                    Icons.keyboard_arrow_right_rounded,
                                    size: 35,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _showBibleVersion(BuildContext context) async {
    List<ModelData> bibleVersions = [
      ModelData(label: 'RVR 1960', value: 'Reina-Valera 1960'),
      ModelData(label: 'NVI', value: 'Nueva Versión Internacional'),
      ModelData(label: 'LBLA', value: 'La Biblia de las Américas'),
      ModelData(label: 'DHH', value: 'Dios Habla Hoy'),
      ModelData(label: 'TLA', value: 'Traducción en Lenguaje Actual'),
      ModelData(label: 'NBD', value: 'Nueva Biblia de los Hispanos'),
      ModelData(label: 'PDT', value: 'Palabra de Dios para Todos'),
    ];
    ModelData versionSelected = bibleVersions[0];
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  SizedBox(height: 30.0),
                  Text(
                    'Seleccione La version de la Biblia',
                    style: StylesApp(context)
                        .textStyleBody16
                        .copyWith(color: StyleColor.orange),
                  ),
                  SizedBox(height: 10.0),
                  CustomDropdownBottomWidget<ModelData>(
                    hintText: "Seleccione una versión",
                    items: bibleVersions,
                    onChanged: (ModelData? newValue) {
                      if (newValue != null) {
                        setModalState(() {
                          versionSelected = newValue;
                        });
                      }
                    },
                    selectedItem: versionSelected,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ButtonThemeWidget(
                         width: 150.0,
                          height: 27.0,
                      text: "Aceptar",
                      buttonStyle: StylesApp(context).btnWidgetSmall,
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
    setState(() {
      // Update the state of the parent widget if needed
    });
  }
}

class modalTextFormatSizeWidget extends StatefulWidget {
  const modalTextFormatSizeWidget({
    super.key,
  });

  @override
  State<modalTextFormatSizeWidget> createState() =>
      _modalTextFormatSizeWidgetState();
}

class _modalTextFormatSizeWidgetState extends State<modalTextFormatSizeWidget> {
  ModelData selectedItem = ModelData(label: "Roboto", value: "1");
  double fontSize = 0.5;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
          ),
          Row(
            spacing: 10,
            children: [
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
              Container(
                width: 40,
                height: 50,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0)),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          CustomDropdownBottomWidget(
            items: [
              ModelData(label: "Roboto", value: "1"),
              ModelData(label: "Erica One", value: "2"),
              ModelData(label: "Aclonica", value: "3"),
              ModelData(label: "All sane", value: "4"),
            ],
            selectedItem: selectedItem,
            onChanged: (ModelData? newValue) {
              setState(() {
                selectedItem = newValue!;
              });
            },
            hintText: "Tipo de fuente",
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                  flex: 0,
                  child: Icon(
                    Icons.text_decrease,
                    color: StyleColor.turquoise,
                  )),
              Expanded(
                flex: 1,
                child: Slider(
                    activeColor: Colors.grey,
                    inactiveColor: Colors.grey,
                    thumbColor: StyleColor.orange,
                    value: fontSize,
                    onChanged: (value) {
                      setState(() {
                        fontSize = value;
                      });
                    }),
              ),
              Expanded(
                  flex: 0,
                  child: Icon(
                    Icons.text_increase_rounded,
                    color: StyleColor.turquoise,
                  ))
            ],
          ),
          SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}

class SearchBibleWidget extends StatefulWidget {
  const SearchBibleWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchBibleWidget> createState() => _SearchBibleWidgetState();
}

class _SearchBibleWidgetState extends State<SearchBibleWidget> {
  
  var _selectedIndex = 0;
  List tabs = [
    {
      "title": 'Libro',
      "placeholder": 'Mensaje a buscar',
    },
    {
      "title": 'Texto',
      "placeholder": 'Nombre del predicador a buscar',
    },
    {
      "title": 'Tema',
      "placeholder": 'Favorito a buscar',
    },
    {
      "title": 'Personajes',
      "placeholder": 'Favorito a buscar',
    }
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppBarHeaderWidget(
                backColor: StyleColor.turquoise,
                buttonColor: StyleColor.orange,
                textButtonColor: Colors.white,
                title: 'Búsqueda',
                styleText: StylesApp(context).textStyleBody7,
                onRoute: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(right: 65),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  )
                ]),
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  labelStyle: StylesApp(context).textStyleBody12,
                  indicatorSize: TabBarIndicatorSize.tab,
                  automaticIndicatorColorAdjustment: true,
                  indicatorWeight: 0,
                  indicatorPadding: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  dividerColor: Color(0XFFFFFDFD),
                  dividerHeight: 0,
                  labelPadding: EdgeInsets.symmetric(horizontal: 2),
                  indicator: BoxDecoration(
                    color: Colors.orange, // Color de la pestaña seleccionada
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ), // Bordes redondeados
                  ),
                  tabs: tabs.asMap().entries.map((entry) {
                    int index = entry.key;
                    var tab = entry.value;
                    return Tab(
                      height: 32.sp,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: _selectedIndex == index
                              ? Colors.orange
                              : Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Center(child: Text(tab["title"])),
                      ),
                    );
                  }).toList(),
                ),
              ),
             
              // Lista de mensajes
              Expanded(
                child: TabBarView(
                  children: [
                   Container(),
                   Container(),
                   Container(),
                   Container(),
                  ],
                ),
              ),
            ],
          ),
        ),
        //  bottomNavigationBar: CustomBottomNavigationBarWidget(
        //     type: BottomNavigationBarType.fixed,
        //     showUnselectedLabels: true,
        //     backgroundColor: Color(0XFF7D7878),
        //     selectedItemColor: Color(0XFF12CBC4),
        //     unselectedItemColor: Colors.white,
        //     selectedLabelStyle: StylesApp(context).textStyleBody10,
        //     unselectedLabelStyle: StylesApp(context).textStyleBody10,
        //     items: getBottomNavigationBarItems(context),
        //     currentIndex: _selectedIndex,
        // onTap: _onItemTapped)
      ),
    );
  }
}
