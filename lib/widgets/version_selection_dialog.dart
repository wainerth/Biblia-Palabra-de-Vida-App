import 'package:biblia_palabra_de_vida_app/models/model_data.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class VersionSelectionDialog extends StatefulWidget {
  final List<ModelData> versions;
  final ModelData initialVersion;

  const VersionSelectionDialog({
    super.key,
    required this.versions,
    required this.initialVersion,
  });

  @override
  State<VersionSelectionDialog> createState() => _VersionSelectionDialogState();
}

class _VersionSelectionDialogState extends State<VersionSelectionDialog> {
  late ModelData selectedVersion;

  @override
  void initState() {
    super.initState();
    selectedVersion = widget.initialVersion;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Seleccione la versión de la Biblia',
            style: StylesApp(context).textStyleBody16.copyWith(
                  color: Colors.orange,
                ),
          ),
          const SizedBox(height: 20),
          CustomDropdownBottomWidget<ModelData>(
            hintText: "Seleccione una versión",
            items: widget.versions,
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() => selectedVersion = newValue);
              }
            },
            selectedItem: selectedVersion,
          ),
          const SizedBox(height: 20),
          ButtonThemeWidget(
            width: 150.0,
            height: 27.0,
            text: "Aceptar",
            onPressed: () => Navigator.pop(context, selectedVersion),
            buttonStyle: StylesApp(context).btnWidgetSmall,
          ),
        ],
      ),
    );
  }
}
