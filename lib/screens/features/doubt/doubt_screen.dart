import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DoubtScreen extends StatelessWidget {
  const DoubtScreen({super.key});

  // Método para determinar la acción del botón de retroceso
  void _handleBackButton(BuildContext context) {
    final bool canPop = Navigator.canPop(context);

    if (canPop) {
      Navigator.pop(context);
    } else {
      Navigator.pushNamed(context, "/layoutPage");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool _isTablet = isTablet(context);
    final translationProvider = context.read<AppTranslationProvider>();

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
            _handleBackButton(context);
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
          translationProvider.tr('doubts.title'),
          style: StylesApp(context).textStyleBody20.copyWith(
                color: StyleColor.orange,
                fontFamily: 'LuckiestGuy',
                fontSize: _isTablet ? 24 : 20,
              ),
        ),
      ),
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(context),
          tablet: _buildTabletLayout(context),
        ),
      ),
    );
  }

  // Layout para móvil (manteniendo el diseño original)
  Widget _buildMobileLayout(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

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
                  translationProvider.tr('doubts.have_doubts'),
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
              translationProvider.tr('doubts.description'),
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
                  question: translationProvider.tr('doubts.question_1'),
                  answer: translationProvider.tr('doubts.answer_1'),
                ),
                _buildQuestion(
                  context,
                  question: translationProvider.tr('doubts.question_2'),
                  answer: translationProvider.tr('doubts.answer_2'),
                ),
                _buildQuestion(
                  context,
                  question: translationProvider.tr('doubts.question_3'),
                  answer: translationProvider.tr('doubts.answer_3'),
                ),
                _buildQuestion(
                  context,
                  question: translationProvider.tr('doubts.question_4'),
                  answer: translationProvider.tr('doubts.answer_4'),
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
                path: ApiConfig.emailContact,
                queryParameters: {
                  'subject': translationProvider.tr('doubts.email_subject'),
                  'body': translationProvider.tr('doubts.email_body'),
                },
              );

              if (await canLaunchUrl(emailLaunchUri)) {
                await launchUrl(emailLaunchUri);
              } else {
                showSnackBar(translationProvider.tr('doubts.email_error'),
                    type: SnackBarType.error);
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '${translationProvider.tr('doubts.not_found_answer')} ${ApiConfig.emailContact}',
                textAlign: TextAlign.center,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: Colors.white70,
                      fontFamily: 'Montserrat',
                      textBaseline: TextBaseline.alphabetic,
                      decoration: TextDecoration.underline,
                      decorationColor: StyleColor.white,
                      decorationStyle: TextDecorationStyle.solid,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            translationProvider.tr('doubts.copyright'),
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
    final translationProvider = context.read<AppTranslationProvider>();

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
                          translationProvider.tr('doubts.have_doubts'),
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
                    translationProvider.tr('doubts.description'),
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
                        path: ApiConfig.emailContact,
                        queryParameters: {
                          'subject':
                              translationProvider.tr('doubts.email_subject'),
                          'body': translationProvider.tr('doubts.email_body'),
                        },
                      );

                      if (await canLaunchUrl(emailLaunchUri)) {
                        await launchUrl(emailLaunchUri);
                      } else {
                        showSnackBar(
                            translationProvider.tr('doubts.email_error'),
                            type: SnackBarType.error);
                      }
                    },
                    child: Column(
                      children: [
                        Text(
                          translationProvider.tr('doubts.or_write_to'),
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
                          ApiConfig.emailContact,
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
                    translationProvider.tr('doubts.copyright'),
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
                    translationProvider.tr('doubts.frequent_questions'),
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
                          question: translationProvider.tr('doubts.question_1'),
                          answer: translationProvider.tr('doubts.answer_1'),
                        ),
                        _buildQuestionCard(
                          context,
                          question: translationProvider.tr('doubts.question_2'),
                          answer: translationProvider.tr('doubts.answer_2'),
                        ),
                        _buildQuestionCard(
                          context,
                          question: translationProvider.tr('doubts.question_3'),
                          answer: translationProvider.tr('doubts.answer_3'),
                        ),
                        _buildQuestionCard(
                          context,
                          question: translationProvider.tr('doubts.question_4'),
                          answer: translationProvider.tr('doubts.answer_4'),
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
          color: Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border:
              Border.all(color: Colors.white.withValues(alpha: 0.2), width: 1),
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
    final translationProvider = context.read<AppTranslationProvider>();

    return ElevatedButton(
      onPressed: () async {
        final Uri emailLaunchUri = Uri(
          scheme: 'mailto',
          path: ApiConfig.emailContact,
          queryParameters: {
            'subject': translationProvider.tr('doubts.email_subject'),
            'body': translationProvider.tr('doubts.email_body'),
          },
        );

        if (await canLaunchUrl(emailLaunchUri)) {
          await launchUrl(emailLaunchUri);
        } else {
          showSnackBar(translationProvider.tr('doubts.email_error'),
              type: SnackBarType.error);
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
            translationProvider.tr('doubts.contact_us'),
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
              color: Colors.white.withValues(alpha: 0.1),
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
            child: _buildFormattedText(
              context,
              text: answer,
              forTablet: forTablet,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormattedText(BuildContext context,
      {required String text, required bool forTablet}) {
    final RegExp regex = RegExp(r'\*(.*?)\*');
    final List<TextSpan> spans = [];
    int currentIndex = 0;

    final baseStyle = StylesApp(context).textStyleBody14.copyWith(
          color: Colors.white70,
          fontFamily: 'Montserrat',
          fontSize: forTablet ? 16 : 14,
          height: 1.5,
        );

    final boldStyle = baseStyle.copyWith(
      fontWeight: FontWeight.bold,
      color: Colors.white, // Opcional: un poco más brillante para la negrita
    );

    // Encontrar todas las coincidencias
    final matches = regex.allMatches(text);

    for (final match in matches) {
      // Texto normal antes de la negrita
      if (match.start > currentIndex) {
        spans.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
            style: baseStyle,
          ),
        );
      }

      // Texto en negrita (sin los asteriscos)
      spans.add(
        TextSpan(
          text: match.group(1),
          style: boldStyle,
        ),
      );

      currentIndex = match.end;
    }

    // Texto normal después de la última negrita
    if (currentIndex < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(currentIndex),
          style: baseStyle,
        ),
      );
    }

    // Si no hay asteriscos, mostrar texto normal
    if (spans.isEmpty) {
      return Text(
        text,
        style: baseStyle,
      );
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}
