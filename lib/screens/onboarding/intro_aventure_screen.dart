import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
    // final bool _isTablet = isTablet(context);
    final translationProvider = context.read<AppTranslationProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            HeaderWidget(),
            Expanded(
              child: ResponsiveLayout(
                  mobile: _buildMobileIntroSlide(context, translationProvider),
                  tablet: _buildTabletIntroSlide(context, translationProvider)),
            ),
          ],
        ),
      ),
    );
  }

  // VERSIÓN TABLET con 2 columnas
  Widget _buildTabletIntroSlide(
      BuildContext context, AppTranslationProvider translationProvider) {
    return Row(
      children: [
        // COLUMNA IZQUIERDA: Imagen y texto
        Expanded(
          flex: 3,
          child: _buildTabletLeftColumn(context, translationProvider),
        ),
        // COLUMNA DERECHA: Sugerencias
        Expanded(
          flex: 2,
          child: _buildTabletRightColumn(context, translationProvider),
        ),
      ],
    );
  }

  // Columna izquierda (contenido principal)
  Widget _buildTabletLeftColumn(
      BuildContext context, AppTranslationProvider translationProvider) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _isLastPage = index == 3;
              });
            },
            children: [
              _buildTabletPage(context, "assets/IntroTablet.png", "",
                  translationProvider.tr('intro_adventure.step_1_title'),translationProvider),
              _buildTabletPage(context, "assets/IntroTablet.png", "1",
                  translationProvider.tr('intro_adventure.step_2_title'),translationProvider),
              _buildTabletPage(context, "assets/IntroTablet.png", "2",
                  translationProvider.tr('intro_adventure.step_3_title'),translationProvider),
              _buildTabletPage(context, "assets/IntroTablet.png", "3",
                  translationProvider.tr('intro_adventure.step_4_title'),translationProvider),
            ],
          ),
        ),

        // Controles inferiores
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                // Indicador de páginas
                SmoothPageIndicator(
                  controller: _controller,
                  count: 4,
                  effect: const WormEffect(
                    activeDotColor: StyleColor.blueHigh,
                    dotColor: Colors.grey,
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 8,
                  ),
                ),
                const SizedBox(height: 20),

                // Botones de navegación
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Botón omitir
                    if (!_isLastPage)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/layoutPage1');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                                color:
                                    StyleColor.blueHigh.withValues(alpha: 0.8)),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          translationProvider.tr('intro_adventure.skip'),
                          style: StylesApp(context)
                              .textStyleBody12
                              .copyWith(color: StyleColor.blueHigh),
                        ),
                      )
                    else
                      const SizedBox(width: 100),

                    // Botón siguiente/iniciar
                    ElevatedButton(
                      onPressed: () {
                        if (_isLastPage) {
                          Navigator.pushNamed(context, '/layoutPage1');
                        } else {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 14),
                        backgroundColor: _isLastPage
                            ? StyleColor.blueHigh
                            : Colors.white.withValues(alpha: 0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                      ),
                      child: _isLastPage
                          ? Text(
                              translationProvider
                                  .tr('intro_adventure.start_adventure').toUpperCase(),
                              style:
                                  StylesApp(context).textStyleBody12.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  translationProvider
                                      .tr('intro_adventure.next'),
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(
                                        color: StyleColor.blueHigh,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward,
                                  color: StyleColor.blueHigh,
                                  size: 20,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Columna derecha (sugerencias)
  Widget _buildTabletRightColumn(
      BuildContext context, AppTranslationProvider translationProvider) {
    final suggestions = [
      {
        'icon': Icons.lightbulb_outline,
        'title': translationProvider.tr('intro_adventure.tip_1.title'),
        'description':
            translationProvider.tr('intro_adventure.tip_1.description'),
        'color': Colors.amber,
      },
      {
        'icon': Icons.star_border,
        'title': translationProvider.tr('intro_adventure.tip_2.title'),
        'description':
            translationProvider.tr('intro_adventure.tip_2.description'),
        'color': Colors.blue,
      },
      {
        'icon': Icons.track_changes,
        'title': translationProvider.tr('intro_adventure.tip_3.title'),
        'description':
            translationProvider.tr('intro_adventure.tip_3.description'),
        'color': Colors.green,
      },
      {
        'icon': Icons.group,
        'title': translationProvider.tr('intro_adventure.tip_4.title'),
        'description':
            translationProvider.tr('intro_adventure.tip_4.description'),
        'color': Colors.purple,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            StyleColor.blueHigh.withValues(alpha: 0.1),
            StyleColor.blueHigh.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Text(
            translationProvider.tr('intro_adventure.suggestions_title'),
            style: StylesApp(context).textStyleBody20.copyWith(
                  color: StyleColor.blueHigh,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            translationProvider.tr('intro_adventure.suggestions_subtitle'),
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: Colors.grey[700],
                ),
          ),
          const SizedBox(height: 40),

          // Lista de sugerencias CON SCROLL
          Expanded(
            // <-- El Expanded DEBE estar aquí, no dentro del ListView
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Lista de sugerencias
                  ListView.separated(
                    shrinkWrap: true, // <-- IMPORTANTE: shrinkWrap
                    physics:
                        const NeverScrollableScrollPhysics(), // <-- Deshabilitar scroll interno
                    itemCount: suggestions.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 20),
                    itemBuilder: (context, index) {
                      final suggestion = suggestions[index];
                      return _buildSuggestionCard(
                        context,
                        icon: suggestion['icon'] as IconData,
                        title: suggestion['title'] as String,
                        description: suggestion['description'] as String,
                        color: suggestion['color'] as Color,
                      );
                    },
                  ),

                  // Consejo adicional
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: StyleColor.blueHigh.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: StyleColor.blueHigh.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.psychology_outlined,
                          color: StyleColor.blueHigh,
                          size: 24,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            translationProvider
                                .tr('intro_adventure.additional_tip'),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.blueHigh,
                                  fontStyle: FontStyle.italic,
                                ),
                          ),
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

  // Tarjeta de sugerencia individual
  Widget _buildSuggestionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icono
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),

          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: StylesApp(context).textStyleBody14.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: Colors.grey[700],
                        height: 1.4,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Página para Tablet
  Widget _buildTabletPage(BuildContext context, String imageUrl, String number,
      String text, AppTranslationProvider translationProvider) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Número de paso (si existe)
            if (number.isNotEmpty)
              Container(
                width: 50,
                height: 50,
                margin: const EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  color: StyleColor.orange,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

            // Título/texto principal
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: 500,
                ),
                child: Text(
                  text,
                  maxLines: 3,
                  style: StylesApp(context).textStyleTitle.copyWith(
                        color: StyleColor.orange,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                ),
              ),
            ),

            // Contador de pasos
            if (number.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  '${translationProvider.tr('intro_adventure.step')} ${int.parse(number) + 1} ${ translationProvider.tr('intro_adventure.of')} 4',
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // VERSIÓN MÓVIL (original)
  Widget _buildMobileIntroSlide(
      BuildContext context, AppTranslationProvider translationProvider) {
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
              _buildMobilePage(context, "assets/layerIntro.png", "",
              translationProvider.tr('intro_adventure.step_1_title_mobile')
                  ),
              _buildMobilePage(context, "assets/layerIntro.png", "1",
                  translationProvider.tr('intro_adventure.step_2_title_mobile')),
              _buildMobilePage(context, "assets/layerIntro.png", "2",
                  translationProvider.tr('intro_adventure.step_3_title_mobile')),
              _buildMobilePage(context, "assets/finalIntro.png", "3",
                  translationProvider.tr('intro_adventure.step_4_title_mobile')),
            ],
          ),
        ),
        if (!_isLastPage)
          Positioned(
            top: 10,
            right: 16,
            child: _buildSkipButton(context, translationProvider),
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
          child: _buildNextButton(context, translationProvider),
        ),
      ],
    );
  }

  // Página para Móvil (original)
  Widget _buildMobilePage(
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
                    if (number.isNotEmpty)
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

  // Botón omitir para Móvil (original)
  Widget _buildSkipButton(BuildContext context, AppTranslationProvider translationProvider) {
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
        translationProvider.tr('intro_adventure.skip_intro'),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
        ),
      ),
    );
  }

  // Botón siguiente para Móvil (original)
  Widget _buildNextButton(BuildContext context, AppTranslationProvider translationProvider) {
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
        backgroundColor: _isLastPage ? StyleColor.blueHigh : Colors.transparent,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: _isLastPage
          ? Text(
             translationProvider.tr('intro_adventure.start_adventure_mobile'),
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
