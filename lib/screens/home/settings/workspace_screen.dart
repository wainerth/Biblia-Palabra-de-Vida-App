import 'dart:async';

import 'package:biblia_palabra_de_vida_app/constants/app_constants.dart';
import 'package:biblia_palabra_de_vida_app/utils/route_observer.dart';
import 'package:biblia_palabra_de_vida_app/widgets/notification_list_widget.dart';
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

class _WorkspaceScreenState extends State<WorkspaceScreen>
    with SafeStateMixin, RouteAware {
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
  int _unreadCount = 0;
  dynamic Function(dynamic)? _notificationListener;
  late final SocketClientProvider _notificationProvider;

  @override
  void initState() {
    super.initState();

    //Obtener referencia al provider
    _notificationProvider =
        Provider.of<SocketClientProvider>(context, listen: false);

    // Agregar listener para cambios
    _notificationProvider.addListener(_onNotificationsChanged);

    // Calcular contador inicial
    _updateUnreadCount();

    _initializePage();
  }

  @override
  void didPop() {
    // Este método se llama cuando la pantalla actual vuelve a ser visible
    super.didPop();

    if (mounted) {
      _updateUnreadCount();
      setState(() {});
      if (kDebugMode) {
        print('🔄 WorkspaceScreen visible nuevamente - Actualizando contador');
      }
    }
  }

  @override
  void didPopNext() {
    // Este método se llama cuando otra pantalla se cierra y esta es la siguiente
    super.didPopNext();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        await loadAllNotifications();
        _updateUnreadCount();
        setState(() {});
        if (kDebugMode) {
          print('🔄 WorkspaceScreen volvió al frente - Actualizando contador');
        }
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Suscribirse al RouteObserver
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void dispose() {
    if (mounted) {
      if (_notificationListener != null) {
        _notificationProvider.removeListenerFromEvent(
            "notification", _notificationListener!);
      }
    }
    routeObserver.unsubscribe(this);
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

        if (_notificationListener != null) {
          notificationProvider.removeListenerFromEvent(
              "notification", _notificationListener!);
        }

        _notificationListener = (dynamic notify) {
          if (kDebugMode) {
            print("📨 Notificación recibida");
          }
          final newNotification = NotificationModel.fromJson(notify);
          // Verificar si ya existe antes de agregar
          final exists = notificationProvider.notifications
              .any((n) => n.id == newNotification.id);

          if (!exists) {
            notificationProvider.addNotification(newNotification);
            notificationProvider.showNotification(newNotification);
          } else {
            if (kDebugMode) {
              print(
                  "⏭️ Notificación duplicada ignorada: ${newNotification.id}");
            }
          }
        };

        notificationProvider.listenToEvent(
            "notification", _notificationListener!);
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
    final translationProvider = context.read<AppTranslationProvider>();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final useData = userProvider.currentUser;

    try {
      final responseNotification = await getAllNotification(
          1, 15, useData != null ? useData.userId : '');
      if (responseNotification.error != null) {
        if (mounted) {
          await showCustomDialog(context,
              message: responseNotification.error!,
              dialogType: DialogType.error);
        }
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
      String error =
          "${translationProvider.tr('workspace.errors.load_notifications')}:  ${e.toString()}";
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
    final translationProvider = context.read<AppTranslationProvider>();
    final userProvider = Provider.of<UserProvider>(context);
    final _isTablet = isTablet(context);
    dataUser = userProvider.currentUser;

    final cardList = AppConstants.homeCards;

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
                    width: _isTablet ? 70 : 35,
                    height: _isTablet ? 70 : 35,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: _isTablet ? 70 : 35,
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
                            size: _isTablet ? 60 : 40,
                            color: StyleColor.redLight,
                          ),
                          Positioned(
                            right: _isTablet ? 22 : 6,
                            top: _isTablet ? 18 : 12,
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
                  _isTablet
                      ? _buildTabletCardSection(
                          context, cardList, translationProvider)
                      : _buildMobileCardSection(
                          context, cardList, translationProvider),

                  const SizedBox(height: 12.0),

                  // Layout principal responsive
                  ResponsiveLayout(
                    mobile: _buildMobileLayout(context, translationProvider),
                    tablet: _buildTabletLayout(context, translationProvider),
                  ),

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
  Widget _buildMobileLayout(
      BuildContext context, AppTranslationProvider translationProvider) {
    return Column(
      children: [
        dataUser != null
            ? _buildPositionSection(context, dataUser, translationProvider)
            : Container(),
        const SizedBox(height: 12.0),
        _buildProverbsSection(
            context, loadingDaily, errorDaily, dailyWord, translationProvider),
        _buildStoriesSection(context, reflection, translationProvider),
        const SizedBox(height: 12.0),
        _buildGridViewSection(context, translationProvider),
        const SizedBox(height: 12.0),
        if (GraphQLConfig.development)
          _buildLibrarySection(context, translationProvider),
      ],
    );
  }

  // ============ LAYOUT PARA TABLET ============
  Widget _buildTabletLayout(
      BuildContext context, AppTranslationProvider translationProvider) {
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
                        ? _buildPositionSection(
                            context, dataUser, translationProvider)
                        : Container(),
                    const SizedBox(height: 16.0),
                    _buildProverbsSection(context, loadingDaily, errorDaily,
                        dailyWord, translationProvider),
                    const SizedBox(height: 16.0),
                    _buildStoriesSection(
                        context, reflection, translationProvider),
                  ],
                ),
              ),
              const SizedBox(width: 16.0),
              // Columna derecha: Grid de opciones y Librería
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildGridViewSection(context, translationProvider),
                    const SizedBox(height: 16.0),
                    if (GraphQLConfig.development)
                      _buildLibrarySection(context, translationProvider),
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
      BuildContext context,
      List<Map<String, dynamic>> cards,
      AppTranslationProvider translationProvider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: cards
            .where((card) =>
                (card['key'] != 'Comunidad' && !GraphQLConfig.development))
            .map((card) => _buildCard(context, card, translationProvider))
            .toList(),
      ),
    );
  }

  // Cards superiores para tablet
  Widget _buildTabletCardSection(
      BuildContext context,
      List<Map<String, dynamic>> cards,
      AppTranslationProvider translationProvider) {
    final filteredCards = cards
        .where((card) =>
            (card['key'] != 'Comunidad' && !GraphQLConfig.development))
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: filteredCards
            .map((card) => _buildTabletCard(context, card, translationProvider))
            .toList(),
      ),
    );
  }

  Widget _buildTabletCard(BuildContext context, Map<String, dynamic> card,
      AppTranslationProvider translationProvider) {
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
                translationProvider.tr(card['label']!),
                textAlign: TextAlign.center,
                style: StylesApp(context).textStyleBody4.copyWith(
                      color: const Color(0xFFFD8C43),
                      fontSize: 14.sp,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> card,
      AppTranslationProvider translationProvider) {
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
              translationProvider.tr(card['label']!),
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
      BuildContext context, Map<String, dynamic> card) async {
    final translationProvider = context.read<AppTranslationProvider>();

    await _loadProgress(context);
    if (card['key'] == 'Aventura') {
      if (error) return;
      if (progressUser != null && progressUser!.success == true) {
        if (progressUser!.message.contains('El curso ya fue finalizado')) {
          await showCustomDialogWithAction(
            context,
            message: progressUser!.message,
            dialogType: DialogTypeAction.info,
            buttonOk:
                translationProvider.tr('workspace.dialogs.see_more_courses'),
            textButton:
                translationProvider.tr('workspace.dialogs.go_to_course'),
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

  Widget _buildLibrarySection(
      BuildContext context, AppTranslationProvider translationProvider) {
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
              translationProvider.tr('workspace.sections.christian_library'),
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

  _buildStoriesSection(BuildContext context, reflection,
      AppTranslationProvider translationProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              translationProvider.tr('workspace.sections.stories_to_reflect'),
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
                size: 20,
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

  _buildGridViewSection(
      BuildContext context, AppTranslationProvider translationProvider) {
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
                    buttonOk: translationProvider
                        .tr('workspace.dialogs.see_more_courses'),
                    textButton: translationProvider
                        .tr('workspace.dialogs.go_to_course'),
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
                labelCard: translationProvider.tr('workspace.cards.adventure'),
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
                labelCard:
                    translationProvider.tr('workspace.sections.preachings'),
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
                labelCard: translationProvider.tr('workspace.sections.games'),
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
                labelCard:
                    translationProvider.tr('workspace.sections.promises'),
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

  _buildProverbsSection(
      BuildContext context,
      bool loadingDaily,
      bool errorDaily,
      DailyWord dailyWord,
      AppTranslationProvider translationProvider) {
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
                              width: 20,
                              height: 20,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  Icons.copy,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                      text:
                                          " ${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}\n ${dailyWord.verse!.text}.\n ${GraphQLConfig.urlServidor}OfficialBible"));
                                  showSnackBar(
                                      translationProvider.tr(
                                          'workspace.daily_proverb.copy_success'),
                                      type: SnackBarType.success);
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.share,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () async {
                                await SharePlus.instance.share(ShareParams(
                                  text:
                                      "${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}\n ${dailyWord.verse!.text}.\n ${GraphQLConfig.urlServidor}OfficialBible",
                                  subject: translationProvider.tr(
                                      'workspace.daily_proverb.share_subject'),
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
                                    "${dailyWord.verse!.text}",
                                    style: StylesApp(context)
                                        .textStyleBody5
                                        .copyWith(
                                          color: Colors.black,
                                          // fontSize: 10.sp,
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

  _buildPositionSection(BuildContext context, userData,
      AppTranslationProvider translationProvider) {
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
                                          fit: BoxFit.contain,
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
                                    "${userData?.league != null ? userData.league.leagueName : translationProvider.tr('workspace.user_profile.welcome_herd')}",
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
                              width: isTablet(context) ? 59 : 30,
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
                            translationProvider
                                .tr('workspace.user_profile.streak_days')
                                .replaceFirst(
                                    '%s', userData.streakDaysCount.toString()),
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
                            translationProvider
                                .tr('workspace.user_profile.energy_points')
                                .replaceFirst(
                                    '%s', userData.energyPoints.toString()),
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
                top: -10,
                child: SizedBox(
                  width: 40.0.sp,
                  height: 30.0.sp,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/profilePage');
                    },
                    icon: const Icon(
                      Icons.account_circle,
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
    return _unreadCount > 0 ? _unreadCount.toString() : '0';
  }

  void _onNotificationsChanged() {
    if (mounted) {
      // Actualizar el contador
      _updateUnreadCount();

      // Forzar rebuild del widget
      setState(() {});

      if (kDebugMode) {
        print('🔄 Notificaciones actualizadas - No leídas: $_unreadCount');
      }
    }
  }

  void _updateUnreadCount() {
    _unreadCount =
        _notificationProvider.notifications.where((n) => !n.isRead).length;
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
