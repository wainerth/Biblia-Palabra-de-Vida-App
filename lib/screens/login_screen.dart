import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

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
        child: Container(
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
                          title: "¡La Biblia\n  Palabra de\n Vida!",
                          subtitle: "Login",
                          heightContent: 287,
                        ),
                        const SizedBox(
                          height: 51,
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
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          // labelText: "Correo electrónico",
                                          hintText: "Correo electrónico",
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          // labelText: "Contraseña",
                                          hintText: "Contraseña",
                                        ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 64,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.25),
                                        offset: const Offset(0, 4),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      
                                      Navigator.pushNamed(context, '/mapPage');
                                    },
                                    style: StylesApp(context).btnSecondarySmall,
                                    child: const Text("Iniciar sesión"),
                                  ),
                                ),
                                const SizedBox(
                                  height: 44,
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: StylesApp(context).btnTransparentSmall,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text("Iniciar con "),
                                      SizedBox(
                                        width: 26.0,
                                        child: Image.asset("/google-icon.png"),
                                      ),
                                    ],
                                  ),
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
