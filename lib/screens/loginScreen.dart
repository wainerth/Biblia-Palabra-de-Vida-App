import 'package:biblia_palabra_de_vida_app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
              color: Color(0Xff12CBC4),
            ),
            child: SingleChildScrollView(
              child: Stack(children: [
                Container(
                  height: 236,
                  width: MediaQuery.sizeOf(context).width,
                  child: Image.asset(
                    '/elipsisTop.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  child: Image.asset(
                    height: 90,
                    '/start.png',
                    fit: BoxFit.fill,
                  ),
                  top: 3,
                  left: -16,
                ),
                Positioned(
                  child: Image.asset(
                    height: 90,
                    '/start.png',
                    fit: BoxFit.fill,
                  ),
                  top: 3,
                  right: -16,
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 46,
                    ),
                    Center(
                      child: Container(
                        child: Text(
                          textAlign: TextAlign.center,
                          "¡La Biblia  \n Palabra de Vida!",
                          style: TextStylesApp(context).textStyleTitleBlue,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 88,
                    ),
                    Form(
                      key: const Key("loginForm"),
                      child: Padding(
                        padding: const EdgeInsets.all(41.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 48,
                            ),
                            Container(
                              constraints:
                                  const BoxConstraints(minWidth: 160.0),
                              child: TextFormField(
                                decoration: TextStylesApp(context)
                                    .InputDecorationStyle
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
                                decoration: TextStylesApp(context)
                                    .InputDecorationStyle
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
                                    offset: Offset(0, 4),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: TextButton(
                                onPressed: () {},
                                style: TextStylesApp(context)
                                    .btnSecondarySmall,
                                child: const Text("Iniciar sesión"),
                              ),
                            ),
                            const SizedBox(
                              height: 44,
                            ),
                            TextButton(
                              onPressed: () {},
                              style: TextStylesApp(context)
                                  .btnTransparentSmall,
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
                    Container(
                      constraints: const BoxConstraints(minHeight: 180),
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
                                      style:
                                          TextStylesApp(context).textStyleBody4,
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
                                      style:
                                          TextStylesApp(context).textStyleBody4,
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
                                    style:
                                        TextStylesApp(context).textStyleBody4,
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
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
