import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/authentication_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: ResponsiveLayout(
                mobile: _buildMobileLayout(translationProvider),
                tablet: _buildTabletLayout(translationProvider),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 16,
              child: Align(
                alignment: Alignment.bottomRight,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(seconds: 1),
                  tween: Tween(begin: 1.0, end: 1.1),
                  curve: Curves.easeInOut,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/introPage');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                              color: Colors.transparent,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          translationProvider.tr('home_screen.view_intro'),
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

  // Layout para móviles (una columna)
  Widget _buildMobileLayout(AppTranslationProvider translationProvider) {
    return Column(
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
                const SizedBox(
                  height: 45,
                ),
                Center(
                  child: Container(
                    constraints: BoxConstraints(
                        maxHeight: StylesApp(context).sizeImgLogin.height,
                        minHeight: StylesApp(context).sizeImgLogin.height),
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
          text: translationProvider.tr("home_screen.register_free_account"),
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
                text: translationProvider.tr('home_screen.create_account'),
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
                text: translationProvider.tr('home_screen.login'),
                buttonStyle: StylesApp(context).btnSecondary,
                onPressed: () {
                  Navigator.pushNamed(context, '/loginPage');
                },
                width: StylesApp(context).btnHeight.width,
                height: StylesApp(context).btnHeight.height,
              ),
              const SizedBox(height: 28),
              ButtonThemeWidget(
                textWithImage: true,
                image: "assets/google-icon.png",
                text: translationProvider.tr('home_screen.sign_up_google'),
                textStyle: StylesApp(context).buttonTextStyle,
                buttonStyle: StylesApp(context).btnTransparentSmall,
                onPressed: () async {
                  final authProvider = context.read<AuthenticationProvider>();
                  LoadingService().showLoading(context);
                  final user = await authProvider.loginWithGoogle(context);

                  if (user.error != null) {
                    LoadingService().hideLoading();
                    await showCustomDialog(context,
                        message: user.userFriendlyError ?? '',
                        messageDetail: user.error ??
                            translationProvider
                                .tr('home_screen.sign_up_google'),
                        showDetails: true,
                        dialogType: DialogType.error);
                  } else {
                    LoadingService().hideLoading();
                    if (!mounted) return;
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/layoutPage', (route) => false);
                  }
                },
                width: isTablet(context)
                    ? StylesApp(context).formWidth
                    : StylesApp(context).btnHeight.width,
                height: StylesApp(context).btnHeight.height,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }

  // Layout para tablets (dos columnas)
  Widget _buildTabletLayout(AppTranslationProvider translationProvider) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Columna izquierda: Imagen y gráficos
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      BackgroundImages(
                        backImages: ['assets/start.png', 'assets/nube.png'],
                      ),
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(height: 45),
                            Center(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxHeight:
                                      StylesApp(context).sizeImgLogin.height,
                                  minHeight:
                                      StylesApp(context).sizeImgLogin.height,
                                ),
                                child: Image.asset(
                                  "assets/bibleLogo.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 40.0),

            // Columna derecha: Texto y botones
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextWithGradient(
                    text: translationProvider
                        .tr('home_screen.register_free_account'),
                    font: StylesApp(context).textWithGradient,
                  ),
                  const SizedBox(height: 53),
                  Column(
                    children: [
                      ButtonThemeWidget(
                        text: translationProvider
                            .tr('home_screen.create_account'),
                        buttonStyle: StylesApp(context).btnPrimary,
                        onPressed: () {
                          Navigator.pushNamed(context, '/registerPage');
                        },
                        width: StylesApp(context).btnHeight.width * 0.45,
                        height: StylesApp(context).btnHeight.height,
                      ),
                      const SizedBox(height: 28),
                      ButtonThemeWidget(
                        text: translationProvider.tr('home_screen.login'),
                        buttonStyle: StylesApp(context).btnSecondary,
                        onPressed: () {
                          Navigator.pushNamed(context, '/loginPage');
                        },
                        width: StylesApp(context).btnHeight.width * 0.45,
                        height: StylesApp(context).btnHeight.height,
                      ),
                      const SizedBox(height: 28),
                      ButtonThemeWidget(
                        textWithImage: true,
                        image: "assets/google-icon.png",
                        text: translationProvider
                            .tr('home_screen.sign_up_google'),
                        textStyle: StylesApp(context).buttonTextStyle,
                        buttonStyle: StylesApp(context).btnTransparentSmall,
                        onPressed: () async {
                          final authProvider =
                              context.read<AuthenticationProvider>();
                          LoadingService().showLoading(context);
                          final user =
                              await authProvider.loginWithGoogle(context);

                          if (user.error != null) {
                            LoadingService().hideLoading();
                            await showCustomDialog(context,
                                message: user.userFriendlyError ?? '',
                                messageDetail: user.error ??
                                    translationProvider
                                        .tr('home_screen.sign_up_google'),
                                showDetails: true,
                                dialogType: DialogType.error);
                          } else {
                            LoadingService().hideLoading();
                            if (!mounted) return;
                            Navigator.pushNamedAndRemoveUntil(
                                context, '/layoutPage', (route) => false);
                          }
                        },
                        width: StylesApp(context).btnHeight.width * 0.45,
                        height: StylesApp(context).btnHeight.height,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
