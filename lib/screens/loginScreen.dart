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
                  SizedBox(
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
                  Form(
                    key: Key("loginForm"),
                    child: Padding(
                      padding: const EdgeInsets.all(41.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 48,
                          ),
                          Container(
                            constraints: BoxConstraints(minWidth: 160.0),
                            child: TextFormField(
                              decoration: TextStylesApp(context)
                                  .InputDecorationStyle
                                  .copyWith(
                                    // labelText: "Correo electrónico",
                                    hintText: "Correo electrónico",
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            constraints: BoxConstraints(minWidth: 160.0),
                            child: TextFormField(
                              decoration: TextStylesApp(context)
                                  .InputDecorationStyle
                                  .copyWith(
                                    // labelText: "Contraseña",
                                    hintText: "Contraseña",
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 64,
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextStylesApp(context).btnSecondary,
                            child: const Text("Iniciar sesión"),
                          ),
                          SizedBox(
                            height: 64,
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextStylesApp(context).btnSecondary,
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
                          SizedBox(
                            height: 78,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: Text("Recuperar contraseña"),
                                  style: TextButton.styleFrom(
                                    // primary: Colors.black, // Color del texto
                                    backgroundColor: Colors
                                        .transparent, // Fondo transparente
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide.none,
                                      borderRadius: BorderRadius.circular(
                                          0), // Borde inferior recto
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Column(
                                    children: [
                                      Text("Recuperar contraseña"),
                                      Divider(
                                        color: Colors.black,
                                        thickness: 2,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
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
    );
  }
}
