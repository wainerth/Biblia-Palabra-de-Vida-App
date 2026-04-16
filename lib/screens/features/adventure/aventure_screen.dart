import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/bible_theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AventureScreen extends StatefulWidget {
  const AventureScreen({super.key});

  @override
  State<AventureScreen> createState() => _AventureScreenState();
}

class _AventureScreenState extends State<AventureScreen> {
  late final UserProvider userProvider;
  LoginUser? dataUser;
  ResponseProgress? progressUser;
  bool isLoading = true;
  List<bool> loadAventure = [];
  late BibleTheme currentTheme;

  String? errorMessage;
  int itemPerPageValue = 10;
  List<int> itemsPerPage = [
    5,
    10,
    15,
    25,
    50,
    100,
  ];
  PaginationInfo pagination = PaginationInfo(
    currentPage: 1,
    totalPages: 0,
    itemsPerPage: 0,
    totalItems: 0,
    hasPreviousPage: false,
    hasNextPage: false,
  );

  List<CourseModel> courses = [];

  // Determinar si es tablet
  bool get isTablet {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.width >= 600;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context, pagination.currentPage, itemPerPageValue);
    });
  }

  Future<void> _generateData(BuildContext context, int page, int limit) async {
    final translationProvider = context.read<AppTranslationProvider>();
    LoadingService().showLoading(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    dataUser = userProvider.currentUser;
    setState(() {
      errorMessage = null;
    });
    try {
      final result = await loadCoursesByUserAndChurch(
          page,
          limit,
          dataUser!.userId,
          dataUser!.userChurch.isNotEmpty
              ? dataUser!.userChurch.first.id
              : null);
      if (result.error != null) {
        LoadingService().hideLoading();
        if (result.error.contains("Información")) {
          await showCustomDialogWithAction(context,
              message: result.error!,
              dialogType: DialogTypeAction.info,
              buttonOk: translationProvider.tr('adventure_screen.go_back'),
              actionCallbackOk: () {
                Navigator.popAndPushNamed(context, '/workspacePage');
              },
              showAction: true,
              textButton: translationProvider
                  .tr('adventure_screen.affiliate_to_church'),
              actionCallback: () {
                Navigator.popAndPushNamed(context, '/profilePage');
              });
          errorMessage = result.error;
        } else {
          errorMessage = result.error;
        }
      } else {
        setState(() {
          courses = result.data['data']
              .map((course) => CourseModel.fromJson(removeTypename(course)))
              .cast<CourseModel>()
              .toList();
          pagination = PaginationInfo.fromJson(result.data['meta']);
        });
      }
    } catch (e) {
      errorMessage = "Un  error  ha ocurrido: $e";
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

    final userProvider = Provider.of<UserProvider>(context);
    dataUser = userProvider.currentUser;
    progressUser = userProvider.progressUser;
    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    currentTheme = themeProvider.themeData;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(),
            Expanded(
              child: isLoading
                  ? Container()
                  : errorMessage != null
                      ? Center(
                          child: BuildErrorWidget(
                            errorMessage: errorMessage!,
                            onRetry: () async => _generateData(context,
                                pagination.currentPage, itemPerPageValue),
                            onBack: () => Navigator.pop(context),
                          ),
                        )
                      : isTablet
                          ? _buildTabletLayout(
                              translationProvider) // Diseño para tablet
                          : _buildMobileLayout(
                              translationProvider), // Diseño para móvil (existente)
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom,
                top: 8.0,
              ),
              child: CustomPagination(
                pagination: PaginationInfo(
                  currentPage: pagination.currentPage,
                  itemsPerPage: pagination.itemsPerPage,
                  totalPages: pagination.totalPages,
                  hasPreviousPage: pagination.hasPreviousPage,
                  hasNextPage: pagination.hasNextPage,
                  totalItems: pagination.totalItems,
                ),
                itemPerPageValue: itemPerPageValue,
                currentTheme: currentTheme,
                onPageChanged: (newPage, newPerPage) async {
                  if (courses.isNotEmpty) {
                    setState(() {
                      itemPerPageValue = newPerPage;
                    });
                    await _generateData(context, newPage, newPerPage);
                  }
                },
                itemsPerPage: itemsPerPage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== DISEÑO PARA TABLET (2 COLUMNAS) ==========
  Widget _buildTabletLayout(AppTranslationProvider translationProvider) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 20.0,
          mainAxisSpacing: 20.0,
          childAspectRatio: 1.8, // ¡CAMBIADO de 1.8 a 0.9! Esto es clave
        ),
        padding: EdgeInsets.only(bottom: 24.0),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          if (loadAventure.length <= index) loadAventure.add(false);
          return _buildTabletCard(index, translationProvider);
        },
      ),
    );
  }

  Widget _buildTabletCard(
      int index, AppTranslationProvider translationProvider) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      margin: EdgeInsets.zero,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 380,
          maxHeight: 420,
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Imagen con altura fija
                SizedBox(
                  height: 160, // Altura fija para la imagen
                  width: double.infinity,
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16.0),
                    ),
                    child: courses[index].img.urlImg.isNotEmpty
                        ? Image.network(
                            GraphQLConfig.urlServidor +
                                courses[index].img.urlImg,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: Center(
                                  child: Icon(
                                    Icons.book,
                                    size: 60,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: currentTheme.buttonColor,
                            child: Center(
                              child: Icon(
                                Icons.book,
                                size: 60,
                                color: Colors.white,
                              ),
                            ),
                          ),
                  ),
                ),

                // Contenido flexible
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Título y descripción - altura flexible
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                courses[index].title,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: currentTheme.textColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 8.0),
                              Flexible(
                                child: SingleChildScrollView(
                                  physics: NeverScrollableScrollPhysics(),
                                  child: Text(
                                    courses[index].introduction,
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      color: Colors.grey[700],
                                      height: 1.4,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16),

                        // Botones - altura fija
                        SizedBox(
                          height: 50, // Altura fija para botones
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    _handleCardTap(index, translationProvider);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: currentTheme.buttonColor,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text(
                                    translationProvider
                                        .tr('adventure_screen.details_button'),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: currentTheme.buttonTextColor,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.0),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () async {
                                    _handleGoToMap(index, translationProvider);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    side: BorderSide(
                                        color: currentTheme.buttonColor),
                                  ),
                                  child: Text(
                                    translationProvider
                                        .tr('adventure_screen.map_button'),
                                    style: TextStyle(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: currentTheme.buttonColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Indicador de carga
            if (loadAventure[index])
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Center(
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircularProgressIndicator(
                        strokeWidth: 4.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ========== DISEÑO PARA MÓVIL (EXISTENTE) ==========
  Widget _buildMobileLayout(AppTranslationProvider translationProvider) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 24.0),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        if (loadAventure.length <= index) loadAventure.add(false);
        return Column(
          children: [
            Stack(children: [
              CardAventureWidget(
                course: courses[index],
                loadingAction: loadAventure[index],
                onTap: () async {
                  _handleCardTap(index, translationProvider);
                },
                goToMap: () async {
                  _handleGoToMap(index, translationProvider);
                },
              ),
              if (loadAventure[index])
                Positioned(
                    right: 20,
                    bottom: 20,
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator.adaptive(
                        strokeWidth: 4.0,
                        strokeAlign: BorderSide.strokeAlignInside,
                        backgroundColor: Colors.white,
                      ),
                    )),
            ]),
          ],
        );
      },
    );
  }

  loadStage(String? userId, String courseId) async {
    List<Stage> stages = [];
    final result = await loadStageByCourse(userId!, courseId);
    if (result.data != null) {
      stages = result.data
          .map((stage) => Stage.fromJson(removeTypename(stage)))
          .cast<Stage>()
          .toList();
      return stages.first;
    }
    return null;
  }

  // Agrega estas funciones dentro de la clase _AventureScreenState:
  Future<void> _handleCardTap(
      int index, AppTranslationProvider translationProvider) async {
    setState(() => loadAventure[index] = true);
    Stage? stage = await loadStage(dataUser?.userId, courses[index].id);
    if (!mounted) return;
    if (stage != null && stage.levelCount > 0) {
      if (!mounted) return;
      Navigator.popAndPushNamed(context, '/detailCoursePage',
          arguments: {"courseId": courses[index].id});
    } else {
      if (mounted) setState(() => loadAventure[index] = false);
      if (!mounted) return;
      await showCustomDialog(context,
          message:
              translationProvider.tr('adventure_screen.course_unavailable'),
          showDetails: false,
          dialogType: DialogType.info);
    }
  }

  Future<void> _handleGoToMap(
      int index, AppTranslationProvider translationProvider) async {
    if (mounted) setState(() => loadAventure[index] = true);

    Stage? stage = await loadStage(dataUser?.userId, courses[index].id);
    if (!mounted) return;

    if (stage != null && stage.levelCount > 0) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final progressResponse = await userProvider.getProgressUser(
          dataUser!.userId, courses[index].id);
      if (!mounted) return;

      if (progressResponse!.error != null) {
        if (mounted) setState(() => loadAventure[index] = false);
        if (!mounted) return;
        await showCustomDialog(
          context,
          messageDetail: progressResponse.error!,
          message: progressResponse.userFriendlyError!,
          dialogType: DialogType.error,
        );
        return;
      }

      progressUser = progressResponse.data;

      if (progressUser?.success == true) {
        if (progressUser!.message.contains('El curso ya fue finalizado')) {
          if (!mounted) return;
          await showCustomDialogWithAction(
            context,
            message: progressUser!.message,
            dialogType: DialogTypeAction.info,
            buttonOk: translationProvider.tr('adventure_screen.close'),
            textButton: translationProvider.tr('adventure_screen.go_to_course'),
            showAction: true,
            actionCallbackOk: () {
              if (mounted) setState(() => loadAventure[index] = false);
              if (mounted) Navigator.pop(context);
            },
            actionCallback: () {
              if (mounted) {
                Navigator.pushNamed(context, '/mapPage', arguments: {
                  'courseId': progressUser?.data?.courseId,
                  'sectionId': progressUser?.data?.sectionId ?? stage.id
                });
              }
            },
          );
          return;
        } else {
          if (mounted) {
            Navigator.pushNamed(context, '/mapPage', arguments: {
              'courseId': courses[index].id,
              'sectionId': progressUser?.data?.sectionId ?? stage.id
            });
          }
        }
      } else {
        if (mounted) {
          Navigator.pushNamed(context, '/mapPage', arguments: {
            'courseId': courses[index].id,
            'sectionId': stage.id
          });
        }
      }
    } else {
      if (mounted) setState(() => loadAventure[index] = false);
      if (!mounted) return;
      await showCustomDialog(context,
          message:
              translationProvider.tr('adventure_screen.course_unavailable'),
          dialogType: DialogType.info);
    }

    if (mounted) setState(() => loadAventure[index] = false);
  }
}
