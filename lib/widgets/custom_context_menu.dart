import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CustomContextMenu extends StatelessWidget {
  final TextSelectionToolbarAnchors anchors;
  final List<CustomContextMenuItem> children;

  const CustomContextMenu({
    super.key,
    required this.anchors,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fondo semitransparente para cerrar al tocar fuera
        Positioned.fill(
          child: GestureDetector(
            onTap: () => ContextMenuController.removeAny(),
            behavior: HitTestBehavior.translucent,
          ),
        ),
        // Menú contextual
        Positioned(
          left: anchors.primaryAnchor.dx,
          top: anchors.primaryAnchor.dy,
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            color: Theme.of(context).cardColor,
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: children,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
