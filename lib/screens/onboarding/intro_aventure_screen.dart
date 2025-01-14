import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderWidget(),
              _buildIntroSlide(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildIntroSlide(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height - 90.0,
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
              _buildPage(context, "assets/introAventureOne.png"),
              _buildPage(context, "assets/introAventureTwo.png"),
              _buildPage(context, "assets/introAventureThree.png"),
              _buildPage(context, "assets/introAventureFour.png"),
            ],
          ),
        ),
        if (!_isLastPage)
          Positioned(
            top: 0,
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

  _buildPage(BuildContext context, String imageUrl) {
    return Image.asset(
      imageUrl,
      fit: BoxFit.fill,
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
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text(
        'Omitir el Intro',
        style: TextStyle(color: Colors.white),
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
          if (_controller.page! >= 2) {
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
          : const Icon(Icons.arrow_forward, color: Colors.white),
    );
  }
}
