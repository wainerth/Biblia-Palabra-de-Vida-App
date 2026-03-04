import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

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
                      HeadWidget(
                        showLeftStar: false,
                        showRightStar: true,
                        title: translationProvider.tr('recover_password.title'),
                        subtitle:
                            translationProvider.tr('recover_password.subtitle'),
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
                                    translationProvider
                                        .tr('recover_password.step1_title'),
                                    style: StylesApp(context).textStyleBody5,
                                  ),
                                ),
                                const SizedBox(
                                  height: 32.0,
                                ),
                                SizedBox(
                                  width: StylesApp(context).formWidth,
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: StylesApp(context)
                                        .inputDecorationOutlineStyle
                                        .copyWith(
                                          hintText: translationProvider
                                              .tr('recover_password.email'),
                                        ),
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(color: StyleColor.black),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return translationProvider.tr(
                                            'recover_password.email_required');
                                      }
                                      final RegExp emailRegExp = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(.[a-zA-Z]+)?$");
                                      if (!emailRegExp.hasMatch(value)) {
                                        return translationProvider.tr(
                                            'recover_password.email_invalid');
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
                                  width: StylesApp(context).formWidth,
                                  child: TextFormField(
                                    controller: __recoveryCodeController,
                                    decoration: StylesApp(context)
                                        .inputDecorationOutlineStyle
                                        .copyWith(
                                            hintText: translationProvider.tr(
                                                'recover_password.recovery_code')),
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(color: StyleColor.black),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return translationProvider.tr(
                                            'recover_password.recovery_code_required');
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 23,
                                ),
                                Container(
                                  width: StylesApp(context).formWidth,
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscureTextPass,
                                    decoration: StylesApp(context)
                                        .inputDecorationOutlineStyle
                                        .copyWith(
                                          hintText: translationProvider.tr(
                                              'recover_password.new_password'),
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
                                    style: StylesApp(context)
                                        .textStyleBody12
                                        .copyWith(color: StyleColor.black),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return translationProvider.tr(
                                            'recover_password.new_password_required');
                                      }
                                      if (value.length < 6) {
                                        return translationProvider.tr(
                                            'recover_password.password_min_length');
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 23,
                                ),
                                SizedBox(
                                  width: StylesApp(context).formWidth,
                                  child: TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: _obscureTextRepeat,
                                    decoration: StylesApp(context)
                                        .inputDecorationOutlineStyle
                                        .copyWith(
                                          hintText: translationProvider.tr(
                                              'recover_password.confirm_password'),
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
                                        return translationProvider.tr(
                                            'recover_password.confirm_password_mismatch');
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
                                    ? translationProvider
                                        .tr('recover_password.continue_button')
                                    : translationProvider
                                        .tr('recover_password.reset_button'),
                                textStyle: StylesApp(context).buttonTextStyle,
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
                                        await showCustomDialog(
                                          context,
                                          showDetails: true,
                                          message: response.userFriendlyError!,
                                          messageDetail: response.error!,
                                          dialogType: DialogType.error,
                                        );
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
                                        LoadingService().hideLoading();
                                        await showCustomDialog(
                                          context,
                                          showDetails: true,

                                          message: response.userFriendlyError!,
                                          messageDetail: response.error!,
                                          dialogType: DialogType.error,
                                        );
                                      } else {
                                        LoadingService().hideLoading();
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                        Navigator.popAndPushNamed(
                                            context, '/loginPage');
                                      }
                                    }
                                  }
                                },
                                buttonStyle:
                                    StylesApp(context).btnSecondarySmall,
                                width: isTablet(context)
                                    ? StylesApp(context).formWidth
                                    : StylesApp(context).btnHeight.width,
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
