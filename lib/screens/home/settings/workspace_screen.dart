import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:share_plus/share_plus.dart';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';

mixin SafeStateMixin<T extends StatefulWidget> on State<T> {
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }
}

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});

  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> with SafeStateMixin {
  LoginUser? dataUser;
  late final catalogueProvider;
  PaginationInfo? paginate;
  LastProgressUser? progressUser = null;
  bool error = false;
  bool errorDaily = false;
  bool loadingDaily = false;
  Reflection? reflection;
  DailyWord dailyWord = DailyWord(
      book: Book(modernName: ""),
      chapter: Chapter(chapter: 0),
      verse: Verse(verse: 0, text: ""));
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        if (Provider.of<UserProvider>(context, listen: false).getDailyProverb !=
            null) {
          setState(() {
            dailyWord = Provider.of<UserProvider>(context, listen: false)
                .getDailyProverb!;
          });
        } else {
          await getDailyProverb();
        }
        await loadGetOneReflection();
        await loadAllNotifications();
        final notificationProvider =
            Provider.of<SocketClientProvider>(context, listen: false);

        notificationProvider.listenToEvent("notification", (notify) {
          if (kDebugMode) {
            print(notify);
          }
          notificationProvider.notifications
              .add(NotificationModel.fromJson(notify));
        });
      }
    });
  }

  Future loadAllNotifications() async {
    final userProvider = Provider.of<UserProvider>(context,
        listen:
            false); // listen: false para evitar reconstrucciones innecesarias
    final useData = userProvider.currentUser;

    try {
      final responseNotification =
          await getAllNotification(1, 10, useData!.userId);
      if (responseNotification.error != null) {
        await showCustomDialog(context,
            message: responseNotification.error!, dialogType: DialogType.error);
        return;
      }

      // almacenamos la notificaciones
      List<NotificationModel> notifys = List<NotificationModel>.from(
          responseNotification.data['data']
              .map((n) => NotificationModel.fromJson(n)));
      Provider.of<SocketClientProvider>(context, listen: false).notifications =
          notifys;
    } catch (e) {
      String error = "Error al leer las notificaciones:  ${e.toString()}";
      await showCustomDialog(context,
          message: error, dialogType: DialogType.error);
    }
  }

  Future<void> _loadProgress(BuildContext context) async {
    setState(() {
      error = false;
    });
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context,
        listen:
            false); // listen: false para evitar reconstrucciones innecesarias
    dataUser = userProvider.currentUser;
    final progressResponse =
        await userProvider.getProgressUser(dataUser?.userId, null);
    if (progressResponse!.error != null) {
      setState(() {
        error = true;
      });
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

  List<ButtonData> buttonsData = [];

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
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0, // Puedes ajustar este valor
                right: 0,
                child: Visibility(
                  visible: true,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.all(0),
                      iconSize: 40,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (BuildContext context) {
                            return NotificationListWidget();
                          },
                        );
                      },
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.notifications,
                            size: 40,
                            color: StyleColor.redLight,
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Container(
                              padding: EdgeInsets.all(0),
                              decoration: BoxDecoration(
                                  // color: Colors.white,
                                  // shape: BoxShape.circle,
                                  ),
                              constraints: BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Center(
                                child: Text(
                                  int.parse(getUnreadCountNotification()) > 0
                                      ? getUnreadCountNotification()
                                      : '',
                                  style: StylesApp(context)
                                      .textStyleBody10
                                      .copyWith(
                                        // color: StyleColor.redLight,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: 15.0),
                  _buildListCardSection(context, cardList),
                  SizedBox(
                    height: 12.0,
                  ),
                  dataUser != null
                      ? _buildPositionSection(context, dataUser)
                      : Container(),
                  SizedBox(
                    height: 12.0,
                  ),
                  _buildProverbsSection(
                      context, loadingDaily, errorDaily, dailyWord),
                  _buildStoriesSection(context, reflection),
                  SizedBox(
                    height: 12.0,
                  ),
                  _buildGridViewSection(context),
                  SizedBox(
                    height: 22.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/soonPage');
                    },
                    child: Container(
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/books.png',
                              width: 52.sp,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kBottomNavigationBarHeight - 40,
                  )
                ],
              ),
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
          if (card['label'] == 'Aventura') {
            if (error) return;
            if (progressUser != null && card['label'] == 'Aventura') {
              Navigator.pushNamed(context, '/mapPage', arguments: {
                'courseId': progressUser!.courseId,
                'sectionId': progressUser!.sectionId
              });
            } else {
              Navigator.pushNamed(context, '/introAventurePage');
            }
          } else if (card['label'] == 'La Biblia') {
            Navigator.pushNamed(
              context,
              '/layoutPage',
              arguments: {'selectedIndex': 1},
            );
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

  _buildStoriesSection(BuildContext context, reflection) {
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
              onPressed: () async {
                LoadingService().showLoading(context);
                final limit = 12;
                final page = 1;
                final responseReflection =
                    await getAllReflections(page, limit, '');
                if (responseReflection.error != null) {
                  LoadingService().hideLoading();
                  await showCustomDialog(
                    context,
                    message: responseReflection.error!,
                    dialogType: DialogType.error,
                  );
                  return;
                }
                LoadingService().hideLoading();
                List reflections = responseReflection.data['data']
                    .map<Reflection>(
                        (reflex) => Reflection.fromJson(removeTypename(reflex)))
                    .toList();
                final PaginationInfo paginate = PaginationInfo.fromJson(
                    removeTypename(responseReflection.data['meta']));
                buttonsData = reflections
                    .map<ButtonData>((reflection) => ButtonData(
                        id: reflection.id,
                        name: reflection.title,
                        urlAudio: reflection.url))
                    .toList();
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ModalTalesWidget(
                        data: buttonsData, pagination: paginate);
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
            fileName: reflection != null ? reflection.title : '',
            pathUrl: reflection != null
                ? "${GraphQLConfig.urlServidor}${reflection.url}"
                : ''),
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
              if (error) return;

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

  Future<void> getDailyProverb() async {
    if (!mounted) return;

    setState(() {
      loadingDaily = true;
    });
    final responseDailyWord = await getDailyWord();
    if (mounted) {
      if (responseDailyWord.error != null) {
        setState(() {
          loadingDaily = false;
          errorDaily = true;
        });
      } else {
        setState(() {
          loadingDaily = false;
          errorDaily = false;
          dailyWord = DailyWord.fromJson(responseDailyWord.data);
          Provider.of<UserProvider>(context, listen: false).dailyProverb =
              dailyWord;
        });
      }
    }
  }

  Future<void> loadGetOneReflection() async {
    if (!mounted) return;
    final responseReflection = await getOneReflection();
    if (responseReflection.error != null) {
    } else {
      safeSetState(() {
        reflection = Reflection.fromJson(responseReflection.data);
      });
    }
  }

  _buildProverbsSection(BuildContext context, bool loadingDaily,
      bool errorDaily, DailyWord dailyWord) {
    bool loading = false;
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF12CBC4),
        borderRadius: BorderRadius.circular(8.0),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      width: MediaQuery.of(context).size.width,
      padding:
          const EdgeInsets.only(left: 7.0, right: 7.0, top: 6.0, bottom: 6.0),
      child: errorDaily
          ? Stack(children: [
              if (!loading)
                Center(
                  child: ButtonThemeWidget(
                    // text: "Recargar",
                    width: 40,
                    height: 40,
                    icon: Icons.restart_alt_rounded,
                    buttonStyle: StylesApp(context).btnWidgetSmall,
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      await getDailyProverb();
                      setState(() {
                        loading = false;
                      });
                    },
                  ),
                ),
            ])
          : Column(
              children: [
                SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 45.0),
                        child: dailyWord.book!.modernName!.isNotEmpty
                            ? Row(
                                spacing: 10,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints(maxWidth: 180),
                                    width: double.infinity,
                                    child: Text(
                                      maxLines: 1,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      "${dailyWord.book!.modernName}",
                                      style: StylesApp(context)
                                          .textStyleBody15
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "${dailyWord.chapter!.chapter}:",
                                        style: StylesApp(context)
                                            .textStyleBody15
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                      Text(
                                        "${dailyWord.verse!.verse}",
                                        style: StylesApp(context)
                                            .textStyleBody15
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Text(""),
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
                                          "${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}\n ${dailyWord.verse!.text}."));
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Proverbio copiado al portapapeles')),
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
                                  "${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}\n ${dailyWord.verse!.text}.",
                                  subject: "Proverbio del día",
                                );
                              },
                            ),
                          ),
                          // SizedBox(
                          //   width: 8,
                          // )
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
                      ? BoxConstraints(minHeight: 96.0, maxHeight: 100.0)
                      : BoxConstraints(),
                  width: double.infinity,
                  child: loadingDaily
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Text(
                                    "${dailyWord.verse!.text}.",
                                    style: StylesApp(context)
                                        .textStyleBody5
                                        .copyWith(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                        ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                              SizedBox(
                                // width: double.infinity,
                                height: StylesApp(context)
                                    .sizeContainerAvatar
                                    .height,
                                width: StylesApp(context)
                                    .sizeContainerAvatar
                                    .width,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      alignment: Alignment.topCenter,
                                      imageUrl: userData != null &&
                                              userData!.imgProfileUser != null
                                          ? GraphQLConfig.urlServidor +
                                              userData.imgProfileUser.urlImg +
                                              '?timestamp=${DateTime.now().millisecondsSinceEpoch}'
                                          : 'assets/no-image.jpg',
                                      placeholder: (context, url) =>
                                          Image.asset('assets/no-image.jpg'),
                                      errorWidget: (context, url, error) =>
                                          Image.asset('assets/no-image.jpg')),
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
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/layoutPage1',
                                    arguments: {'selectedIndex': 2});
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        StylesApp(context).sizeTextPosition,
                                    minHeight: 20),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC7AA34),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                child: Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "${userData?.league != null ? userData.league.leagueName : 'necesitas experiencia para Entrar a una liga'}",
                                    style: userData?.league != null
                                        ? StylesApp(context)
                                            .textStyleBody6
                                            .copyWith(color: Colors.white)
                                        : StylesApp(context)
                                            .textStyleBody10
                                            .copyWith(color: Colors.white),
                                  ),
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
                              width:
                                  StylesApp(context).sizeContainerAvatar.width,
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
                            textAlign: TextAlign.center,
                            softWrap: true,
                            dataUser != null
                                ? dataUser!.name
                                        .split(' ')[0][0]
                                        .toUpperCase() +
                                    dataUser!.name.split(' ')[0].substring(1)
                                : '', //userData!.user.username,
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

  String getUnreadCountNotification() {
    final notificationProvider = Provider.of<SocketClientProvider>(context);
    final notifications = notificationProvider.notifications.reversed.toList();
    final unreadCount = notifications.where((n) => n.isRead == false).length;
    return unreadCount > 0 ? unreadCount.toString() : '0';
  }
}

