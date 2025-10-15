import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
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
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final double formWidth = StylesApp(context).sizeTextFormField.width;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: formWidth,
            child: TextFormField(
              controller: widget.nameController,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
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
            width: formWidth,
            child: TextFormField(
              controller: widget.lastNameController,
              decoration: StylesApp(context)
                  .inputDecorationOutlineStyle
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
          ValidatedRadioGroup<String>(
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
          const SizedBox(
            height: 23.0,
          ),
          Container(
            width: formWidth,
            child: DatePickerFormField(
              initialDate: DateTime.now().subtract(Duration(days: 15 * 365)),
              onChanged: (value) {
                widget.dateController.text = value;
              },
            ),
          ),
          const SizedBox(
            height: 23.0,
          ),
          Container(
            width: formWidth,
            padding: EdgeInsets.symmetric(horizontal: 8),
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
          const SizedBox(
            height: 23.0,
          ),
          Container(
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
          const SizedBox(
            height: 23.0,
          ),
          Container(
            width: formWidth,
            child: IntlPhoneFieldWithValidation(
              controller: widget.phoneNumberController,
              validator: (PhoneNumber? phone) {
                if (phone == null || phone.number.isEmpty) {
                  return "Por favor, ingresa tu número de teléfono.";
                }
                final cleanNumber =
                    phone.number.replaceAll(RegExp(r'[^\d]'), '');
                if (cleanNumber.length < 7) {
                  return "Número de teléfono demasiado corto.";
                }
                return null;
              },
              onChanged: (phone) {
                print(phone.completeNumber);
                setState(() {
                  widget.prefixNumberController.text = phone.countryCode;
                });
                 AreaCode code = Provider.of<CatalogueProvider>(context,
                    listen: false)
                .allAreasCode
                .firstWhere((areaCode) => areaCode.code == phone.countryCode);
                  widget.onPrefixSelected(ModelData(label: code.code, value: code.id));
              },
            ),
          ),
          const SizedBox(
            height: 41,
          ),
        ],
      ),
    );
  }
}
