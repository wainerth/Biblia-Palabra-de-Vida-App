import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // _initializeCatalogues();
    });
  }

  // void _initializeCatalogues() async {
  //   final catalogueProvider =
  //       Provider.of<CatalogueProvider>(context, listen: false);
  //   catalogueProvider.initialize();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      BackgroundImages(
                        backImages: ['assets/start.png', 'assets/nube.png'],
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 45,
                          ),
                          Center(
                            child: Container(
                              constraints: BoxConstraints(
                                  maxHeight:
                                      StylesApp(context).sizeImgLogin.height,
                                  minHeight:
                                      StylesApp(context).sizeImgLogin.height),
                              child: Image.asset(
                                "assets/bibleLogo.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextWithGradient(
                    text: "REGISTRA UNA\n CUENTA GRATIS",
                    font: StylesApp(context).textWithGradient,
                  ),
                  const SizedBox(
                    height: 53,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        ButtonThemeWidget(
                          text: "Crear una cuenta",
                          buttonStyle: StylesApp(context).btnPrimary,
                          onPressed: () {
                            Navigator.pushNamed(context, '/registerPage');
                          },
                          width: StylesApp(context).btnHeight.width,
                          height: StylesApp(context).btnHeight.height,
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        ButtonThemeWidget(
                          text: "Iniciar Sesión",
                          buttonStyle: StylesApp(context).btnSecondary,
                          onPressed: () {
                            Navigator.pushNamed(context, '/loginPage');
                          },
                          width: StylesApp(context).btnHeight.width,
                          height: StylesApp(context).btnHeight.height,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              left: 16,
              child: Align(
                alignment: Alignment.bottomRight,
                child: TweenAnimationBuilder<double>(
                  duration:
                      const Duration(seconds: 1), // Duration of the animation
                  tween: Tween(begin: 1.0, end: 1.1), // Scale from 1.0 to 1.1
                  curve: Curves.easeInOut, // Use curve directly here
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/introPage');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.transparent, // Transparent background
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Ver intro',
                          style: StylesApp(context).textStyleBody5,
                        ),
                      ),
                    );
                  },
                  onEnd: () {
                    setState(() {});
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
