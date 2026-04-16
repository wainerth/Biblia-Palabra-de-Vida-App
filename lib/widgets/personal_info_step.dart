import 'dart:math' as math;

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

    return ResponsiveLayout(
      mobile: _buildMobileLayout(translationProvider),
      tablet: _buildTabletLayout(translationProvider),
    );
  }

  // Layout para móvil
  Widget _buildMobileLayout(AppTranslationProvider translationProvider) {
    final double formWidth = _formWidth;

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
          SizedBox(height: 41),
        ],
      ),
    );
  }

  // Layout para tablet
  Widget _buildTabletLayout(AppTranslationProvider translationProvider) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 600,
          ),
          child: Column(
            children: [
              // Fila 1: Nombre y Apellido
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

              // Fila 2: Género y Bautizado
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

              // Fila 3: Fecha de Nacimiento 
              Column(
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

}
