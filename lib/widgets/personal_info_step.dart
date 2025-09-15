import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class PersonalInfoStep extends StatefulWidget {
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
    this.onChangeGender,
    this.onChangeBaptized,
  });

  @override
  State<PersonalInfoStep> createState() => _PersonalInfoStepState();
}

class _PersonalInfoStepState extends State<PersonalInfoStep> {
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateFormat formatter = DateFormat.yMd('es_ES');
  //   final DateTime now = DateTime.now();
  //   final DateTime? picked = await showDatePicker(
  //       context: context,
  //       initialDate: widget.selectedDate ?? now,
  //       firstDate: DateTime(1951),
  //       lastDate: now,
  //       locale: const Locale('es', 'ES'),
  //       builder: (BuildContext context, Widget? child) {
  //         return Theme(
  //           data: ThemeData.light().copyWith(
  //             primaryColor: const Color(0Xff12CBC4),
  //             colorScheme: ColorScheme.light(primary: const Color(0Xff12CBC4)),
  //             buttonTheme:
  //                 const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  //           ),
  //           child: child!,
  //         );
  //       });
  //   if (picked != null && picked != widget.selectedDate) {
  //     widget.onDateSelected(picked);
  //     widget.dateController.text = formatter.format(picked);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
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
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
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
        Container(
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              color: Colors.white,
              borderRadius: BorderRadius.circular(8)),
          child: RadioButtonWidget<String>(
            label: "Género:",
            value: widget.gender,
            onChanged: (newValue) => widget.onChangeGender!(newValue),
            options: [
              RadioButtonOption(value: "m", label: "Masculino"),
              RadioButtonOption(value: "f", label: "Femenino")
            ],
          ),
        ),
        const SizedBox(
          height: 23.0,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
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
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
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
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          decoration: BoxDecoration(
              color: StyleColor.white,
              borderRadius: BorderRadius.circular(8.0)),
          child: CustomDropdownBottomWidget<Country>(
            hintText: "Seleccione un país",
            items: widget.dropDownList,
            onChanged: widget.onCountrySelected,
            selectedItem: widget.selectedData,
          ),
        ),
        const SizedBox(
          height: 23.0,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: 160.0,
            maxWidth: StylesApp(context).sizeTextFormField.width,
          ),
          child: Row(
            children: [
              // Campo del código del país
              Flexible(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: StyleColor.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: CustomDropdownBottomWidget<AreaCode>(
                    hintText: "código",
                    items: widget.dropDownListArea,
                    onChanged: widget.onPrefixSelected,
                    selectedItem: widget.selectedDataArea,
                  ),
                ),
              ),
              const SizedBox(width: 10), // Espaciado entre los campos
              // Campo del número de teléfono
              Flexible(
                flex: 7,
                child: TextFormField(
                  controller: widget.phoneNumberController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    maskFormatterTel, // Permite solo números
                  ],
                  decoration:
                      StylesApp(context).inputDecorationOutlineStyle.copyWith(
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
        ),
        const SizedBox(
          height: 41,
        ),
      ],
    );
  }
}
