import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    cursorHeight: 16.sp,
                                    style: StylesApp(context).textStyleHintText,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          hintText: "Correo electrónico",
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    cursorHeight: 16.sp,
                                    style: StylesApp(context).textStyleHintText,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          // labelText: "Contraseña",
                                          hintText: "Contraseña",
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 54,
                                ),
                                ButtonThemeWidget(
                                  text: "Iniciar sesión",
                                  image: "assets/google-icon.png",
                                  buttonStyle:
                                      StylesApp(context).btnSecondarySmall,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/layoutPage');
                                  },
                                  width: StylesApp(context).btnHeight.width,
                                  height: StylesApp(context).btnHeight.height,
                                ),
                                const SizedBox(
                                  height: 44,
                                ),
                                ButtonThemeWidget(
                                  textWithImage: true,
                                  image: "assets/google-icon.png",
                                  text: "Iniciar con",
                                  buttonStyle:
                                      StylesApp(context).btnTransparentSmall,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/layoutPage');
                                  },
                                  width: StylesApp(context).btnHeight.width,
                                  height: StylesApp(context).btnHeight.height,
                                ),
                                const SizedBox(
                                  height: 48,
                                ),
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
