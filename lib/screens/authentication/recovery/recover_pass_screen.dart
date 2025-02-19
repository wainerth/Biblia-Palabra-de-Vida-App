import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/authentication_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/loading_service.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

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
  bool _obscureTextPass = true;
  bool _obscureTextRepeat = true;
  String messageSend = '';

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
    setState(() {
      _currentStep++;
    });
  }

  // Método para registrar al usuario
  void _recoveryPassword(email, code, password) {
    if (_formKey.currentState?.validate() ?? false) {}
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
                        title: "¡La Biblia\n  Palabra De\n Vida!",
                        subtitle: "Recuperar\n Contraseña",
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
                                Center(
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    "Ingrese su correo electrónico para buscar tu cuenta",
                                    style: StylesApp(context).textStyleBody5,
                                  ),
                                ),
                                const SizedBox(
                                  height: 32.0,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 160.0,
                                    maxWidth: StylesApp(context)
                                        .sizeTextFormField
                                        .width,
                                  ),
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: StylesApp(context)
                                        .inputDecorationOutlineStyle
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
                                Center(
                                  child: Text(
                                      textAlign: TextAlign.center,
                                      messageSend,
                                      style: StylesApp(context).textStyleBody5),
                                ),
                                const SizedBox(
                                  height: 33.0,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 160.0,
                                    maxWidth: StylesApp(context)
                                        .sizeTextFormField
                                        .width,
                                  ),
                                  child: TextFormField(
                                    controller: __recoveryCodeController,
                                    decoration: StylesApp(context)
                                        .inputDecorationOutlineStyle
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
                                  constraints: BoxConstraints(
                                    minWidth: 160.0,
                                    maxWidth: StylesApp(context)
                                        .sizeTextFormField
                                        .width,
                                  ),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscureTextPass,
                                    decoration: StylesApp(context)
                                        .inputDecorationOutlineStyle
                                        .copyWith(
                                          hintText: "Contraseña",
                                          suffixIcon: IconButton(
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
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 23,
                                ),
                                Container(
                                  constraints: BoxConstraints(
                                    minWidth: 160.0,
                                    maxWidth: StylesApp(context)
                                        .sizeTextFormField
                                        .width,
                                  ),
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
                              ButtonThemeWidget(
                                text: _currentStep == 0
                                    ? "Continuar"
                                    : "Restablecer",
                                onPressed: () async {
                                  final authProvider =
                                      Provider.of<AuthenticationProvider>(
                                          context,
                                          listen: false);
                                  if (_currentStep == 0) {
                                    if (_validateStep()) {
                                      LoadingService().showLoading(context);
                                      final ResponseData response =
                                          await authProvider.forgotUserPassword(
                                              _emailController.text);
                                      if (response.error != null) {
                                        LoadingService().hideLoading();
                                        await showCustomDialog(context,
                                            message: response.error!,
                                            dialogType: DialogType.error);
                                      } else {
                                        setState(() {
                                          messageSend =
                                              response.data['message'];
                                        });
                                        _nextStep();
                                        LoadingService().hideLoading();
                                      }
                                    }
                                  } else {
                                    final validate =
                                        _formKey.currentState?.validate();
                                    if (validate!) {
                                      LoadingService().showLoading(context);
                                      final ResponseData response =
                                          await authProvider.recoveryPassword(
                                              _emailController.text,
                                              __recoveryCodeController.text,
                                              _passwordController.text);
                                      if (response.error != null) {
                                        await showCustomDialog(context,
                                            message: response.error!,
                                            dialogType: DialogType.error);
                                      } else {
                                        LoadingService().hideLoading();
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        Navigator.popAndPushNamed(
                                            context, '/loginPage');
                                      }
                                    }
                                  }
                                  // LoadingService().hideLoading();
                                },
                                buttonStyle:
                                    StylesApp(context).btnSecondarySmall,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
