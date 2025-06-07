import 'package:flutter/material.dart';

class VerseHighlighter extends StatefulWidget {
  final String verseText;
  final Function(Color, String) onHighlight;

  const VerseHighlighter({
    super.key,
    required this.verseText,
    required this.onHighlight,
  });

  @override
  State<VerseHighlighter> createState() => _VerseHighlighterState();
}

class _VerseHighlighterState extends State<VerseHighlighter> {
  TextSelection _selection = const TextSelection.collapsed(offset: -1);
  bool _isSelecting = false;
  Offset? _startSelectionOffset;

  Future<void> _showColorPicker(String selectedText) async {
    final color = await ColorPickerDialog.show(context);
    if (color != null && selectedText.isNotEmpty) {
      widget.onHighlight(color, selectedText);
    }
    setState(() {
      _selection = const TextSelection.collapsed(offset: -1);
      _isSelecting = false;
    });
  }

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isSelecting = true;
      _startSelectionOffset = details.globalPosition;
      final offset = details.globalPosition;
      final textPosition = _getTextPosition(offset);
      _selection = TextSelection.collapsed(offset: textPosition.offset);
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (!_isSelecting) return;

    final offset = details.globalPosition;
    final startPosition = _getTextPosition(_startSelectionOffset!);
    final currentPosition = _getTextPosition(offset);

    setState(() {
      _selection = TextSelection(
        baseOffset: startPosition.offset,
        extentOffset: currentPosition.offset,
      );
    });
  }

  void _onLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    if (!_isSelecting) return;

    final offset = details.globalPosition;
    final startPosition = _getTextPosition(_startSelectionOffset!);
    final currentPosition = _getTextPosition(offset);

    setState(() {
      _selection = TextSelection(
        baseOffset: startPosition.offset,
        extentOffset: currentPosition.offset,
      );
    });
  }

  void _onPanEnd(DragEndDetails details) {
    if (_isSelecting && _selection.textInside(widget.verseText).isNotEmpty) {
      _showColorPicker(_selection.textInside(widget.verseText));
    } else {
      setState(() {
        _isSelecting = false;
        _selection = const TextSelection.collapsed(offset: -1);
      });
    }
  }

  TextPosition _getTextPosition(Offset offset) {
    final renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(offset);
    final textSpan = TextSpan(text: widget.verseText);
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.start
    );
    textPainter.layout(maxWidth: renderBox.size.width);
    return textPainter.getPositionForOffset(localPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) =>
          _onTapDown(TapDownDetails(globalPosition: details.position)),
      onPointerMove: (details) =>
          _onPanUpdate(DragUpdateDetails(globalPosition: details.position)),
      onPointerUp: (details) => _onPanEnd(DragEndDetails()),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPressStart: (details) =>
            _onTapDown(TapDownDetails(globalPosition: details.globalPosition)),
        onLongPressMoveUpdate: (details) => _onPanUpdate(
            DragUpdateDetails(globalPosition: details.globalPosition)),
        onLongPressEnd: (details) => _onPanEnd(DragEndDetails()),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: RichText(
            text: TextSpan(
              text: widget.verseText,
              style: DefaultTextStyle.of(context).style,
              children: _buildHighlightSpans(),
            ),
          ),
        ),
      ),
    );
  }

  List<TextSpan> _buildHighlightSpans() {
    if (!_selection.isValid ||
        !_selection.textInside(widget.verseText).isNotEmpty) {
      return [];
    }

    final before = widget.verseText.substring(0, _selection.start);
    final selected =
        widget.verseText.substring(_selection.start, _selection.end);
    final after = widget.verseText.substring(_selection.end);

    return [
      TextSpan(text: before),
      TextSpan(
        text: selected,
        style: TextStyle(
          backgroundColor: Colors.lightBlue.withOpacity(0.3),
        ),
      ),
      TextSpan(text: after),
    ];
  }
}

// Diálogo de selección de color (versión simplificada)
class ColorPickerDialog extends StatelessWidget {
  final ValueChanged<Color> onColorSelected;

  const ColorPickerDialog({super.key, required this.onColorSelected});

  static final List<Color> colorPalette = [
    const Color(0xFFEE5A24),
    const Color(0xFFF79F1F),
    // ... (tus colores aquí)
    const Color(0xFFEA2027),
  ];

  static Future<Color?> show(BuildContext context) {
    return showDialog<Color>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar color'),
          content: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: colorPalette.map((color) {
              return GestureDetector(
                onTap: () => Navigator.pop(context, color),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // No se usa directamente
  }
}
