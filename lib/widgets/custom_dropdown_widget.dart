import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CustomDropdownWidget<T> extends StatefulWidget {
  final List<ModelData> items;
  final ModelData? selectedItem;
  final ValueChanged<ModelData?> onChanged;
  // final String Function(T) labelBuilder;
  final String hintText;

  const CustomDropdownWidget({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.hintText,
  });

  @override
  State<CustomDropdownWidget<T>> createState() => _CustomDropdownWidgetState<T>();
}

class _CustomDropdownWidgetState<T> extends State<CustomDropdownWidget<T>> {
  @override
  Widget build(BuildContext context) {
    // List<ModelData> dropDownList = widget.items;

    return widget.items.isEmpty
        ? CircularProgressIndicator()
        : DropdownButtonFormField<ModelData>(
            value: widget.selectedItem,
            hint: Text(
              widget.hintText,
              style: StylesApp(context).textStyleHintText,
            ),
            items:
                widget.items.map<DropdownMenuItem<ModelData>>((ModelData data) {
              return DropdownMenuItem<ModelData>(
                value: data,
                child: Text(data.label),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                return 'Campo es obligatorio';
              }

              return null;
            },
            onChanged: widget.onChanged,
            decoration: StylesApp(context).inputDecorationStyle,
            isExpanded: true,
          );
  }
}
