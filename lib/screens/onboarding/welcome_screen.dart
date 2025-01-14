import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;

  Future<void> _setIntroSeen() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool('hasSeenIntro', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: SizedBox(
                height: MediaQuery.sizeOf(context).height,
                child: PageView(
                  controller: _controller,
                  onPageChanged: (index) {
                    setState(() => _isLastPage = index == 4);
                  },
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            // Text(
                            // 'Width: ${constraints.maxWidth}, Height: ${constraints}'),
                            _buildPage(
                              image: '',
                              backImages: ['assets/start.png', 'assets/nube.png'],
                              title: 'PALABRA\n de\n Vida',
                              subTitle: "¡La Biblia!",
                              description: 'La palabra de Dios cambiará tu vida.',
                              constraints: constraints,
                            ),
                          ],
                        );
                      },
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            // Text(
                            // 'Width: ${constraints.maxWidth}, Height: ${constraints}'),
                            _buildPage(
                              image: 'assets/jesusImage.png',
                              subTitle: "¡Aventúrate en la historia sagrada!",
                              description:
                                  'Explora los relatos bíblicos a través de historias.',
                              constraints: constraints,
                            ),
                          ],
                        );
                      },
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            // Text(
                            // 'Width: ${constraints.maxWidth}, Height: ${constraints}'),
                            _buildPage(
                              image: 'assets/LionImage.png',
                              subTitle: "¡Conoce el libro\n más leído del mundo!",
                              description:
                                  'Escudriña la palabra en sus diferentes versiones.',
                              constraints: constraints,
                            ),
                          ],
                        );
                      },
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Column(
                          children: [
                            // Text(
                            // 'Width: ${constraints.maxWidth}, Height: ${constraints}'),
                            _buildPage(
                              image: 'assets/angelImage.png',
                              subTitle: "¡Enriquece tu fe con\n la Biblia!",
                              description:
                                  'Realiza un viaje por la Biblia logrando metas diarias.',
                              constraints: constraints,
                            ),
                          ],
                        );
                      },
                    ),
                    const EndIntroScreen(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric( horizontal: 8.0),
                child: Row(
                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                  children: [
                    if (!_isLastPage) _buildSkipButton(context),
                    Center(
                      child: SmoothPageIndicator(
                        controller: _controller,
                        count: 5,
                        effect: const WormEffect(
                          activeDotColor: Colors.blue,
                          dotColor: Colors.grey,
                        ),
                      ),
                    ),
                    _buildNextButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage({
    String image = '',
    List<String> backImages = const [],
    String title = '',
    String subTitle = '',
    required BoxConstraints constraints,
    required String description,
  }) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          if (backImages.isNotEmpty) _buildBackgroundImages(backImages),
          if (image.isNotEmpty)
            Image.asset(
              image,
              width: MediaQuery.sizeOf(context).width,
              // height: 285.0,
              alignment: Alignment.topCenter,
              fit: BoxFit.cover,
            ),
          _buildContent(
            image,
            title,
            subTitle,
            description,
            constraints,
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundImages(List<String> backImages) {
    return SizedBox(
      height: 130,
      child: Stack(
        children: [
          if (backImages.length > 1)
            Positioned(
              left: 0.0,
              top: 44.0,
              child: Image.asset(
                backImages[1],
                fit: BoxFit.fill,
                height: 76.0,
              ),
            ),
          Positioned(
            right: 0.0,
            top: 27.0,
            child: Image.asset(
              backImages[0],
              fit: BoxFit.fill,
              height: 108.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(String image, String title, String subTitle,
      String description, BoxConstraints constraints) {
    final fontBody =
        GoogleFonts.alegreyaSansSc(fontSize: 32, color: Colors.white);

    return SizedBox(
      height: constraints.maxHeight,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Text((MediaQuery.sizeOf(context).height * 0.10).toString()),

          if (title.isNotEmpty) ...{
            // SizedBox(height: 150.0,),
            Center(
              child: TextWithGradient(
                text: title,
                font: StylesApp(context)
                    .textWithGradient
                    .copyWith(fontSize: StylesApp(context).fontSizeTitle),
              ),
            ),
            SizedBox(
              height: 150.0,
            )
          },
          // if (image.isEmpty) const SizedBox(height: 78),
          _buildDescriptionBox(subTitle, description,
              StylesApp(context).textStyleTitle, fontBody),
        ],
      ),
    );
  }

  Widget _buildDescriptionBox(String subTitle, String description,
      TextStyle fontTitle, TextStyle fontBody) {
    return Container(
      width: double.infinity,
      // constraints: const BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/backgroundBox.png"),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 35.0),
          if (subTitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(subTitle,
                    textAlign: TextAlign.center,
                    style: fontTitle.copyWith(
                      color: Colors.white,
                      fontSize: StylesApp(context).fontSizeTitle1,
                    )),
              ),
            ),
          Container(
            width: 329,
            height: 151,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFD8C43),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(description,
                  textAlign: TextAlign.center, style: fontBody),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _setIntroSeen();
        Navigator.pushNamed(context, '/homePage');
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Omitir',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_controller.page! > 3) {
          _setIntroSeen();
          Navigator.pushNamed(context, '/homePage');
        } else {
          _controller.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Icon(Icons.arrow_forward, color: Colors.white),
    );
  }
}
