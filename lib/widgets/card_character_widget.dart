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
        margin: EdgeInsets.only(left: 4.0, right: 4.0, bottom: 12.0),
        constraints: BoxConstraints(maxWidth: 220.0),
        decoration: BoxDecoration(
          color: Color(int.parse('0XFF${widget.data.color}')),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Color(int.parse('0XFF${widget.data.color}'))
                  .withValues(alpha: 0.25),
              blurRadius: 4.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: EdgeInsets.all(8.0),
        width: MediaQuery.sizeOf(context).width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${widget.showTypeName ? widget.data.typeNameChar.splitMapJoin(" ") : ''} ${widget.data.name}",
              style: StylesApp(context)
                  .textStyleBody15
                  .copyWith(color: widget.currentTheme.textColor),
            ),
            Container(
              // width: MediaQuery.,
              constraints: BoxConstraints(minHeight: 81, maxHeight: 81),
              child: Image.network(
                  color: widget.currentTheme.textColor,
                  '${GraphQLConfig.urlServidor}${widget.data.img.urlImg}'),
            ),
          ],
        ),
      ),
    );
  }
}
