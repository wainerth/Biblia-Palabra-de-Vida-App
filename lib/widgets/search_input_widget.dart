import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';

class SearchInputWidget extends StatelessWidget {
  final String placeholder;
  final Iterable<String> Function(String) getSuggestions;
  final void Function(String) onSelected;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const SearchInputWidget({
    super.key,
    required this.placeholder,
    required this.getSuggestions,
    required this.onSelected,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: padding ?? const EdgeInsets.all(0.0),
      child: Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }
          return getSuggestions(textEditingValue.text);
        },
        onSelected: (String selection) {
          if (kDebugMode) {
            print('You just selected $selection');
          }
          onSelected(selection);
        },
        fieldViewBuilder: (
          BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted,
        ) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: placeholder,
              suffixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }
}
