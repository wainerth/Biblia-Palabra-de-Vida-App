import 'dart:async';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class CustomVerseDialog extends StatelessWidget {
  final ReferenceBiblicalModel data;
  final BibleTheme currentTheme;
  final Function(InputDataSearchModel) onActionReferences;
  final String baseUrl;

  const CustomVerseDialog({
    super.key,
    required this.data,
    required this.currentTheme,
    required this.onActionReferences,
    required this.baseUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(12.0),
      child: Container(
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: currentTheme.backgroundColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4.0),
              spreadRadius: 4.0,
              color: StyleColor.black.withValues(alpha: 0.25),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Botones de acción (copiar y compartir)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: currentTheme.backgroundColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 25.0,
                      onPressed: () => copyToClipboard(context, data),
                      icon: Icon(
                        Icons.file_copy_rounded,
                        color: currentTheme.buttonColor,
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 25.0,
                      onPressed: () => shareVerse(context, data),
                      icon: Icon(
                        Icons.share_rounded,
                        color: StyleColor.turquoise,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Contenido principal del diálogo
            Padding(
              padding:
                  const EdgeInsets.only(top: 40.0), // Espacio para los botones
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    data.book.modernName,
                    style: StylesApp(context).textStyleBody18.copyWith(
                          color: currentTheme.textColor,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    "${data.chapter.chapter}:${data.verse.verse}-${data.numberEndVerse}",
                    style: StylesApp(context).textStyleBody16.copyWith(
                          color: currentTheme.textColor,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    textAlign: TextAlign.center,
                    data.verse.text,
                    style: StylesApp(context).textStyleBody14.copyWith(
                          color: currentTheme.textColor,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ButtonThemeWidget(
                        width: 120,
                        icon: Icons.read_more_outlined,
                        showIcon: true,
                        text: "Leer Más",
                        buttonStyle: StylesApp(context).btnWidgetSmall,
                        onPressed: () {
                          final dataToSend = InputDataSearchModel(
                            versionId: data.book.bibleId.toString(),
                            bookId: data.book.id,
                            chapterId: data.chapter.id,
                            startVerseId: data.verse.id,
                            endVerseId: data.numberEndVerse.toString(),
                          );
                          onActionReferences(dataToSend);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
