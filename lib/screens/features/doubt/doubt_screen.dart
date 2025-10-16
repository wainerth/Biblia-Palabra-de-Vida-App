import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

class DoubtScreen extends StatelessWidget {
  const DoubtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12CBC4),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
            foregroundColor: WidgetStatePropertyAll(StyleColor.white),
          ),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pushNamed(context, "/layoutPage");
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.white,
        title: Text(
          'Dudas Frecuentes',
          style: StylesApp(context).textStyleBody20.copyWith(
                color: StyleColor.orange,
                fontFamily: 'LuckiestGuy',
                fontSize: 20,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    CircleAvatar(
                      radius: 48,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.help_outline,
                        size: 50,
                        color: StyleColor.orange,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      '¿Tienes dudas?',
                      style: StylesApp(context).textStyleBody24.copyWith(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Aquí ALgunas de las preguntas más frecuentes sobre la app y su uso.',
                  textAlign: TextAlign.center,
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: const Divider(color: Colors.white, thickness: 1),
              ),
              const SizedBox(height: 16),
              // Preguntas frecuentes
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    _buildQuestion(
                      context,
                      question: '¿Cómo puedo buscar un versículo?',
                      answer:
                          'En la pantalla principal, Ingresas a la opción de la Biblia y el los iconos de la parte superior donde esta la lupa ...\n Encontraras las opciones que te permiten moverte sobre los Versiones, libros capítulos y versículos, ademas de acceder, a la sección de enseñanzas, y personajes...',
                    ),
                    _buildQuestion(
                      context,
                      question: '¿Puedo leer la Biblia sin conexión?',
                      answer:
                          'No,necesitas estar conectado a internet, para poder acceder a las funcionalidades de la Biblia',
                    ),
                    _buildQuestion(
                      context,
                      question: '¿Cómo puedo cambiar el tema de la app?',
                      answer:
                          'Solo puedes cambiar el tema de colores en la sección de la Biblia. \n Ve a la biblia usas el icono de personalización  y selecciona el tema que prefieras: claro, oscuro o personalizado. \n Ademas puedes cambiar el tipo de fuente, ajustar el tamaño de la fuente, estos\n datos permanecen guardados dentro del store de la aplicación',
                    ),
                    _buildQuestion(
                      context,
                      question:
                          '¿Dónde puedo enviar sugerencias o reportar errores?',
                      answer:
                          'a traves del correo Electrónico, que encuentras en configuración "acerca de la app", puedes enviarnos tus sugerencias o reportar cualquier inconveniente.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: const Divider(color: Colors.white, thickness: 1),
              ),
              const SizedBox(height: 16),
              Text(
                '¿No encontraste tu respuesta? Escríbenos a devidapalabra25@gmail',
                textAlign: TextAlign.center,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: Colors.white70,
                      fontFamily: 'Montserrat',
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                '© 2025 Biblia Palabra de Vida',
                style: StylesApp(context).textStyleBody10.copyWith(
                      color: Colors.white70,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                    ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuestion(BuildContext context,
      {required String question, required String answer}) {
    return ExpansionTile(
      tilePadding: EdgeInsets.zero,
      collapsedIconColor: Colors.white,
      iconColor: StyleColor.orange,
      title: Text(
        question,
        style: StylesApp(context).textStyleBody16.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12.0, left: 8, right: 8),
          child: Text(
            answer,
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: Colors.white70,
                  fontFamily: 'Montserrat',
                ),
          ),
        ),
      ],
    );
  }
}
