import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class RadioButtonWidget<T> extends StatefulWidget {
  final String? label;
  final T? value;
  final List<RadioButtonOption<T>> options;
  final ValueChanged<T?>? onChanged;

  const RadioButtonWidget(
      {super.key,
      required this.value,
      this.onChanged,
      this.label,
      required this.options});

  @override
  State<RadioButtonWidget<T>> createState() => _RadioButtonWidgetState<T>();
}

class _RadioButtonWidgetState<T> extends State<RadioButtonWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return Row(
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
          runSpacing: 8.0,
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
    );
  }
}
