import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/main.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/authentication_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final Provider catalogueProvider;
  int _currentStep = 0; // Controla el paso actual
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController(text: "");
  final TextEditingController _lastNameController =
      TextEditingController(text: "");
  final TextEditingController _prefixNumberController = TextEditingController(
      text: Intl.defaultLocale == 'es_UY' ? '+598' : '+54');
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController(text: "");
  bool _obscureTextPass = true;
  bool _obscureTextRepeat = true;
  String setGender = '';
  bool setIsBaptized = false;
  ModelData? _selectedDataArea;
  ModelData? _selectedData;
  Country? _selectedCountry;
  AreaCode? _selectedPrefix;
  late List<Country> countries;
  late List<AreaCode> prefixCodes;
  late List<ModelData> dropDownListArea;
  late List<ModelData> dropDownList;

  // Método para detectar si es tablet
  bool _isTablet(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    return shortestSide >= 600;
  }

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCountry(context);
      // _showDialogVerify(
      //     context,
      //     VerificationResponse(
      //       userId: "2",
      //       showVerifyPinModal: true,
      //     ).toMap(),
      //     "pedpab.12@gmail.com");
    });
  }

  Future<void> loadCountry(context) async {
    final catalogueProvider =
        Provider.of<CatalogueProvider>(context, listen: false);

    setState(() {
      countries = (catalogueProvider.allCountries as List)
          .map((i) => Country.fromJson(i.toJson()))
          .toList();

      prefixCodes = (catalogueProvider.allAreasCode as List)
          .map((i) => AreaCode.fromJson(i.toJson()))
          .toList();

      dropDownListArea = prefixCodes
          .map((area) => ModelData(value: area.id, label: area.code))
          .cast<ModelData>()
          .toList();
      dropDownList = countries
          .map((country) => ModelData(value: country.id, label: country.name))
          .cast<ModelData>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

    final bool isTablet = _isTablet(context);

    return Scaffold(
      body: SafeArea(
        child: isTablet
            ? _buildTabletLayout(context, translationProvider)
            : _buildMobileLayout(context, translationProvider),
      ),
    );
  }

  // Layout para móvil (manteniendo el diseño actual)
  Widget _buildMobileLayout(
      BuildContext context, AppTranslationProvider translationProvider) {
    return Container(
      height: MediaQuery.sizeOf(context).height,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        color: _currentStep == 0 ? StyleColor.white : Color(0Xff12CBC4),
      ),
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
                    showLeftStar: _currentStep == 0,
                    showRightStar: _currentStep != 0,
                    title: translationProvider.tr('register_screen.title'),
                    subtitle:
                        translationProvider.tr('register_screen.subtitle'),
                  ),
                  if (_currentStep == 1) ...{
                    Align(
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _currentStep--;
                          });
                        },
                        child: AnimatedContainer(
                          margin: EdgeInsets.only(left: 20),
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: StyleColor.orange,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_back,
                            color: StyleColor.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                  } else ...{
                    const SizedBox(
                      height: 42,
                    ),
                  },
                  Form(
                    key: _formKey,
                    autovalidateMode: _autoValidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 29.0, right: 29.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25,
                          ),
                          if (_currentStep == 0) ...[
                            UserInfoStep(
                              userIdController: _userIdController,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              confirmPasswordController:
                                  _confirmPasswordController,
                              obscureTextPass: _obscureTextPass,
                              obscureTextRepeat: _obscureTextRepeat,
                              onObscureTextPassChanged: (value) =>
                                  setState(() => _obscureTextPass = value),
                              onObscureTextRepeatChanged: (value) =>
                                  setState(() => _obscureTextRepeat = value),
                              userNameController: _userNameController,
                            )
                          ] else if (_currentStep == 1) ...[
                            PersonalInfoStep(
                              nameController: _nameController,
                              lastNameController: _lastNameController,
                              dateController: _dateController,
                              selectedDate: _selectedDate,
                              onDateSelected: (picked) =>
                                  setState(() => _selectedDate = picked),
                              dropDownListArea: dropDownListArea,
                              dropDownList: dropDownList,
                              selectedDataArea: _selectedDataArea,
                              selectedData: _selectedData,
                              selectedCountry: _selectedCountry,
                              onPrefixSelected: (newValue) {
                                setState(() {
                                  _selectedDataArea = newValue;

                                  _selectedPrefix = prefixCodes.firstWhere(
                                      (country) =>
                                          country.id == newValue!.value);
                                  _prefixNumberController.text =
                                      newValue!.value;
                                });
                              },
                              onCountrySelected: (newValue) {
                                if (newValue != null) {
                                  setState(() {
                                    _selectedData = newValue;
                                    _selectedCountry =
                                        _selectedData?.originalData;
                                    _prefixNumberController.text =
                                        _selectedCountry!.countryCode!.code;
                                  });
                                } else {
                                  setState(() {
                                    _selectedData = null;
                                    _selectedCountry = null;
                                  });
                                }
                              },
                              prefixNumberController: _prefixNumberController,
                              phoneNumberController: _phoneNumberController,
                              gender: setGender,
                              onChangeGender: (newValue) {
                                setState(() {
                                  setGender = newValue!;
                                });
                              },
                              isBaptized: setIsBaptized,
                              onChangeBaptized: (baptized) {
                                setState(() {
                                  setIsBaptized = baptized!;
                                });
                              },
                              autoValidate: _autoValidate,
                            ),
                          ],
                          const SizedBox(
                            height: 23,
                          ),
                          ButtonThemeWidget(
                            textStyle: StylesApp(context).buttonTextStyle,
                            onPressed: () async {
                              initRegister(translationProvider);
                            },
                            text: _currentStep == 0
                                ? translationProvider
                                    .tr('register_screen.continue')
                                : translationProvider
                                    .tr('register_screen.register'),
                            buttonStyle: StylesApp(context).btnSecondarySmall,
                            width: isTablet(context)
                                ? StylesApp(context).formWidth
                                : StylesApp(context).btnHeight.width,
                            height: StylesApp(context).btnHeight.height,
                          ),
                          const SizedBox(
                            height: 41,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 31.0,
            ),
            if (_currentStep == 0)
              Padding(
                padding: const EdgeInsets.only(left: 29.0, right: 29.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/loginPage');
                            },
                            child: Text(
                              translationProvider
                                  .tr('register_screen.go_to_login'),
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
                            endIndent: 8, // Espacio entre la línea y el texto
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            "O",
                            style: StylesApp(context).textStyleBody4,
                          ),
                        ),
                        const Expanded(
                          child: Divider(
                            color: Colors.black,
                            thickness: 1.5,
                            indent: 8, // Espacio entre el texto y la línea
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Layout para tablet con 2 columnas
  Widget _buildTabletLayout(
      BuildContext context, AppTranslationProvider translationProvider) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
          color: Color(0Xff12CBC4),
        ),
        child: Row(
          children: [
            // Columna izquierda: Logo y título (40% del ancho)
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0Xff12CBC4),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40),
                      HeadWidget(
                        showLeftStar: _currentStep == 0,
                        showRightStar: _currentStep != 0,
                        title: translationProvider.tr('register_screen.title'),
                        subtitle:
                            translationProvider.tr('register_screen.subtitle'),
                      ),
                      SizedBox(height: 30),

                      // Indicador de pasos
                      _buildStepIndicator(translationProvider),
                      SizedBox(height: 40),

                      // Información adicional
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildInfoItem(
                                icon: Icons.security,
                                text: translationProvider
                                    .tr('register_screen.secure_data'),
                              ),
                              SizedBox(height: 20),
                              _buildInfoItem(
                                icon: Icons.speed,
                                text: translationProvider
                                    .tr('register_screen.fast_registration'),
                              ),
                              SizedBox(height: 20),
                              _buildInfoItem(
                                icon: Icons.people,
                                text: translationProvider
                                    .tr('register_screen.join_community'),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Enlace a login
                      if (_currentStep == 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 30),
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/loginPage');
                            },
                            child: Text.rich(
                              TextSpan(children: [
                                TextSpan(
                                  text: translationProvider.tr(
                                      'register_screen.already_have_account'),
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        color: StyleColor.white
                                            .withValues(alpha: 0.8),
                                        fontSize: 16,
                                      ),
                                ),
                                TextSpan(
                                  text: translationProvider
                                      .tr('register_screen.login_here'),
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        color: StyleColor.white,
                                        fontSize: 18,
                                        // decoration: TextDecoration.underline,
                                      ),
                                ),
                              ]),
                              style:
                                  StylesApp(context).textStyleBody16.copyWith(
                                        color: StyleColor.white,
                                        fontSize: 16,
                                        // decoration: TextDecoration.underline,
                                      ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Columna derecha: Formulario (60% del ancho)
            Expanded(
              flex: 6,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: StyleColor.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 30,
                        offset: Offset(-5, 0),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Botón de retroceso (solo en paso 2)
                          if (_currentStep == 1)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _currentStep--;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 30),
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: StyleColor.orange,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_back,
                                  color: StyleColor.white,
                                  size: 24,
                                ),
                              ),
                            ),

                          // Título del paso actual
                          Text(
                            _currentStep == 0
                                ? translationProvider
                                    .tr('register_screen.user_info_title')
                                : translationProvider
                                    .tr('register_screen.personal_info_title'),
                            style: StylesApp(context).textStyleBody20.copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0Xff12CBC4),
                                ),
                          ),
                          SizedBox(height: 10),

                          // Descripción del paso
                          Text(
                            _currentStep == 0
                                ? translationProvider
                                    .tr('register_screen.user_info_description')
                                : translationProvider.tr(
                                    'register_screen.personal_info_description'),
                            style: StylesApp(context).textStyleBody14.copyWith(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                          ),
                          SizedBox(height: 30),

                          // Formulario
                          Form(
                            key: _formKey,
                            autovalidateMode: _autoValidate
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            child: Column(
                              children: [
                                if (_currentStep == 0) ...[
                                  _buildTabletUserInfoStep(translationProvider),
                                ] else if (_currentStep == 1) ...[
                                  _buildTabletPersonalInfoStep(
                                      translationProvider),
                                ],
                                SizedBox(height: 12),

                                // Botón de acción
                                Container(
                                  width: 400,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      initRegister(translationProvider);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: StyleColor.orange,
                                      foregroundColor: StyleColor.white,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 40),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 4,
                                      shadowColor: StyleColor.orange
                                          .withValues(alpha: 0.3),
                                    ),
                                    child: Text(
                                      _currentStep == 0
                                          ? "${translationProvider.tr('register_screen.continue')} →"
                                          : translationProvider
                                              .tr('register_screen.register'),
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),

                                // Espaciado adicional para tablet
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para el indicador de pasos en tablet
  Widget _buildStepIndicator(AppTranslationProvider translationProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Paso 1
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _currentStep >= 0
                ? StyleColor.orange
                : StyleColor.white.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: StyleColor.white,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              translationProvider.tr('register_screen.step_1'),
              style: StylesApp(context).textStyleBody16.copyWith(
                    color:
                        _currentStep >= 0 ? StyleColor.white : Colors.grey[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
            ),
          ),
        ),
        // Línea entre pasos
        Container(
          width: 60,
          height: 3,
          color: StyleColor.white.withValues(alpha: 0.5),
        ),
        // Paso 2
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: _currentStep >= 1
                ? StyleColor.orange
                : StyleColor.white.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(
              color: StyleColor.white,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              translationProvider.tr('register_screen.step_2'),
              style: TextStyle(
                color: _currentStep >= 1 ? StyleColor.white : Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget para ítems de información en tablet
  Widget _buildInfoItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          color: StyleColor.white,
          size: 24,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: StylesApp(context).textStyleBody14.copyWith(
                  color: StyleColor.white.withValues(alpha: 0.9),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  // Paso de información de usuario optimizado para tablet
  Widget _buildTabletUserInfoStep(AppTranslationProvider translationProvider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UserInfoStep(
                      userIdController: _userIdController,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      confirmPasswordController: _confirmPasswordController,
                      obscureTextPass: _obscureTextPass,
                      obscureTextRepeat: _obscureTextRepeat,
                      onObscureTextPassChanged: (value) =>
                          setState(() => _obscureTextPass = value),
                      onObscureTextRepeatChanged: (value) =>
                          setState(() => _obscureTextRepeat = value),
                      userNameController: _userNameController,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Paso de información personal optimizado para tablet
  Widget _buildTabletPersonalInfoStep(
      AppTranslationProvider translationProvider) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: PersonalInfoStep(
                nameController: _nameController,
                lastNameController: _lastNameController,
                dateController: _dateController,
                selectedDate: _selectedDate,
                onDateSelected: (picked) =>
                    setState(() => _selectedDate = picked),
                dropDownListArea: dropDownListArea,
                dropDownList: dropDownList,
                selectedDataArea: _selectedDataArea,
                selectedData: _selectedData,
                selectedCountry: _selectedCountry,
                onPrefixSelected: (ModelData? newValue) {
                  setState(() {
                    _selectedDataArea = newValue;

                    _selectedPrefix = AreaCode(
                        id: _selectedDataArea!.value,
                        code: _selectedDataArea!.label);
                  });
                },
                onCountrySelected: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedData = newValue;
                      _selectedCountry = _selectedData?.originalData;
                      _prefixNumberController.text =
                          _selectedCountry!.countryCode!.code;
                    });
                  } else {
                    setState(() {
                      _selectedData = null;
                      _selectedCountry = null;
                    });
                  }
                },
                prefixNumberController: _prefixNumberController,
                phoneNumberController: _phoneNumberController,
                gender: setGender,
                onChangeGender: (newValue) {
                  setState(() {
                    setGender = newValue!;
                  });
                },
                isBaptized: setIsBaptized,
                onChangeBaptized: (baptized) {
                  setState(() {
                    setIsBaptized = baptized!;
                  });
                },
                autoValidate: _autoValidate,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void initRegister(AppTranslationProvider translationProvider) async {
    if (_currentStep == 0) {
      _nextStep();
    } else {
      // abrir dialogo para preguntar se desea recibir mensajes via whatsapp
      await _showSmoothDialog(context);
      setState(() {
        _autoValidate = true; // Activar validaciones
      });

      // Esperar un frame para que se actualice el estado
      // WidgetsBinding.instance.addPostFrameCallback((_) {
      //   final bool isValid = _formKey.currentState?.validate() ?? false;
      //   if (!isValid) {
      //     showSnackBar(
      //         translationProvider.tr('register_screen.dialogs.complete_fields'),
      //         type: SnackBarType.info);
      //     return;
      //   }

      // Si es válido, proceder con el registro
      // _proceedWithRegistration();
      // });
    }
  }

  Future<Future<Object?>> _showSmoothDialog(BuildContext context) async {
    bool receiveWhatsApp = false;
    List<String> selectedHours = [];

    return showGeneralDialog(
      context: context,
      barrierDismissible:
          false, // Cambiado a false para obligar a tomar una decisión
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Center(
              child: Material(
                type: MaterialType.transparency,
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  body: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                    child: FadeTransition(
                      opacity: animation,
                      child: _buildDialogContent(
                        context,
                        receiveWhatsApp,
                        selectedHours,
                        (value) {
                          setState(() {
                            receiveWhatsApp = value;
                            if (!receiveWhatsApp) {
                              selectedHours.clear();
                            }
                          });
                        },
                        (hours) {
                          setState(() {
                            selectedHours = hours;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );
  }

  Widget _buildDialogContent(
    BuildContext context,
    bool receiveWhatsApp,
    List<String> selectedHours,
    Function(bool) onWhatsAppChanged,
    Function(List<String>) onHoursChanged,
  ) {
    final iconsWhatsApp = SvgPicture.asset(
      "assets/whatsapp.svg",
      width: 60,
      height: 60,
    );

    final List<String> availableHours = [
      '08:00 AM',
      '09:00 AM',
      '10:00 AM',
      '11:00 AM',
      '12:00 PM',
      '01:00 PM',
      '02:00 PM',
      '03:00 PM',
      '04:00 PM',
      '05:00 PM',
      '06:00 PM',
      '07:00 PM',
      '08:00 PM',
      '09:00 PM'
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      // padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              child: iconsWhatsApp,
            ),
            SizedBox(height: 16),
            Text(
              'Mensajes por WhatsApp',
              style: StylesApp(context).textStyleBody20.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: StyleColor.grayDark),
            ),
            SizedBox(height: 12),
            Text(
              '¿Deseas recibir mensajes de notificación a través de WhatsApp?',
              textAlign: TextAlign.center,
              style: StylesApp(context)
                  .textStyleBody16
                  .copyWith(fontSize: 16, color: StyleColor.grayMedium),
            ),
            SizedBox(height: 20),

            // Checkbox para habilitar WhatsApp
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    receiveWhatsApp = !receiveWhatsApp;
                  });
                  onWhatsAppChanged(receiveWhatsApp);
                },
                child: Row(
                  children: [
                    Checkbox(
                      value: receiveWhatsApp,
                      onChanged: (value) => onWhatsAppChanged(value ?? false),
                      activeColor: Color(0xFF25D366),
                    ),
                    Expanded(
                      child: Text(
                        'Habilitar notificaciones por WhatsApp',
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(fontSize: 16, color: StyleColor.black),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (receiveWhatsApp) ...[
              SizedBox(height: 24),
              Divider(),
              SizedBox(height: 16),
              Text(
                'Selecciona los horarios para recibir mensajes',
                style: StylesApp(context)
                    .textStyleBody16
                    .copyWith(fontSize: 16, color: StyleColor.black),
              ),
              SizedBox(height: 8),
              Text(
                'Mínimo 2 horas - Máximo 3 horas',
                style: StylesApp(context).textStyleBody12.copyWith(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
              ),
              SizedBox(height: 16),

              // Selector múltiple de horas
              Container(
                constraints: BoxConstraints(maxHeight: 300),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2,
                  ),
                  itemCount: availableHours.length,
                  itemBuilder: (context, index) {
                    final hour = availableHours[index];
                    final isSelected = selectedHours.contains(hour);

                    return GestureDetector(
                      onTap: () {
                        if (isSelected) {
                          // Deseleccionar
                          onHoursChanged(
                              selectedHours.where((h) => h != hour).toList());
                        } else {
                          // Seleccionar con límites
                          if (selectedHours.length < 3) {
                            onHoursChanged([...selectedHours, hour]);
                          } else {
                            _showLimitSnackBar(
                                context, 'Máximo 3 horas permitidas');
                          }
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Color(0xFF25D366)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Color(0xFF25D366)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            hour,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey.shade800,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Mostrar horas seleccionadas
              if (selectedHours.isNotEmpty) ...[
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Horas seleccionadas:',
                        style: StylesApp(context).textStyleBody12.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade700,
                            ),
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: selectedHours.map((hour) {
                          return Chip(
                            label: Text(hour,
                                style: StylesApp(context)
                                    .textStyleBody12
                                    .copyWith(fontSize: 12)),
                            onDeleted: () {
                              onHoursChanged(selectedHours
                                  .where((h) => h != hour)
                                  .toList());
                            },
                            backgroundColor: Color(0xFF25D366).withValues(alpha: 0.1),
                            deleteIconColor: Color(0xFF25D366),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            SizedBox(height: 24),

            // Botones de acción
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: ButtonThemeWidget(
                    buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                        backgroundColor: WidgetStatePropertyAll(Colors.white),
                        foregroundColor:
                            WidgetStatePropertyAll(StyleColor.grayDark),
                        side: WidgetStatePropertyAll(
                            BorderSide(color: StyleColor.greenDark))),
                    onPressed: () {
                      // Cancelar - no guardar configuración
                      Navigator.pop(context);
                    },
                    text: 'Cancelar',
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ButtonThemeWidget(
                    buttonStyle: StylesApp(context).btnWidgetSmall,
                    onPressed: () {
                      // Validar antes de guardar
                      if (receiveWhatsApp) {
                        if (selectedHours.length < 2) {
                          _showLimitSnackBar(
                              context, 'Debes seleccionar al menos 2 horas');
                          return;
                        }
                        if (selectedHours.length > 3) {
                          _showLimitSnackBar(
                              context, 'Máximo 3 horas permitidas');
                          return;
                        }
                      }

                      // Guardar configuración
                      _saveWhatsAppConfig(receiveWhatsApp, selectedHours);
                      Navigator.pop(context);
                    },
                    text: 'Guardar',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }

  void _showLimitSnackBar(BuildContext context, String message) {
    final rootContext = Navigator.of(context).context;

    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _saveWhatsAppConfig(bool enabled, List<String> hours) {
    final rootContext = Navigator.of(context).context;

    if (enabled) {
      print('WhatsApp habilitado');
      print('Horas seleccionadas: ${hours.join(", ")}');
      // Aquí guardas la configuración en tu backend o almacenamiento local
      // Ejemplo: sharedPreferences, API, etc.

      // Mostrar snackbar de éxito
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text('Configuración de WhatsApp guardada correctamente'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      print('WhatsApp deshabilitado');
    }
  }

  void _proceedWithRegistration() async {
    LoadingService().showLoading(context);
    final authenticationProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    final dataToRegister = SignupInput(
      name: _nameController.text,
      lastname: _lastNameController.text,
      email: _emailController.text,
      birthdate: _dateController.text,
      codeAreaId: _selectedPrefix?.id,
      countryId: _selectedCountry?.id,
      identifier: _userIdController.text,
      password: _passwordController.text,
      phoneNumber:
          _phoneNumberController.text.replaceAll(RegExp(r'[^\d]+'), ''),
      city: null,
      state: null,
      username: _userNameController.text,
      isBaptized: setIsBaptized,
      gender: setGender,
    );

    final ResponseData response =
        await authenticationProvider.registerUser(dataToRegister);

    LoadingService().hideLoading();

    if (response.error != null) {
      await showCustomDialog(context,
          messageDetail: response.error!,
          message: response.userFriendlyError!,
          showDetails: true,
          dialogType: DialogType.error);
    } else {
      final data = VerificationResponse.fromJson(response.data);
      if (data.showVerifyPinModal) {
        // levantar diálogo  de verificador de pin
        _showDialogVerify(context, response.data, _emailController.text);
      } else {
        Navigator.popAndPushNamed(context, '/layoutPage');
      }
    }
  }

  // En tu código original
  void _showDialogVerify(
      BuildContext context, Map<String, dynamic> data, String email) {
    showVerifyPinDialog(
      context: context,
      email: email,
      onPinVerified: (pin) async {
        // Aquí llamas a tu API o lógica de verificación
        final response = await context
            .read<AuthenticationProvider>()
            .verifyPinWithApi(email, pin);
        if (response.error != null) {
          await showCustomDialog(context,
              message: response.error!, dialogType: DialogType.error);
          _showDialogVerify(context, data, email);
        } else {
          Navigator.popAndPushNamed(context, '/layoutPage');
        }
      },
      onResendCode: () async {
        // Lógica para reenviar el código
        if (kDebugMode) {
          print('Reenviando código a $email');
        }
        final timeZone = await getDeviceTimeZone();
        final response = await resendVerificationCode(email, timeZone);

        if (response.error != null) {
          await showCustomDialog(context,
              message: response.error!, dialogType: DialogType.error);
          _showDialogVerify(context, data, email);
        }
      },
    );
  }
}
