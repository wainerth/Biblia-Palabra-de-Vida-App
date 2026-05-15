import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/utils/route_observer.dart';
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

class NewDashboard extends StatefulWidget {
  const NewDashboard({super.key});

  @override
  State<NewDashboard> createState() => _NewDashboardState();
}

class _NewDashboardState extends State<NewDashboard>
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

    _notificationProvider =
        Provider.of<SocketClientProvider>(context, listen: false);

    _notificationProvider.addListener(_onNotificationsChanged);
    _updateUnreadCount();
    _initializePage();
  }

  @override
  void didPop() {
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

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();
    final userProvider = Provider.of<UserProvider>(context);
    final _isTablet = isTablet(context);
    dataUser = userProvider.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12.h),
                // Header con saludo
                Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                      // image: DecorationImage(
                      //   image: AssetImage(
                      //     'assets/background_player.jpg',
                      //   ),
                      //   colorFilter: ColorFilter.mode( StyleColor.withValues(alpha: 0.50), BlendMode.color),
                      //   fit: BoxFit.cover,
                      // ),
                      color: StyleColor.blueHigh.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: [
                      _buildGreetingHeader(translationProvider),
                      SizedBox(height: 20.h),
                      _buildMainActionButtons(translationProvider),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Tarjeta de estado del usuario
                // dataUser != null
                //     ? _buildStatusCard(dataUser!, translationProvider)
                //     : const SizedBox.shrink(),
                // SizedBox(height: 24.h),
                // Botones principales Aventura y La Biblia

                SizedBox(height: 24.h),
                // Versículo del día
                _buildProverbsSection(context, loadingDaily, errorDaily,
                    dailyWord, translationProvider),
                SizedBox(height: 20.h),
                // Cuentos para reflexionar
                _buildStoriesSection(context, reflection, translationProvider),
                SizedBox(height: 20.h),
                // Grid de opciones (Predicas, Juegos, Promesas)
                _buildGridViewSection(context, translationProvider),
                const SizedBox(height: 12.0),
                // if (GraphQLConfig.development)
                //   _buildLibrarySection(context, translationProvider),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============ NUEVOS COMPONENTES SEGÚN DISEÑO ============
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

  _buildGridViewSection(
      BuildContext context, AppTranslationProvider translationProvider) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 8.0,
      mainAxisSpacing: 15.0,
      childAspectRatio: 1.95,
      children: [
        // Aventura
        GestureDetector(
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
                  textButton:
                      translationProvider.tr('workspace.dialogs.go_to_course'),
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
          },
          child: CardOptionWidget(
            imageBackground: "assets/ranking.png",
            labelCard: translationProvider.tr('workspace.cards.adventure'),
            gradientColors: [
              const Color(0XFFA731EC),
              const Color(0XFF620188),
            ],
          ),
        ),
        // Predicas
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/preachPage'),
          child: CardOptionWidget(
            imageBackground: "assets/predicas.png",
            labelCard: translationProvider.tr('workspace.sections.preachings'),
            gradientColors: [
              const Color(0XFF1FEFEC),
              const Color(0XFF0159A7),
            ],
          ),
        ),
        // Juegos
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/playPage'),
          child: CardOptionWidget(
            imageBackground: "assets/games.png",
            labelCard: translationProvider.tr('workspace.sections.games'),
            gradientColors: [
              const Color(0XFF3531F3),
              const Color(0XFF040681),
            ],
          ),
        ),
        // Promesas
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/promisePage'),
          child: CardOptionWidget(
            imageBackground: "assets/promesas.png",
            labelCard: translationProvider.tr('workspace.sections.promises'),
            gradientColors: [
              const Color(0XFF58AC5F),
              const Color(0XFF2F6624),
            ],
          ),
        ),
      ],
    );
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

  Widget _buildGreetingHeader(AppTranslationProvider translationProvider) {
    final userProvider = Provider.of<UserProvider>(context);
    final userData = userProvider.currentUser!;
    final userName = userProvider.currentUser?.name.split(' ')[0] ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: ClipOval(
                      child:
                          (userData != null && userData!.imgProfileUser != null)
                              ? CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  alignment: Alignment.topCenter,
                                  imageUrl: GraphQLConfig.urlServidor +
                                      userData.imgProfileUser!.urlImg +
                                      '?timestamp=${DateTime.now().millisecondsSinceEpoch}',
                                  placeholder: (context, url) =>
                                      Image.asset('assets/no-image.jpg'),
                                  errorWidget: (context, url, error) =>
                                      Image.asset('assets/no-image.jpg'),
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
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  Text(
                    'Hola, $userName',
                    style: StylesApp(context).textStyleTitle.copyWith(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF333333),
                        ),
                  ),
                  Text(
                    'Dios te acompaña hoy',
                    style: StylesApp(context).textStyleBody4.copyWith(
                          fontSize: 14.sp,
                          color: const Color(0xFF888888),
                        ),
                  ),
                ],
              ),
            ),

            // Container(
            //   child: ,
            // )
          ],
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  Widget _buildStatusCard(
      LoginUser user, AppTranslationProvider translationProvider) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF12CBC4), Color(0xFF0D9E98)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF12CBC4).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatusItem(
            icon: Icons.local_fire_department,
            label: translationProvider
                .tr('workspace.user_profile.streak_days')
                .replaceFirst('%s', ''),
            value:
                '${user.streakDaysCount} ${translationProvider.tr('workspace.user_profile.day')}',
            color: Colors.white,
          ),
          _buildVerticalDivider(),
          _buildStatusItem(
            icon: Icons.emoji_events,
            label: translationProvider.tr('workspace.user_profile.level'),
            value:
                translationProvider.tr('workspace.user_profile.leader_level'),
            color: Colors.white,
          ),
          _buildVerticalDivider(),
          _buildStatusItem(
            icon: Icons.monetization_on,
            label:
                translationProvider.tr('workspace.user_profile.energy_points'),
            value: '${user.energyPoints} Lms.',
            color: Colors.white,
          ),
          _buildVerticalDivider(),
          _buildStatusItem(
            icon: Icons.calendar_today,
            label: translationProvider.tr('workspace.user_profile.weekly_goal'),
            value:
                '${_getWeeklyProgress()}/7 ${translationProvider.tr('workspace.user_profile.days')}',
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 24.sp),
          SizedBox(height: 8.h),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              color: color.withOpacity(0.8),
              fontSize: 10.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 50.h,
      color: Colors.white.withOpacity(0.3),
    );
  }

  int _getWeeklyProgress() {
    // Aquí implementa la lógica para obtener el progreso semanal
    // Por ahora retorna un valor de ejemplo
    return 3; // 3/7 días
  }

  Widget _buildMainActionButtons(AppTranslationProvider translationProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.explore,
            label: translationProvider.tr('workspace.cards.adventure'),
            color1: const Color(0XFFA731EC),
            color2: const Color(0XFF620188),
            onTap: () => _onAdventureTap(translationProvider),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: _buildActionButton(
            icon: Icons.menu_book,
            label: translationProvider.tr('workspace.cards.bible'),
            color1: const Color(0XFF1FEFEC),
            color2: const Color(0XFF0159A7),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/layoutPage',
                arguments: {'selectedIndex': 1},
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: color1.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 32.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyVerseSection(
    AppTranslationProvider translationProvider,
    bool loadingDaily,
    bool errorDaily,
    DailyWord dailyWord,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translationProvider.tr('workspace.sections.daily_verse'),
                  style: StylesApp(context).textStyleBody5.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFD8C43),
                      ),
                ),
                Row(
                  children: [
                    _buildIconButton(Icons.bookmark_border, () {
                      _saveVerseToFavorites();
                    }),
                    SizedBox(width: 8.w),
                    _buildIconButton(Icons.chevron_right, () {
                      _showMoreVerseInfo();
                    }),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: errorDaily
                ? Center(
                    child: IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xFF12CBC4)),
                      onPressed: getDailyProverb,
                    ),
                  )
                : loadingDaily
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dailyWord.verse?.text ?? '',
                            style: StylesApp(context).textStyleBody4.copyWith(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF555555),
                                  height: 1.5,
                                ),
                          ),
                          SizedBox(height: 12.h),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '— ${dailyWord.book?.modernName} ${dailyWord.chapter?.chapter}:${dailyWord.verse?.verse}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xFF12CBC4),
                                fontWeight: FontWeight.w500,
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

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(icon, size: 20.sp, color: const Color(0xFFFD8C43)),
    );
  }

  Widget _buildStoriesSection(BuildContext context, reflection,
      AppTranslationProvider translationProvider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  translationProvider
                      .tr('workspace.sections.stories_to_reflect'),
                  style: StylesApp(context).textStyleBody5.copyWith(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFD8C43),
                      ),
                ),
                _buildIconButton(Icons.add_circle_outline, () async {
                  await _showAllStoriesDialog(context, translationProvider);
                }),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.shade200,
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: AudioPlayerWidget(
              showImage: false,
              inactiveColor: StyleColor.orange,
              backgroundColor: Colors.white,
              controlsColor: StyleColor.turquoise,
              fileName: reflection != null ? reflection.title : '',
              pathUrl: reflection != null
                  ? "${GraphQLConfig.urlServidor}${reflection.url}"
                  : '',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomGridMenu(AppTranslationProvider translationProvider) {
    final items = [
      {
        'icon': Icons.bolt,
        'label': translationProvider.tr('workspace.cards.adventure'),
        'route': '/introAventurePage',
        'color1': const Color(0XFFA731EC),
        'color2': const Color(0XFF620188),
      },
      {
        'icon': Icons.mic,
        'label': translationProvider.tr('workspace.sections.preachings'),
        'route': '/preachPage',
        'color1': const Color(0XFF1FEFEC),
        'color2': const Color(0XFF0159A7),
      },
      {
        'icon': Icons.sports_esports,
        'label': translationProvider.tr('workspace.sections.games'),
        'route': '/playPage',
        'color1': const Color(0XFF3531F3),
        'color2': const Color(0XFF040681),
      },
      {
        'icon': Icons.auto_awesome,
        'label': translationProvider.tr('workspace.sections.promises'),
        'route': '/promisePage',
        'color1': const Color(0XFF58AC5F),
        'color2': const Color(0XFF2F6624),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildGridMenuItem(
          icon: item['icon'] as IconData,
          label: item['label'] as String,
          color1: item['color1'] as Color,
          color2: item['color2'] as Color,
          onTap: () => Navigator.pushNamed(context, item['route'] as String),
        );
      },
    );
  }

  Widget _buildGridMenuItem({
    required IconData icon,
    required String label,
    required Color color1,
    required Color color2,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color1, color2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 28.sp),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ============ MÉTODOS DE FUNCIONALIDAD ============

  Future<void> _onAdventureTap(
      AppTranslationProvider translationProvider) async {
    await _loadProgress(context);
    if (error) return;

    if (progressUser != null && progressUser!.success == true) {
      if (progressUser!.message.contains('El curso ya fue finalizado')) {
        await showCustomDialogWithAction(
          context,
          message: progressUser!.message,
          dialogType: DialogTypeAction.info,
          buttonOk:
              translationProvider.tr('workspace.dialogs.see_more_courses'),
          textButton: translationProvider.tr('workspace.dialogs.go_to_course'),
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
        Navigator.pushNamed(context, '/mapPage', arguments: {
          'courseId': progressUser!.data?.courseId,
          'sectionId': progressUser!.data?.sectionId
        });
      }
    } else {
      Navigator.pushNamed(context, '/introAventurePage');
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

  Future<void> _showAllStoriesDialog(
      BuildContext context, AppTranslationProvider translationProvider) async {
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

    List<ButtonData> buttonsData = reflections
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

  void _saveVerseToFavorites() {
    showSnackBar(
      'Versículo guardado en favoritos',
      type: SnackBarType.success,
    );
  }

  void _showMoreVerseInfo() {
    if (dailyWord.book!.modernName!.isNotEmpty) {
      Navigator.pushNamed(context, "/layoutPage", arguments: {
        'selectedIndex': 1,
        'bibleId': dailyWord.book!.bibleId,
        'bookId': dailyWord.book!.id,
        'chapterId': dailyWord.chapter!.id,
        'verseId': dailyWord.verse!.id,
      });
    }
  }

  // ============ MÉTODOS DE NOTIFICACIONES ============

  String getUnreadCountNotification() {
    return _unreadCount > 0 ? _unreadCount.toString() : '0';
  }

  void _onNotificationsChanged() {
    if (mounted) {
      _updateUnreadCount();
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
      final response = await markAsViewNotification();
      if (response.error != null) {
        if (kDebugMode) {
          print(
              '❌ Error al marcar notificaciones como vistas: ${response.error}');
        }
        return;
      }
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
}
