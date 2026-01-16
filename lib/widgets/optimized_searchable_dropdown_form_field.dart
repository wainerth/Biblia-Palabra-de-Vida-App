// optimized_searchable_dropdown_form_field.dart
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:flutter/material.dart';
import 'optimized_searchable_dropdown.dart';

class OptimizedSearchableDropdownFormField extends FormField<ModelData> {
  OptimizedSearchableDropdownFormField({
    super.key,
    required String hintText,
    required Future<PaginationModel<ModelData>> Function(String query, int page)
        searchFunction,
    Future<ModelData?> Function(String)? fetchItemById,
    bool border = true,
    Widget? leadingIcon,
    EdgeInsetsGeometry? padding,
    double? height,
    bool showClearButton = true,
    String? defaultValueId,
    super.initialValue,
    ValueChanged<ModelData?>? onChanged,
    super.onSaved,
    super.validator,
    bool autovalidateMode = false,
  }) : super(
          autovalidateMode: autovalidateMode
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          builder: (FormFieldState<ModelData> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                OptimizedSearchableDropdown(
                  hintText: hintText,
                  selectedItem: field.value,
                  onChanged: (ModelData? newValue) {
                    field.didChange(newValue);
                    if (onChanged != null) {
                      onChanged(newValue);
                    }
                  },
                  searchFunction: searchFunction,
                  fetchItemById: fetchItemById,
                  border: border,
                  leadingIcon: leadingIcon,
                  padding: padding,
                  height: height,
                  showClearButton: showClearButton,
                  defaultValueId: defaultValueId,
                  // NO pasamos validator aquí, se maneja en el FormField
                ),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0, left: 8.0),
                    child: Text(
                      field.errorText!,
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );
}
