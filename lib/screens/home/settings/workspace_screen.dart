import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:share_plus/share_plus.dart';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
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
  late final CatalogueProvider catalogueProvider;
  PaginationInfo? paginate;
  ResponseProgress? progressUser;
  bool error = false;
  bool errorDaily = false;
  bool loadingDaily = false;
  Reflection? reflection;
  DailyWord dailyWord = DailyWord(
      book: Book(modernName: ""),
      chapter: Chapter(chapter: 0),
      verse: Verse(verse: 0, text: ""));
  bool _initCompleted = false;

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _initializePage() async {
    if (_initCompleted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (_initCompleted || !mounted) return;

      if (Provider.of<UserProvider>(context, listen: false).getDailyProverb !=
          null) {
        setState(() {
          dailyWord = Provider.of<UserProvider>(context, listen: false)
              .getDailyProverb!;
        });
      } else {
        await getDailyProverb();
      }

      if (mounted) {
        final notificationProvider =
            Provider.of<SocketClientProvider>(context, listen: false);
        await loadAllNotifications();

        notificationProvider.listenToEvent("notification", (notify) {
          if (kDebugMode) {
            print(notify);
          }
          final newNotification = NotificationModel.fromJson(notify);
          notificationProvider.addNotification(newNotification);
          notificationProvider.showNotification(newNotification);
        });
      }

      if (mounted) {
        await loadGetOneReflection();
        _initCompleted = true;
      }
    });
  }

  Future loadAllNotifications() async {
    List<NotificationModel> notifies = [];
    Provider.of<SocketClientProvider>(context, listen: false)
        .cleanNotification();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final useData = userProvider.currentUser;

    try {
      final responseNotification = await getAllNotification(
          1, 15, useData != null ? useData.userId : '');
      if (responseNotification.error != null) {
        await showCustomDialog(context,
            message: responseNotification.error!, dialogType: DialogType.error);
        return;
      }
      setState(() {
        notifies = responseNotification.data['data']
            .map<NotificationModel>(
                (notify) => NotificationModel.fromJson(notify))
            .toList();

        if (notifies.isNotEmpty) {
          Provider.of<SocketClientProvider>(context, listen: false)
              .addAllNotification(notifies);
        }
      });
    } catch (e) {
      String error = "Error al leer las notificaciones:  ${e.toString()}";
      if (mounted) {
        await showCustomDialog(context,
            message: error, dialogType: DialogType.error);
      }
    }
  }

  Future<void> _loadProgress(BuildContext context) async {
    setState(() {
      error = false;
    });
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    dataUser = userProvider.currentUser;
    final progressResponse =
        await userProvider.getProgressUser(dataUser!.userId, null);
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
    setState(() {});
  }

  List<ButtonData> buttonsData = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;
    final userProvider = Provider.of<UserProvider>(context);
    dataUser = userProvider.currentUser;

    final cardList = [
      {
        'label': 'Aventura',
        'img': 'assets/aventure.gif',
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
        width: double.infinity,
        child: SingleChildScrollView(
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Visibility(
                  visible: true,
                  child: Container(
                    width: isTablet ? 70 : 35,
                    height: isTablet ? 70 : 35,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: isTablet ? 70 :  35,
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (BuildContext context) {
                            return const NotificationListWidget();
                          },
                        );
                      },
                      icon: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(
                            Icons.notifications,
                            size: isTablet ? 60 : 40,
                            color: StyleColor.redLight,
                          ),
                          Positioned(
                            right: isTablet ? 22 : 6,
                            top: isTablet ? 18 : 12,
                            child: Container(
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(
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
                  const SizedBox(height: 15.0),
                  // Sección de cards superiores - Responsive
                  isTablet
                      ? _buildTabletCardSection(context, cardList)
                      : _buildMobileCardSection(context, cardList),

                  const SizedBox(height: 12.0),

                  // Layout principal responsive
                  isTablet
                      ? _buildTabletLayout(context)
                      : _buildMobileLayout(context),

                  SizedBox(height: kBottomNavigationBarHeight - 40),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============ LAYOUT PARA MÓVIL ============
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        dataUser != null
            ? _buildPositionSection(context, dataUser)
            : Container(),
        const SizedBox(height: 12.0),
        _buildProverbsSection(context, loadingDaily, errorDaily, dailyWord),
        _buildStoriesSection(context, reflection),
        const SizedBox(height: 12.0),
        _buildGridViewSection(context),
        const SizedBox(height: 12.0),
        if (GraphQLConfig.development) _buildLibrarySection(context),
      ],
    );
  }

  // ============ LAYOUT PARA TABLET ============
  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          // Primera fila: Perfil y Proverbio
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Columna izquierda: Perfil, Proverbio y Cuentos
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    dataUser != null
                        ? _buildPositionSection(context, dataUser)
                        : Container(),
                    const SizedBox(height: 16.0),
                    _buildProverbsSection(
                        context, loadingDaily, errorDaily, dailyWord),
                    const SizedBox(height: 16.0),
                    _buildStoriesSection(context, reflection),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              // Columna derecha: Grid de opciones y Librería
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildGridViewSection(context),
                    const SizedBox(height: 16.0),
                    if (GraphQLConfig.development)
                      _buildLibrarySection(context),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  // ============ COMPONENTES REUTILIZABLES ============

  // Cards superiores para móvil
  Widget _buildMobileCardSection(
      BuildContext context, List<Map<String, String>> cards) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards
            .where((card) =>
                !(card['label'] == 'Comunidad' && !GraphQLConfig.development))
            .map((card) => _buildCard(context, card))
            .toList(),
      ),
    );
  }

  // Cards superiores para tablet
  Widget _buildTabletCardSection(
      BuildContext context, List<Map<String, String>> cards) {
    final filteredCards = cards
        .where((card) =>
            !(card['label'] == 'Comunidad' && !GraphQLConfig.development))
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: filteredCards
            .map((card) => _buildTabletCard(context, card))
            .toList(),
      ),
    );
  }

  Widget _buildTabletCard(BuildContext context, Map<String, String> card) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: GestureDetector(
          onTap: () => _onCardTap(context, card),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(60),
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
                      fontSize: 16.sp,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, String> card) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GestureDetector(
        onTap: () => _onCardTap(context, card),
        child: Column(
          children: [
            Container(
              width: StylesApp(context).sizeContainerCard.width,
              height: StylesApp(context).sizeContainerCard.height,
              clipBehavior: Clip.none,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    StylesApp(context).sizeContainerCard.width),
                image: DecorationImage(
                  alignment: Alignment.center,
                  image: AssetImage(card['img']!),
                  fit: BoxFit.fitHeight,
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

  Future<void> _onCardTap(
      BuildContext context, Map<String, String> card) async {
    await _loadProgress(context);
    if (card['label'] == 'Aventura') {
      if (error) return;
      if (progressUser != null && progressUser!.success == true) {
        if (progressUser!.message.contains('El curso ya fue finalizado')) {
          await showCustomDialogWithAction(
            context,
            message: progressUser!.message,
            dialogType: DialogTypeAction.info,
            buttonOk: "Ver más cursos",
            textButton: "ir Al curso",
            showAction: true,
            actionCallbackOk: () {
              Navigator.pushNamed(context, '/layoutPage1',
                  arguments: {'selectedIndex': 1});
            },
            actionCallback: () {
              Navigator.pushNamed(context, '/mapPage', arguments: {
                'courseId': progressUser!.data?.courseId,
                'sectionId': progressUser?.data?.sectionId
              });
            },
          );
          return;
        } else {
          Navigator.pushNamed(context, '/mapPage', arguments: {
            'courseId': progressUser!.data?.courseId,
            'sectionId': progressUser!.data?.sectionId
          });
        }
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
  }

  Widget _buildLibrarySection(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/layoutLibrary');
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 16.0),
        decoration: BoxDecoration(
          color: const Color(0XFF5C9EDB),
          borderRadius: BorderRadius.circular(12.0),
        ),
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
    );
  }

  // ============ MANTENER EL RESTO DE LOS MÉTODOS EXISTENTES ============

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
                  .copyWith(color: const Color(0xFFFE8D43)),
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

              if (progressUser != null && progressUser!.success == true) {
                if (progressUser!.message
                    .contains('El curso ya fue finalizado')) {
                  await showCustomDialogWithAction(
                    context,
                    message: progressUser!.message,
                    dialogType: DialogTypeAction.info,
                    buttonOk: "Ver más cursos",
                    textButton: "ir Al curso",
                    showAction: true,
                    actionCallbackOk: () {
                      Navigator.pushNamed(context, '/layoutPage1',
                          arguments: {'selectedIndex': 1});
                    },
                    actionCallback: () {
                      Navigator.pushNamed(context, '/mapPage', arguments: {
                        'courseId': progressUser?.data?.courseId,
                        'sectionId': progressUser?.data?.sectionId
                      });
                    },
                  );
                  return;
                } else {
                  if (mounted) {
                    final currentContext = context;

                    if (currentContext.mounted) {
                      Navigator.pushNamed(currentContext, '/mapPage',
                          arguments: {
                            'courseId': progressUser!.data?.courseId,
                            'sectionId': progressUser!.data?.sectionId
                          });
                    }
                  }
                }
              } else {
                Navigator.pushNamed(context, '/introAventurePage');
              }
            },
            child: CardOptionWidget(
                imageBackground: "assets/ranking.png",
                labelCard: "Aventura",
                gradientColors: [
                  const Color(0XFFA731EC),
                  const Color(0XFF620188)
                ]),
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
                  const Color(0XFF1FEFEC),
                  const Color(0XFF0159A7),
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
                gradientColors: [
                  const Color(0XFF3531F3),
                  const Color(0XFF040681)
                ]),
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
                  const Color(0XFF58AC5F),
                  const Color(0XFF2F6624),
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
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, "/layoutPage",
                                      arguments: {
                                        'selectedIndex': 1,
                                        'bibleId': dailyWord.book!.bibleId,
                                        'bookId': dailyWord.book!.id,
                                        'chapterId': dailyWord.chapter!.id,
                                        'verseId': dailyWord.verse!.id,
                                      });
                                },
                                child: Row(
                                  spacing: 10,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 180),
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
                                ),
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
                                padding: EdgeInsets.zero,
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
                                    const SnackBar(
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
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 16.sp,
                              ),
                              onPressed: () async {
                                await SharePlus.instance.share(ShareParams(
                                  text:
                                      "${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}\n ${dailyWord.verse!.text}.\n ${GraphQLConfig.urlServidor}OfficialBible",
                                  subject: "Proverbio del día",
                                ));
                              },
                            ),
                          ),
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
                      ? const BoxConstraints(minHeight: 96.0, maxHeight: 100.0)
                      : const BoxConstraints(),
                  width: double.infinity,
                  child: loadingDaily
                      ? const Center(child: CircularProgressIndicator())
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
                                          fontSize: 10.sp,
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
                                height: StylesApp(context)
                                    .sizeContainerAvatar
                                    .height,
                                width: StylesApp(context)
                                    .sizeContainerAvatar
                                    .width,
                                child: ClipOval(
                                  child: (userData != null &&
                                          userData!.imgProfileUser != null)
                                      ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          imageUrl: GraphQLConfig.urlServidor +
                                              userData.imgProfileUser.urlImg +
                                              '?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'assets/no-image.jpg'),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                  'assets/no-image.jpg'),
                                        )
                                      : Image.asset(
                                          'assets/no-image.jpg',
                                          fit: BoxFit.cover,
                                          alignment: Alignment.center,
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
                                    "${userData?.league != null ? userData.league.leagueName : 'El rebaño te espera!'}",
                                    style: userData?.league != null
                                        ? StylesApp(context)
                                            .textStyleBody6
                                            .copyWith(color: Colors.white)
                                        : StylesApp(context)
                                            .textStyleBody10
                                            .copyWith(
                                                color: Colors.white,
                                                fontSize: 14.0),
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
                                  StylesApp(context).sizeContainerAvatar.width -
                                      10,
                              child: Image.asset(
                                'assets/kawaii_fire.png',
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                : '',
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
                    icon: const Icon(
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

class _NotificationListWidgetState extends State<NotificationListWidget>
    with SingleTickerProviderStateMixin {
  List<NotificationModel> notifications = [];
  late SocketClientProvider notificationProvider;
  late TabController _tabController; // ✅ NUEVO: Controlador para los tabs

  @override
  void initState() {
    super.initState();
    notificationProvider =
        Provider.of<SocketClientProvider>(context, listen: false);
    notifications = notificationProvider.notifications;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0, // ← Fuerza el tab inicial
    );
    // Listen for changes in notifications
    notificationProvider.addListener(_onNotificationsChanged);
  }

  void _onNotificationsChanged() {
    final newNotifications = [...notificationProvider.notifications];
    setState(() {
      notifications = newNotifications;
    });
  }

  @override
  void dispose() {
    notificationProvider.removeListener(_onNotificationsChanged);
    _tabController.dispose();
    super.dispose();
  }

  List<NotificationModel> get unreadNotifications {
    return notifications.where((n) => n.isRead == false).toList();
  }

  List<NotificationModel> get readNotifications {
    return notifications.where((n) => n.isRead == true).toList();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Notificaciones",
                style: StylesApp(context).textStyleBody5.copyWith(
                    color: StyleColor.black, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // cerramos la modal

                  Navigator.pushNamed(context, '/notificationPage');
                },
                child: Text("Ver Todas...",
                    style: StylesApp(context)
                        .textStyleBody14
                        .copyWith(color: StyleColor.turquoise)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                color: StyleColor.orange,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: StyleColor.black,
              // unselectedLabelStyle: TextStyle(backgroundColor: Colors.blueGrey[200]),

              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("No leídas"),
                      if (unreadNotifications.isNotEmpty) ...[
                        SizedBox(width: 4),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            unreadNotifications.length.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Tab(text: "Leídas"),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(unreadNotifications),
                _buildNotificationsList(readNotifications),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<NotificationModel> notificationsToShow) {
    return notificationsToShow.isEmpty
        ? Center(
            child: Text(
              _tabController.index == 0
                  ? "No tienes notificaciones no leídas."
                  : "No tienes notificaciones leídas.",
              style: StylesApp(context)
                  .textStyleBody7
                  .copyWith(color: StyleColor.black),
            ),
          )
        : ListView.separated(
            itemCount: notificationsToShow.length,
            separatorBuilder: (_, __) => SizedBox(height: 20.0),
            itemBuilder: (context, index) {
              final notification = notificationsToShow[index];
              return _buildNotificationItem(notification);
            },
          );
  }

  Widget _buildNotificationItem(NotificationModel notification) {
    return Container(
      decoration: BoxDecoration(
        color: notification.isRead ? Colors.white : Colors.blueGrey[100],
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
        tilePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
          style: StylesApp(context).textStyleBody14.copyWith(
                color: notification.isRead
                    ? StyleColor.grayMedium
                    : StyleColor.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.message,
                  style: StylesApp(context).textStyleBody10.copyWith(
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
                  style: StylesApp(context).textStyleBody10.copyWith(
                      color: notification.isRead
                          ? StyleColor.grayMedium
                          : StyleColor.black),
                ),
                if (notification.actionLabel.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        final responseMarkReadNotification =
                            await markAsReadOneNotification(notification.id!);

                        if (responseMarkReadNotification.error != null) {
                          await showCustomDialogWithAction(
                            context,
                            dialogType: DialogTypeAction.error,
                            message: responseMarkReadNotification.error!,
                            actionCallback: () {
                              Navigator.pop(context);
                            },
                            buttonOk: "Ok",
                          );
                          return;
                        } else {
                          if (responseMarkReadNotification.data != null) {
                            if (!responseMarkReadNotification.data['success']) {
                              await showCustomDialog(
                                context,
                                dialogType: DialogType.error,
                                message: responseMarkReadNotification
                                    .data['message'],
                              );
                              return;
                            }
                          }
                        }

                        if (getRouterScreen(notification.model.toLowerCase(),
                                    notification.variables)
                                .arguments !=
                            null) {
                          Navigator.pushNamed(
                              context,
                              getRouterScreen(notification.model.toLowerCase(),
                                      notification.variables)
                                  .routeName,
                              arguments: getRouterScreen(notification.model.toLowerCase(),
                                      notification.variables)
                                  .arguments);
                        } else {
                          Navigator.pushNamed(
                              context,
                              getRouterScreen(notification.model.toLowerCase(), null)
                                  .routeName);
                        }
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: StyleColor.blueDark,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
    );
  }
}
