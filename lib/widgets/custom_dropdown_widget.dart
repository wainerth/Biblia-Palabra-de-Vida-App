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
  State<CustomDropdownWidget<T>> createState() =>
      _CustomDropdownWidgetState<T>();
}

class _CustomDropdownWidgetState<T> extends State<CustomDropdownWidget<T>> {
  @override
  Widget build(BuildContext context) {
    // List<ModelData> dropDownList = widget.items;
 // Agrega este logging para verificar duplicados:
    Set<ModelData> elementosUnicos = Set<ModelData>();
    List<ModelData> duplicados = [];
    for (ModelData elemento in widget.items) {
      if (elementosUnicos.contains(elemento)) {
        duplicados.add(elemento);
        print("Duplicado encontrado: ${elemento.toString()}"); // O imprime propiedades relevantes de ModelData
      } else {
        elementosUnicos.add(elemento);
      }
    }

    if (duplicados.isNotEmpty) {
      print("Duplicados encontrados: ${duplicados.length}");
      // Considera lanzar una excepción aquí en modo debug para detener la ejecución e investigar.
      // throw Exception("¡Elementos ModelData duplicados detectados!");
    }
    return widget.items.isEmpty
        ? CircularProgressIndicator()
        : DropdownButtonFormField<ModelData>(
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
            decoration: StylesApp(context).inputDecorationOutlineStyle,
            isExpanded: true,
            value: widget.selectedItem,
          );
  }
}
