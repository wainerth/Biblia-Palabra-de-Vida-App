import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0; // Controla el paso actual
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _prefixNumberController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  bool _obscureText = true;
  String _selectedCountry = 'Selecciona tu país';
  final List<String> countries = [
    'Selecciona tu país',
    'Argentina',
    'Brasil',
    'Uruguay',
    'Chile',
    'Perú'
  ];

  var maskFormatterTel = MaskTextInputFormatter(
    mask: '###-##-##',
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
      if (kDebugMode) {
        print("Registro completado");
      }
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
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: BoxDecoration(
            color:_currentStep == 0 ?Colors.white  : Color(0Xff12CBC4),
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
                        title: "¡La Biblia\n  Palabra de\n Vida!",
                        subtitle: "Registro",
                        heightContent: 329,
                      ),
                      const SizedBox(
                        height: 42,
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
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _userIdController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Permite solo números
                                    ],
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          hintText: "Identificador de usuario",
                                        ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "El identificador es obligatorio";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 23.0,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    // inputFormatters: [maskFormatterEmail],
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
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
                                const SizedBox(
                                  height: 23.0,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscureText,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          hintText: "Contraseña",
                                          suffixIcon: IconButton(
                                            iconSize: 20,
                                            padding: const EdgeInsets.all(0),
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
                                  height: 23.0,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _confirmPasswordController,
                                    obscureText: _obscureText,
                                    textAlignVertical: TextAlignVertical.center,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          hintText: "Confirmar Contraseña",
                                          suffixIcon: IconButton(
                                            alignment: Alignment.center,
                                            iconSize: 20,
                                            padding: const EdgeInsets.all(0),
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
                              ] else if (_currentStep == 1) ...[
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(hintText: "Nombre"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "El Nombre es obligatorio";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 23.0,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _lastNameController,
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(hintText: "Apellido"),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "El Apellido es obligatorio";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 23.0,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: TextFormField(
                                    controller: _dateController,
                                    readOnly: true,
                                    onTap: () => _selectDate(context),
                                    decoration: StylesApp(context)
                                        .inputDecorationStyle
                                        .copyWith(
                                          hintText: "Fecha de nacimiento",
                                          suffixIcon:
                                              const Icon(Icons.calendar_today),
                                        ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "La Fecha de nacimiento es obligatoria";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 23.0,
                                ),
                                Container(
                                  constraints:
                                      const BoxConstraints(minWidth: 160.0),
                                  child: DropdownButtonFormField(
                                    value: _selectedCountry,
                                    items: countries.map((String country) {
                                      return DropdownMenuItem(
                                        value: country,
                                        child: Text(country),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        _selectedCountry = newValue!;
                                      });
                                    },
                                    decoration:
                                        StylesApp(context).inputDecorationStyle,
                                  ),
                                ),
                                const SizedBox(
                                  height: 23.0,
                                ),
                                Row(
                                  children: [
                                    // Campo del código del país
                                    Flexible(
                                      flex: 2,
                                      child: TextFormField(
                                        controller: _prefixNumberController,
                                        initialValue:
                                            "+598", // Código inicial del país
                                        enabled:
                                            false, // Deshabilitado para que no pueda ser editado
                                        decoration: StylesApp(context)
                                            .inputDecorationStyle
                                            .copyWith(
                                              filled: true,
                                            ),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    const SizedBox(
                                        width:
                                            10), // Espaciado entre los campos
                                    // Campo del número de teléfono
                                    Flexible(
                                      flex: 8,
                                      child: TextFormField(
                                        controller: _phoneNumberController,
                                        keyboardType: TextInputType.phone,
                                        inputFormatters: [
                                          maskFormatterTel, // Permite solo números
                                        ],
                                        decoration: StylesApp(context)
                                            .inputDecorationStyle
                                            .copyWith(
                                              hintText: "Número de teléfono",
                                            ),
                                        style: const TextStyle(fontSize: 16),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Por favor, ingresa tu número de teléfono.";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(
                                height: 23,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha:  0.25),
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
                                    }
                                  },
                                  style: StylesApp(context).btnSecondarySmall,
                                  child: Text(
                                    _currentStep == 0
                                        ? "Continuar"
                                        : "Registrar",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
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
