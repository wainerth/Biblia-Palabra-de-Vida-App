import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // decoration: BoxDecoration(
        //         color: Colors.amber

        //       ),
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
                          Container(
                            constraints: const BoxConstraints(
                                maxHeight: 304, minHeight: 304),
                            child: Image.asset(
                              "assets/bibleLogo.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // const SizedBox(
                  //   height: 21,
                  // ),
                  TextWithGradient(
                    text: "REGISTRA UNA CUENTA GRATIS",
                    font: StylesApp(context).textWithGradient,
                  ),
                  const SizedBox(
                    height: 53,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/registerPage');
                            },
                            style: StylesApp(context).btnPrimary,
                            child: const Text("Crea una cuenta"),
                          ),
                        ),
                        const SizedBox(
                          height: 28,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                offset: const Offset(0, 4),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/loginPage');
                            },
                            style: StylesApp(context).btnSecondary,
                            child: const Text("Iniciar Sesión"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(
                  //   height: 67.0,
                  // ),
                ],
              ),
            ),
            Positioned(
              bottom: 8,
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
                        child: const Text(
                          'Ver intro',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                  onEnd: () {
                    // No need to handle `onEnd` since TweenAnimationBuilder loops implicitly
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
