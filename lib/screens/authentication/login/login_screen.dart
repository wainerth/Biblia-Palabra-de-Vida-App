import 'dart:convert';

import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textPass = TextEditingController();
  bool _obscureTextPass = true;

  @override
  void initState() {
    super.initState();
  }

  Widget _buildLoginForm(
      BuildContext context, AppTranslationProvider translationProvider) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return Column(
      children: [
        HeadWidget(
          showLeftStar: true,
          showRightStar: true,
          title: translationProvider.tr('login.title'),
          subtitle: translationProvider.tr('login.subtitle'),
        ),
        const SizedBox(height: 40),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 21.0, right: 21.0),
            child: Column(
              children: [
                SizedBox(
                  width: StylesApp(context).formWidth,
                  child: TextFormField(
                    controller: textEmail,
                    cursorHeight: 16.sp,
                    style: StylesApp(context)
                        .textStyleBody12
                        .copyWith(color: StyleColor.black),
                    decoration:
                        StylesApp(context).inputDecorationOutlineStyle.copyWith(
                              hintText: translationProvider.tr('login.username'),
                            ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translationProvider.tr('login.username_required');
                      }
                      if (value.contains(' ')) {
                        return translationProvider.tr('login.username_no_spaces');
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: StylesApp(context).formWidth,
                  child: TextFormField(
                    controller: textPass,
                    cursorHeight: 16.sp,
                    obscureText: _obscureTextPass,
                    textAlignVertical: TextAlignVertical.center,
                    style: StylesApp(context)
                        .textStyleBody12
                        .copyWith(color: StyleColor.black),
                    decoration:
                        StylesApp(context).inputDecorationOutlineStyle.copyWith(
                              hintText: translationProvider.tr('login.password'),
                              suffixIcon: IconButton(
                                iconSize: 20,
                                padding: const EdgeInsets.all(0),
                                icon: Icon(
                                  _obscureTextPass
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureTextPass = !_obscureTextPass;
                                  });
                                },
                              ),
                            ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translationProvider.tr('login.password');
                      }
                      if (value.length < 6) {
                        return translationProvider.tr('login.password_min_length');
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 54),
                ButtonThemeWidget(
                  text: translationProvider.tr('login.login_button'),
                  buttonStyle: StylesApp(context).btnSecondarySmall,
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    LoadingService().showLoading(context);

                    final user = await authProvider.loginUser(
                        context, textEmail.text, textPass.text);
                    if (kDebugMode) {
                      print(user);
                    }

                    if (user.error != null) {
                      if (user.error.contains(
                          "Por favor verifica tu correo electrónico primero")) {
                        final Map<String, dynamic> jsonError =
                            json.decode(user.error.replaceAll("'", '"'));
                        final timeZone = await getDeviceTimeZone();
                        final response = await resendVerificationCode(
                            jsonError['email'], timeZone);

                        if (response.error != null) {
                          await showCustomDialog(context,
                              message: response.error!,
                              dialogType: DialogType.error);
                        }
                        final data =
                            VerificationResponse.fromJson(VerificationResponse(
                          userId: 'data.userId',
                          showVerifyPinModal: true,
                        ).toMap());
                        LoadingService().hideLoading();

                        _showDialogVerify(
                            context, data.toJson(), jsonError['email']);
                      } else {
                        LoadingService().hideLoading();

                        // ignore: use_build_context_synchronously
                        await showCustomDialog(context,
                            message: user.userFriendlyError!,
                            messageDetail: user.error ?? '',
                            showDetails: true,
                            dialogType: DialogType.error);
                      }
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
                const SizedBox(height: 44),
                ButtonThemeWidget(
                  textWithImage: true,
                  image: "assets/google-icon.png",
                  text: translationProvider.tr('login.google_login'),
                  textStyle: StylesApp(context).buttonTextStyle,
                  buttonStyle: StylesApp(context).btnTransparentSmall,
                  onPressed: () async {
                    if (kDebugMode) {
                      print("estoy en iniciar session con google");
                    }

                    LoadingService().showLoading(context);
                    final user = await authProvider.loginWithGoogle(context);
                    if (kDebugMode) {
                      print(user);
                    }

                    if (user.error != null) {
                      LoadingService().hideLoading();
                      await showCustomDialog(context,
                          message: user.userFriendlyError ?? '',
                          messageDetail: user.error ??
                             translationProvider.tr('dialogs.google_login_error'),
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
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(
      BuildContext context, AppTranslationProvider translationProvider) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 34.0, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/forgotPasswordPage');
                    },
                    child: Text(
                      translationProvider.tr('login.forgot_password'),
                      textAlign: TextAlign.center,
                      style: StylesApp(context).textStyleBody4,
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registerPage');
                    },
                    child: Text(
                      translationProvider.tr('login.register'),
                      textAlign: TextAlign.center,
                      style: StylesApp(context).textStyleBody4,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 1.5,
                    endIndent: 8,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'o',
                    style: StylesApp(context).textStyleBody4,
                  ),
                ),
                const Expanded(
                  child: Divider(
                    color: Colors.black,
                    thickness: 1.5,
                    indent: 8,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
      BuildContext context, AppTranslationProvider translationProvider) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0Xff12CBC4),
          ),
          child: _buildLoginForm(context, translationProvider),
        ),
        _buildFooter(context, translationProvider),
      ],
    );
  }

  Widget _buildTabletLayout(
      BuildContext context, AppTranslationProvider translationProvider) {
    return Container(
      color: const Color(0Xff12CBC4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Columna izquierda: Formulario de login
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
              child: SingleChildScrollView(
                child: _buildLoginForm(context, translationProvider),
              ),
            ),
          ),

          // Columna derecha: Footer en fondo blanco
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                  ),
                ),
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: StyleColor.turquoise,
                          backgroundImage: AssetImage(
                            'assets/icon.png',
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          translationProvider.tr('login.welcome'),
                          style: StylesApp(context).textStyleBody1.copyWith(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: const Color(0Xff12CBC4),
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          translationProvider.tr('login.welcome_message'),
                          style: StylesApp(context).textStyleBody4.copyWith(
                                fontSize: 16,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 40),
                        _buildFooter(context, translationProvider),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: ResponsiveLayout(
              mobile: SingleChildScrollView(
                child: _buildMobileLayout(context, translationProvider),
              ),
              tablet: _buildTabletLayout(context, translationProvider),
            )),
      ),
    );
  }

  void _showDialogVerify(
      BuildContext context, Map<String, dynamic> data, String email) {
    showVerifyPinDialog(
      context: context,
      email: email,
      onPinVerified: (pin) async {
        // Aquí llamas a tu API o lógica de verificación
        final response = await context
            .read<AuthenticationProvider>()
            .verifyPinWithApi(email, pin);
        if (response.error != null) {
          await showCustomDialog(context,
              message: response.error!, dialogType: DialogType.error);
          _showDialogVerify(context, data, email);
        } else {
          Navigator.popAndPushNamed(context, '/layoutPage');
        }
      },
      onResendCode: () async {
        // Lógica para reenviar el código
        // print('Reenviando código a $email');
        final timeZone = await getDeviceTimeZone();
        final response = await resendVerificationCode(email, timeZone);

        if (response.error != null) {
          await showCustomDialog(context,
              message: response.error!, dialogType: DialogType.error);
          _showDialogVerify(context, data, email);
        }
      },
    );
  }
}
