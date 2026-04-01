import 'dart:math' as math;

import 'package:biblia_palabra_de_vida_app/models/model_data.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/models/pagination_model.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/services/country_search_service.dart';
import 'package:biblia_palabra_de_vida_app/services/phone_validator_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

class UserInfoStep extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool obscureTextPass;
  final bool obscureTextRepeat;
  final ValueChanged<bool> onObscureTextPassChanged;
  final ValueChanged<bool> onObscureTextRepeatChanged;

  final List<ModelData> dropDownList; // Lista de países
  final ModelData? selectedCountry;
  final ValueChanged<ModelData?> onCountrySelected;
  final ValueChanged<AreaCode?> onAreCodeSelected;
  final TextEditingController prefixNumberController;
  final TextEditingController phoneNumberController;

  const UserInfoStep({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscureTextPass,
    required this.obscureTextRepeat,
    required this.onObscureTextPassChanged,
    required this.onObscureTextRepeatChanged,
    required this.dropDownList,
    required this.selectedCountry,
    required this.onCountrySelected,
    required this.onAreCodeSelected,
    required this.prefixNumberController,
    required this.phoneNumberController,
  });

  @override
  State<UserInfoStep> createState() => _UserInfoStepState();
}

class _UserInfoStepState extends State<UserInfoStep> {
  late final CountrySearchService _countrySearchService;
  late final AreaCodeSearchService _areaCodeSearchService;
  final TextEditingController _internalPhoneController =
      TextEditingController(text: '');
  Key _phoneFieldKey = UniqueKey();

  bool get _isTablet {
    final shortestSide = MediaQuery.sizeOf(context).width;
    return shortestSide > 600;
  }

  // Función para width responsive
  double get _formWidth {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (_isTablet) {
      // Para tablet: 100% del ancho disponible en la columna
      return screenWidth;
    } else {
      // Para mobile: usa tu valor actual o 90% del ancho
      return math.min(
        StylesApp(context).sizeTextFormField.width,
        screenWidth * 0.9,
      );
    }
  }

  double get _fieldHeight {
    return _isTablet
        ? StylesApp(context).sizeTextFormField.height + 8
        : StylesApp(context).sizeTextFormField.height;
  }

  @override
  void initState() {
    super.initState();
    _countrySearchService = CountrySearchService();
    _areaCodeSearchService = AreaCodeSearchService();

    // Sincronizar el controlador interno con el externo
    _internalPhoneController.addListener(() {
      if (widget.phoneNumberController.text != _internalPhoneController.text) {
        widget.phoneNumberController.text = _internalPhoneController.text;
      }
    });

    // Si ya hay un país seleccionado al inicio, actualizar el teléfono
    if (widget.selectedCountry != null) {
      _updatePhonePrefixForCountry(widget.selectedCountry!);
    }
  }

  @override
  void dispose() {
    _internalPhoneController.dispose();
    super.dispose();
  }

  Future<void> _updatePhonePrefixForCountry(ModelData country) async {
    try {
      // Buscar el código de área por el ID del país
      final areaCodeFound = await _areaCodeSearchService
          .getCodeAreaById(country.originalData.countryCode.id);

      if (areaCodeFound != null) {
        setState(() {
          widget.prefixNumberController.text = country.originalData.isoCode;
          _phoneFieldKey = UniqueKey();
        });

        _internalPhoneController.text = _internalPhoneController.text;
      }
    } catch (e) {
      // Si no se encuentra el código de área, usar el código de país por defecto
      debugPrint('Error obteniendo código de área: $e');
    }
  }

