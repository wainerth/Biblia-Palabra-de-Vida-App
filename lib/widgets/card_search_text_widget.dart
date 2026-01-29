import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CardSearchTextWidget extends StatelessWidget {
  const CardSearchTextWidget({
    super.key,
    required this.currentTheme,
    required this.data,
    required this.onAction,
  });

  final BibleTheme currentTheme;
  final WordSearchResult data;
  final void Function()? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isTablet(context)
          ? EdgeInsets.symmetric(horizontal: 20, vertical: 8)
          : EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: isTablet(context)
                ? EdgeInsets.all(16.0)
                : EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            constraints:
                BoxConstraints(minHeight: isTablet(context) ? 100 : 75),
            decoration: BoxDecoration(
              color: currentTheme.backgroundColor,
              borderRadius: BorderRadius.circular(isTablet(context) ? 12 : 8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 4.0,
                  offset: Offset(0, 4),
                  color: StyleColor.black.withValues(alpha: 0.25),
                )
              ],
            ),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${data.book.modernName} ${data.chapter.chapter}:${data.verse.verse}",
                        style: isTablet(context)
                            ? StylesApp(context).textStyleBody16.copyWith(
                                  color: StyleColor.orange,
                                  fontWeight: FontWeight.bold,
                                )
                            : StylesApp(context).textStyleBody14.copyWith(
                                  color: StyleColor.orange,
                                ),
                      ),
                      SizedBox(height: isTablet(context) ? 8 : 4),
                      // Resalta las ocurrencias usando los índices start y end
                      RichText(
                        text: TextSpan(
                          style: isTablet(context)
                              ? StylesApp(context).textStyleBody14.copyWith(
                                    color: currentTheme.textColor,
                                  )
                              : StylesApp(context).textStyleBody12.copyWith(
                                    color: currentTheme.textColor,
                                  ),
                          children: _buildHighlightedText(data),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet(context) ? 16 : 8),
                Container(
                  width: isTablet(context) ? 48 : 40,
                  height: isTablet(context) ? 48 : 40,
                  decoration: BoxDecoration(
                    color: currentTheme.buttonColor,
                    borderRadius:
                        BorderRadius.circular(isTablet(context) ? 24 : 20),
                  ),
                  child: IconButton(
                    iconSize: isTablet(context) ? 24 : 20,
                    color: currentTheme.buttonTextColor,
                    icon: Icon(Icons.more_vert_rounded),
                    onPressed: onAction,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: isTablet(context) ? 12 : 10.0),
        ],
      ),
    );
  }

  List<TextSpan> _buildHighlightedText(WordSearchResult data) {
    final text = data.verse.text;
    final occurrences = data.verse.occurrence;

    if (occurrences.isEmpty) {
      return [TextSpan(text: '"$text"')];
    }

    List<TextSpan> spans = [];
    int currentIndex = 0;

    for (var occ in occurrences) {
      int start = occ.start;
      int end = occ.end + 1;

      // Añade el texto antes de la ocurrencia
      if (currentIndex < start) {
        spans.add(TextSpan(text: text.substring(currentIndex, start)));
      }

      // Añade la ocurrencia resaltada
      spans.add(TextSpan(
        text: text.substring(start, end),
        style: TextStyle(
          backgroundColor: StyleColor.orange.withValues(alpha: 0.50),
          fontWeight: FontWeight.bold,
        ),
      ));
      currentIndex = end;
    }

    // Añade el texto restante después de la última ocurrencia
    if (currentIndex < text.length) {
      spans.add(TextSpan(text: text.substring(currentIndex)));
    }

    return spans;
  }
}
