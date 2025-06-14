import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class GridButtonWidget<T extends GridItem> extends StatefulWidget {
  final List<T> data;
  final bool loading;
  final BibleTheme currentTheme;
  final Function(T)? onTap; // Callback opcional

  const GridButtonWidget({
    super.key,
    required this.data,
    required this.currentTheme,
    required this.loading,
    this.onTap,
  });

  @override
  State<GridButtonWidget<T>> createState() => _GridButtonWidgetState<T>();
  // State<GridButtonWidget<T extends GridItem>> createState() => _GridButtonWidgetState<T extends GridItem>();
}

class _GridButtonWidgetState<T extends GridItem> extends State<GridButtonWidget<T>> {
  @override
  Widget build(BuildContext context) {
    return widget.loading ? Center(child: LoadingIndicator())  : GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        final item = widget.data[index];
        return GestureDetector(
          onTap: () => widget.onTap?.call(item),
          child: Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: widget.currentTheme.buttonColor,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 5.0,
                  offset: Offset(5, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                item.displayText, // Texto dinámico
                style: StylesApp(context).textStyleBody16.copyWith(
                      color: widget.currentTheme.buttonTextColor,
                    ),
              ),
            ),
          ),
        );
      },
    );
  }
}
