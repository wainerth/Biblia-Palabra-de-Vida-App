import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RecoverPassScreen extends StatefulWidget {
  const RecoverPassScreen({super.key});

  @override
  State<RecoverPassScreen> createState() => _RecoverPassScreenState();
}

class _RecoverPassScreenState extends State<RecoverPassScreen> {
  int _currentStep = 0; // Controla el paso actual
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController __recoveryCodeController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;

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
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0Xff12CBC4),
          ),
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
                        showLeftStar: false,
                        showRightStar: true,
                        title: "¡La Biblia\n  Palabra de\n Vida!",
                        subtitle: "Recuperar\n Contraseña",
                        heightContent: 409,
                      ),
                      const SizedBox(
                        height: 46.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 29.0, right: 29.0),
                          child: Column(
                            children: [
                              if (_currentStep == 0) ...[
                                Container(
                                  child: Center(
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        "Ingrese su correo electrónico para buscar tu cuenta",
                                        style:
                                            StylesApp(context).textStyleBody5),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32.0,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          hintText: "Correo electrónico",
                                        ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "El correo es obligatorio";
                                      }
                                      final RegExp emailRegExp = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(.[a-zA-Z]+)?$");
                                      if (!emailRegExp.hasMatch(value)) {
                                        return 'Ingrese un correo electrónico válido';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ] else if (_currentStep == 1) ...[
                                Container(
                                  child: Center(
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        "Se ha enviado un código de recuperación  a su dirección de correo electrónico",
                                        style:
                                            StylesApp(context).textStyleBody5),
                                  ),
                                ),
                                const SizedBox(
                                  height: 33.0,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: __recoveryCodeController,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                            hintText: "Código de recuperación"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "El Código de recuperación es obligatorio";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 23,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscureText,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          hintText: "Contraseña",
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                        ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "La contraseña es obligatoria";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 23,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: _obscureText,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          hintText: "Confirmar Contraseña",
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _obscureText = !_obscureText;
                                              });
                                            },
                                          ),
                                        ),
                                    validator: (value) {
                                      if (value != _passwordController.text) {
                                        return "Las contraseñas no coinciden";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                              const SizedBox(
                                height: 33,
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
                                    if (_currentStep == 0) {
                                      _nextStep();
                                    } else {
                                      _register();
                                      Navigator.pushNamed(
                                          context, '/changePasswordPage');
                                    }
                                  },
                                  style: StylesApp(context).btnSecondarySmall,
                                  child: Text(
                                    _currentStep == 0
                                        ? "Continuar"
                                        : "Restablecer",
                                  ),
                                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
