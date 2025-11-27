import 'dart:math' as math;

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/services/phone_validator_service.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
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
  bool get _isTablet {
    final shortestSide = MediaQuery.sizeOf(context).shortestSide;
    return shortestSide > 600;
  }

  double get _formWidth {
    final screenWidth = MediaQuery.sizeOf(context).width;
    if (_isTablet) {
      // Para tablet: máximo 500px o 60% del ancho
      return math.min(500, screenWidth * 0.6);
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
  Widget build(BuildContext context) {
    final double formWidth = StylesApp(context).sizeTextFormField.width;
    final double screenWidth = MediaQuery.sizeOf(context).width;

    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: TextFormField(
              controller: widget.nameController,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
                  .copyWith(hintText: "Nombre"),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "El Nombre es obligatorio";
                }
                return null;
              },
            ),
          ),
          SizedBox(height: _isTablet ? 28.0 : 23.0),
          // CAMPO APELLIDO
          SizedBox(
            width: formWidth,
            height: StylesApp(context).sizeTextFormField.height,
            child: TextFormField(
              controller: widget.lastNameController,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
                  .copyWith(hintText: "Apellido"),
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: StyleColor.black),
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
          SizedBox(
            width: formWidth,
            child: ValidatedRadioGroup<String>(
              label: "Género:",
              initialValue: widget.gender,
              onChanged: (newValue) {
                setState(() {
                  widget.onChangeGender!(newValue);
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Por favor selecciona tu género";
                }
                return null;
              },
              onSaved: (newValue) {},
              options: [
                RadioButtonOption(value: "m", label: "Masculino"),
                RadioButtonOption(value: "f", label: "Femenino"),
              ],
            ),
          ),
          SizedBox(height: _isTablet ? 28.0 : 23.0),
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
          SizedBox(height: _isTablet ? 28.0 : 23.0),

          // BAUTIZADO
          Container(
            width: formWidth,
            padding: EdgeInsets.symmetric(
              horizontal: _isTablet ? 20 : 8,
              vertical: _isTablet ? 12 : 8,
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
                borderRadius: BorderRadius.circular(8)),
            child: RadioButtonWidget<bool>(
                // Ejemplo con opciones de tipo String
                label: "Bautizado:",
                value: widget.isBaptized,
                onChanged: (newValue) => widget.onChangeBaptized!(newValue!),
                options: [
                  RadioButtonOption(value: true, label: "Si"),
                  RadioButtonOption(value: false, label: "No")
                ]),
          ),
          SizedBox(height: _isTablet ? 28.0 : 23.0),

          // PAÍS
          SizedBox(
            width: formWidth,
            child: CustomDropdownWithValidation(
              items: widget.dropDownList,
              hintText: "Seleccione un país",
              onChanged: widget.onCountrySelected,
              validator: (value) {
                if (value == null) {
                  return "Por favor selecciona un país";
                }
                return null;
              },
              border: true,
            ),
          ),
          SizedBox(height: _isTablet ? 28.0 : 23.0),

          // TELÉFONO
          SizedBox(
            width: formWidth,
            child: Stack(
              children: [
                IntlPhoneFieldWithValidation(
                  controller: widget.phoneNumberController,
                  validator: (PhoneNumber? phone) {
                    if (phone == null || phone.number.isEmpty) {
                      return 'El número de teléfono es obligatorio';
                    }
                    return PhoneValidatorService.validatePhoneNumber(phone);
                  },
                  onChanged: (phone) {
                    if (kDebugMode) {
                      print('Country Code: ${phone.countryCode}');
                      print('Complete Number: ${phone.completeNumber}');
                      print('Country ISO: ${phone.countryISOCode}');
                      print('Raw Number: ${phone.number}');

                      // MOSTRAR INFORMACIÓN ADICIONAL PARA DEBUG
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
                      AreaCode code = Provider.of<CatalogueProvider>(context,
                              listen: false)
                          .allAreasCode
                          .firstWhere(
                              (areaCode) => areaCode.code == phone.countryCode);
                      widget.onPrefixSelected(
                          ModelData(label: code.code, value: code.id));
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
                    message: 'El número de operador no debe iniciar con 0',
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 20,
                      icon: const Icon(Icons.info_outline),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Información'),
                            content: const Text(
                                'El número de operador no debe iniciar con 0'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: _isTablet ? 50 : 41),
        ],
      ),
    );
  }
}
