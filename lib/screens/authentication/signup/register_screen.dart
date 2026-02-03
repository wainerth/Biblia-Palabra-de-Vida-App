import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/authentication_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
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
    final bool isTablet = _isTablet(context);

    return Scaffold(
      body: SafeArea(
        child: isTablet
            ? _buildTabletLayout(context)
            : _buildMobileLayout(context),
      ),
    );
  }

  // Layout para móvil (manteniendo el diseño actual)
  Widget _buildMobileLayout(BuildContext context) {
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
                    title: "¡La Biblia\n  Palabra De\n Vida!",
                    subtitle: "Registro",
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
                              initRegister();
                            },
                            text: _currentStep == 0 ? "Continuar" : "Registrar",
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
                              'Ir a iniciar session',
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
                            'o',
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
  Widget _buildTabletLayout(BuildContext context) {
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
                        title: "¡La Biblia\n  Palabra De\n Vida!",
                        subtitle: "Registro",
                      ),
                      SizedBox(height: 30),

                      // Indicador de pasos
                      _buildStepIndicator(),
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
                                text: "Datos seguros y protegidos",
                              ),
                              SizedBox(height: 20),
                              _buildInfoItem(
                                icon: Icons.speed,
                                text: "Registro rápido y sencillo",
                              ),
                              SizedBox(height: 20),
                              _buildInfoItem(
                                icon: Icons.people,
                                text: "Únete a nuestra comunidad",
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
                                  text: '¿Ya tienes cuenta? ',
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        color: StyleColor.white
                                            .withValues(alpha: 0.8),
                                        fontSize: 16,
                                      ),
                                ),
                                TextSpan(
                                  text: 'Inicia sesión',
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
                                ? "Información de Usuario"
                                : "Información Personal",
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
                                ? "Completa tus datos básicos para crear tu cuenta"
                                : "Completa tu información personal para continuar",
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
                                  _buildTabletUserInfoStep(),
                                ] else if (_currentStep == 1) ...[
                                  _buildTabletPersonalInfoStep(),
                                ],
                                SizedBox(height: 12),

                                // Botón de acción
                                Container(
                                  width: 400,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      initRegister();
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
                                          ? "Continuar →"
                                          : "Registrarse",
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
  Widget _buildStepIndicator() {
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
              "1",
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
              "2",
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
  Widget _buildTabletUserInfoStep() {
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
  Widget _buildTabletPersonalInfoStep() {
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

  void initRegister() async {
    if (_currentStep == 0) {
      _nextStep();
    } else {
      setState(() {
        _autoValidate = true; // Activar validaciones
      });

      // Esperar un frame para que se actualice el estado
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final bool isValid = _formKey.currentState?.validate() ?? false;
        if (!isValid) {
          showSnackBar('Por favor completa todos los campos requeridos',
              type: SnackBarType.info);
          return;
        }

        // Si es válido, proceder con el registro
        _proceedWithRegistration();
      });
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
        print('Reenviando código a $email');
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
