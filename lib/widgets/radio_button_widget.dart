import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class RadioButtonWidget<T> extends StatefulWidget {
  final String? label;
  final T? value;
  final List<RadioButtonOption<T>> options;
  final ValueChanged<T?>? onChanged;
  final String? errorText;
  final bool showError;

  const RadioButtonWidget({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    required this.options,
    this.errorText,
    this.showError = false,
  });

  @override
  State<RadioButtonWidget<T>> createState() => _RadioButtonWidgetState<T>();
}

class _RadioButtonWidgetState<T> extends State<RadioButtonWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: 8.0, // Espacio horizontal entre elementos
          runSpacing: 0, // Espacio vertical entre líneas
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            if (widget.label != null)
              Text(
                "${widget.label}",
                style: StylesApp(context)
                    .textStyleBody12
                    .copyWith(color: Colors.black),
              ),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: widget.options.map(
                (option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio<T>(
                        value: option.value,
                        activeColor: StyleColor.turquoise,
                        groupValue: widget.value,
                        onChanged: widget.onChanged,
                      ),
                      Text(
                        option.label,
                        style: StylesApp(context)
                            .textStyleBody12
                            .copyWith(color: Colors.black),
                      )
                    ],
                  );
                },
              ).toList(),
            ),
          ],
        ),
        // Mostrar error si existe y showError es true
        if (widget.showError && widget.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 8.0),
            child: Text(
              widget.errorText!,
              style: StylesApp(context)
                  .textStyleBody12
                  .copyWith(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
