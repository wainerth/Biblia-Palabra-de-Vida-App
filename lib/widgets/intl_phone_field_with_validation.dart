// IntlPhoneFieldWithValidation.dart
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import 'package:intl_phone_field/countries.dart';

class IntlPhoneFieldWithValidation extends FormField<PhoneNumber> {
  IntlPhoneFieldWithValidation({
    super.key,
    required TextEditingController controller,
    String? initialPhoneCode, // "+598", "+58", etc.
    String? initialCountryCode, // "UY", "VE", etc.
    super.validator,
    ValueChanged<PhoneNumber>? onChanged,
  }) : super(
          builder: (FormFieldState<PhoneNumber> field) {
            // Función robusta para determinar el país inicial
            String determineInitialCountryCode() {
              // Prioridad 1: Código de país directo
              if (initialCountryCode != null &&
                  initialCountryCode.length == 2) {
                final country = countries.firstWhere(
                  (c) => c.code == initialCountryCode.toUpperCase(),
                  orElse: () => countries.firstWhere((c) => c.code == 'US'),
                );
                return country.code;
              }

              // Prioridad 2: Convertir código de teléfono a código de país
              if (initialPhoneCode != null) {
                final country = getCountryFromPhoneCode(initialPhoneCode);
                return country?.code ?? 'US';
              }

              // Prioridad 3: Usar locale del dispositivo
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

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntlPhoneField(
                  initialCountryCode: determineInitialCountryCode(),
                  controller: controller,
                  style: StylesApp(field.context).textStyleBody14.copyWith(color: StyleColor.black),
                  dropdownTextStyle: StylesApp(field.context).textStyleBody14.copyWith(color: StyleColor.black),
                  decoration: StylesApp(field.context)
                      .inputDecorationOutlineStyle
                      .copyWith(
                        hintText: "Número de teléfono",
                        errorText: field.hasError ? field.errorText : null,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: field.hasError ? Colors.red : Colors.black,
                          ),
                        ),
                      ),
                  validator: validator,
                  languageCode: "es",
                  invalidNumberMessage: "Número de Teléfono Invalido!",
                  onChanged: (phone) {
                    field.didChange(phone);
                    onChanged?.call(phone);
                  },
                  onCountryChanged: (country) {
                    controller.text = '';
                    print('Country changed to: ${country.code}');
                    print('Country dial code: ${country.dialCode}');
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
