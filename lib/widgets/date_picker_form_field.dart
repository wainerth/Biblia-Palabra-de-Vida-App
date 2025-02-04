import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerFormField extends StatefulWidget {
  final void Function(String)? onChanged;
  final DateTime? initialDate; // Nuevo parámetro para la fecha inicial

  const DatePickerFormField({super.key, this.initialDate, this.onChanged});

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate; // Inicializa _selectedDate con initialDate
    if (_selectedDate != null) {
      _dateController.text = DateFormat.yMd('es_ES').format(_selectedDate!);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateFormat formatter = DateFormat.yMd('es_ES');
    final DateTime now = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1951),
      lastDate: now,
      locale: const Locale('es', 'ES'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color(0Xff12CBC4),
            colorScheme: ColorScheme.light(
              primary: const Color(0Xff12CBC4),
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = formatter.format(picked);
        widget.onChanged!(_dateController.text);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      style: StylesApp(context).textStyleBody16.copyWith(
        color: Colors.black
      ),
      readOnly: true,
      onTap: () => _selectDate(context),
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        hintText: "Fecha de nacimiento",
        suffixIcon: const Icon(Icons.calendar_today),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "La Fecha de nacimiento es obligatoria";
        }
        return null;
      },
    );
  }
}