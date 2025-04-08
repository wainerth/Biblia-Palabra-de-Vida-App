import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/bottom_navigation_items.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:share_plus/share_plus.dart';

class PromisesScreen extends StatefulWidget {
  const PromisesScreen({super.key});

  @override
  State<PromisesScreen> createState() => _PromisesScreenState();
}

class _PromisesScreenState extends State<PromisesScreen> {
  int _selectedIndex = 2;
  List<Map<String, dynamic>> promises = [
    {
      "id": 1,
      "title": "¡Abre tu promesa!",
      "img": "assets/promesa-1.png",
      "description":
          "Encontrarás la fuerza interior necesaria para hallar consuelo en tu vida"
    },
    {
      "id": 2,
      "title": "¡Abre tu promesa!",
      "img": "assets/promesa-2.png",
      "description":
          "Conecta con la fuente de toda sabiduria y encuentra la paz que tanto anhelas"
    },
    {
      "id": 3,
      "title": "¡Abre tu promesa!",
      "img": "assets/promesa-3.png",
      "description":
          "¿Qué secreto esconde este versiculo que puede cambiar tu vida?"
    },
  ];

  void _onItemTapped(int index) {
    if(index == _selectedIndex) return; 
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
        child: SingleChildScrollView(
          child: Container(
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
                          '571',
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
                              TextSpan(text: '0 días'),
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
                Column(
                  children: promises.map((promise) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 5.0),
                      child: CardPromiseWidget(
                        onePromise: promise,
                      ),
                    );
                  }).toList(),
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
              ],
            ),
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
  final onePromise;
  const CardPromiseWidget({
    super.key,
    this.onePromise,
  });

  @override
  State<CardPromiseWidget> createState() => _CardPromiseWidgetState();
}

class _CardPromiseWidgetState extends State<CardPromiseWidget> {
  bool redeemedPromise = false;
  Map<String, dynamic> promise = {
    "id": null,
    "color": '',
    "verse": '',
    "earnedEnergy": 0,
    "description": ""
  };
  List<Map<String, dynamic>> RedeemedPromiseObj = [
    {
      "id": 1,
      "color": "03C6DC",
      "verse": "Gálatas 3:22",
      "earnedEnergy": 10,
      "description":
          "Mas encerró la Escritura todo bajo pecado, para que la promesa fuese dada a los creyentes por la fe de Jesucristo."
    },
    {
      "id": 2,
      "color": "9747FF",
      "verse": "1 Crónicas 16:34",
      "earnedEnergy": 10,
      "description":
          "Celebrad a Jehová, porque es bueno; Porque su misericordia es eterna."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          //canjear
          promise = RedeemedPromiseObj.firstWhere(
            (element) => element['id'] == widget.onePromise['id'],
            orElse: () => {
              "id": null,
              "color": '',
              "verse": '',
              "earnedEnergy": 0,
              "description": ""
            },
          );
          if (promise["id"] != null) {
            redeemedPromise = true;
          }
        });
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
        child: redeemedPromise ? _buildRedeemedPromiseCard() : _buildPromiseCard(),
      ),
    );
  //      child: AnimatedSwitcher(
  //     duration: const Duration(milliseconds: 500),
  //     transitionBuilder: (Widget child, Animation<double> animation) {
  //       // Animación de "volteo de hoja"
  //       return AnimatedBuilder(
  //         animation: animation,
  //         builder: (context, child) {
  //           double value = Curves.easeInOut.transform(animation.value);
  //           return Transform(
  //             transform: Matrix4.identity()
  //               ..setEntry(3, 2, 0.001) // Perspectiva
  //               ..rotateY(3.1415927 * value), // Rotación en el eje Y
  //             alignment: Alignment.center,
  //             child: child,
  //           );
  //         },
  //         child: child,
  //       );
  //     },
  //     child: redeemedPromise ? _buildRedeemedPromiseCard() : _buildPromiseCard(),
  //   )
  // );
  //      child: AnimatedSwitcher(
  //       duration: const Duration(milliseconds: 500),
  //       transitionBuilder: (Widget child, Animation<double> animation) {
  //         // Animación de rotación horizontal
  //         return RotationTransition(
  //           turns: Tween<double>(begin: 0.5, end: 1).animate(animation),
  //           child: child,
  //         );
  //       },
  //       child: redeemedPromise ? _buildRedeemedPromiseCard() : _buildPromiseCard(),
  //     ),
  //   );
    //   child: AnimatedSwitcher(
    //     duration: const Duration(milliseconds: 500),
    //     transitionBuilder: (Widget child, Animation<double> animation) {
    //       // Animación de rotación
    //       return RotationTransition(
    //         turns: Tween<double>(begin: 0, end: 1).animate(animation),
    //         child: child,
    //       );
    //     },
    //     child: redeemedPromise ? _buildRedeemedPromiseCard() : _buildPromiseCard(),
    //   ),
    // );
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
            Image.asset(widget.onePromise['img']),
            Text(
              widget.onePromise['title'],
              style: StylesApp(context).textStyleBodyOrange15,
            ),
            Text(
              widget.onePromise['description'],
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
        color: Color(int.parse("0XFF${promise['color']}")),
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
              onPressed:  () async {
                        await Share.share(
                          "${promise['verse']}\n${promise['description']}.",
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
                  promise['verse'],
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
                    constraints:
                        BoxConstraints(maxWidth: 280, minHeight: 80),
                    child: Text(
                      promise['description'],
                      textAlign: TextAlign.center,
                      style: StylesApp(context).textStyleBody12,
                    ),
                  ),
                ),
                Image.asset("assets/star_complete.png"),
                Text(
                  textAlign: TextAlign.center,
                  "Haz gando una mini estrella\n ${promise['earnedEnergy']} Lms de energia",
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
