import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ValidatedRadioGroup<T> extends FormField<T> {
  ValidatedRadioGroup({
    super.key,
    required String label,
    required List<RadioButtonOption<T>> options,
    required ValueChanged<T?> onChanged,
    super.onSaved,
    super.validator,
    super.initialValue,
    bool forceValidation = false,
  }) : super(
          builder: (FormFieldState<T> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    field.didChange(field.value);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: field.hasError ? Colors.red : Colors.black,
                      ),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: field.hasError ? Colors.red : Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 16.0,
                          children: options.map((option) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Radio<T>(
                                  value: option.value,
                                  groupValue: field.value,
                                  onChanged: (T? newValue) {
                                    field.didChange(newValue);
                                    onChanged(newValue);
                                  },
                                ),
                                GestureDetector(
                                  onTap: () {
                                    field.didChange(option.value);
                                    onChanged(option.value);
                                  },
                                  child: Text(
                                    option.label,
                                    style:StylesApp(field.context).textStyleBody14.copyWith(
                                      color: field.hasError 
                                          ? Colors.red 
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                    child: Text(
                      field.errorText!,
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
              ],
            );
          },
        );
}