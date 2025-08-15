import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class BibleVersionSelector {
  static Future<ModelData?> show(
      {required BuildContext context,
      required List<ModelData> versions,
      preferenceKey,
      required savedId}) async {
    // Cargar la versión guardada

    final initialVersion = savedId != null
        ? versions.firstWhere((v) => v.value == savedId,
            orElse: () => versions.first)
        : versions.first;

    // Mostrar el diálogo
    final selected = await showModalBottomSheet<ModelData>(
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
