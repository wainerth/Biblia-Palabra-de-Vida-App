import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_bible_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class DialogInternalTeaching extends StatefulWidget {
  final void Function(InputDataSearchModel data)? onActionReferences;
  final TeachingModel data;
  const DialogInternalTeaching({
    super.key,
    required this.data,
    this.onActionReferences,
    required this.currentTheme,
  });

  final BibleTheme currentTheme;

  @override
  State<DialogInternalTeaching> createState() => _DialogInternalTeachingState();
}

class _DialogInternalTeachingState extends State<DialogInternalTeaching> {
  List<ReferenceBiblicalModel> references = [];

  @override
  void initState() {
    // consultamos las referencias
    WidgetsBinding.instance.addPostFrameCallback((_) => initialized());
    super.initState();
  }

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
                      '${GraphQLConfig.urlServidor}${widget.data.img.urlImg}'),
                ),
                Text(
                  textAlign: TextAlign.center,
                  widget.data.title,
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
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12.0),
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
                      widget.data.description,
                      style: StylesApp(context)
                          .textStyleBody16
                          .copyWith(color: widget.currentTheme.textColor),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 15.0,),
          ButtonThemeWidget(
            text: "Referencias Bíblicas",
            disabled: references.isEmpty ,
            buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
            ),
            onPressed: references.isEmpty
                ? null
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogReference(
                              currentTheme: widget.currentTheme,
                              title: widget.data.title,
                              data: references,
                              onActionReferences: (InputDataSearchModel data){
                                widget.onActionReferences!(data);
                                Navigator.pop(context);
                              },
                              );
                        });
                  },
          ),
           SizedBox(height: 15.0,),
        ],
      ),
    );
  }

  void initialized() async {
    final responseReferences = await getReferenceTeaching(widget.data.id);
    if (responseReferences.error != null) {
      await showCustomDialog(
        context,
        message: responseReferences.error!,
        dialogType: DialogType.error,
      );
      return;
    }
    setState(() {
      references = responseReferences.data
          .map<ReferenceBiblicalModel>((reference) => ReferenceBiblicalModel.fromJson(reference))
          .toList();
    });
  }
}
