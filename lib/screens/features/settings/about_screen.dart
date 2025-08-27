import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12CBC4),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.white,
        // actions: [
        //   Image.asset(
        //     "assets/kawaii_fire.png",
        //     height: 52.0,
        //     fit: BoxFit.contain,
        //   )
        // ],
      ),

      //  AppBar(
      //   backgroundColor: Colors.white,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: Color(0xFF12CBC4)),
      //     onPressed: () => Navigator.pop(context),
      //   ),
      //   title: const Text(
      //     'Acerca de',
      //     style: TextStyle(
      //       color: Color(0xFFFF914D),
      //       fontFamily: 'LuckiestGuy',
      //       fontSize: 28,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   centerTitle: true,
      // ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage("assets/elipsisTop.png"),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo o imagen de la app
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/icon.png', // Cambia por el logo de tu app
                      width: 70,
                      height: 70,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Biblia Palabra de Vida',
                    style: TextStyle(
                      color: Color(0xFFFF914D),
                      fontFamily: 'LuckiestGuy',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Versión 1.0.0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  12.0),
              child: const Divider(color: Colors.white, thickness: 1),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:  12.0),
              child: const Text(
                'Esta aplicación fue creada para ayudarte a estudiar y compartir la Palabra de Dios de manera interactiva y divertida.\n\nDesarrollada por el equipo de Biblia Palabra de Vida.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:  12.0),
              child: const Divider(color: Colors.white, thickness: 1),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:  12.0),
              child: const Text(
                'Contacto: bibliaapp@ejemplo.com',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),
            const Spacer(),
            const Text(
              '© 2025 Biblia Palabra de Vida',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontFamily: 'Montserrat',
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
