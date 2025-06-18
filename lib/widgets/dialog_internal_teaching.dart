import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_bible_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class DialogInternalTeaching extends StatelessWidget {
  final TeachingModel data;
  const DialogInternalTeaching({
    super.key,
    required this.data,
    required this.currentTheme,
  });

  final BibleTheme currentTheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: currentTheme.backgroundColor,
      child: Column(
        children: [
          AppBarHeaderWidget(
            backColor: StyleColor.turquoise,
            buttonColor: StyleColor.orange,
            textButtonColor: Colors.white,
            title: 'Enseñanza',
            styleText: StylesApp(context).textStyleBody7,
            onRoute: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: 8),
          Container(
            constraints: BoxConstraints(maxWidth: 211.0),
            child: Column(
              children: [
                Center(
                  child: Image.network(
                      '${GraphQLConfig.urlServidor}${data.img.urlImg}'),
                ),
                Text(
                  textAlign: TextAlign.center,
                  data.title,
                  style: StylesApp(context)
                      .textStyleBody16
                      .copyWith(color: StyleColor.orange),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12.0),
            height: 500, // Altura fija para hacer el scroll visible
            child: Scrollbar(
              thumbVisibility:
                  true, // Hace que el scrollbar sea siempre visible
              trackVisibility: true, // Opcional: muestra la pista del scroll
              thickness: 6.0, // Grosor del scrollbar
              radius: Radius.circular(10), // Bordes redondeados
              child: SingleChildScrollView(
                padding: EdgeInsets.all(8), // Espacio interno
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    textAlign: TextAlign.justify,
                    data.description,
                    style: StylesApp(context)
                        .textStyleBody16
                        .copyWith(color: currentTheme.textColor),
                  ),
                ),
              ),
            ),
          ),
          ButtonThemeWidget(
            text: "Referencias Biblicas",
            buttonStyle: StylesApp(context).btnWidgetSmall,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogReference(currentTheme: currentTheme);
                  });
            },
          )
        ],
      ),
    );
  }
}
