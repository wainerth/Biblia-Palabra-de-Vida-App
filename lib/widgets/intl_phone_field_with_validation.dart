// IntlPhoneFieldWithValidation.dart
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:intl_phone_field/countries.dart';

class IntlPhoneFieldWithValidation extends FormField<PhoneNumber> {
  IntlPhoneFieldWithValidation({
    super.key,
    required TextEditingController controller,
    String? initialPhoneCode,
    String? initialCountryCode,
    super.validator,
    ValueChanged<PhoneNumber>? onChanged,
    bool disableLengthCheck = true,
    String? hintText,
    String? invalidNumberMessage,
  }) : super(
          builder: (FormFieldState<PhoneNumber> field) {
            String determineInitialCountryCode() {
              if (initialCountryCode != null &&
                  initialCountryCode.length == 2) {
                final country = countries.firstWhere(
                  (c) => c.code == initialCountryCode.toUpperCase(),
                  orElse: () => countries.firstWhere((c) => c.code == 'US'),
                );
                return country.code;
              }

              if (initialPhoneCode != null) {
                final country = getCountryFromPhoneCode(initialPhoneCode);
                return country?.code ?? 'US';
              }

              final locale = Localizations.localeOf(field.context);
              if (locale.countryCode != null) {
                final country = countries.firstWhere(
                  (c) => c.code == locale.countryCode!.toUpperCase(),
                  orElse: () => countries.firstWhere((c) => c.code == 'US'),
                );
                return country.code;
              }

              return 'US';
            }

            // Si el controlador tiene texto, actualizar el campo
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (controller.text.isNotEmpty && field.value == null) {
                final countryCode = determineInitialCountryCode();
                final country = countries.firstWhere(
                  (c) => c.code == countryCode,
                  orElse: () => countries.firstWhere((c) => c.code == 'US'),
                );

                final phoneNumber = PhoneNumber(
                  countryISOCode: country.code,
                  countryCode: country.dialCode,
                  number: controller.text.replaceAll(RegExp(r'[^\d]+'), ''),
                );

                // ✅ Esto ahora es seguro porque ya pasó el build
                field.didChange(phoneNumber);
              }
            });

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntlPhoneField(
                  pickerDialogStyle: PickerDialogStyle(
                    countryNameStyle: StylesApp(field.context)
                        .textStyleBody16
                        .copyWith(color: StyleColor.black),
                    backgroundColor: Colors.white,
                    width: isTablet(field.context) ? 400.0 : double.infinity,
                  ),
                  initialCountryCode: determineInitialCountryCode(),
                  controller: controller,
                  style: StylesApp(field.context)
                      .textStyleBody14
                      .copyWith(color: StyleColor.black),
                  dropdownTextStyle: StylesApp(field.context)
                      .textStyleBody14
                      .copyWith(color: StyleColor.black),
                  disableLengthCheck: disableLengthCheck,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [],
                  decoration: StylesApp(field.context)
                      .inputDecorationOutlineStyle
                      .copyWith(
                        hintText: hintText,
                        errorMaxLines: 2,
                        error: field.hasError
                            ? Text(
                                field.errorText ?? '',
                                style: StylesApp(field.context)
                                    .textStyleBody12
                                    .copyWith(color: Colors.red),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: field.hasError ? Colors.red : Colors.grey,
                          ),
                        ),
                      ),
                  languageCode: "es",
                  invalidNumberMessage: invalidNumberMessage,
                  onChanged: (phone) {
                    // 🔹 ACTUALIZAR EL ESTADO DEL FORMULARIO
                    field.didChange(phone);
                    field.validate(); // Forzar validación
                    onChanged?.call(phone);
                  },
                  onCountryChanged: (country) {
                    controller.text = '';
                    field.didChange(null); // Limpiar valor al cambiar país
                  },
                ),
              ],
            );
          },
        );
}

// Función auxiliar
Country getCountryFromPhoneCode(String phoneCode) {
  if (phoneCode.startsWith('+')) {
    phoneCode = phoneCode.substring(1);
  }

  return countries.firstWhere(
    (c) => c.dialCode == phoneCode,
    orElse: () => countries.firstWhere((c) => c.code == 'US'),
  );
}
