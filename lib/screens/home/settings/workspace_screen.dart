import 'dart:async';

import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/constants/app_constants.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/utils/route_observer.dart';
import 'package:biblia_palabra_de_vida_app/widgets/auto_scroll_text.dart';
import 'package:biblia_palabra_de_vida_app/widgets/notification_list_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:share_plus/share_plus.dart';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/config/graphql_config.dart';
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
  final AppTranslationProvider _translationProvider = AppTranslationProvider();
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
  String wavingHand = '👋';
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
          "${_translationProvider.tr('workspace.errors.load_notifications')}:  ${e.toString()}";
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
              Column(
                children: [
                  const SizedBox(height: 25.0),
                  _isTablet
                      ? _buildTabletCardSection(
                          context, cardList, _translationProvider)
                      : _buildPositionSection(
                          context, dataUser, _translationProvider),

                  const SizedBox(height: 12.0),

                  // Layout principal responsive
                  ResponsiveLayout(
                    mobile: _buildMobileLayout(context, _translationProvider),
                    tablet: _buildTabletLayout(context, _translationProvider),
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
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        dataUser != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: _buildMobileCardSection(
                    context, AppConstants.homeCards, translationProvider),
              )
            : Container(),
        const SizedBox(height: 12.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: _buildCalendarEvent(context, translationProvider),
        ),
        const SizedBox(height: 12.0),
        _buildProverbsSection(
            context, loadingDaily, errorDaily, dailyWord, translationProvider),
        _buildStoriesSection(context, reflection, translationProvider),
        const SizedBox(height: 12.0),
        _buildGridViewSection(context, translationProvider),
        const SizedBox(height: 12.0),
        if (ApiConfig.development)
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
                    if (ApiConfig.development)
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

// Función para construir el ícono de notificaciones con contador
  Widget _buildNotificationIcon(bool isTablet) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(
          Icons.notifications,
          size: isTablet ? 30 : 30,
          color: StyleColor.white,
        ),
        Positioned(
          right: 0,
          top: 0,
          child: _buildNotificationBadge(),
        ),
      ],
    );
  }

