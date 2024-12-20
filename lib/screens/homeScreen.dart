import 'package:biblia_palabra_de_vida_app/themes/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  @override
  Widget build(BuildContext context) {
    TextStyle buttonTextStyle = GoogleFonts.getFont(
      "Aclonica",
      fontSize: 20,
    );

    return Stack(children: [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                child: Image.asset(
                  "/bibleLogo.png",
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                height: 21,
              ),
              Container(
                child: TextWithGradient(
                  text: "CREA UNA CUENTA GRATIS",
                  font: TextStylesApp(context).textWhithGradient,
                ),
              ),
              const SizedBox(
                height: 53,
              ),
              Container(
                width: double.infinity,
                child: Column(
                  children: [
                    TextButton(
                      onPressed: () {},
                      style: TextStylesApp(context).btnPrimary,
                      child: const Text("Crea una cuenta"),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/loginPage');
                      },
                      style: TextStylesApp(context).btnSecondary,
                      child: const Text("Iniciar Sesion"),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 67.0,
              ),
              Container(
                child: TextButton(
                  onPressed: () {},
                  style: TextStylesApp(context).btnTertiary,
                  child: const Text("Leer la Biblia"),
                ),
              )
            ],
          ),
        ),
      ),
      
      Positioned(
  bottom: 8,
  left: 16,
  child: Align(
    alignment: Alignment.bottomRight,
    child: TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 1), // Duration of the animation
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
              backgroundColor: Colors.transparent, // Transparent background
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

    ],);
  }
}
