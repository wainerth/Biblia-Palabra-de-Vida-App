import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class BibleVersionSelector {
  static Future<ModelData?> show(
      {required BuildContext context,
      required List<ModelData> versions,
      preferenceKey,
      required savedId}) async {
    // Cargar la versión guardada
  final themeProvider = Provider.of<BibleThemeProvider>(context, listen: false);
   final currentTheme = themeProvider.themeData;

    final initialVersion = savedId != null
        ? versions.firstWhere((v) => v.value == savedId,
            orElse: () => versions.first)
        : versions.first;

    // Mostrar el diálogo
    final selected = await showModalBottomSheet<ModelData>(
      backgroundColor: currentTheme.backgroundColor,
      context: context,
      builder: (context) => VersionSelectionDialog(
        versions: versions,
        initialVersion: initialVersion,
      ),
    );

    // Guardar si se seleccionó una versión
    if (selected != null) {
      await PreferencesManager().setSelectedBibleVersion(selected.value);
    }

    return selected;
  }
}
