import 'dart:async';

import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
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

  bool _isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final aspectRatio = size.width / size.height;
    final shortestSide = size.shortestSide;

    // Para Chrome, considera también el aspect ratio
    if (shortestSide > 600) return true;

    // Si el ancho es grande pero el aspect ratio es de desktop
    if (size.width > 800 && aspectRatio > 1.3) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = _isTablet(context);
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: isTablet ? 6 : 4,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: StyleColor.black)
              ),
              height: MediaQuery.sizeOf(context).height,
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() => _isLastPage = index == 4);
                },
                children: isTablet
                    ? _buildTabletPages() 
                    : _buildMobilePages(),
              ),
            ),
          ),
          _buildNavigationControls(isTablet: isTablet),
        ],
      )),
    );
  }

// ========== LAYOUT PARA TABLE ================
  List<Widget> _buildTabletPages() {
    return [
      _buildTabletPage(
        image: 'assets/jesusImage.png',
        backImages: ['assets/start.png', 'assets/nube.png'],
        title: 'PALABRA DE VIDA',
        subTitle: "¡La Biblia!",
        description: 'La palabra de dios \ncambiará tu vida.',
        verse:
            'Juan 8:32. "Y conoceréis la verdad y la verdad os hará libres".',
      ),
      _buildTabletPage(
        image: 'assets/jesusImage.png',
        subTitle: "¡Aventúrate en la historia sagrada!",
        description: 'Explora los relatos bíblicos a través de historias.',
        verse: '"Yo he venido para que tengas vida." - Jesús',
      ),
      _buildTabletPage(
        image: 'assets/LionImage.png',
        subTitle: "¡Conoce el libro más leído del mundo!",
        description: 'Escudriña la palabra en sus diferentes versiones.',
        verse:
            'Juan 8:32. "Y conoceréis la verdad y la verdad os hará libres".',
      ),
      _buildTabletPage(
        image: 'assets/angelImage.png',
        subTitle: "¡Enriquece tu fe con la Biblia!",
        description: 'Realiza un viaje por la Biblia logrando metas diarias.',
        verse: '"Yo he venido para que tengas vida." - Jesús',
      ),
      _buildTabletEndPage(), // Última página
    ];
  }

  Widget _buildTabletPage({
    required String image,
    List<String> backImages = const [],
    String title = '',
    required String subTitle,
    required String description,
    required String verse,
  }) {
    return Row(
      children: [
        // Columna izquierda - Imagen
        Expanded(
          flex: 5,
          child: _buildTabletImageSection(image: image, backImages: backImages),
        ),
    
        // Columna derecha - Contenido
        Expanded(
          flex: 6,
          child: _buildTabletContentSection(
            title: title,
            subTitle: subTitle,
            description: description,
            verse: verse,
          ),
        ),
      ],
    );
  }

  Widget _buildTabletImageSection({
    required String image,
    List<String> backImages = const [],
  }) {
    return Container(
      decoration: BoxDecoration(
        // border: Border.all( color:  StyleColor.black),
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [Colors.blue.shade100, Colors.lightBlue.shade200],
          // ),
          ),
      child: Stack(
        children: [
          if (backImages.isNotEmpty) _buildTabletBackgroundImages(backImages),
           Positioned(
            bottom: 40,
             child: Center(
              child: Image.asset(
                image,
                width: MediaQuery.sizeOf(context).width * 0.4,
                height: MediaQuery.sizeOf(context).height * 0.6,
                fit: BoxFit.contain,
              ),
                       ),
           ),
        ],
      ),
    );
  }

  Widget _buildTabletBackgroundImages(List<String> backImages) {
    return Stack(
      children: [
        if (backImages.length > 1)
          Positioned(
            left: 40,
            top: 80,
            child: Image.asset(
              backImages[1],
              height: 120,
              width: 120,
              fit: BoxFit.contain,
            ),
          ),
        Positioned(
          right: 40,
          bottom: 80,
          child: Image.asset(
            backImages[0],
            height: 150,
            width: 150,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildTabletContentSection({
    String title = '',
    required String subTitle,
    required String description,
    required String verse,
  }) {
    return Container(
      height: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (title.isNotEmpty) ...{
            TextWithGradient(
              text: title,
              font: StylesApp(context).textWithGradient,
            ),
          },
            const SizedBox(height: 40),
          _buildDescriptionTableBox(
              context,
              subTitle,
              description,
              StylesApp(context).textStyleTitle,
              StylesApp(context).textStyleTitleAlegra),
        ],
      ),
    );
  }

  Widget _buildTabletEndPage() {
    return const Row(
      children: [
        Expanded(
          child: EndIntroScreen(), // Tu pantalla final existente
        ),
      ],
    );
  }

// ========== PÁGINAS PARA MÓVIL (ORIGINAL) ==========
  List<Widget> _buildMobilePages() {
    return [
      LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildPage(
                image: '',
                backImages: ['assets/start.png', 'assets/nube.png'],
                title: 'palabra\n de\n Vida',
                subTitle: "¡La Biblia!",
                description: 'la palabra de dios cambiará tu vida.',
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
              _buildPage(
                image: 'assets/LionImage.png',
                subTitle: "¡Conoce el libro\n más leído del mundo!",
                description:
                    'Escudriña la palabra\n en sus diferentes versiones.',
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
    ];
  }

  Widget _buildDescriptionTableBox(BuildContext context, String subTitle,
      String description, TextStyle fontTitle, TextStyle fontBody) {
    return Container(
      // width: double.infinity,
      decoration: BoxDecoration(
        // border: Border.all( color:  StyleColor.black),
        image: DecorationImage(
          image: AssetImage("assets/backgroundBox.png"),
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: StylesApp(context).heightSpacing1,
          ),
          if (subTitle.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  subTitle,
                  textAlign: TextAlign.center,
                  style: fontTitle.copyWith(
                    color: Colors.white,
                    fontSize: StylesApp(context).fontSizeTitle,
                  ),
                ),
              ),
            ),
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.5,
              // minHeight: 200.0,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFFD8C43),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 24.0, horizontal: 24.0),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: fontBody.copyWith(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ========== CONTROLES DE NAVEGACIÓN ==========
  Widget _buildNavigationControls({required bool isTablet}) {
    return Expanded(
      flex: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 40.0 : 8.0,
          vertical: isTablet ? 10.0 : 0.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (!_isLastPage) _buildSkipButton(context, isTablet),
            if (_isLastPage) SizedBox(width: isTablet ? 60 : 40),
            Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 5,
                effect: WormEffect(
                  activeDotColor: Colors.blue,
                  dotColor: Colors.grey,
                  dotHeight: isTablet ? 12 : 8,
                  dotWidth: isTablet ? 12 : 8,
                  spacing: isTablet ? 16 : 8,
                ),
              ),
            ),
            _buildNextButton(context, isTablet),
          ],
        ),
      ),
    );
  }

  // ========== MÉTODOS ORIGINALES PARA MÓVIL ==========

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
    return SizedBox(
      height: constraints.maxHeight,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (title.isNotEmpty) ...{
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
          _buildDescriptionBox(
              context,
              subTitle,
              description,
              StylesApp(context).textStyleTitle,
              StylesApp(context).textStyleTitleAlegra),
        ],
      ),
    );
  }

  Widget _buildDescriptionBox(BuildContext context, String subTitle,
      String description, TextStyle fontTitle, TextStyle fontBody) {
    return Container(
      width: double.infinity,
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
          SizedBox(height: StylesApp(context).heightSpacing1),
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
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minHeight: 151.0),
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

  Widget _buildSkipButton(BuildContext context, bool isTablet) {
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
      child: Text(
        'Omitir',
        style: StylesApp(context).textStyleBody6.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context, bool isTablet) {
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
      child: Icon(
        Icons.arrow_forward,
        color: Colors.white,
        size: StylesApp(context).sizeBtn,
      ),
    );
  }

  _buildMobileLayout() {}
}