// Formats a DateTime object to a readable string (e.g., "12/06/2024 14:30")
String formatDateTime(String dateTimeStr) {
  try {
    // Remove spaces around 'T' if present
    String cleaned = dateTimeStr.replaceAll(' ', '');
    DateTime dateTime = DateTime.parse(cleaned.replaceFirst('T', 'T'));
    return "${dateTime.day.toString().padLeft(2, '0')}/"
        "${dateTime.month.toString().padLeft(2, '0')}/"
        "${dateTime.year}  "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
  } catch (e) {
    return dateTimeStr;
  }
}

class NotificationListWidget extends StatefulWidget {
  const NotificationListWidget({super.key});

  @override
  State<NotificationListWidget> createState() => _NotificationListWidgetState();
}

class _NotificationListWidgetState extends State<NotificationListWidget> {
  late List<NotificationModel> notifications;
  late SocketClientProvider notificationProvider;

  @override
  void initState() {
    super.initState();
    notificationProvider =
        Provider.of<SocketClientProvider>(context, listen: false);
    notifications = notificationProvider.notifications.reversed.toList();

    // Listen for changes in notifications
    notificationProvider.addListener(_onNotificationsChanged);
  }

  void _onNotificationsChanged() {
    setState(() {
      notifications = notificationProvider.notifications.reversed.toList();
      // Optionally, sort by createdAt if needed
      notifications.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    });
  }

