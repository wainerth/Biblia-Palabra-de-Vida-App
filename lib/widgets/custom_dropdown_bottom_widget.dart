import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CustomDropdownBottomWidget<T> extends StatefulWidget {
  final List<ModelData> items;
  final ModelData? selectedItem;
  final ValueChanged<ModelData?> onChanged;
  final String hintText;
  final bool border;

  const CustomDropdownBottomWidget(
      {super.key,
      required this.items,
      required this.selectedItem,
      required this.onChanged,
      required this.hintText,
      this.border = true});

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
      onTap: widget.items.isEmpty
          ? null
          : () {
              FocusScope.of(context).unfocus();
              showModalBottomSheet(
                backgroundColor: Colors.white,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 8.0),
                              child: TextFormField(
                                // controller: searchTextController,Z
                                style: StylesApp(context).textStyleSmallBlack,
                                decoration: StylesApp(context)
                                    .inputDecorationOutlineStyle
                                    .copyWith(
                                      hintText: 'Buscar...',
                                      border: OutlineInputBorder(),
                                      suffixIcon: _searchText.isNotEmpty
                                          ? IconButton(
                                              icon: Icon(Icons.clear),
                                              onPressed: () {
                                                setState(() {
                                                  cleanSearch();
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
                            SizedBox(height: 10),
                            _buildFilteredList(),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
      child: AbsorbPointer(
        child: TextFormField(
          focusNode: _focusNode,
          textAlign: TextAlign.left,
          style:
              StylesApp(context).textStyleBody14.copyWith(color: Colors.black),
            decoration: StylesApp(context).inputDecorationOutlineStyle.copyWith(
              border: widget.border
                ? null
                : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide.none,
                  ),
              enabledBorder: widget.border
                ? null
                : OutlineInputBorder(
                  borderRadius: BorderRadius.circular(0),
                  borderSide: BorderSide.none,
                  ),
              hintText: widget.hintText,
              suffixIcon:  Icon(Icons.arrow_drop_down, color: widget.items.isEmpty ? disabledColor : null  ,),
              fillColor: widget.items.isEmpty ? Colors.white : null,
              filled: true
              ),
          controller: TextEditingController(
              text: widget.selectedItem?.label ??
                  ""), // Display selected item label
          // style: StylesApp(context).textStyleSmallBlack, // Your text style
          enabled: false, // Important: Disable direct text input
        ),
      ),
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
