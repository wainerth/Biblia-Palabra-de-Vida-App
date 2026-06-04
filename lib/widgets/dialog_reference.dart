import 'package:biblia_palabra_de_vida_app/config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class DialogReference extends StatefulWidget {
  final BibleTheme currentTheme;
  final void Function(InputDataSearchModel data) onActionReferences;
  final String title;
  final List<ReferenceBiblicalModel> data;
  const DialogReference({
    super.key,
    required this.title,
    required this.data,
    required this.onActionReferences,
    required this.currentTheme,
  });

  @override
  State<DialogReference> createState() => _DialogReferenceState();
}

class _DialogReferenceState extends State<DialogReference> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.currentTheme.backgroundColor,
      child: Column(
        children: [
          AppBarHeaderWidget(
            backColor: StyleColor.turquoise,
            buttonColor: StyleColor.orange,
            textButtonColor: Colors.white,
            title: 'Referencias',
            styleText: StylesApp(context).textStyleBody7,
            onRoute: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(maxWidth: 230.0),
            child: Column(
              children: [
                Text(
                  textAlign: TextAlign.center,
                  widget.title,
                  style: StylesApp(context)
                      .textStyleBody18
                      .copyWith(color: StyleColor.turquoise),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.data.length,
              itemBuilder: (context, int index) {
                return SizedBox(
                  // padding: EdgeInsets.all(8.0),
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    children: [
                      ButtonThemeWidget(
                        text:
                            "${widget.data[index].book.modernName} ${widget.data[index].chapter.chapter}:${widget.data[index].verse.verse}${widget.data[index].numberEndVerse > 0 ? '-${widget.data[index].numberEndVerse}' : ''}",
                        buttonStyle: StylesApp(context).btnWidgetSmall,
                        onPressed: () {
                          // En lugar de showDialog con todo el contenido, ahora solo necesitas:
                          showDialog(
                            context: context,
                            builder: (context) => CustomVerseDialog(
                              data: widget.data[index],
                              currentTheme: widget.currentTheme,
                              onActionReferences: (data) {
                                final dataToSend = InputDataSearchModel(
                                  versionId: widget.data[index].book.bibleId
                                      .toString(),
                                  bookId: widget.data[index].book.id,
                                  chapterId: widget.data[index].chapter.id!,
                                  startVerseId: widget.data[index].verse.id!,
                                  endVerseId: widget.data[index].numberEndVerse
                                      .toString(),
                                );
                                widget.onActionReferences(dataToSend);
                                Navigator.pop(context);
                              },
                              baseUrl: GraphQLConfig.endpoint,
                            ),
                          );
                        },
                      ),
                      SizedBox(
                        height: 15.0,
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
