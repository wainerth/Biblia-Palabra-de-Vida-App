import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/authentication_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
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
      TextEditingController(text: "");
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadCountry(context);
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
          .map(
              (country) => ModelData(value: country.id, label: country.country))
          .cast<ModelData>()
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color: _currentStep == 0 ? Colors.white : Color(0Xff12CBC4),
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
                                    color: Colors.black.withOpacity(0.3),
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
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 29.0, right: 29.0),
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
                                      setState(
                                          () => _obscureTextRepeat = value),
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
                                          _selectedCountry!.countryCode!.code;
                                    });
                                  },
                                  onCountrySelected: (newValue) {
                                    setState(() {
                                      _selectedData = newValue;
                                      _selectedCountry = countries.firstWhere(
                                          (country) =>
                                              country.id == newValue!.value);
                                      _prefixNumberController.text =
                                          _selectedCountry!.countryCode!.code;
                                    });
                                  },
                                  prefixNumberController:
                                      _prefixNumberController,
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
                                ),
                              ],
                              const SizedBox(
                                height: 23,
                              ),
                              ButtonThemeWidget(
                                textStyle: StylesApp(context).buttonTextStyle,
                                onPressed: () async {
                                  if (_currentStep == 0) {
                                    _nextStep();
                                  } else {
                                    final bool validate =
                                        _formKey.currentState?.validate() ??
                                            false;
                                    if (!validate) {
                                      return;
                                    }
                                    LoadingService().showLoading(context);
                                    final authenticationProvider =
                                        Provider.of<AuthenticationProvider>(
                                            context,
                                            listen: false);
                                    // final SignupInput data;
                                    final dataToRegister = SignupInput(
                                        name: _nameController.text,
                                        lastname: _lastNameController.text,
                                        email: _emailController.text,
                                        birthdate: _dateController.text,
                                        // city: _cityController ,
                                        codeAreaId: _selectedPrefix?.id,
                                        countryId: _selectedCountry?.id,
                                        identifier: _userIdController.text,
                                        password: _passwordController.text,
                                        phoneNumber: _phoneNumberController.text
                                            .replaceAll(RegExp(r'[^\d]+'), ''),
                                        username: _userNameController.text,
                                        isBaptized: setIsBaptized,
                                        gender: setGender);

                                    final ResponseData response =
                                        await authenticationProvider
                                            .registerUser(dataToRegister);

                                    if (response.error != null) {
                                      LoadingService().hideLoading();
                                      await showCustomDialog(context,
                                          message: response.error!,
                                          dialogType: DialogType.error);
                                    } else {
                                      Navigator.popAndPushNamed(
                                          context, '/layoutPage');
                                    }
                                    LoadingService().hideLoading();
                                  }
                                },
                                text: _currentStep == 0
                                    ? "Continuar"
                                    : "Registrar",
                                buttonStyle:
                                    StylesApp(context).btnSecondarySmall,
                                width: StylesApp(context).btnHeight.width,
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
                                endIndent:
                                    8, // Espacio entre la línea y el texto
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
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
        ),
      ),
    );
  }
}
