import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CustomHeaderBodyWidget extends StatelessWidget {
  final Widget header;
  final Widget body;
  final EdgeInsetsGeometry? padding;

  const CustomHeaderBodyWidget({
    super.key,
    required this.header,
    required this.body,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header personalizado
        header,

        // Body personalizado
        Expanded(
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: body,
          ),
        ),
      ],
    );
  }
}
