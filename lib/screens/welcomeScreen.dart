import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;
  void _setIntroSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  _buildPage(
                    image: '',
                    backImage1: '/estrella.png',
                    backImage2: '/nube.png',
                    title: 'PALABRA de Vida',
                    subTitle: "¡La Biblia!",
                    description: 'La palabra de Dios cambiara tu vida.',
                  ),
                  _buildPage(
                    image: '/jesusImage.png',
                    title: "",
                    subTitle: "¡Aventúrate en la historia sagrada!",
                    description:
                        'Explora los relatos bíblicos a través de historias. .',
                  ),
                  _buildPage(
                    image: '/LionImage.png',
                    title: '',
                    subTitle: "¡Conoce el libro más leído del mundo!",
                    description:
                        'Escudriña la palabra en sus diferentes versiones',
                  ),
                  _buildPage(
                    image: '/angelImage.png',
                    title: '',
                    subTitle: "¡Enriquece tu fe con la Biblia!",
                    description:
                        'Realiza un viaje por la Biblia y logrando  metas diarias.',
                  ),
                  EndIntroScreen()
                ],
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                     _setIntroSeen();
                    Navigator.pushNamed(context, '/homePage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent, // Fondo transparente
                    // onPrimary: Colors.blue, // Color del texto
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        color: Colors.transparent,
                        width: 2.0, // Ancho del subrayado
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Omitir',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 5, // Número total de páginas
                  effect: const WormEffect(
                    activeDotColor: Colors.blue,
                    dotColor: Colors.grey,
                  ),
                ),
              ),
            ),
            if (!_isLastPage)
              Positioned(
                bottom: 16,
                right: 16,
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent, // Fondo transparente
                      // onPrimary: Colors.blue, // Color del texto
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(
                          color: Colors.transparent,
                          width: 2.0, // Ancho del subrayado
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (_controller.page!.toInt() > 3) {
                        _setIntroSeen();
                        Navigator.pushNamed(context, '/homePage');
                      }
                      // Lógica para ir a la siguiente página o a la pantalla principal
                      _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease);
                    },
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  Widget _buildPage(
      {String image = "",
      String backImage1 = "",
      String backImage2 = "",
      String title = "",
      String subTitle = "",
      required String description}) {
    TextStyle font = GoogleFonts.getFont(
      "Alfa Slab One",
      fontSize: 64,
    );
    TextStyle fontTitle = GoogleFonts.getFont(
      "Alfa Slab One",
      fontSize: 35,
      // fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    TextStyle fontBody = GoogleFonts.getFont(
      "Alegreya Sans SC",
      fontSize: 32,
      // fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (backImage1 != '' && backImage2 != '')
              Container(
                constraints:
                    const BoxConstraints(minHeight: 220, maxHeight: 220),
                height: double.infinity,
                child: Stack(
                  children: [
                    // Nube (You can use an SVG or a Path)
                    Positioned(
                      left: 0.0, // Use double values for positioning
                      top: 82.0,
                      child: Image.asset(
                        '/nube.png', // Correct path with "" prefix
                        fit: BoxFit.contain,
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      top: 88.0,
                      child: Image.asset(
                        '/start.png', // Correct path with "assets" prefix
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            Container(
              // height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (image != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 54.0),
                      child: Container(
                        child: Image.asset(
                          image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  if (image == '') const SizedBox(height: 80),
                  if (title != '')
                    Container(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 43,
                          ),
                          Center(
                            child: TextWithGradient(text: title, font: font),
                          ),
                        ],
                      ),
                    ),
                  Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxHeight: 395,
                      minHeight: 395,
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          "/backgroundBox.png",
                          width: MediaQuery.sizeOf(context).width,
                          height: 395,
                          fit: BoxFit.fill,
                          scale: 1,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 80,
                            ),
                            if (subTitle != '')
                              Center(
                                child: Text(
                                    textAlign: TextAlign.center,
                                    subTitle,
                                    style: fontTitle),
                              ),
                            Center(
                              child: Container(
                                constraints: const BoxConstraints(
                                  minWidth: 318,
                                  maxWidth: 318,
                                ),
                                width: double.infinity,
                                height: 151,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFD8C43),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(description,
                                      textAlign: TextAlign.center,
                                      style: fontBody),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
