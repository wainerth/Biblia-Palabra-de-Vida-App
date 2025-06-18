import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class CardCharacterWidget extends StatefulWidget {
  final bool showTypeName;
  final CharacterModel data;
  final BibleTheme currentTheme;
  final void Function()? onTap;
  const CardCharacterWidget({
    super.key,
    required this.data,
    required this.currentTheme,
    this.showTypeName = false,
    this.onTap,
  });

  @override
  State<CardCharacterWidget> createState() => _CardCharacterWidgetState();
}

class _CardCharacterWidgetState extends State<CardCharacterWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
         constraints: BoxConstraints(maxWidth: 220.0),
          padding: EdgeInsets.all(8.0),
          width: MediaQuery.sizeOf(context).width,
          child: Column(children: [
            Container(
              width: MediaQuery.sizeOf(context).width,
              constraints: BoxConstraints(minHeight: 150, maxHeight: 150),
              child: Image.network(
                  color: widget.currentTheme.textColor,
                  '${GraphQLConfig.urlServidor}${widget.data.img.urlImg}'),
            ),
            SizedBox(
              height: 8.0,
            ),
            Text(
              "${widget.showTypeName ? widget.data.typeNameChar.splitMapJoin(" "): ''}${widget.data.name}",
              style: StylesApp(context)
                  .textStyleBody15
                  .copyWith(color: widget.currentTheme.textColor),
            )
          ])),
    );
  }
}
