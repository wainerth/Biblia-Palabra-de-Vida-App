import 'dart:async';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CustomPagination extends StatelessWidget {
  final PaginationInfo pagination;
  final int itemPerPageValue;
  final List<int> itemsPerPage;
  final BibleTheme currentTheme;
  final Future<void> Function(int page, int perPage) onPageChanged;
  final TextStyle? textStyle;

  const CustomPagination({
    super.key,
    required this.pagination,
    required this.itemPerPageValue,
    required this.currentTheme,
    required this.onPageChanged,
    this.itemsPerPage = const [10, 20, 50, 100],
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextStyle = textStyle ??
        StylesApp(context).textStyleBody10.copyWith(
              color: currentTheme.textColor,
            );

    return Material(
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón de página anterior
          IconButton(
            onPressed: pagination.hasPreviousPage
                ? () => onPageChanged(
                      pagination.currentPage - 1,
                      itemPerPageValue,
                    )
                : null,
            icon: Icon(Icons.arrow_back),
            color: currentTheme.buttonColor,
          ),

          // Indicador de página actual/total
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  style: effectiveTextStyle,
                  text:
                      "${pagination.currentPage} de ${pagination.totalPages} páginas",
                ),
              ],
            ),
          ),

          // Dropdown para items por página
          DropdownButton<int>(
            value: itemPerPageValue,
            icon: const Icon(Icons.arrow_drop_down),
            elevation: 16,
            style: effectiveTextStyle,
            dropdownColor: currentTheme.backgroundColor,
            onChanged: (int? newValue) async {
              if (newValue != null) {
                await onPageChanged(1, newValue); // Resetear a primera página
              }
            },
            items: itemsPerPage.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text(
                  '$value items',
                  style: effectiveTextStyle,
                ),
              );
            }).toList(),
          ),

          // Botón de página siguiente
          IconButton(
            disabledColor: currentTheme.disabledColor,
            onPressed: pagination.hasNextPage
                ? () => onPageChanged(
                      pagination.currentPage + 1,
                      itemPerPageValue,
                    )
                : null,
            icon: Icon(Icons.arrow_forward),
            color: currentTheme.buttonColor,
          ),
        ],
      ),
    );
  }
}
