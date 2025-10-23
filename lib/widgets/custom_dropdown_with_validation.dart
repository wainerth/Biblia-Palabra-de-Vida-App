import 'package:biblia_palabra_de_vida_app/models/model_data.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CustomDropdownWithValidation<T> extends FormField<ModelData> {
  CustomDropdownWithValidation({
    super.key,
    required List<ModelData> items,
    required String hintText,
    required ValueChanged<ModelData?> onChanged,
    super.validator,
    super.initialValue,
    bool border = true,
  }) : super(
          builder: (FormFieldState<ModelData> field) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomDropdownBottomWidget<ModelData>(
                  border: border,
                  hintText: hintText,
                  items: items,
                  onChanged: (ModelData? newValue) {
                    field.didChange(newValue);
                    onChanged(newValue);
                  },
                  selectedItem: field.value,
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