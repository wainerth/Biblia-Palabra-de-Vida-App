import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class CustomDropdownBottomWidget<T> extends StatefulWidget {
  final List<ModelData> items;
  final ModelData? selectedItem;
  final ValueChanged<ModelData?> onChanged;
  final String hintText;
  final bool border;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? leadingIcon;
  final BibleTheme? currentTheme;

  const CustomDropdownBottomWidget(
      {super.key,
      required this.items,
      required this.selectedItem,
      required this.onChanged,
      required this.hintText,
      this.border = true,
      this.contentPadding =
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      this.leadingIcon,
      this.currentTheme});

  @override
  State<CustomDropdownBottomWidget<T>> createState() =>
      _CustomDropdownBottomWidgetState<T>();
}

class _CustomDropdownBottomWidgetState<T>
    extends State<CustomDropdownBottomWidget<T>> {
  final FocusNode _focusNode = FocusNode();
  final Color disabledColor = Colors.grey[400]!;
  String _searchText = '';
  TextEditingController? _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController?.dispose();
    super.dispose();
  }

  void cleanSearch() {
    setState(() {
      _searchText = '';
      _searchController?.clear();
    });
  }

  void _updateSearchText(String value) {
    setState(() {
      _searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.items.isEmpty ? null : _showBottomSheet,
      child: Container(
        height: StylesApp(context).sizeTextFormField.height,
        decoration: widget.border
            ? BoxDecoration(
                color: widget.currentTheme != null
                    ? widget.currentTheme!.backgroundColor
                    : Colors.white,
                border: Border.all(color:widget.currentTheme != null
                    ? widget.currentTheme!.textColor
                    : Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              )
            : null,
        child: Padding(
          padding: widget.contentPadding!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.leadingIcon != null) ...[
                widget.leadingIcon!,
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  widget.selectedItem?.label ?? widget.hintText,
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: widget.selectedItem != null
                            ? widget.currentTheme != null
                                ? widget.currentTheme!.textColor
                                : Colors.black
                            : Colors.grey.shade600,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color:
                    widget.items.isEmpty ? disabledColor : Colors.grey.shade600,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    FocusScope.of(context).unfocus();
    // Sincronizar el controlador con el texto actual
    _searchController?.text = _searchText;

    showModalBottomSheet(
      backgroundColor: widget.currentTheme != null
          ? widget.currentTheme!.backgroundColor
          : Colors.white,
      context: context,
      builder: (BuildContext context) {
        return _buildBottomSheetContent();
      },
    );
  }

  Widget _buildBottomSheetContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
            child: TextFormField(
              controller: _searchController,
              style: StylesApp(context).textStyleSmallBlack,
              decoration:
                  StylesApp(context).inputDecorationOutlineStyle.copyWith(
                        hintText: 'Buscar...',
                        hintStyle: StylesApp(context).textStyleBody14.copyWith(
                              color: StyleColor.grayMedium,
                            ),
                        border: const OutlineInputBorder(),
                        suffixIcon: _searchController?.text.isNotEmpty == true
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  // Limpiar el controlador y el estado
                                  _searchController?.clear();
                                  _updateSearchText('');
                                  // Forzar rebuild del modal
                                  if (context.mounted) {
                                    (context as Element).markNeedsBuild();
                                  }
                                },
                              )
                            : null,
                      ),
              onChanged: (value) {
                _updateSearchText(value);
              },
            ),
          ),
          const SizedBox(height: 10),
          _buildFilteredList(),
        ],
      ),
    );
  }

  Widget _buildFilteredList() {
    List<ModelData> filteredItems = widget.items
        .where((item) =>
            item.label.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return ListTile(
            leading: widget.leadingIcon,
            title: Center(child: Text(item.label)),
            titleTextStyle: StylesApp(context).textStyleBody14.copyWith(
                color: widget.currentTheme != null
                    ? widget.currentTheme!.textColor
                    : StyleColor.black),
            onTap: () {
              widget.onChanged(item);
              cleanSearch(); // Esto ahora limpia ambos: controlador y estado
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
