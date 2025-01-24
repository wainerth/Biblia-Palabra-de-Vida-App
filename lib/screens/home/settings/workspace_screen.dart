import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:share_plus/share_plus.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  List<ButtonData> buttonsData = [
    ButtonData(
        id: "1",
        name: "La liebre y la tortuga",
        urlAudio: "assets/audio/liebre_tortuga.mp3"),
    ButtonData(
        id: "2", name: "El labrador", urlAudio: "assets/audio/labrador.mp3"),
    ButtonData(
        id: "3", name: "El Navegante", urlAudio: "assets/audio/navegante.mp3"),
    ButtonData(
        id: "4",
        name: "El explorador",
        urlAudio: "assets/audio/explorador.mp3"),
    ButtonData(
        id: "5", name: "Los Hermanos", urlAudio: "assets/audio/hermanos.mp3"),
    ButtonData(
        id: "6",
        name: "La Casa Vieja",
        urlAudio: "assets/audio/casa_vieja.mp3"),
    ButtonData(
        id: "7", name: "Los Artistas", urlAudio: "assets/audio/artistas.mp3"),
    ButtonData(id: "8", name: "La cuenta", urlAudio: "assets/audio/cuenta.mp3"),
    ButtonData(
        id: "9",
        name: "Tres es mejor que dos",
        urlAudio: "assets/audio/tres_es_mejor.mp3"),
    ButtonData(
        id: "10",
        name: "Saltamontes",
        urlAudio: "assets/audio/saltamontes.mp3"),
    ButtonData(
        id: "11", name: "La Hormiga", urlAudio: "assets/audio/hormiga.mp3"),
  ];
  onSearch(value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cardList = [
      // Replace with your actual asset paths and route names
      {
        'label': 'Aventura',
        'img': 'assets/aventura.png',
        'route': '/introAventurePage',
      },
      {
        'label': 'La Biblia',
        'img': 'assets/biblia.png',
        'route': '/bibliaPage',
      },
      {
        'label': 'Comunidad',
        'img': 'assets/comunidad.png',
        'route': '/communityPage',
      },
    ];

    return SafeArea(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 15.0),
              _buildListCardSection(context, cardList),
              SizedBox(
                height: 12.0,
              ),
              _buildPositionSection(context),
              SizedBox(
                height: 12.0,
              ),
              _buildProverbsSection(context),
              // SizedBox(
              //   height: 12.0,
              // ),
              _buildStoriesSection(context),
              SizedBox(
                height: 12.0,
              ),
              _buildGridViewSection(context),
              SizedBox(
                height: 22.0,
              ),
              Container(
                constraints: BoxConstraints(minHeight: 60.sp),
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                padding: EdgeInsets.symmetric(horizontal: 26.0),
                decoration: BoxDecoration(
                    color: Color(0XFF5C9EDB),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Librería Cristiana",
                      style: StylesApp(context).textStyleBody7,
                    ),
                    Image.asset(
                      'assets/books.png',
                      width: 72.sp,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: kBottomNavigationBarHeight-30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListCardSection(
      BuildContext context, List<Map<String, String>> cards) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards.map((card) => _buildCard(context, card)).toList(),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, String> card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, card['route']!),
        child: Column(
          children: [
            Container(
              width: StylesApp(context).sizeContainerCard.width,
              height: StylesApp(context).sizeContainerCard.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                image: DecorationImage(
                  image: AssetImage(card['img']!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              card['label']!,
              textAlign: TextAlign.center,
              style: StylesApp(context).textStyleBody4.copyWith(
                    color: const Color(0xFFFD8C43),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  _buildStoriesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Cuentos para reflexionar",
              style: StylesApp(context)
                  .textStyleBody5
                  .copyWith(color: Color(0xFFFE8D43)),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ModalTalesWidget(data: buttonsData);
                  },
                );
              },
              icon: Icon(
                Icons.add_circle_outline_sharp,
                color: StyleColor.orange,
                size: 20.sp,
              ),
            )
          ],
        ),
        AudioPlayerWidget(
          showImage: false,
          inactiveColor: StyleColor.orange,
          backgroundColor: Colors.white,
          controlsColor: StyleColor.turquoise,
          pathUrl: "reflexion2.mp3",
        ),
      ],
    );
  }

  _buildGridViewSection(BuildContext context) {
    return Wrap(
      spacing: 0.0,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 15.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/introAventurePage'),
            child: CardOptionsWidget(
                imageBackground: "assets/ranking.png",
                labelCard: "Aventura",
                gradientColors: [Color(0XFFA731EC), Color(0XFF620188)]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 15.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/preachPage'),
            child: CardOptionsWidget(
                imageBackground: "assets/predicas.png",
                labelCard: "Prédicas",
                gradientColors: [
                  Color(0XFF1FEFEC),
                  Color(0XFF0159A7),
                ]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 15.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/introAventurePage'),
            child: CardOptionsWidget(
                imageBackground: "assets/games.png",
                labelCard: "Juegos",
                gradientColors: [Color(0XFF3531F3), Color(0XFF040681)]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 15.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/introAventurePage'),
            child: CardOptionsWidget(
                imageBackground: "assets/promesas.png",
                labelCard: "Promesas",
                gradientColors: [
                  Color(0XFF58AC5F),
                  Color(0XFF2F6624),
                ]),
          ),
        )
      ],
    );
  }
}

