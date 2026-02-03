import 'package:biblia_palabra_de_vida_app/constants/app_constants.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class PromisesScreen extends StatefulWidget {
  const PromisesScreen({super.key});

  @override
  State<PromisesScreen> createState() => _PromisesScreenState();
}

class _PromisesScreenState extends State<PromisesScreen> {
  int _selectedIndex = 2;
  bool isLoading = true;
  String? errorMessage;
  LoginUser? userData;
  List<PromiseModel> redeemedPromise = [];
  List<PromiseCardModel> promises = [];

  // lista de mensaje de presentación para las promesas
  final List<String> textPromise = AppConstants.textPromise..shuffle();
  // lista de imágenes para las promesas
  List<String> images = AppConstants.imagesPromise;
  // lista de colores para las card de las promesas canjeadas
  final List<String> colorsCard = AppConstants.colorsCard;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _generateData(context);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      userData = userProvider.currentUser;
    });
  }

  // Función que genera la data de las promesas a mostrar
  Future<void> _generateData(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userData = userProvider.currentUser;

    LoadingService().showLoading(context);
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    try {
      setState(() {});
      // cargamos las promesas
      final responsePromises = await getDailyPromises(userData!.userId);
      if (responsePromises.error != null) {
        errorMessage = responsePromises.error;
      }
      redeemedPromise = responsePromises.data
          .map<PromiseModel>((pr) => PromiseModel.fromJson(removeTypename(pr)))
          .toList();
      redeemedPromise = redeemedPromise.map((promise) {
        final randomColor = colorsCard[redeemedPromise.indexOf(promise)];
        return promise.copyWith(
          color: randomColor.toString(),
        );
      }).toList();

      promises = redeemedPromise.map((promise) {
        return PromiseCardModel(
          id: promise.id!,
          title: "¡Abre tu promesa!",
          description: textPromise.isNotEmpty
              ? textPromise[
                  redeemedPromise.indexOf(promise) % textPromise.length]
              : "Descubre tu promesa",
          images: images[redeemedPromise.indexOf(promise)],
          hasViewed: promise.hasViewed!,
        );
      }).toList();
    } catch (e) {
      errorMessage = "An error occurred: $e";
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == _selectedIndex) return;
    setState(() {
      _selectedIndex = index;
      Navigator.popAndPushNamed(
        context,
        '/layoutPage',
        arguments: {'selectedIndex': _selectedIndex},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(),
          tablet: _buildTabletLayout(),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBarWidget(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0XFF12CBC4),
        unselectedItemColor: Colors.white,
        selectedLabelStyle: StylesApp(context).textStyleBody10,
        unselectedLabelStyle: StylesApp(context).textStyleBody10,
        items: getItemsPromises(context),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Layout para móvil
  Widget _buildMobileLayout() {
    return SizedBox(
      child: Column(
        children: [
          SimpleHeaderWidget(
            title: 'Promesas',
            onRoute: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            height: 8.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
                color: StyleColor.orange,
                borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 0,
                  child: Image.asset(
                    'assets/kawaii_fire.png',
                    width: 40,
                    height: 40,
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Text(
                    '${userData != null ? userData!.energyPoints : ''}',
                    style: StylesApp(context).textStyleBody14,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      style: StylesApp(context).textStyleBody14,
                      children: [
                        TextSpan(text: 'Racha: '),
                        TextSpan(
                            text:
                                '${userData != null ? userData!.streakDaysCount : '0'} días'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                  child: Column(
                children: [
                  if (isLoading) ...{
                    Container()
                  } else ...{
                    if (errorMessage != null) ...{
                      BuildErrorWidget(
                        errorMessage: errorMessage!,
                        onRetry: () async => _generateData(context),
                        onBack: () => Navigator.pop(context),
                      )
                    } else ...{
                      Column(
                        children: [
                          for (var index = 0; index < promises.length; index++)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5.0),
                              child: CardPromiseWidget(
                                onePromise: promises[index],
                                redeemedPromise: redeemedPromise[index],
                                updateData: (bool value) {
                                  if (value) {
                                    setState(() {
                                      promises[index] = promises[index]
                                          .copyWith(hasViewed: value);
                                      if (kDebugMode) {
                                        print(
                                            "cambio valor ${promises[index].hasViewed}");
                                      }
                                      didChangeDependencies();
                                    });
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: Text(
                          textAlign: TextAlign.center,
                          'Las promesas se actualizarán cada 24 horas',
                          style: StylesApp(context)
                              .textStyleBody12
                              .copyWith(color: StyleColor.turquoise),
                        ),
                      ),
                    }
                  }
                ],
              )),
            ),
          )
        ],
      ),
    );
  }

  // Layout para tablet
  Widget _buildTabletLayout() {
    return Column(
      children: [
        // Header para tablet
        Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Botón de retroceso
              SizedBox(
                width: 45,
                height: 45,
                child: IconButton(
                  style: IconButton.styleFrom(
                    backgroundColor: StyleColor.orange,
                    foregroundColor: StyleColor.white,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(35, 35),
                    fixedSize: const Size(35, 35),
                    iconSize: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
              ),
              // Título y estadísticas
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Promesas',
                          style:
                              StylesApp(context).textStyleTitleOrange.copyWith(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        if (userData != null && promises.isNotEmpty)
                          SizedBox(height: 8),
                        if (userData != null && promises.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              color: StyleColor.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${promises.where((p) => !p.hasViewed).length} de ${promises.length} por abrir',
                              style: StylesApp(context)
                                  .textStyleBody14
                                  .copyWith(color: StyleColor.orange),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              // Puntos de energía
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: StyleColor.orange,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'assets/kawaii_fire.png',
                      width: 30,
                      height: 30,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${userData?.energyPoints ?? '0'}',
                          style: StylesApp(context)
                              .textStyleBody14
                              .copyWith(color: Colors.white),
                        ),
                        Text(
                          '${userData?.streakDaysCount ?? '0'} días',
                          style: StylesApp(context)
                              .textStyleBody12
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Contenido principal
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage != null
                    ? Center(
                        child: BuildErrorWidget(
                          errorMessage: errorMessage!,
                          onRetry: () async => _generateData(context),
                          onBack: () => Navigator.pop(context),
                        ),
                      )
                    : promises.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.inbox_outlined,
                                    size: 60, color: Colors.grey),
                                SizedBox(height: 20),
                                Text(
                                  'No hay promesas disponibles',
                                  style: StylesApp(context)
                                      .textStyleBody14
                                      .copyWith(color: Colors.grey),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _getCrossAxisCount(context),
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                              // childAspectRatio: _getChildAspectRatio(context),
                            ),
                            itemCount: promises.length,
                            itemBuilder: (context, index) {
                              return CardPromiseWidget(
                                onePromise: promises[index],
                                redeemedPromise: redeemedPromise[index],
                                updateData: (bool value) {
                                  if (value) {
                                    setState(() {
                                      promises[index] = promises[index]
                                          .copyWith(hasViewed: value);
                                      didChangeDependencies();
                                    });
                                  }
                                },
                              );
                            },
                          ),
          ),
        ),
        // Mensaje de actualización
        Container(
          padding: EdgeInsets.all(16),
          color: StyleColor.turquoise.withValues(alpha: 0.1),
          child: Text(
            'Las promesas se actualizarán cada 24 horas',
            style: StylesApp(context)
                .textStyleBody12
                .copyWith(color: StyleColor.turquoise),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // Calcular número de columnas según tamaño de pantalla
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1200) return 4;
    if (width > 1000) return 3;
    if (width > 700) return 2;
    return 1;
  }

  // Calcular aspect ratio según orientación
}
