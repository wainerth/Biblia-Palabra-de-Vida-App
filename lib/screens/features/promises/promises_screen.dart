import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
  final List<String> textPromise = [
    "¿Qué secreto esconde este versículo que puede cambiar tu vida?",
    "Descubre la fuerza que transforma vidas y embárcate en un viaje espiritual",
    "Permite que la sabiduría te inspire a vivir una vida auténtica y compasiva",
    "Embárcate en un viaje que te llevará a descubrir las profundidades de tu alma",
    "Encontrarás la fuerza interior necesaria para hallar consuelo en tu vida",
    "Cada verso es una semilla que puede florecer en tu corazón",
    "Conecta con la fuente de toda sabiduría y encuentra la paz que tanto anhelas",
    "Descubre el tesoro oculto que se encuentra en cada palabra",
    "Permite que la sabiduría de los antiguos maestros te guíe",
    "Abre tu mente y tu corazón a las infinitas posibilidades que la palabra te ofrece",
    "Descubre la belleza de la simplicidad y la profundidad de la fe",
    "Las palabras tienen el poder de sanar, inspirar y transformar",
    "Permite que estas verdades eternas transforme enormemente tu corazón",
    "Cada verso es un regalo que te invita a crecer como persona",
    "Conecta con la fuente de toda sabiduría y encuentra la paz que tanto anhelas",
    "Cada palabra es una pieza que te ayudará a comprender tu lugar en el mundo."
  ]..shuffle();
  // lista de imágenes para las promesas
  List<String> images = [
    "assets/promesa-1.png",
    "assets/promesa-2.png",
    "assets/promesa-3.png",
  ];
  // lista de colores para las card de las promesas canjeadas
  final List<String> colorsCard = ["03C6DC", "9747FF", "E85151"];

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
        // colorsCard[redeemedPromise.indexOf(promise) % colorsCard.length];
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
        child: SizedBox(
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
                              for (var index = 0;
                                  index < promises.length;
                                  index++)
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
}

class CardPromiseWidget extends StatefulWidget {
  final PromiseCardModel onePromise;
  final PromiseModel? redeemedPromise;
  final Function(bool value) updateData;
  const CardPromiseWidget({
    super.key,
    required this.onePromise,
    this.redeemedPromise,
    required this.updateData,
  });

  @override
  State<CardPromiseWidget> createState() => _CardPromiseWidgetState();
}

class _CardPromiseWidgetState extends State<CardPromiseWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onePromise.hasViewed
          ? null
          : () async {
              LoadingService().showLoading(context);
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final userData = userProvider.currentUser;
              try {
                final responseOpenPromise = await openOnePromise(
                    userData!.userId, widget.onePromise.id);
                if (responseOpenPromise.error != null) {
                  LoadingService().hideLoading();
                  await showCustomDialog(context,
                      message: responseOpenPromise.error!,
                      dialogType: DialogType.error);
                  return;
                }

                String? userToken = await PreferencesManager().getUserToken();

                await Provider.of<AuthenticationProvider>(context,
                        listen: false)
                    .loadProfileUser(userData.userId, userToken);
                LoadingService().hideLoading();
                widget.updateData(responseOpenPromise.data);
              } catch (e) {
                LoadingService().hideLoading();
                await showCustomDialog(context,
                    message: e.toString(), dialogType: DialogType.error);
                return;
              }
            },
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            // Animación de fundido
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: widget.onePromise.hasViewed
              ? _buildRedeemedPromiseCard()
              : _buildPromiseCard()),
    );
  }

  Widget _buildPromiseCard() {
    return Container(
      key: ValueKey(1), // Clave única para AnimatedSwitcher
      decoration: BoxDecoration(
        color: Color(0XFFF3E9C6),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: .25),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 4))
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Image.asset(widget.onePromise.images.isNotEmpty
                ? widget.onePromise.images
                : ''),
            Text(
              widget.onePromise.title,
              style: StylesApp(context).textStyleBodyOrange15,
            ),
            Text(
              widget.onePromise.description,
              textAlign: TextAlign.center,
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRedeemedPromiseCard() {
    return Container(
      key: ValueKey(2), // Clave única para AnimatedSwitcher
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(int.parse("0XFF${widget.redeemedPromise!.color}")),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: .25),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 4))
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              onPressed: () async {
                await Share.share(
                  "${widget.redeemedPromise!.book!.modernName} ${widget.redeemedPromise!.chapter!.chapter}:${widget.redeemedPromise!.verse!.verse}\n${widget.redeemedPromise!.verse!.text}.",
                  subject: "Promesa",
                );
              },
              icon: Icon(Icons.share, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Text(
                  "${widget.redeemedPromise!.book!.modernName} ${widget.redeemedPromise!.chapter!.chapter}:${widget.redeemedPromise!.verse!.verse}",
                  style: StylesApp(context)
                      .textStyleBody4
                      .copyWith(color: Colors.white),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Container(
                    width: double.infinity,
                    constraints: BoxConstraints(maxWidth: 280, minHeight: 80),
                    child: Text(
                      widget.redeemedPromise!.verse!.text!,
                      textAlign: TextAlign.center,
                      style: StylesApp(context).textStyleBody12,
                    ),
                  ),
                ),
                Image.asset("assets/star_complete.png"),
                Text(
                  textAlign: TextAlign.center,
                  "Haz ganado una mini estrella\n ${widget.redeemedPromise!.energyPoint} Lms de energía",
                  style: StylesApp(context)
                      .textStyleBody12
                      .copyWith(color: StyleColor.yellowLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
