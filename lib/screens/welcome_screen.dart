import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenIntro', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              controller: _controller,
              onPageChanged: (index) {
                setState(() => _isLastPage = index == 4);
              },
              children: [
                _buildPage(
                  image: '',
                  backImages: ['/start.png', '/nube.png'],
                  title: 'PALABRA\n de\n Vida',
                  subTitle: "¡La Biblia!",
                  description: 'La palabra de Dios cambiará tu vida.',
                ),
                _buildPage(
                  image: '/jesusImage.png',
                  subTitle: "¡Aventúrate en la historia sagrada!",
                  description:
                      'Explora los relatos bíblicos a través de historias.',
                ),
                _buildPage(
                  image: '/LionImage.png',
                  subTitle: "¡Conoce el libro\n más leído del mundo!",
                  description:
                      'Escudriña la palabra en sus diferentes versiones.',
                ),
                _buildPage(
                  image: '/angelImage.png',
                  subTitle: "¡Enriquece tu fe con\n la Biblia!",
                  description:
                      'Realiza un viaje por la Biblia logrando metas diarias.',
                ),
                const EndIntroScreen(),
              ],
            ),
          ),
          if (!_isLastPage)
            Positioned(
              bottom: 16,
              left: 16,
              child: _buildSkipButton(context),
            ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 5,
                effect: const WormEffect(
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: _buildNextButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    String image = '',
    List<String> backImages = const [],
    String title = '',
    String subTitle = '',
    required String description,
  }) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (backImages.isNotEmpty) _buildBackgroundImages(backImages),
      
          if(!backImages.isNotEmpty) const SizedBox(height: 130),
          _buildContent(image, title, subTitle, description),
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

  Widget _buildContent(
      String image, String title, String subTitle, String description) {
    final fontBody =
        GoogleFonts.alegreyaSansSc(fontSize: 32, color: Colors.white);

    return Container(
      constraints: BoxConstraints(
        minHeight: StylesApp(context).minHeightContentPage,
      ),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Text(MediaQuery.sizeOf(context).height.toString()),
          if (image.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 28.0),
              child: Image.asset(image,
                  width: MediaQuery.sizeOf(context).width,
                  height: 400.0,
                  alignment: Alignment.topCenter,
                  fit: BoxFit.contain),
            ),
          if (title.isNotEmpty)
            Center(
              child: TextWithGradient(
                text: title,
                font: StylesApp(context)
                    .textWithGradient
                    .copyWith(fontSize: StylesApp(context).fontSizeTitle),
              ),
            ),
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
      constraints: const BoxConstraints(minHeight: 200),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: const AssetImage("/backgroundBox.png"),
            fit: BoxFit.cover,
            alignment: Alignment.topCenter),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 23.0),
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
        if (_controller.page == 3) {
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
