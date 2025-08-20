import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class GenericCoordinationWidget<T> extends StatelessWidget {
  final Widget? countryDropdown;
  final Widget? areaDropdown;
  final Widget? currencyDropdown;
  final Widget? cityDropdown;
  final bool showCountry;
  final bool showCurrency;
  final bool showCity;
  final bool showRecipientName;
  final bool showPhoneNumber;
  final String recipientNameLabel;
  final String phoneNumberLabel;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final Color? iconColor;
  final ValueChanged<String>? onRecipientNameChanged;
  final ValueChanged<String>? onPhoneNumberChanged;

  const GenericCoordinationWidget({
    super.key,
    this.countryDropdown,
    this.areaDropdown,
    this.currencyDropdown,
    this.cityDropdown,
    this.showCountry = true,
    this.showCurrency = true,
    this.showCity = false,
    this.showRecipientName = false,
    this.showPhoneNumber = false,
    this.recipientNameLabel = "Nombre de la persona a entregarle",
    this.phoneNumberLabel = "Número de teléfono",
    this.padding,
    this.textStyle,
    this.labelStyle,
    this.iconColor,
    this.onRecipientNameChanged,
    this.onPhoneNumberChanged,
  });

  @override
  Widget build(BuildContext context) {
    final defaultTextStyle = textStyle ?? TextStyle(fontSize: 16);
    final defaultLabelStyle = labelStyle ??
        TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
        );
    final defaultIconColor = iconColor ?? Colors.grey;

    return Container(
      padding: padding ?? EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila para país y moneda
          Row(
            spacing: 4.0,
            children: [
              if (countryDropdown != null && showCountry)
                Expanded(
                  flex: showCountry && showCurrency ? 2 : 0,
                  child: _buildDropdownItem(
                    label: "País",
                    icon: Icons.flag,
                    dropdown: countryDropdown!,
                    iconColor: defaultIconColor,
                    labelStyle: defaultLabelStyle,
                  ),
                ),
              if (currencyDropdown != null && showCurrency)
                Expanded(
                  flex: showCountry && showCurrency ? 1 : 1,
                  child: _buildDropdownItem(
                    label: "Moneda",
                    icon: Icons.attach_money,
                    dropdown: currencyDropdown!,
                    iconColor: defaultIconColor,
                    labelStyle: defaultLabelStyle,
                  ),
                ),
            ],
          ),
          if (cityDropdown != null && showCity)
            _buildDropdownItem(
              label: "Ciudad",
              icon: Icons.location_city,
              dropdown: cityDropdown!,
              iconColor: defaultIconColor,
              labelStyle: defaultLabelStyle,
            ),
          if (showRecipientName)
            _buildEditableItem(
              label: recipientNameLabel,
              icon: Icons.person,
              textStyle: defaultTextStyle,
              labelStyle: defaultLabelStyle,
              iconColor: defaultIconColor,
              onChanged: onRecipientNameChanged,
            ),
          if (showPhoneNumber) ...{
            Row(
              spacing: 4.01244,
              children: [
                Expanded(
                  child: _buildDropdownItem(
                    label: "Area",
                    icon: Icons.flag,
                    dropdown: areaDropdown!,
                    iconColor: defaultIconColor,
                    labelStyle: defaultLabelStyle,
                  ),
                ),
                Expanded(
                  child: _buildEditableItem(
                    label: phoneNumberLabel,
                    textInputType: TextInputType.phone,
                    icon: Icons.phone,
                    textStyle: defaultTextStyle,
                    labelStyle: defaultLabelStyle,
                    iconColor: defaultIconColor,
                    onChanged: onPhoneNumberChanged,
                  ),
                ),
              ],
            )
          }
        ],
      ),
    );
  }

  Widget _buildDropdownItem({
    required String label,
    required IconData icon,
    required Widget dropdown,
    required Color iconColor,
    bool showLabel = false,
    bool showIcon = false,
    required TextStyle labelStyle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showLabel) ...{
            Text(label, style: labelStyle),
            SizedBox(height: 4),
          },
          Row(
            children: [
              if (showIcon) ...{
                Icon(icon, color: iconColor, size: 20),
                SizedBox(width: 12),
              },
              Expanded(child: dropdown),
            ],
          ),
          // Divider(height: 16, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildEditableItem({
    required String label,
    required IconData icon,
    required TextStyle textStyle,
    required TextStyle labelStyle,
    required Color iconColor,
    TextInputType textInputType = TextInputType.text,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: labelStyle),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: TextField(
                  keyboardType: textInputType,
                  style: textStyle,
                  onChanged: onChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: label,
                  ),
                ),
              ),
            ],
          ),
          // Divider(height: 16, thickness: 1),
        ],
      ),
    );
  }
}
