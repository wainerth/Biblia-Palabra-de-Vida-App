import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class DialogInternalCharacter extends StatefulWidget {
  final void Function(InputDataSearchModel data)? onActionReferences;
  final CharacterModel data;
  final BibleTheme currentTheme;

  const DialogInternalCharacter({
    super.key,
    required this.data,
    this.onActionReferences,
    required this.currentTheme,
  });

  @override
  State<DialogInternalCharacter> createState() =>
      _DialogInternalCharacterState();
}

class _DialogInternalCharacterState extends State<DialogInternalCharacter> {
  List<ReferenceBiblicalModel> references = [];

   @override
  void initState() {
    // consultamos las referencias
    WidgetsBinding.instance.addPostFrameCallback((_) => initialized());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final imageUrl = '${GraphQLConfig.urlServidor}${widget.data.img.urlImg}';

    return Container(
      color: widget.currentTheme.backgroundColor,
      child: Column(
        children: [
          AppBarHeaderWidget(
            backColor: StyleColor.turquoise,
            buttonColor: StyleColor.orange,
            textButtonColor: Colors.white,
            title: 'Personajes',
            styleText: StylesApp(context).textStyleBody7,
            onRoute: () => Navigator.pop(context),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                // Contenedor de imagen mejorado
                Container(
                  width: 211,
                  height: 211,
                  decoration: BoxDecoration(
                    color: Color(int.parse('0XFF${widget.data.color}')),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      color: widget.currentTheme.textColor,
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.person, size: 50),
                      ),
                      loadingBuilder: (_, child, progress) {
                        return progress == null
                            ? child
                            : Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "${widget.data.typeNameChar} ${widget.data.name}",
                  textAlign: TextAlign.center,
                  style: StylesApp(context).textStyleBody16.copyWith(
                        color: StyleColor.orange,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Scrollbar(
                thumbVisibility: true,
                thickness: 6.0,
                radius: const Radius.circular(10),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    widget.data.description,
                    textAlign: TextAlign.justify,
                    style: StylesApp(context).textStyleBody16.copyWith(
                          color: widget.currentTheme.textColor,
                          height: 1.5,
                        ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15.0,
          ),
          ButtonThemeWidget(
            text: "Referencias Bíblicas",
            buttonStyle: StylesApp(context).btnWidgetSmall,
            onPressed: references.isEmpty
                ? null
                : () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return DialogReference(
                            currentTheme: widget.currentTheme,
                            title: "${widget.data.typeNameChar} ${widget.data.name}",
                            data: references,
                            onActionReferences: (InputDataSearchModel data) {
                              widget.onActionReferences!(data);
                              Navigator.pop(context);
                            },
                          );
                        });
                  },
          ),
            SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
   void initialized() async {
    // final responseReferences = await getCharacterFirstAppearance(widget.data.id);
    // if (responseReferences.error != null) {
    //   await showCustomDialog(
    //     context,
    //     message: responseReferences.error!,
    //     dialogType: DialogType.error,
    //   );
    //   return;
    // }
    // setState(() {
    //   references = responseReferences.data
    //       .map<ReferenceBiblicalModel>((reference) => ReferenceBiblicalModel.fromJson(reference))
    //       .toList();
    // });
  }
}
