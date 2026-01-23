import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoubtScreen extends StatelessWidget {
  const DoubtScreen({super.key});

  // Método para detectar si es tablet
  bool _isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = _isTablet(context);

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
                fontSize: isTablet ? 24 : 20,
              ),
        ),
      ),
      body: SafeArea(
        child: isTablet
            ? _buildTabletLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  // Layout para móvil (manteniendo el diseño original)
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
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
          GestureDetector(
            onTap: () async {
              final Uri emailLaunchUri = Uri(
                scheme: 'mailto',
                path: GraphQLConfig.emailContact,
                queryParameters: {
                  'subject': 'Consulta - Biblia Palabra de Vida',
                  'body': 'Hola, tengo una consulta sobre la aplicación:',
                },
              );

              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No se pudo abrir la aplicación de correo'),
                  ),
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '¿No encontraste tu respuesta? Escríbenos a ${GraphQLConfig.emailContact}',
                textAlign: TextAlign.center,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: Colors.white70,
                      fontFamily: 'Montserrat',
                      decoration: TextDecoration.underline,
                    ),
              ),
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
    );
  }

  // Layout para tablet con header en izquierda y grid de dudas en derecha
  Widget _buildTabletLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Columna izquierda: Header, título y contacto (40% del ancho)
          SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.4,
              padding: const EdgeInsets.only(right: 30, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Encabezado con imagen de fondo
                  Container(
                    // height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage("assets/elipsisTop.png"),
                        fit: BoxFit.cover,
                        alignment: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.help_outline,
                            size: 80,
                            color: StyleColor.orange,
                          ),
                        ),
                        Text(
                          '¿Tienes dudas?',
                          style: StylesApp(context).textStyleBody24.copyWith(
                                color: Color(0xFFFF914D),
                                fontFamily: 'LuckiestGuy',
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
            
                  // Texto descriptivo
                  Text(
                    'Aquí ALgunas de las preguntas más frecuentes sobre la app y su uso.',
                    textAlign: TextAlign.center,
                    style: StylesApp(context).textStyleBody18.copyWith(
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                        ),
                  ),
                  const SizedBox(height: 30),
            
                  // Botón de contacto
                  _buildContactButton(context),
                  const SizedBox(height: 20),
            
                  // Información de contacto adicional
                  GestureDetector(
                    onTap: () async {
                      final Uri emailLaunchUri = Uri(
                        scheme: 'mailto',
                        path: GraphQLConfig.emailContact,
                        queryParameters: {
                          'subject': 'Consulta - Biblia Palabra de Vida',
                          'body': 'Hola, tengo una consulta sobre la aplicación:',
                        },
                      );
            
                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('No se pudo abrir la aplicación de correo'),
                          ),
                        );
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          'O escríbenos a:',
                          textAlign: TextAlign.center,
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: Colors.white70,
                                fontFamily: 'Montserrat',
                              ),
                        ),
                        // const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.only(
                              bottom: 4), // Espacio entre texto y línea
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.white70,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          GraphQLConfig.emailContact,
                          textAlign: TextAlign.center,
                          style: StylesApp(context).textStyleBody14.copyWith(
                                color: Colors.white70,
                                fontFamily: 'Montserrat',
                              ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
            
                  // Copyright
                  Text(
                    '© 2025 Biblia Palabra de Vida',
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Montserrat',
                        ),
                  ),
                ],
              ),
            ),
          ),

          // Columna derecha: Grid de dudas (60% del ancho)
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 30, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preguntas Frecuentes',
                    style: StylesApp(context).textStyleBody24.copyWith(
                          color: Colors.white,
                          fontFamily: 'LuckiestGuy',
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white, thickness: 1),
                  const SizedBox(height: 30),

                  // Grid de dudas (2 columnas)
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.2,
                      children: [
                        _buildQuestionCard(
                          context,
                          question: '¿Cómo puedo buscar un versículo?',
                          answer:
                              'En la pantalla principal, Ingresas a la opción de la Biblia y el los iconos de la parte superior donde esta la lupa ...\n Encontraras las opciones que te permiten moverte sobre los Versiones, libros capítulos y versículos, ademas de acceder, a la sección de enseñanzas, y personajes...',
                        ),
                        _buildQuestionCard(
                          context,
                          question: '¿Puedo leer la Biblia sin conexión?',
                          answer:
                              'No,necesitas estar conectado a internet, para poder acceder a las funcionalidades de la Biblia',
                        ),
                        _buildQuestionCard(
                          context,
                          question: '¿Cómo puedo cambiar el tema de la app?',
                          answer:
                              'Solo puedes cambiar el tema de colores en la sección de la Biblia. \n Ve a la biblia usas el icono de personalización y selecciona el tema que prefieras: claro, oscuro o personalizado. \n Ademas puedes cambiar el tipo de fuente, ajustar el tamaño de la fuente, estos\n datos permanecen guardados dentro del store de la aplicación',
                        ),
                        _buildQuestionCard(
                          context,
                          question:
                              '¿Dónde puedo enviar sugerencias o reportar errores?',
                          answer:
                              'a traves del correo Electrónico, que encuentras en configuración "acerca de la app", puedes enviarnos tus sugerencias o reportar cualquier inconveniente.',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget para tarjeta de pregunta en grid (tablet)
  Widget _buildQuestionCard(
    BuildContext context, {
    required String question,
    required String answer,
  }) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          collapsedIconColor: Colors.white,
          iconColor: StyleColor.orange,
          title: Text(
            question,
            style: StylesApp(context).textStyleBody16.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                answer,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: Colors.white70,
                      fontFamily: 'Montserrat',
                      fontSize: 16,
                      height: 1.5,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para botón de contacto en tablet
  Widget _buildContactButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: GraphQLConfig.emailContact,
          queryParameters: {
            'subject': 'Consulta - Biblia Palabra de Vida',
            'body': 'Hola, tengo una consulta sobre la aplicación:',
          },
        );

        if (await canLaunchUrl(emailLaunchUri)) {
          await launchUrl(emailLaunchUri);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('No se pudo abrir la aplicación de correo'),
            ),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: StyleColor.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.email, size: 24),
          const SizedBox(width: 12),
          Text(
            'Contáctanos',
            style: StylesApp(context).textStyleBody18.copyWith(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion(BuildContext context,
      {required String question,
      required String answer,
      bool forTablet = false}) {
    return Container(
      margin: forTablet ? const EdgeInsets.only(bottom: 8) : null,
      decoration: forTablet
          ? BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      child: ExpansionTile(
        tilePadding: forTablet
            ? const EdgeInsets.symmetric(horizontal: 20, vertical: 8)
            : EdgeInsets.zero,
        collapsedIconColor: Colors.white,
        iconColor: StyleColor.orange,
        title: Text(
          question,
          style: StylesApp(context).textStyleBody16.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontFamily: 'Montserrat',
                fontSize: forTablet ? 18 : 16,
              ),
        ),
        children: [
          Padding(
            padding: forTablet
                ? const EdgeInsets.all(20.0)
                : const EdgeInsets.only(bottom: 12.0, left: 8, right: 8),
            child: Text(
              answer,
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: Colors.white70,
                    fontFamily: 'Montserrat',
                    fontSize: forTablet ? 16 : 14,
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
