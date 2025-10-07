import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CustomDropdownBottomWidget<T> extends StatefulWidget {
  final List<ModelData> items;
  final ModelData? selectedItem;
  final ValueChanged<ModelData?> onChanged;
  final String hintText;
  final bool border;
  final EdgeInsetsGeometry? contentPadding;

  const CustomDropdownBottomWidget({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
    required this.hintText,
    this.border = true,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
  });

  @override
  State<CustomDropdownBottomWidget<T>> createState() =>
      _CustomDropdownBottomWidgetState<T>();
}

class _CustomDropdownBottomWidgetState<T>
    extends State<CustomDropdownBottomWidget<T>> {
  final FocusNode _focusNode = FocusNode();
  final Color disabledColor = Colors.grey[400]!;
  String _searchText = '';

  @override
  void dispose() {
    super.dispose();
  }

  cleanSearch() {
    setState(() {
      _searchText = '';
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
                color: StyleColor.white,
                border: Border.all(color: StyleColor.black),
                borderRadius: BorderRadius.circular(8.0),
              )
            : null,
        child: Padding(
          padding: widget.contentPadding!,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.selectedItem?.label ?? widget.hintText,
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: widget.selectedItem != null
                            ? Colors.black
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
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return _buildBottomSheetContent();
      },
    );
  }

  Widget _buildBottomSheetContent() {
    return StatefulBuilder(
      builder: (context, setState) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
                child: TextFormField(
                  style: StylesApp(context).textStyleSmallBlack,
                  decoration:
                      StylesApp(context).inputDecorationOutlineStyle.copyWith(
                            hintText: 'Buscar...',
                            border: const OutlineInputBorder(),
                            suffixIcon: _searchText.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _searchText = '';
                                      });
                                    },
                                  )
                                : null,
                          ),
                  onChanged: (value) {
                    setState(() {
                      _searchText = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              _buildFilteredList(),
            ],
          ),
        );
      },
    );
  }

  // Widget para construir la lista filtrada
  Widget _buildFilteredList() {
    List<ModelData> filteredItems = widget.items
        .where((item) =>
            item.label.toLowerCase().contains(_searchText.toLowerCase()))
        .toList();

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.4,
      child: ListView.builder(
        shrinkWrap:
            true, // Importante para que el ListView no intente expandirse infinitamente
        itemCount: filteredItems.length,
        itemBuilder: (context, index) {
          final item = filteredItems[index];
          return ListTile(
            title: Center(child: Text(item.label)),
            onTap: () {
              widget.onChanged(item);
              cleanSearch();
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