class CardOptionsWidget extends StatelessWidget {
  final String imageBackground;
  final String labelCard;
  final List<Color> gradientColors;
  const CardOptionsWidget({
    super.key,
    required this.imageBackground,
    required this.labelCard,
    required this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints(minHeight: 70.0.sp, maxWidth: 170.0.sp),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                imageBackground,
                fit: BoxFit.cover,
                height: 69,
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  labelCard,
                  textAlign: TextAlign.center,
                  style: StylesApp(context).textStyleBody7,
                ),
              ),
            ),
          ],
        ));
  }
}

_buildProverbsSection(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF12CBC4),
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
    width: MediaQuery.of(context).size.width,
    padding:
        const EdgeInsets.only(left: 7.0, right: 7.0, top: 6.0, bottom: 6.0),
    child: Column(
      children: [
        SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 45.0),
                child: Text(
                  "Proverbios 3:4",
                  style: StylesApp(context).textStyleBody7.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 10.0,
                children: [
                  Center(
                    child: SizedBox(
                      width: 16.sp,
                      height: 16.sp,
                      child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.copy,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                              text:
                                  "Proverbios 3:4\n Y hallarás gracia y buena opinión En los ojos de Dios y de los hombres."));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text('Proverbio copiado al portapapeles')),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                     width: 16.sp,
                    height: 16.sp,
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      icon: Icon(
                        Icons.share,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                      onPressed: () async {
                        await Share.share(
                          "Proverbios 3:4\nY hallarás gracia y buena opinión En los ojos de Dios y de los hombres.",
                          subject: "Proverbio del día",
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8,)
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF),
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(minHeight: 96.0),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    "Y hallarás gracia y buena opinión En los ojos de Dios y de los hombres.",
                    style: StylesApp(context)
                        .textStyleBody5
                        .copyWith(color: Colors.black, fontSize: 14.sp),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}

_buildPositionSection(BuildContext context) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF12CBC4),
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
    width: MediaQuery.of(context).size.width,
    padding: const EdgeInsets.only(left: 20.0, top: 6.0, bottom: 6.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Column(
                          children: [
                            SizedBox(
                              width:
                                  StylesApp(context).sizeContainerAvatar.width,
                              child: CircleAvatar(
                                radius: StylesApp(context).radiusAvatar,
                                backgroundImage:
                                    const AssetImage('assets/avatar.png'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Container(
                            constraints: BoxConstraints(
                                maxWidth: StylesApp(context).sizeTextPosition,
                                minHeight: 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFC7AA34),
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            child: Center(
                              child: Text(
                                textAlign: TextAlign.center,
                                "Soldado de Cristo",
                                style: StylesApp(context)
                                    .textStyleBody6
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: StylesApp(context).sizeContainerAvatar.width,
                            child: Image.asset(
                              'assets/kawaii_fire.png',
                              alignment: Alignment.center,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(
                    //   width: 20,
                    // )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Text(
                        "Robinson",
                        style: StylesApp(context)
                            .textStyleBody6
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Const: 300 Dias",
                        style: StylesApp(context)
                            .textStyleBody6
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    Center(
                      child: Text(
                        " 9999 Lms.",
                        style: StylesApp(context)
                            .textStyleBody6
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    // SizedBox(
                    //   width: 20,
                    // )
                  ],
                )
              ],
            ),
            Positioned(
              right: 0,
              top: -15,
              child: SizedBox(
                width: 40.0.sp,
                height: 30.0.sp,
                child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profilePage');
                  },
                  icon: Icon(
                    Icons.fast_forward_outlined,
                    color: Colors.white,
                    size: 30.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
