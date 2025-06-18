import 'dart:math';

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class GridButtonWidget<T extends GridItem> extends StatefulWidget {
  final List<T> data;
  final bool loading;
  final BibleTheme currentTheme;
  final Function(List<T>)? onTap;
  final bool rangeSelect; // Habilita selección por rango
  final List<T>? initiallySelected;

  const GridButtonWidget({
    super.key,
    required this.data,
    required this.currentTheme,
    required this.loading,
    this.onTap,
    this.rangeSelect = false,
    this.initiallySelected,
  });

  @override
  State<GridButtonWidget<T>> createState() => _GridButtonWidgetState<T>();
}

class _GridButtonWidgetState<T extends GridItem>
    extends State<GridButtonWidget<T>> {
  late List<T> _selectedItems;
  T? _firstSelectedItem; // Guarda el primer ítem seleccionado para el rango
  int? _initialVerse;
  int? _endVerse;
  @override
  void initState() {
    super.initState();
    _selectedItems = widget.initiallySelected ?? [];
  }

  @override
  void didUpdateWidget(GridButtonWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data ||
        widget.initiallySelected != oldWidget.initiallySelected) {
      // Actualizar selecciones si los datos cambian
      setState(() {
        _selectedItems =
            widget.initiallySelected != null ? widget.initiallySelected! : [];
        if (widget.initiallySelected != null) {
          if (widget.initiallySelected!.isEmpty) {
            _initialVerse = null;
            _endVerse = null;
          }
        }
      });
    }
  }

  void _handleItemTap(T item) {
    setState(() {
      final pos = widget.data.indexOf(item);
      if (widget.rangeSelect) {
        if (_initialVerse == null) {
          _initialVerse = pos;
          _selectedItems.add(item);
          _endVerse = pos + 1;
        } else if (_initialVerse != null && _endVerse != null) {
          if (pos == _initialVerse) {
            final verseToRemove = widget.data[pos];
            _selectedItems.removeWhere((verse) => verse.id == verseToRemove.id);
            _initialVerse = _selectedItems.isEmpty ? null : pos + 1;
            _endVerse = _selectedItems.isEmpty ? null : _endVerse;
          } else if (pos == _endVerse) {
            final verseToRemove = widget.data[pos];
            _selectedItems.removeWhere((verse) => verse.id == verseToRemove.id);
            _endVerse = pos - 1;
          } else if (pos >= _initialVerse! && pos < _endVerse!) {
            _endVerse = pos;
          } else if (pos < _initialVerse!) {
            _initialVerse = pos;
          } else if (pos > _endVerse!) {
            _endVerse = pos;
          }

          if (_initialVerse == null && _endVerse == null) {
            _selectedItems = [];
          } else {
            _selectedItems =
                widget.data.sublist(_initialVerse!, _endVerse! + 1).toList();
          }
        }
      } else {
        _selectedItems = widget.data.sublist(pos, pos + 1).toList();
      }
    });
    widget.onTap?.call(_selectedItems);
  }

  bool _isSelected(T item) => _selectedItems.contains(item);

  @override
  Widget build(BuildContext context) {
    return widget.loading
        ? Center(child: LoadingIndicator())
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              final item = widget.data[index];
              final isSelected = _isSelected(item);
              final isRangeStart = widget.rangeSelect &&
                  _firstSelectedItem != null &&
                  item == _firstSelectedItem;

              return GestureDetector(
                onTap: () => _handleItemTap(item),
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? StyleColor.orange
                        : widget.currentTheme.buttonColor,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.35),
                        blurRadius: 5.0,
                        offset: Offset(5, 3),
                      ),
                    ],
                    border: isRangeStart
                        ? Border.all(
                            color: Colors.white,
                            width: 3.0, // Borde más grueso para el inicio
                          )
                        : isSelected
                            ? Border.all(
                                color: Colors.white,
                                width: 2.0,
                              )
                            : null,
                  ),
                  child: Center(
                    child: Text(
                      item.displayText,
                      style: StylesApp(context).textStyleBody16.copyWith(
                            color: isSelected
                                ? Colors.white
                                : widget.currentTheme.buttonTextColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                    ),
                  ),
                ),
              );
            },
          );
  }
}
