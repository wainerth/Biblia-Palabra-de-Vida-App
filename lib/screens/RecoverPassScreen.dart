import 'package:biblia_palabra_de_vida_app/themes/text_styles.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
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
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  bool _obscureText = true;


  var maskFormatterTel = new MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  var maskFormatterEmail = new MaskTextInputFormatter(
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
      print("Registro completado");
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    // final Locale locale = Localizations.localeOf(context);
    final DateFormat formatter = DateFormat.yMd('es_ES'); //locale.languageCode;
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(2000),
        lastDate: now,
        locale: const Locale('es', 'ES') // locale
        );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = formatter
            .format(picked); // DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

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
              child: Column(
                children: [
                  const HeadScreen(
                    showLeftStar: false,
                    showRightStar: true,
                    title: "¡La Biblia\n  Palabra de\n Vida!",
                    subtitle: "Recuperar Contraseña",
                    heightContent: 409,
                  ),
                  Column(
                    children: [
                      const SizedBox(
                        height: 43.0,
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(41.0),
                          child: Column(
                            children: [
                              if (_currentStep == 0) ...[
                                Container(
                                  constraints: const BoxConstraints(
                                    maxWidth: 265.0,
                                  ),
                                  child: Center(
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        "Ingrese su correo electrónico para buscar tu cuenta",
                                        style: TextStylesApp(context)
                                            .textStyleBody5),
                                  ),
                                ),
                                const SizedBox(
                                  height: 33.0,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    // inputFormatters: [maskFormatterEmail],
                                    // style: TextStylesApp(context).textStyleBody4,
                                    decoration: TextStylesApp(context)
                                        .InputDecorationStyle
                                        .copyWith(
                                          // labelText: "Correo electrónico",
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
                                  constraints: const BoxConstraints(
                                    maxWidth: 265.0,
                                  ),
                                  child: Center(
                                    child: Text(
                                        textAlign: TextAlign.center,
                                        "Se ha enviado un codigo de recuperacion  a su direccion de correo electronico",
                                        style: TextStylesApp(context)
                                            .textStyleBody5),
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
                                    decoration: TextStylesApp(context)
                                        .InputDecorationStyle
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
                                  height: 48,
                                ),
                                Container(
                                constraints:
                                    const BoxConstraints(minWidth: 160.0),
                                child: TextFormField(
                                  controller: _passwordController,
                                  obscureText: _obscureText,
                                  decoration: TextStylesApp(context)
                                      .InputDecorationStyle
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
                                height: 30,
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(minWidth: 160.0),
                                child: TextFormField(
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureText,
                                  decoration: TextStylesApp(context)
                                      .InputDecorationStyle
                                      .copyWith(
                                        hintText: "Confirmar Contraseña",
                                      ),
                                  validator: (value) {
                                    if (value != _passwordController.text) {
                                      return "Las contraseñas no coinciden";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                                const SizedBox(
                                  height: 48,
                                ),
                              ],
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
                                    if (_currentStep == 0) {
                                      _nextStep();
                                    } else {
                                      // _register();
                                      Navigator.pushNamed(context, '/changePasswordPage');
                                    }
                                  },
                                  style: TextStylesApp(context)
                                      .btnSecondarySmall,
                                  child: Text(
                                    _currentStep == 0
                                        ? "Continuar"
                                        : "Reestablecer",
                                    style: const TextStyle(color: Colors.white),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
