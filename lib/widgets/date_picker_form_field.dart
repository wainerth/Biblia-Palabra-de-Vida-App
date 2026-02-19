import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    _selectedDate =
        widget.initialDate; // Inicializa _selectedDate con initialDate
    if (_selectedDate != null) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      setState(() {
        _dateController.text = formatter.format(_selectedDate!);
      });
      widget.onChanged!(_dateController.text);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateFormat formatter = DateFormat('dd/MM/yyyy');
    final DateTime now = DateTime.now();
    final translationProvider = context.read<AppTranslationProvider>();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      firstDate: DateTime(1951),
      lastDate: now,
      locale: Locale(translationProvider.currentLanguage),
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
    final translationProvider = context.read<AppTranslationProvider>();
    return TextFormField(
      controller: _dateController,
      style: StylesApp(context).textStyleBody12.copyWith(color: Colors.black),
      readOnly: true,
      onTap: () => _selectDate(context),
      onChanged: widget.onChanged,
      decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
            hintText: translationProvider.tr('birth_date'),
            suffixIcon: const Icon(Icons.calendar_today),
            // border: const OutlineInputBorder(),
          ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return translationProvider.tr('birth_date');
        }
        return null;
      },
    );
  }
}
