import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class ChangePassScreen extends StatefulWidget {
  const ChangePassScreen({super.key});

  @override
  State<ChangePassScreen> createState() => _ChangePassScreenState();
}

class _ChangePassScreenState extends State<ChangePassScreen> {
  int _currentStep = 0; // Controla el paso actual
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureTextCurrentPass = true;
  bool _obscureTextNewPass = true;
  bool _obscureTextRepeat = true;

  var maskFormatterTel = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var maskFormatterEmail = MaskTextInputFormatter(
    mask: '******@******.com',
    filter: {"*": RegExp(r'[a-zA-Z0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  // Método para validar campos obligatorios
  bool _validateStep() {
    if (_currentStep == 0) {
      return _formKey.currentState?.validate() ?? false;
    }
    return true;
  }

// Método para avanzar al siguiente paso
  void _nextStep() {
    if (_validateStep()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  // Método para registrar al usuario
  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      // Lógica de registro
      if (kDebugMode) {
        print("Registro completado");
      }
    }
  }

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
                        showRightStar: false,
                        title: "¡La Biblia\n  Palabra De\n Vida!",
                        subtitle: "Cambiar\n contraseña",
                      ),
                      const SizedBox(
                        height: 53.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 29.0, right: 29.0),
                          child: Column(
                            children: [
                              Container(
                                width: StylesApp(context).formWidth,
                                child: TextFormField(
                                  controller: _currentPasswordController,
                                  obscureText: _obscureTextCurrentPass,
                                  decoration: StylesApp(context)
                                      .inputDecorationOutlineStyle
                                      .copyWith(
                                        hintText: "Contraseña actual",
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureTextCurrentPass
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureTextCurrentPass =
                                                  !_obscureTextCurrentPass;
                                            });
                                          },
                                        ),
                                      ),
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(color: StyleColor.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "La contraseña es obligatoria";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: StylesApp(context).formWidth,
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscureTextNewPass,
                                  decoration: StylesApp(context)
                                      .inputDecorationOutlineStyle
                                      .copyWith(
                                        hintText: "Contraseña",
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureTextNewPass
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureTextNewPass =
                                                  !_obscureTextNewPass;
                                            });
                                          },
                                        ),
                                      ),
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(color: StyleColor.black),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "La contraseña es obligatoria";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                width: StylesApp(context).formWidth,
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureTextRepeat,
                                  decoration: StylesApp(context)
                                      .inputDecorationOutlineStyle
                                      .copyWith(
                                        hintText: "Confirmar Contraseña",
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureTextRepeat
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureTextRepeat =
                                                  !_obscureTextRepeat;
                                            });
                                          },
                                        ),
                                      ),
                                  style: StylesApp(context)
                                      .textStyleBody12
                                      .copyWith(color: StyleColor.black),
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return "Las contraseñas no coinciden";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                              ButtonThemeWidget(
                                text: _currentStep == 0
                                    ? "Continuar"
                                    : "Restablecer",
                                onPressed: () {
                                  if (_currentStep == 0) {
                                    _nextStep();
                                  } else {
                                    _register();
                                  }
                                },
                                buttonStyle:
                                    StylesApp(context).btnSecondarySmall,
                                    textStyle: StylesApp(context).buttonTextStyle,
                                width: StylesApp(context).btnHeight.width,
                                height: StylesApp(context).btnHeight.height,
                              ),
                              const SizedBox(
                                height: 44,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                                      'Ir a recuperar contraseña',
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