// Función para construir el badge del contador
  Widget _buildNotificationBadge() {
    final unreadCount = getUnreadCountNotification();
    final hasNotifications = int.parse(unreadCount) > 0;

    return hasNotifications
        ? Container(
            decoration: BoxDecoration(
                color: StyleColor.redDark,
                borderRadius: BorderRadius.circular(100)),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: Center(
              child: Text(
                hasNotifications ? unreadCount : '',
                style: StylesApp(context).textStyleBody10.copyWith(
                      // color: StyleColor.black,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : Container();
  }

// Función para construir el botón de notificaciones completo
  Widget _buildNotificationButton(bool isTablet) {
    return Visibility(
      visible: true,
      child: Container(
        width: 30,
        height: 30,
        // decoration: const BoxDecoration(
        //   color: Colors.transparent,
        // ),
        child: IconButton(
          padding: EdgeInsets.zero,
          iconSize: isTablet ? 35 : 35,
          onPressed: () => _showNotificationsModal(context),
          icon: _buildNotificationIcon(isTablet),
        ),
      ),
    );
  }

  // Cards superiores para móvil
  Widget _buildMobileCardSection(
      BuildContext context,
      List<Map<String, dynamic>> cards,
      AppTranslationProvider translationProvider) {
    List<List<Color>> listGradients = [
      [Color(0xFF2AC8F4), Color(0xFF12CBC4)],
      [Color(0xFF3579F6), Color(0xFF3C0BFF)]
    ];
    return SingleChildScrollView(
      padding: EdgeInsets.all(0),
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 10.0,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: cards
            .where((card) =>
                (card['key'] != 'Comunidad' /*&& !ApiConfig.development*/))
            .map((
          card,
        ) {
          List<Color> gradientColors;
          switch (card['key']) {
            case 'Aventura':
              gradientColors = listGradients[0];
              break;
            case 'Biblia':
              gradientColors = listGradients[1];
              break;
            default:
              gradientColors = listGradients[0];
          }

          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              // image: DecorationImage(
              //     image: AssetImage('assets/background_player.jpg'),
              //     fit: BoxFit.cover,
              //     opacity: 0.25),
              gradient: LinearGradient(colors: gradientColors),
            ),
            constraints: BoxConstraints(
              maxWidth: 180,
            ),
            child: _buildCard(context, card, translationProvider),
          );
        }).toList(),
      ),
    );
  }

  // Cards superiores para tablet
  Widget _buildTabletCardSection(
      BuildContext context,
      List<Map<String, dynamic>> cards,
      AppTranslationProvider translationProvider) {
    final filteredCards = cards
        .where((card) => (card['key'] != 'Comunidad' && !ApiConfig.development))
        .toList();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: filteredCards.map((card) {
          List<List<Color>> listGradients = [
            [Color(0xFF2AC8F4), Color(0xFF12CBC4)],
            [Color(0xFF3579F6), Color(0xFF3C0BFF)]
          ];

          List<Color> gradientColors;
          switch (card['key']) {
            case 'Aventura':
              gradientColors = listGradients[0];
              break;
            case 'Biblia':
              gradientColors = listGradients[1];
              break;
            default:
              gradientColors = listGradients[0];
          }
          return Container(
              constraints: BoxConstraints(maxWidth: 300.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: LinearGradient(colors: gradientColors),
              ),
              child: _buildCard(context, card,
                  translationProvider) // _buildTabletCard(context, card, translationProvider)
              );
        }).toList(),
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> card,
      AppTranslationProvider translationProvider) {
    return GestureDetector(
      onTap: () => _onCardTap(context, card),
      child: Stack(children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  // decoration: BoxDecoration(
                  //   boxShadow: [
                  //     BoxShadow(
                  //       color: StyleColor.black.withValues(alpha: 0.2),
                  //       blurRadius: 5,
                  //       spreadRadius: 2,
                  //       offset: Offset(0, 4),
                  //     )
                  //   ],
                  // ),
                  clipBehavior: Clip.none,
                  child: Image.asset(
                    card['img']!,
                    height: 80,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  translationProvider.tr(card['label']!),
                  textAlign: TextAlign.center,
                  style: StylesApp(context).textStyleBody4.copyWith(
                        color: StyleColor.white,
                      ),
                ),
                AutoScrollText(
                  translationProvider.tr(card['subTitle']!),
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: StyleColor.white,
                      ),
                  maxWidth: 150, // Ajusta según el tamaño de tu card
                  scrollDuration: Duration(seconds: 3),
                  pauseDuration: Duration(seconds: 1),
                )
              ],
            ),
          ),
        ),
        Positioned(
            bottom: 10,
            right: 5,
            child: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    color: StyleColor.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(50)),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 20.0,
                )))
      ]),
    );
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            spacing: 5.0,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      color: StyleColor.blueLight,
                      border: Border.all(
                        width: 2.0,
                        color: StyleColor.white,
                      ),
                      borderRadius: BorderRadius.circular(40)),
                  child: Icon(
                    Icons.menu_book_sharp,
                    size: 30,
                    color: StyleColor.white,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          translationProvider
                              .tr('workspace.sections.stories_to_reflect'),
                          style: StylesApp(context)
                              .textStyleBody5
                              .copyWith(color: const Color(0xFFFE8D43)),
                        ),
                        SizedBox(
                          width: 25,
                          height: 20,
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            onPressed: () => handleTapShowStories(),
                            icon: Icon(
                              Icons.add_circle_outline_sharp,
                              color: StyleColor.orange,
                              size: 20,
                            ),
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
                            ? "${GraphQLConfig.endpoint}${reflection.url}"
                            : ''),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildGridViewSection(
      BuildContext context, AppTranslationProvider translationProvider) {
    return Wrap(
      spacing: 10.0,
      children: [
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
        ),
        Padding(
          padding: const EdgeInsets.only(right: 4.0, bottom: 15.0),
          child: GestureDetector(
            onTap: () async {
              handleNavigateTo();
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
      ],
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
        image: DecorationImage(
            image: AssetImage('assets/background_player.jpg'),
            fit: BoxFit.cover,
            opacity: 0.25),
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
                                          " ${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}\n ${dailyWord.verse!.text}.\n ${GraphQLConfig.endpoint}OfficialBible"));
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
                                      "${dailyWord.book!.modernName} ${dailyWord.chapter!.chapter}:${dailyWord.verse!.verse}\n ${dailyWord.verse!.text}.\n ${GraphQLConfig.endpoint}OfficialBible",
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
    double sizeAvatar =
        getSizeFire(dataUser != null ? dataUser!.energyPoints : 150);
    return Container(
      decoration: BoxDecoration(
        // image: DecorationImage(
        //     image: AssetImage('assets/background_player.jpg'),
        //     fit: BoxFit.cover,
        //     opacity: 0.25),
        color: StyleColor.turquoise,
        // gradient: LinearGradient(colors: [
        //   StyleColor.white,
        //   StyleColor.blueLight,
        //   StyleColor.blue,
        // ], begin: Alignment.topRight, end: Alignment.topLeft),
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
                    children: [
                      Expanded(
                        child: Row(
                          spacing: 12.0,
                          children: [
                            SizedBox(
                              width: 80.0,
                              height: 80.0,
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2.0, color: StyleColor.white),
                                    borderRadius: BorderRadius.circular(80.0)),
                                child: ClipOval(
                                  child: (userData != null &&
                                          userData!.imgProfileUser != null)
                                      ? CachedNetworkImage(
                                          fit: BoxFit.cover,
                                          alignment: Alignment.topCenter,
                                          imageUrl: ApiConfig.baseUrl +
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
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${translationProvider.trParams("workspace.hello", {
                                        "name": getCapitalizedFirstName(
                                            userData.name)
                                      })} $wavingHand",
                                  style: StylesApp(context)
                                      .textStyleBody20
                                      .copyWith(color: StyleColor.white),
                                  // .copyWith(fontSize: 22),
                                ),
                                Text(
                                  translationProvider
                                      .tr("workspace.great_work"),
                                  style: StylesApp(context).textStyleBody12,
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        color: StyleColor.white,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Row(
                      spacing: 6.0,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          // flex: 1,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  spacing: 5,
                                  children: [
                                    Icon(
                                      Icons.calendar_month_outlined,
                                      color: StyleColor.blueMedium,
                                      size: 16,
                                    ),
                                    Expanded(
                                      child: Text("Constancia",
                                          style: StylesApp(context)
                                              .textStyleBody14
                                              .copyWith(
                                                  color: StyleColor.black),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                                Center(
                                  child: Text(
                                    softWrap: true,
                                    maxLines: 2,
                                    "${dataUser != null ? dataUser!.streakDaysCount.toString() : ''} Días",
                                    style: StylesApp(context)
                                        .textStyleBody6
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                              ]),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 2.0, right: 2.0),
                          width: 0.5,
                          height: 30,
                          decoration: BoxDecoration(
                            color: StyleColor.black,
                          ),
                        ),
                        Expanded(
                          // flex: 1,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/layoutPage1',
                                  arguments: {'selectedIndex': 2});
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.stars_rounded,
                                        color: StyleColor.yellowLight,
                                        size: 16,
                                      ),
                                      Expanded(
                                        child: Text("Nivel",
                                            style: StylesApp(context)
                                                .textStyleBody14
                                                .copyWith(
                                                    color: StyleColor.black),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                    ],
                                  ),
                                  Center(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      "${userData?.league != null ? userData.league.leagueName : translationProvider.tr('workspace.user_profile.welcome_herd')}",
                                      style: userData?.league != null
                                          ? StylesApp(context)
                                              .textStyleBody6
                                              .copyWith(color: Colors.black)
                                          : StylesApp(context)
                                              .textStyleBody10
                                              .copyWith(
                                                  color: Colors.black,
                                                  fontSize: 14.0),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                        Container(
                          width: 0.5,
                          height: 30,
                          decoration: BoxDecoration(
                            color: StyleColor.black,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: sizeAvatar,
                                      child: Image.asset(
                                        'assets/go-aventure.gif',
                                        alignment: Alignment.center,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: Text("Monedas",
                                    //       style: StylesApp(context)
                                    //           .textStyleBody14
                                    //           .copyWith(color: StyleColor.black),
                                    //       maxLines: 1,
                                    //       overflow: TextOverflow.ellipsis),
                                    // ),
                                  ],
                                ),
                              ),
                              Center(
                                child: Text(
                                  translationProvider
                                      .tr(
                                          'workspace.user_profile.energy_points')
                                      .replaceFirst('%s',
                                          userData.energyPoints.toString()),
                                  style: StylesApp(context)
                                      .textStyleBody6
                                      .copyWith(color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: StyleColor.white,
                        borderRadius: BorderRadius.circular(12.0)),
                    child: Row(
                      spacing: 5.0,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.stars,
                                color: StyleColor.yellowLight,
                              ),
                              Text(
                                "Objetivo Semanal",
                                style: StylesApp(context)
                                    .textStyleBody12
                                    .copyWith(color: StyleColor.black),
                              ),
                            ],
                          ),
                        ),
                        // Si estás mostrando progreso de una tarea
                        Expanded(
                          flex: 1,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(8),
                            minHeight: 15.0,
                            color: StyleColor.redDark,
                            backgroundColor:
                                StyleColor.grayDark.withValues(alpha: 0.3),
                            value: (dataUser?.streakDaysCount ?? 0) /
                                7, // Variable que cambia
                            valueColor: AlwaysStoppedAnimation<Color>(
                                StyleColor.turquoise),
                          ),
                        ),
                        Text("${dataUser?.streakDaysCount} / 7"),
                        Text(
                          "¡Sigue Así!",
                          style: StylesApp(context)
                              .textStyleBody12
                              .copyWith(color: StyleColor.black),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(width: 2.0)
                    // ),
                    width: 40.0.sp,
                    height: 30.0.sp,
                    child: _buildNotificationButton(isTablet(context))),
              ),
              Positioned(
                top: 50,
                right: 0,
                child: Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(width: 2.0)
                  // ),
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

  Future<void> _markNotificationsAsViewed() async {
    try {
      // Llamar a la mutation
      final response = await markAsViewNotification();

      if (response.error != null) {
        if (kDebugMode) {
          print(
              '❌ Error al marcar notificaciones como vistas: ${response.error}');
        }
        return;
      }
      // Forzar actualización del contador
      _updateUnreadCount();
      setState(() {});

      if (kDebugMode) {
        print('✅ Notificaciones marcadas como vistas exitosamente');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Excepción al marcar notificaciones como vistas: $e');
      }
    }
  }

  void _showNotificationsModal(BuildContext context) {
    _markNotificationsAsViewed();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return const NotificationListWidget();
      },
    );
  }

  double getSizeFire(int energyPoints) {
    if (energyPoints > 500) {
      return isTablet(context) ? 60 : 50;
    } else if (energyPoints > 250) {
      return isTablet(context) ? 50 : 40;
    } else {
      return isTablet(context) ? 40 : 30;
    }
  }

  void handleNavigateTo() async {
    await _loadProgress(context);
    if (error) return;

    if (progressUser != null && progressUser!.success == true) {
      if (progressUser!.message.contains('El curso ya fue finalizado')) {
        await showCustomDialogWithAction(
          context,
          message: progressUser!.message,
          dialogType: DialogTypeAction.info,
          buttonOk:
              _translationProvider.tr('workspace.dialogs.see_more_courses'),
          textButton: _translationProvider.tr('workspace.dialogs.go_to_course'),
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
            Navigator.pushNamed(currentContext, '/mapPage', arguments: {
              'courseId': progressUser!.data?.courseId,
              'sectionId': progressUser!.data?.sectionId
            });
          }
        }
      }
    } else {
      Navigator.pushNamed(context, '/introAventurePage');
    }
  }

  void handleTapShowStories() async {
    LoadingService().showLoading(context);
    final limit = 12;
    final page = 1;
    final responseReflection = await getAllReflections(page, limit, '');
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
        return ModalTalesWidget(data: buttonsData, pagination: paginate);
      },
    );
  }

  _buildCalendarEvent(
      BuildContext context, AppTranslationProvider translationProvider) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color: Colors.transparent,
      semanticContainer: false,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [StyleColor.turquoise, StyleColor.blueLight]),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_outlined,
                            size: 80,
                            color: StyleColor.white,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Calendario de Eventos",
                                style: StylesApp(context)
                                    .textStyleBody16
                                    .copyWith(color: StyleColor.black),
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text:
                                            "ver actividades de las\n iglesias "),
                                    TextSpan(
                                        text: "Palabra de Vida",
                                        style: StylesApp(context)
                                            .textStyleBody14
                                            .copyWith(
                                                color: StyleColor.orange)),
                                  ],
                                  style: StylesApp(context)
                                      .textStyleBody14
                                      .copyWith(
                                        color: StyleColor.black,
                                      ),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.all(0),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(StyleColor.turquoise),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/eventCalendarPage");
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: StyleColor.white,
                    ),
                  )
                  // Container(
                  //   padding: EdgeInsets.all(8.0),
                  //   decoration: BoxDecoration(
                  //       color: StyleColor.turquoise, shape: BoxShape.circle),
                  //   child:
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
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
