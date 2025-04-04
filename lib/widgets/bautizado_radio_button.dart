import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class BautizadoRadioButton extends StatefulWidget {
  final bool isBautizado;
  final Function(bool?)? onChanged;
  const BautizadoRadioButton(
      {super.key, required this.isBautizado, this.onChanged});

  @override
  State<BautizadoRadioButton> createState() => _BautizadoRadioButtonState();
}

class _BautizadoRadioButtonState extends State<BautizadoRadioButton> {
  // Variable para almacenar la opción seleccionada

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          '¿Está bautizado?',
          style:
              StylesApp(context).textStyleBody12.copyWith(color: Colors.black),
        ), // Etiqueta para el grupo de RadioButtons
        Radio<bool>(
          value: true, // Valor para la opción "Sí"
          activeColor: StyleColor.turquoise,
          groupValue:
              widget.isBautizado, // Grupo al que pertenece este RadioButton
          onChanged: widget.onChanged,
        ),
        Text('Sí',
            style: StylesApp(context)
                .textStyleBody12
                .copyWith(color: Colors.black)), // Etiqueta para la opción "Sí"
        Radio<bool>(
          value: false, // Valor para la opción "No"
          activeColor: StyleColor.turquoise,
          groupValue:
              widget.isBautizado, // Grupo al que pertenece este RadioButton
          onChanged: widget.onChanged,
        ),
        Text('No',
            style: StylesApp(context)
                .textStyleBody12
                .copyWith(color: Colors.black)), // Etiqueta para la opción "No"
      ],
    );
  }
}
