import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  LoginUser? dataUser;
  late final catalogueProvider;
  LastProgressUser? progressUser = null;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadProgress(BuildContext context) async {
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context,
        listen:
            false); // listen: false para evitar reconstrucciones innecesarias
    dataUser = userProvider.currentUser;
    final progressResponse =
        await userProvider.getProgressUser(dataUser?.user.id, null);
    if (progressResponse!.error != null) {
      LoadingService().hideLoading();
      await showCustomDialog(
        context,
        message: progressResponse.error!,
        dialogType: DialogType.error,
      );
      return;
    }
    progressUser = progressResponse.data;
    LoadingService().hideLoading();
    setState(() {}); // Fuerza una reconstrucción para mostrar los datos
  }

  void _initializeCatalogues() async {
    catalogueProvider = Provider.of<CatalogueProvider>(context, listen: false);
    catalogueProvider._initialize();
  }

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
    final userProvider = Provider.of<UserProvider>(context);
    dataUser = userProvider.currentUser;
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
              _buildPositionSection(context, dataUser!),
              SizedBox(
                height: 12.0,
              ),
              _buildProverbsSection(context),
              _buildStoriesSection(context),
              SizedBox(
                height: 12.0,
              ),
              _buildGridViewSection(context),
              SizedBox(
                height: 22.0,
              ),
              Container(
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
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/soonPage');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/books.png',
                          width: 52.sp,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: kBottomNavigationBarHeight - 40,
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
        onTap: () async {
          await _loadProgress(context);
          if (progressUser != null && card['label'] == 'Aventura') {
            Navigator.pushNamed(context, '/mapPage', arguments: {
              'courseId': progressUser!.courseId,
              'sectionId': progressUser!.sectionId
            });
          } else {
            Navigator.pushNamed(context, card['route']!);
          }
        },
        child: Column(
          children: [
            Container(
              width: StylesApp(context).sizeContainerCard.width,
              height: StylesApp(context).sizeContainerCard.height,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    StylesApp(context).sizeContainerCard.width),
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
            onTap: () async {
              await _loadProgress(context);
              if (progressUser != null) {
                Navigator.pushNamed(context, '/mapPage', arguments: {
                  'courseId': progressUser!.courseId,
                  'sectionId': progressUser!.sectionId
                });
              } else {
                Navigator.pushNamed(context, '/introAventurePage');
              }
            },
            child: CardOptionWidget(
                imageBackground: "assets/ranking.png",
                labelCard: "Aventura",
                gradientColors: [Color(0XFFA731EC), Color(0XFF620188)]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 15.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/preachPage'),
            child: CardOptionWidget(
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
            onTap: () => Navigator.pushNamed(context, '/playPage'),
            child: CardOptionWidget(
                imageBackground: "assets/games.png",
                labelCard: "Juegos",
                gradientColors: [Color(0XFF3531F3), Color(0XFF040681)]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 4.0, bottom: 15.0),
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/promisePage'),
            child: CardOptionWidget(
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
                                content:
                                    Text('Proverbio copiado al portapapeles')),
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
                  SizedBox(
                    width: 8,
                  )
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
          constraints: MediaQuery.of(context).size.width > 400
              ? BoxConstraints(minHeight: 96.0)
              : BoxConstraints(),
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

_buildPositionSection(BuildContext context, userData) {
  return Container(
    decoration: BoxDecoration(
      color: const Color(0xFF12CBC4),
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 10.0),
    width: MediaQuery.of(context).size.width,
    padding:
        const EdgeInsets.only(left: 5.0, right: 5.0, top: 6.0, bottom: 6.0),
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
                            Container(
                               
                        // width: double.infinity,
                        height:StylesApp(context).sizeContainerAvatar.height,
                              width:
                                  StylesApp(context).sizeContainerAvatar.width,
                              child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              imageUrl: userData!.imgProfileUser.isNotEmpty
                              ? GraphQLConfig.urlServidor+ userData.imgProfileUser + '?timestamp=${DateTime.now().millisecondsSinceEpoch}'
                              : 'assets/no-image.jpg',
                              placeholder:(context, url ) => Image.asset('assets/no-image.jpg'),
                              errorWidget:(context, url , error) => Image.asset('assets/no-image.jpg')
                            ),
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
                                "${userData?.league != null ? userData.league.leagueName : ''}",
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
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          userData!.user.username,
                          style: StylesApp(context)
                              .textStyleBody6
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          "Const: ${userData.streakDaysCount} Dias",
                          style: StylesApp(context)
                              .textStyleBody6
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Text(
                          " ${userData.energyPoints} Lms.",
                          style: StylesApp(context)
                              .textStyleBody6
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            Positioned(
              right: -3,
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
