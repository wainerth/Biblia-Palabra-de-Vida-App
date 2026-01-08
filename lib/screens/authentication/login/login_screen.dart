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
  Widget build(BuildContext context) {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    decoration: const BoxDecoration(
                      color: Color(0Xff12CBC4),
                    ),
                    child: Column(
                      children: [
                        const HeadWidget(
                          showLeftStar: true,
                          showRightStar: true,
                          title: "¡La Biblia\n  Palabra De\n Vida!",
                          subtitle: "Login",
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        Form(
                          key: _formKey,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 21.0, right: 21.0),
                            child: Column(
                              children: [
                                Container(
                                  width: StylesApp(context).formWidth,
                                  child: TextFormField(
                                    controller: textEmail,
                                    cursorHeight: 16.sp,
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(color: StyleColor.black),
                                    decoration: StylesApp(context)
                                        .inputDecorationOutlineStyle
                                        .copyWith(
                                          hintText:
                                              "usuario o Correo electrónico",
                                        ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "usuario o Correo electrónico es obligatoria";
                                      }
                                      if (value.contains(' ')) {
                                        return "usuario o Correo electrónico no puede contener espacios";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  width: StylesApp(context).formWidth,
                                  child: TextFormField(
                                    controller: textPass,
                                    cursorHeight: 16.sp,
                                    obscureText: _obscureTextPass,
                                    textAlignVertical: TextAlignVertical.center,
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(color: StyleColor.black),
                                    decoration: StylesApp(context)
                                        .inputDecorationOutlineStyle
                                        .copyWith(
                                          hintText: "Contraseña",
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
                                                _obscureTextPass =
                                                    !_obscureTextPass;
                                              });
                                            },
                                          ),
                                        ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "La contraseña es obligatoria";
                                      }
                                      if (value.length < 6) {
                                        return "La contraseña debe contener mínimo 6 caracteres";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 54,
                                ),
                                ButtonThemeWidget(
                                  text: "Iniciar sesión",
                                  buttonStyle:
                                      StylesApp(context).btnSecondarySmall,
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
                                      LoadingService().hideLoading();
                                      // ignore: use_build_context_synchronously
                                      await showCustomDialog(context,
                                          message: user.userFriendlyError!,
                                          messageDetail: user.error ?? '',
                                          showDetails: true,
                                          dialogType: DialogType.error);
                                    } else {
                                      LoadingService().hideLoading();
                                      if (!mounted) return;
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          '/layoutPage', (route) => false);
                                    }
                                  },
                                  width: isTablet(context)
                                      ? StylesApp(context).formWidth
                                      : StylesApp(context).btnHeight.width,
                                  height: StylesApp(context).btnHeight.height,
                                ),
                                const SizedBox(
                                  height: 44,
                                ),
                                ButtonThemeWidget(
                                  textWithImage: true,
                                  image: "assets/google-icon.png",
                                  text: "Iniciar con",
                                  textStyle: StylesApp(context).buttonTextStyle,
                                  buttonStyle:
                                      StylesApp(context).btnTransparentSmall,
                                  onPressed: () async {
                                    if (kDebugMode) {
                                      print(
                                          "estoy en iniciar session con google");
                                    }

                                    LoadingService().showLoading(context);
                                    final user = await authProvider
                                        .loginWithGoogle(context);
                                    if (kDebugMode) {
                                      print(user);
                                    }

                                    if (user.error != null) {
                                      LoadingService().hideLoading();
                                      await showCustomDialog(context,
                                          message: user.userFriendlyError! ,
                                          messageDetail: user.error ?? '',
                                          showDetails: true,
                                          dialogType: DialogType.error);
                                    } else {
                                      LoadingService().hideLoading();
                                      if (!mounted) return;
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          '/layoutPage', (route) => false);
                                    }
                                  },
                                  width: isTablet(context)
                                      ? StylesApp(context).formWidth
                                      : StylesApp(context).btnHeight.width,
                                  height: StylesApp(context).btnHeight.height,
                                ),
                                const SizedBox(
                                  height: 48,
                                ),
                                // IconButton(
                                //     onPressed: () {},
                                //     icon: Icon(Icons.fingerprint_rounded))
                              ],
                            ),
                          ),
                        ),
                      ],
                    )),
                Column(
                  children: [
                    Container(
                      // constraints: const BoxConstraints(minHeight: 180),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 34.0, left: 10, right: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/forgotPasswordPage');
                                    },
                                    child: Text(
                                      'Recuperar contraseña',
                                      textAlign: TextAlign.center,
                                      style: StylesApp(context).textStyleBody4,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, '/registerPage');
                                    },
                                    child: Text(
                                      'Registrarme',
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
                                    endIndent:
                                        8, // Espacio entre la línea y el texto
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    'o',
                                    style: StylesApp(context).textStyleBody4,
                                  ),
                                ),
                                const Expanded(
                                  child: Divider(
                                    color: Colors.black,
                                    thickness: 1.5,
                                    indent:
                                        8, // Espacio entre el texto y la línea
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
