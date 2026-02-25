import 'dart:math' as math;

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/services/country_search_service.dart';
import 'package:biblia_palabra_de_vida_app/services/phone_validator_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:provider/provider.dart';

class PersonalInfoStep extends StatefulWidget {
  final bool autoValidate;
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController dateController;
  final String gender;
  final bool isBaptized;
  final DateTime? selectedDate;
  final ValueChanged<DateTime?> onDateSelected;
  final List<ModelData> dropDownListArea;
  final List<ModelData> dropDownList;
  final ModelData? selectedDataArea;
  final ModelData? selectedData;
  final Country? selectedCountry;
  final ValueChanged<ModelData?> onPrefixSelected;
  final ValueChanged<ModelData?> onCountrySelected;
  final TextEditingController prefixNumberController;
  final TextEditingController phoneNumberController;
  final void Function(String?)? onChangeGender;
  final void Function(bool?)? onChangeBaptized;

  const PersonalInfoStep({
    super.key,
    required this.nameController,
    required this.lastNameController,
    required this.dateController,
    required this.gender,
    required this.isBaptized,
    required this.selectedDate,
    required this.onDateSelected,
    required this.dropDownListArea,
    required this.dropDownList,
    required this.selectedDataArea,
    required this.selectedData,
    required this.selectedCountry,
    required this.onPrefixSelected,
    required this.onCountrySelected,
    required this.prefixNumberController,
    required this.phoneNumberController,
    required this.autoValidate,
    this.onChangeGender,
    this.onChangeBaptized,
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  late final CountrySearchService _countrySearchService;
  late final AreaCodeSearchService _areaCodeSearchService;

  bool get _isTablet {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    return shortestSide > 600;
  }

  double get _formWidth {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (_isTablet) {
      return screenWidth * 0.9;
    } else {
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
  }

  Future<PaginationModel<ModelData>> _searchCountries(String query, int page) {
    return _countrySearchService.searchCountries(
      query: query,
      page: page,
      limit: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

    return ResponsiveLayout(
      mobile: _buildMobileLayout(translationProvider),
      tablet: _buildTabletLayout(translationProvider),
    );
  }

  // Layout para móvil (manteniendo el diseño actual)
  Widget _buildMobileLayout(AppTranslationProvider translationProvider) {
    final double formWidth = StylesApp(context).sizeTextFormField.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          // NOMBRE
          SizedBox(
            width: formWidth,
            child: TextFormField(
              controller: widget.nameController,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
                  .copyWith(
                      hintText: translationProvider
                          .tr('personal_info_step.first_name_hint')),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translationProvider
                      .tr('personal_info_step.first_name_error');
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // APELLIDO
          SizedBox(
            width: formWidth,
            child: TextFormField(
              controller: widget.lastNameController,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
                  .copyWith(
                      hintText: translationProvider
                          .tr('personal_info_step.last_name_hint')),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translationProvider
                      .tr('personal_info_step.last_name_error');
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 23.0),

          // GÉNERO
          SizedBox(
            width: formWidth,
            child: ValidatedRadioGroup<String>(
              label: translationProvider.tr('personal_info_step.gender'),
              initialValue: widget.gender,
              onChanged: (newValue) {
                setState(() {
                  widget.onChangeGender!(newValue);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return translationProvider
                      .tr('personal_info_step.gender_error');
                }
                return null;
              },
              onSaved: (newValue) {},
              options: [
                RadioButtonOption(
                    value: "m",
                    label: translationProvider.tr('personal_info_step.male')),
                RadioButtonOption(
                    value: "f",
                    label: translationProvider.tr('personal_info_step.female')),
              ],
            ),
          ),
          SizedBox(height: 23.0),

          // FECHA DE NACIMIENTO
          SizedBox(
            width: formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: DatePickerFormField(
              initialDate: DateTime.now().subtract(Duration(days: 15 * 365)),
              onChanged: (value) {
                widget.dateController.text = value;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // BAUTIZADO
          Container(
            width: formWidth,
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: RadioButtonWidget<bool>(
                label: translationProvider.tr('personal_info_step.baptized'),
                value: widget.isBaptized,
                onChanged: (newValue) => widget.onChangeBaptized!(newValue!),
                options: [
                  RadioButtonOption(
                      value: true,
                      label: translationProvider.tr('personal_info_step.yes')),
                  RadioButtonOption(
                      value: false,
                      label: translationProvider.tr('personal_info_step.no'))
                ]),
          ),
          SizedBox(height: 23.0),

          // PAÍS
          SizedBox(
            width: _formWidth,
            child: OptimizedSearchableDropdownFormField(
              hintText:
                  translationProvider.tr('personal_info_step.country_hint'),
              onChanged: widget.onCountrySelected,
              searchFunction: _searchCountries,
              fetchItemById: (id) => _countrySearchService.getCountryById(id),
              defaultValueId: 'VE',
              showClearButton: true,
              border: true,
              leadingIcon: Icon(
                Icons.location_on,
                color: StyleColor.cosmicBlue,
                size: 20,
              ),
              height: StylesApp(context).sizeTextFormField.height + 4,
              validator: (value) {
                if (value == null) {
                  return translationProvider
                      .tr('personal_info_step.country_error');
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 23.0),

          // TELÉFONO
          SizedBox(
            width: formWidth,
            child: Stack(
              children: [
                IntlPhoneFieldWithValidation(
                  controller: widget.phoneNumberController,
                  hintText: translationProvider.tr('personal_info_step.phone_hint'),
                  invalidNumberMessage: translationProvider
                      .tr('personal_info_step.phone_error_invalid'),
                  validator: (PhoneNumber? phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return translationProvider
                          .tr('personal_info_step.phone_error_required');
                    }
                    return PhoneValidatorService.validatePhoneNumber(phone);
                  },
                  onChanged: (phone) async {
                    if (kDebugMode) {
                      print("Estoy en Personal Info ...");
                      print('Country Code: ${phone.countryCode}');
                      print('Complete Number: ${phone.completeNumber}');
                      print('Country ISO: ${phone.countryISOCode}');
                      print('Raw Number: ${phone.number}');

                      final rules = PhoneValidatorService.getCountryRules(
                          phone.countryISOCode);
                      if (rules != null) {
                        print(
                            'Country Rules: ${rules.name} - Min: ${rules.minLength}, Max: ${rules.maxLength}');
                      }
                    }

                    setState(() {
                      widget.prefixNumberController.text = phone.countryCode;
                    });
                    try {
                      final areaCodeFound = await _areaCodeSearchService
                          .getCodeAreaByCode(phone.countryCode);
                      if (areaCodeFound != null) {
                        AreaCode code = AreaCode(
                            id: areaCodeFound.id, code: areaCodeFound.code);
                        widget.onPrefixSelected(
                            ModelData(label: code.code, value: code.id));
                      }
                    } catch (e) {
                      if (kDebugMode) {
                        print(
                            'Código de Area no encontrado para: ${phone.countryCode}');
                      }
                    }
                  },
                ),
                Positioned(
                  right: -10,
                  child: Tooltip(
                    message: translationProvider
                        .tr('personal_info_step.phone_warning'),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        _showDialogInfoFormatNUmberTel(translationProvider);
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
  // Layout para tablet con 2 columnas - VERSIÓN CORREGIDA
  Widget _buildTabletLayout(AppTranslationProvider translationProvider) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ConstrainedBox(
          // AÑADE ESTE ConstrainedBox
          constraints: BoxConstraints(
            maxWidth: 600, // O el ancho máximo que quieras para tablet
          ),
          child: Column(
            children: [
              // Fila 1: Nombre y Apellido (2 columnas)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: Nombre
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${translationProvider.tr('personal_info_step.first_name')}*",
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: _fieldHeight,
                            child: TextFormField(
                              controller: widget.nameController,
                              decoration: StylesApp(context)
                                  .inputDecorationOutlineStyle
                                  .copyWith(
                                    hintText: translationProvider.tr(
                                        'personal_info_step.first_name_example'),
                                  ),
                              style:
                                  StylesApp(context).textStyleBody12.copyWith(
                                        color: StyleColor.black,
                                        fontSize: 16,
                                      ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return translationProvider
                                      .tr('personal_info_step.required_field');
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Columna derecha: Apellido
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${translationProvider.tr('personal_info_step.last_name')} *",
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: _fieldHeight,
                            child: TextFormField(
                              controller: widget.lastNameController,
                              decoration: StylesApp(context)
                                  .inputDecorationOutlineStyle
                                  .copyWith(
                                    hintText: translationProvider.tr(
                                        'personal_info_step.last_name_example'),
                                  ),
                              style:
                                  StylesApp(context).textStyleBody12.copyWith(
                                        color: StyleColor.black,
                                        fontSize: 16,
                                      ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return translationProvider
                                      .tr('personal_info_step.required_field');
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
              SizedBox(height: 8),

              // Fila 2: Género y Bautizado (2 columnas)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: Género
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${translationProvider.tr('personal_info_step.gender')}",
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            // height: _fieldHeight,
                            // padding: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: ValidatedRadioGroup<String>(
                              label: "",
                              initialValue: widget.gender,
                              onChanged: (newValue) {
                                setState(() {
                                  widget.onChangeGender!(newValue);
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return translationProvider
                                      .tr('personal_info_step.select_gender');
                                }
                                return null;
                              },
                              onSaved: (newValue) {},
                              options: [
                                RadioButtonOption(
                                    value: "m",
                                    label: translationProvider
                                        .tr('personal_info_step.male')),
                                RadioButtonOption(
                                    value: "f",
                                    label: translationProvider
                                        .tr('personal_info_step.female')),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Columna derecha: Bautizado
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translationProvider
                                .tr('personal_info_step.baptized'),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: StyleColor.black),
                              color: StyleColor.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: RadioButtonWidget<bool>(
                              label: "",
                              value: widget.isBaptized,
                              onChanged: (newValue) =>
                                  widget.onChangeBaptized!(newValue!),
                              options: [
                                RadioButtonOption(
                                    value: true,
                                    label: translationProvider
                                        .tr('personal_info_step.yes')),
                                RadioButtonOption(
                                    value: false,
                                    label: translationProvider
                                        .tr('personal_info_step.no'))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Fila 3: Fecha de Nacimiento y País (2 columnas)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Columna izquierda: Fecha de Nacimiento
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translationProvider
                                .tr('personal_info_step.birth_date'),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                          ),
                          SizedBox(height: 8),
                          SizedBox(
                            height: _fieldHeight,
                            child: DatePickerFormField(
                              initialDate: DateTime.now()
                                  .subtract(Duration(days: 15 * 365)),
                              onChanged: (value) {
                                widget.dateController.text = value;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Columna derecha: País
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            translationProvider
                                .tr('personal_info_step.country'),
                            style: StylesApp(context).textStyleBody12.copyWith(
                                  color: StyleColor.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                          ),
                          SizedBox(height: 8),
                          OptimizedSearchableDropdownFormField(
                            hintText: translationProvider
                                .tr('personal_info_step.country_search_hint'),
                            onChanged: widget.onCountrySelected,
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
                            // height: _fieldHeight,
                            validator: (value) {
                              if (value == null) {
                                return translationProvider
                                    .tr('personal_info_step.country_error');
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              // Fila 4: Teléfono (columna completa con información)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        translationProvider.tr('personal_info_step.phone'),
                        style: StylesApp(context).textStyleBody12.copyWith(
                              color: StyleColor.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                      ),
                      SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          _showDialogInfoFormatNUmberTel(translationProvider);
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
                              .tr('personal_info_step.phone_error_required');
                        }
                        return PhoneValidatorService.validatePhoneNumber(phone);
                      },
                      onChanged: (phone) async {
                        if (kDebugMode) {
                          print("Personal Info tablet");
                          print('Country Code: ${phone.countryCode}');
                          print('Complete Number: ${phone.completeNumber}');
                          print('Country ISO: ${phone.countryISOCode}');
                          print('Raw Number: ${phone.number}');

                          final rules = PhoneValidatorService.getCountryRules(
                              phone.countryISOCode);
                          if (rules != null) {
                            print(
                                'Country Rules: ${rules.name} - Min: ${rules.minLength}, Max: ${rules.maxLength}');
                          }
                        }

                        setState(() {
                          widget.prefixNumberController.text =
                              phone.countryCode;
                        });
                        try {
                          final areaCodeFound = await _areaCodeSearchService
                              .getCodeAreaByCode(phone.countryCode);
                          if (areaCodeFound != null) {
                            AreaCode code = AreaCode(
                                id: areaCodeFound.id, code: areaCodeFound.code);
                            widget.onPrefixSelected(
                                ModelData(label: code.code, value: code.id));
                          }
                        } catch (e) {
                          if (kDebugMode) {
                            print(
                                'Código de Area no encontrado para: ${phone.countryCode}');
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

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
                            .tr('personal_info_step.required_fields_info'),
                        style: StylesApp(context).textStyleBody12.copyWith(
                              color: Colors.grey[700],
                              fontSize: 13,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> _showDialogInfoFormatNUmberTel(
      AppTranslationProvider translationProvider) {
    return showDialog(
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
                            .tr('personal_info_step.phone_format_title'),
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
                      .tr('personal_info_step.phone_format_description'),
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
                            .tr('personal_info_step.correct_examples'),
                        style: StylesApp(context).textStyleBody16.copyWith(
                            color: StyleColor.grayDark,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0),
                      ),
                      SizedBox(height: 8),
                      Text(
                        translationProvider
                            .tr('personal_info_step.uruguay_example'),
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(color: StyleColor.grayDark, fontSize: 14),
                      ),
                      Text(
                        translationProvider
                            .tr('personal_info_step.argentina_example'),
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(color: StyleColor.grayDark, fontSize: 14),
                      ),
                      Text(
                        translationProvider
                            .tr('personal_info_step.chile_example'),
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(color: StyleColor.grayDark, fontSize: 14),
                      ),
                      Text(
                        translationProvider
                            .tr('personal_info_step.colombia_example'),
                        style: StylesApp(context)
                            .textStyleBody16
                            .copyWith(color: StyleColor.grayDark, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber, size: 16, color: Colors.orange),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          translationProvider
                              .tr('personal_info_step.phone_warning'),
                          style: StylesApp(context).textStyleBody16.copyWith(
                                color: StyleColor.grayDark,
                                fontSize: 13,
                              ),
                        ),
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
                      translationProvider.tr('personal_info_step.understood'),
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
