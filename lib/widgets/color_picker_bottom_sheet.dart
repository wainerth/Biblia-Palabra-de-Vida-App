import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class ColorPickerBottomSheet extends StatelessWidget {
  final List<VerseModel> selectedVerses;
  final Function(Color) onColorSelected;

  const ColorPickerBottomSheet({
    super.key,
    required this.selectedVerses,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFFEE5A24),
      const Color(0xFFF79F1F),
      const Color(0xFFFFC312),
      const Color(0xFFFFD55F),
      const Color(0xFFC4E538),
      const Color(0xFFA3CB38),
      const Color(0xFF009432),
      const Color(0xFF006266),
      const Color(0xFF12CBC4),
      const Color(0xFF1289A7),
      const Color(0xFF0652DD),
      const Color(0xFF1B1464),
      const Color(0xFF5758BB),
      const Color(0xFF9980FA),
      const Color(0xFFD980FA),
      const Color(0xFFFDA7DF),
      const Color(0xFF833471),
      const Color(0xFFB53471),
      const Color(0xFF6F1E51),
      const Color(0xFFED4C67),
      const Color(0xFFEA2027),
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Resaltar ${selectedVerses.length} versículo(s) seleccionado(s)',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Divider(),
        SizedBox(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: colors.map((color) {
              return GestureDetector(
                onTap: () => onColorSelected(color),
                child: Container(
                  width: 50,
                  height: 50,
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(width: 2),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        ListTile(
          leading: Icon(Icons.cancel),
          title: Text('Cancelar'),
          onTap: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
