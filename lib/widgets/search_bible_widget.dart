import 'dart:async';

import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_book_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_character_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_text_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_theme_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchBibleWidget extends StatefulWidget {
   final void Function(InputDataSearchModel searchData) onActionBook;
  const SearchBibleWidget({
    super.key,
    required this.onActionBook
  });

  @override
  State<SearchBibleWidget> createState() => _SearchBibleWidgetState();
}

class _SearchBibleWidgetState extends State<SearchBibleWidget> {
  late BibleTheme currentTheme;
  LoginUser? userData;
  var _selectedIndex = 0;

  List tabs = [
    {
      "title": 'Libro',
      "placeholder": 'Mensaje a buscar',
    },
    {
      "title": 'Texto',
      "placeholder": 'Nombre del predicador a buscar',
    },
    {
      "title": 'Tema',
      "placeholder": 'Favorito a buscar',
    },
    {
      "title": 'Personajes',
      "placeholder": 'Favorito a buscar',
    }
  ];
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeAppData());
  }

  Future<void> _initializeAppData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userData = userProvider.currentUser;
    await Provider.of<BibleThemeProvider>(context, listen: false)
        .loadSavedTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider =
        Provider.of<BibleThemeProvider>(context, listen: false);
    currentTheme = themeProvider.themeData;
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                AppBarHeaderWidget(
                  backColor: StyleColor.turquoise,
                  buttonColor: StyleColor.orange,
                  textButtonColor: Colors.white,
                  title: 'Búsqueda',
                  styleText: StylesApp(context).textStyleBody7,
                  onRoute: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 8),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  // padding: const EdgeInsets.only(right: 65),
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    )
                  ]),
                  child: TabBar(
                    // isScrollable: true,
                    onTap: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    unselectedLabelColor: Colors.white,
                    labelColor: Colors.white,
                    labelStyle: StylesApp(context).textStyleBody12,
                    indicatorSize: TabBarIndicatorSize.tab,
                    automaticIndicatorColorAdjustment: true,
                    indicatorWeight: 0,
                    indicatorPadding: EdgeInsets.all(0),
                    padding: EdgeInsets.all(0),
                    dividerColor: Color(0XFFFFFDFD),
                    dividerHeight: 0,
                    labelPadding: EdgeInsets.symmetric(horizontal: 2),
                    indicator: BoxDecoration(
                      color: Colors.orange, // Color de la pestaña seleccionada
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ), // Bordes redondeados
                    ),
                    tabs: tabs.asMap().entries.map((entry) {
                      int index = entry.key;
                      var tab = entry.value;
                      return Tab(
                        height: 32.sp,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 100),
                          child: Container(
                            // width: double.infinity,
                            decoration: BoxDecoration(
                              color: _selectedIndex == index
                                  ? Colors.orange
                                  : Colors.grey,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Center(
                              child: Text(
                                tab["title"],
                                maxLines: 1, // Asegura una sola línea
                                // overflow: TextOverflow.visible,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                // Lista de mensajes
                Expanded(
                  child: TabBarView(
                    children: [
                      SearchByBookWidget(
                        onActionBook: (InputDataSearchModel data){
                          print(data.versionId);
                          widget.onActionBook(data);
                          Navigator.pop(context);
                        },
                      ),
                      SearchByTextWidget(),
                      SearchByThemeWidget(),
                      SearchByCharacterWidget(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DialogReference extends StatelessWidget {
  const DialogReference({
    super.key,
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
                  "Como encontrar la ayuda de Dios",
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
              itemCount: 10,
              itemBuilder: (context, int index) {
                return Container(
                  // padding: EdgeInsets.all(8.0),
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    children: [
                      ButtonThemeWidget(
                        text: "Salmo 86:1-17",
                        buttonStyle: StylesApp(context).btnWidgetSmall,
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

class CardSearchTextWidget extends StatelessWidget {
  const CardSearchTextWidget(
      {super.key,
      required this.currentTheme,
      required this.data,
      required this.onAction});

  final BibleTheme currentTheme;
  final data;
  final void Function()? onAction;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            constraints: BoxConstraints(minHeight: 75),
            decoration: BoxDecoration(
                color: currentTheme.backgroundColor,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 4.0,
                    offset: Offset(0, 4),
                    color: StyleColor.black.withValues(alpha: 0.25),
                  )
                ]),
            width: MediaQuery.sizeOf(context).width,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Deuteronomio 6:4",
                        style: StylesApp(context)
                            .textStyleBody14
                            .copyWith(color: StyleColor.orange),
                      ),
                      Text(
                        '"Escucha, Israel: Jehová nuestro Dios, Jehová uno es."',
                        style: StylesApp(context)
                            .textStyleBody12
                            .copyWith(color: currentTheme.textColor),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: IconButton(
                    icon: Icon(Icons.more_vert_rounded),
                    onPressed: onAction,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          )
        ],
      ),
    );
  }
}
