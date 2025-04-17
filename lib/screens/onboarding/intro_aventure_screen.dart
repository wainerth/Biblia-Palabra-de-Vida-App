import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroAventureScreen extends StatefulWidget {
  const IntroAventureScreen({super.key});

  @override
  State<IntroAventureScreen> createState() => _IntroAventureScreenState();
}

class _IntroAventureScreenState extends State<IntroAventureScreen> {
  final PageController _controller = PageController();
  bool _isLastPage = false;
  bool hasSeenIntro = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(),
            Expanded(
              // Use Expanded to fill the remaining space
              child: _buildIntroSlide(context),
            ),
          ],
        ),
      ),
    );
  }

  _buildIntroSlide(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == 4;
                if (_controller.page! > 2.5) {
                  setState(() {
                    _isLastPage = true;
                  });
                } else {
                  setState(() {
                    _isLastPage = false;
                  });
                }
              });
            },
            children: [
              _buildPage(context, "assets/layerIntro.png", "",
                  "Sigue\n la\n ruta\n de la\n sabiduría"),
              _buildPage(context, "assets/layerIntro.png", "1",
                  "Selecciona\n el tema\n que\n quiere\n aprender"),
              _buildPage(context, "assets/layerIntro.png", "2",
                  "Inicia la\n aventura,\n completa\n y avanza en\n las etapas\n para conocer\n más de\n Dios"),
              _buildPage(context, "assets/finalIntro.png", "3",
                  "Sigue los\n pasos lee o\n escucha el\n contenido y\n responde las\n preguntas\n para sumar\n puntos de\n experiencia"),
            ],
          ),
        ),
        if (!_isLastPage)
          Positioned(
            top: 10,
            right: 16,
            child: _buildSkipButton(context),
          ),
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Center(
            child: SmoothPageIndicator(
              controller: _controller,
              count: 4,
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
    );
  }

  _buildPage(
      BuildContext context, String imageUrl, String number, String text) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imageUrl),
              fit: orientation == Orientation.landscape
                  ? BoxFit.contain
                  : BoxFit.fill,
            ),
          ),
          child: Stack(children: [
            Positioned(
              top: 40,
              left: 30,
              child: Text.rich(

                TextSpan(
                  children: [
                    if(number.isNotEmpty)
                    WidgetSpan(
                      child: Container(
                        width: 40.sp,
                        height: 40.sp,
                        decoration: BoxDecoration(
                          color: StyleColor.orange,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          number,
                          style: StylesApp(context)
                              .textStyleBody7
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: text,
                      style: StylesApp(context)
                          .textStyleBody28
                          .copyWith(color: StyleColor.orange),
                    )
                  ],
                ),
              ),
            )
          ]),
        );
      },
    );
  }

  Widget _buildSkipButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          hasSeenIntro = false;
          Navigator.pushNamed(context, '/layoutPage1');
        });
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(8.sp),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        'Omitir el Intro',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (_isLastPage) {
          setState(() {
            hasSeenIntro = false;
            Navigator.pushNamed(context, '/layoutPage1');
          });
        } else {
          if (_controller.page! >= 3) {
            setState(() {
              _isLastPage = true;
            });
          } else {
            _controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.ease,
            );
          }
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(8.sp),
        backgroundColor: _isLastPage ? Color(0XFF006AFF) : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLastPage
          ? Text(
              "Iniciar Aventura",
              style: StylesApp(context).textStyleBody7,
            )
          : Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 25.sp,
            ),
    );
  }
}