  Future<PaginationModel<ModelData>> _searchCountries(
      String query, int page) async {
    return await _countrySearchService.searchCountries(
      query: query,
      page: page,
      limit: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

    return _isTablet
        ? _buildTabletLayout(translationProvider)
        : _buildMobileLayout(translationProvider);
  }

  // Layout para móvil (manteniendo el diseño actual)
  Widget _buildMobileLayout(AppTranslationProvider translationProvider) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // CORREO ELECTRÓNICO
          SizedBox(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height + 20,
            child: TextFormField(
              controller: widget.emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
                  .copyWith(
                    hintText: translationProvider.tr('user_info_step.email'),
                  ),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translationProvider
                      .tr('user_info_step.email_error_required');
                }
                final RegExp emailRegExp = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(.[a-zA-Z]+)?$");
                if (!emailRegExp.hasMatch(value)) {
                  return translationProvider
                      .tr('user_info_step.email_error_invalid');
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // CONTRASEÑA
          SizedBox(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height + 20,
            child: TextFormField(
              controller: widget.passwordController,
              obscureText: widget.obscureTextPass,
              textAlignVertical: TextAlignVertical.center,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
                  .copyWith(
                    hintText: translationProvider.tr('user_info_step.password'),
                    suffixIcon: IconButton(
                      iconSize: 20,
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        widget.obscureTextPass
                            ? Icons.visibility
                            : Icons.visibility_off,
                        size: 20,
                      ),
                      onPressed: () => widget
                          .onObscureTextPassChanged(!widget.obscureTextPass),
                    ),
                  ),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translationProvider
                      .tr('user_info_step.password_error_required');
                }
                if (value.length < 6) {
                  return translationProvider
                      .tr('user_info_step.password_error_length');
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // CONFIRMAR CONTRASEÑA
          SizedBox(
            width: _formWidth,
            height: StylesApp(context).sizeTextFormField.height + 20,
            child: TextFormField(
              controller: widget.confirmPasswordController,
              obscureText: widget.obscureTextRepeat,
              textAlignVertical: TextAlignVertical.center,
              decoration:
                  StylesApp(context).inputDecorationOutlineStyle.copyWith(
                        hintText: translationProvider
                            .tr('user_info_step.confirm_password'),
                        suffixIcon: IconButton(
                          alignment: Alignment.center,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            widget.obscureTextRepeat
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20,
                          ),
                          onPressed: () => widget.onObscureTextRepeatChanged(
                              !widget.obscureTextRepeat),
                        ),
                      ),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value != widget.passwordController.text) {
                  return translationProvider
                      .tr('user_info_step.password_mismatch');
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // PAÍS (NUEVO)
          SizedBox(
            width: _formWidth,
            // height: StylesApp(context).sizeTextFormField.height + 20,
            child: OptimizedSearchableDropdownFormField(
              hintText: translationProvider.tr('user_info_step.country_hint'),
              onChanged: (ModelData? newValue) {
                // Llamar al callback original
                widget.onCountrySelected(newValue);
                // Actualizar el prefijo del teléfono
                if (newValue != null) {
                  _updatePhonePrefixForCountry(newValue);
                }
              },
              searchFunction: _searchCountries,
              fetchItemById: (id) => _countrySearchService.getCountryById(id),
              defaultValueId: widget.selectedCountry?.value ?? '239',
              showClearButton: true,
              border: true,
              leadingIcon: Icon(
                Icons.location_on,
                color: StyleColor.cosmicBlue,
                size: 20,
              ),
              height: _fieldHeight,
              validator: (value) {
                if (value == null) {
                  return translationProvider.tr('user_info_step.country_error');
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // TELÉFONO (NUEVO)
          SizedBox(
            width: _formWidth,
            child: Stack(
              children: [
                IntlPhoneFieldWithValidation(
                  key: _phoneFieldKey,
                  controller: widget.phoneNumberController,
                  initialCountryCode:
                      widget.prefixNumberController.text.isNotEmpty
                          ? widget.prefixNumberController.text
                          : '+598',
                  hintText: translationProvider.tr('user_info_step.phone_hint'),
                  invalidNumberMessage: translationProvider
                      .tr('user_info_step.phone_error_invalid'),
                  validator: (PhoneNumber? phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return translationProvider
                          .tr('user_info_step.phone_error_required');
                    }
                    return PhoneValidatorService.validatePhoneNumber(phone);
                  },
                  onChanged: (phone) async {
                    setState(() {
                      widget.prefixNumberController.text = phone.countryCode;
                    });
                    try {
                      final areaCodeFound = await _areaCodeSearchService
                          .getCodeAreaByCode(phone.countryCode);

                      widget.onAreCodeSelected(areaCodeFound);
                      if (areaCodeFound != null) {
                        // Si necesitas actualizar algún área code
                      }
                    } catch (e) {
                      // Ignorar
                    }
                  },
                ),
                Positioned(
                  right: -10,
                  child: Tooltip(
                    message:
                        translationProvider.tr('user_info_step.phone_warning'),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        _showDialogInfoFormatNumberTel(translationProvider);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 41),
        ],
      ),
    );
  }

  // Layout para tablet con 2 columnas
  Widget _buildTabletLayout(AppTranslationProvider translationProvider) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            // Fila 1: Correo electrónico (columna completa)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translationProvider.tr('user_info_step.email'),
                  style: StylesApp(context).textStyleBody12.copyWith(
                        color: StyleColor.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: StylesApp(context).sizeTextFormField.height + 10,
                  child: TextFormField(
                    controller: widget.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        StylesApp(context).inputDecorationOutlineStyle.copyWith(
                              hintText: translationProvider
                                  .tr('user_info_step.email_hint'),
                              // errorStyle: TextStyle(fontSize: 12),
                            ),
                    style: StylesApp(context).textStyleBody12.copyWith(
                          color: StyleColor.black,
                          fontSize: 16,
                        ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return translationProvider
                            .tr('user_info_step.required_field');
                      }
                      final RegExp emailRegExp = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+(.[a-zA-Z]+)?$");
                      if (!emailRegExp.hasMatch(value)) {
                        return translationProvider
                            .tr('user_info_step.invalid_email');
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),

            // Fila 2: Contraseña y Confirmar contraseña (2 columnas)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Columna izquierda: Contraseña
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translationProvider.tr('user_info_step.password'),
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: StyleColor.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height:
                              StylesApp(context).sizeTextFormField.height + 10,
                          child: TextFormField(
                            controller: widget.passwordController,
                            obscureText: widget.obscureTextPass,
                            decoration: StylesApp(context)
                                .inputDecorationOutlineStyle
                                .copyWith(
                                  hintText: translationProvider
                                      .tr('user_info_step.password_hint'),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      widget.obscureTextPass
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 22,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () =>
                                        widget.onObscureTextPassChanged(
                                            !widget.obscureTextPass),
                                  ),
                                  // errorStyle: TextStyle(fontSize: 12),
                                ),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontSize: 16,
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return translationProvider
                                    .tr('user_info_step.required_field');
                              }
                              if (value.length < 6) {
                                return translationProvider
                                    .tr('user_info_step.minimum_characters');
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Columna derecha: Confirmar contraseña
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translationProvider
                              .tr('user_info_step.confirm_password_hint'),
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: StyleColor.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(height: 8),
                        SizedBox(
                          height:
                              StylesApp(context).sizeTextFormField.height + 10,
                          child: TextFormField(
                            controller: widget.confirmPasswordController,
                            obscureText: widget.obscureTextRepeat,
                            decoration: StylesApp(context)
                                .inputDecorationOutlineStyle
                                .copyWith(
                                  hintText: translationProvider.tr(
                                      'user_info_step.repeat_password_hint'),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      widget.obscureTextRepeat
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 22,
                                      color: Colors.grey[600],
                                    ),
                                    onPressed: () =>
                                        widget.onObscureTextRepeatChanged(
                                            !widget.obscureTextRepeat),
                                  ),
                                  // errorStyle: TextStyle(fontSize: 12),
                                ),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontSize: 16,
                                ),
                            validator: (value) {
                              if (value != widget.passwordController.text) {
                                return translationProvider
                                    .tr('user_info_step.password_mismatch');
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Fila 3: País y Teléfono
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${translationProvider.tr('user_info_step.country')}*",
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: StyleColor.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                        ),
                        SizedBox(height: 8),
                        OptimizedSearchableDropdownFormField(
                          hintText: translationProvider
                              .tr('user_info_step.country_search_hint'),
                          onChanged: (ModelData? newValue) {
                            // Llamar al callback original
                            widget.onCountrySelected(newValue);
                            // Actualizar el prefijo del teléfono
                            if (newValue != null) {
                              _updatePhonePrefixForCountry(newValue);
                            }
                          },
                          searchFunction: _searchCountries,
                          fetchItemById: (id) =>
                              _countrySearchService.getCountryById(id),
                          defaultValueId: 'VE',
                          showClearButton: true,
                          border: true,
                          leadingIcon: Icon(
                            Icons.search,
                            color: Colors.grey[600],
                            size: 20,
                          ),
                          validator: (value) {
                            if (value == null) {
                              return translationProvider
                                  .tr('user_info_step.country_error');
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${translationProvider.tr('user_info_step.phone')}*",
                              style:
                                  StylesApp(context).textStyleBody12.copyWith(
                                        color: StyleColor.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                _showDialogInfoFormatNumberTel(
                                    translationProvider);
                              },
                              child: Icon(
                                Icons.help_outline,
                                size: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IntlPhoneFieldWithValidation(
                            controller: widget.phoneNumberController,
                            validator: (PhoneNumber? phone) {
                              if (phone == null || phone.number.isEmpty) {
                                return translationProvider
                                    .tr('user_info_step.phone_error_required');
                              }
                              return PhoneValidatorService.validatePhoneNumber(
                                  phone);
                            },
                            onChanged: (phone) async {
                              setState(() {
                                widget.prefixNumberController.text =
                                    phone.countryCode;
                              });
                              try {
                                await _areaCodeSearchService
                                    .getCodeAreaByCode(phone.countryCode);
                              } catch (e) {
                                // Ignorar
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Información adicional para tablet
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0Xff12CBC4).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Color(0Xff12CBC4).withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Color(0Xff12CBC4),
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      translationProvider
                          .tr('user_info_step.required_fields_info'),
                      style: StylesApp(context).textStyleBody12.copyWith(
                            color: Colors.grey[700],
                            fontSize: 13,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  void _showDialogInfoFormatNumberTel(
      AppTranslationProvider translationProvider) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        translationProvider
                            .tr('user_info_step.phone_format_title'),
                        style: StylesApp(context).textStyleBody16.copyWith(
                              color: StyleColor.grayDark,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  translationProvider
                      .tr('user_info_step.phone_format_description'),
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: StyleColor.grayDark,
                        fontSize: 14,
                      ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        translationProvider
                            .tr('user_info_step.correct_examples'),
                        style: StylesApp(context).textStyleBody16.copyWith(
                            color: StyleColor.grayDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                      SizedBox(height: 8),
                      Text(
                        translationProvider
                            .tr('user_info_step.uruguay_example'),
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(color: StyleColor.grayDark, fontSize: 14),
                      ),
                      Text(
                        translationProvider
                            .tr('user_info_step.argentina_example'),
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(color: StyleColor.grayDark, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: StylesApp(context).btnWidgetSmall,
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      translationProvider.tr('user_info_step.understood'),
                      style: StylesApp(context).textStyleBody14,
                    ),
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