  @override
  void dispose() {
    notificationProvider.removeListener(_onNotificationsChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            "Notificaciones",
            style: StylesApp(context)
                .textStyleBody5
                .copyWith(color: StyleColor.black, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: notifications.isEmpty
                ? Center(
                    child: Text(
                      "No tienes notificaciones.",
                      style: StylesApp(context)
                          .textStyleBody7
                          .copyWith(color: StyleColor.black),
                    ),
                  )
                : ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => SizedBox(
                      height: 20.0,
                    ),
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: notification.isRead
                                  ? Colors.white
                                  : Colors.blueGrey[100],
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: StyleColor.black.withAlpha(90),
                                  offset: Offset(0, 4),
                                  spreadRadius: 4.0,
                                  blurRadius: 4.0,
                                )
                              ],
                            ),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              leading: Icon(
                                Icons.notifications,
                                color: notification.isRead
                                    ? StyleColor.grayMedium
                                    : StyleColor.turquoise,
                              ),
                              title: Text(
                                notification.title,
                                style:
                                    StylesApp(context).textStyleBody14.copyWith(
                                          color: notification.isRead
                                              ? StyleColor.grayMedium
                                              : StyleColor.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16.0, right: 8.0, bottom: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        notification.message,
                                        style: StylesApp(context)
                                            .textStyleBody10
                                            .copyWith(
                                              color: notification.isRead
                                                  ? StyleColor.grayMedium
                                                  : StyleColor.black,
                                              fontWeight: notification.isRead
                                                  ? FontWeight.normal
                                                  : FontWeight.bold,
                                            ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        formatDateTime(notification.createdAt),
                                        style: StylesApp(context)
                                            .textStyleBody10
                                            .copyWith(
                                                color: notification.isRead
                                                    ? StyleColor.grayMedium
                                                    : StyleColor.black),
                                      ),
                                      if (notification.actionLabel != null &&
                                          notification.actionLabel.isNotEmpty)
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: TextButton(
                                            onPressed: () async {
                                              // if (notification.action
                                              //     .contains('course')) {
                                              //   final progress = await _loadProgress(context);
                                              //   if (progress == null) return;
                                              //   // if (progressUser != null && card['label'] == 'Aventura') {
                                              //   Navigator.pushNamed(context,
                                              //       '/mapPage', arguments: {
                                              //     'courseId':
                                              //         progressUser!.courseId,
                                              //     'sectionId':
                                              //         progressUser!.sectionId
                                              //   });
                                              //   // } else {
                                              //   //   Navigator.pushNamed(context, '/introAventurePage');
                                              //   // }
                                              // }
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor:
                                                  StyleColor.blueDark,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(notification.actionLabel),
                                                Icon(Icons.arrow_forward)
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _loadProgress(BuildContext context) async {
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context,
        listen:
            false); // listen: false para evitar reconstrucciones innecesarias
    final dataUser = userProvider.currentUser;
    final progressResponse =
        await userProvider.getProgressUser(dataUser?.userId, null);
    if (progressResponse!.error != null) {
      LoadingService().hideLoading();
      await showCustomDialog(
        context,
        message: progressResponse.error!,
        dialogType: DialogType.error,
      );
      return;
    }
    LoadingService().hideLoading();
    return progressResponse.data;
  }
}
