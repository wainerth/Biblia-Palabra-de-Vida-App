import 'dart:async';

import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_character_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_text_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_theme_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchBibleWidget extends StatefulWidget {
  final VersionModel currentVersion;
  final BookModel currentBook;
  final ChapterModel currentChapter;
  final void Function(InputDataSearchModel searchData) onActionBook;
  final void Function(InputDataSearchModel searchData) onActionTabText;
  final void Function(InputDataSearchModel searchData) onActionTheme;
  const SearchBibleWidget({
    super.key,
    required this.currentVersion,
    required this.currentBook,
    required this.currentChapter,
    required this.onActionBook,
    required this.onActionTabText,
    required this.onActionTheme,
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

    if (isTablet(context)) {
      return _buildTabletLayout();
    } else {
      return _buildMobileLayout();
    }
  }

  // diseño para Tablet
  Widget _buildTabletLayout() {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: currentTheme.backgroundColor,
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              // Header
              _buildAppBar(),
              SizedBox(
                height: 16,
              ),

              // contenido principal en dos columnas
              Expanded(
                child: Row(
                  children: [
                    // Columna Izquierda
                    Container(
                      width: 200,
                      decoration: BoxDecoration(
                        color: StyleColor.white,
                        boxShadow: [
                          BoxShadow(
                            color: StyleColor.black.withValues(alpha: 0.25),
                            spreadRadius: 0,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: _buildVerticalTabs(),
                    ),
                    // Columna Derecha - CONTENIDO
                    Expanded(
                      child: _buildTabContent(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // diseño pata móvil
  Widget _buildMobileLayout() {
    return SafeArea(
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: Container(
            color: currentTheme.backgroundColor,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                _buildAppBar(),
                SizedBox(height: 8),
                _buildHorizontalTabBar(),
                Expanded(
                  child: TabBarView(
                    children: _buildTabViewChildren(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Tabs verticales
  Widget _buildVerticalTabs() {
    return ListView.builder(
        itemCount: tabs.length,
        itemBuilder: (context, index) {
          var tab = tabs[index];
          bool isSelected = _selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedIndex = index);
            },
            child: Container(
              width: double.infinity,
              height: 60,
              decoration: BoxDecoration(
                color: isSelected ? StyleColor.orange : StyleColor.grayMedium,
                border: Border(
                  right: BorderSide(
                    color: isSelected ? StyleColor.orange : Colors.transparent,
                    width: 4,
                  ),
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    _getTabIcon(index),
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tab["title"],
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                ],
              ),
            ),
          );
        });
  }

  // 🔥 MÉTODO PARA CONSTRUIR APP BAR RESPONSIVE
  Widget _buildAppBar() {
    return Container(
      padding: isTablet(context)
          ? EdgeInsets.symmetric(horizontal: 20, vertical: 0)
          : EdgeInsets.zero,
      decoration: BoxDecoration(
        color: StyleColor.turquoise,
        borderRadius: isTablet(context)
            ? BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              )
            : BorderRadius.zero,
      ),
      child: Row(
        children: [
          // Botón de cerrar
          Container(
            height: isTablet(context) ? 40 : 35,
            width: isTablet(context) ? 40 : 35,
            decoration: BoxDecoration(
              color: StyleColor.orange,
              borderRadius: BorderRadius.circular(isTablet(context) ? 40 : 35),
            ),
            child: IconButton(
              constraints: BoxConstraints(
                maxHeight: isTablet(context) ? 40 : 35,
                maxWidth: isTablet(context) ? 40 : 35,
              ),
              padding: EdgeInsets.all(0),
              iconSize: isTablet(context) ? 30 : 25,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
          ),

          SizedBox(width: isTablet(context) ? 16 : 12),

          // Título
          Expanded(
            child: Text(
              'Búsqueda',
              style: isTablet(context)
                  ? StylesApp(context).textStyleBody18.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      )
                  : StylesApp(context).textStyleBody7.copyWith(
                        color: Colors.white,
                      ),
            ),
          ),
        ],
      ),
    );
  }

// 🔥 CONTENIDO DE TABS PARA TABLET
  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0:
        return SearchByBookWidget(
          version: widget.currentVersion,
          book: widget.currentBook,
          chapter: widget.currentChapter,
          onActionBook: (InputDataSearchModel data) {
            if (kDebugMode) {
              print(data.versionId);
            }
            widget.onActionBook(data);
            Navigator.pop(context);
          },
        );
      case 1:
        return SearchByTextWidget(
          onActionTabText: (InputDataSearchModel data) {
            if (kDebugMode) {
              print(data.versionId);
            }
            widget.onActionTabText(data);
            Navigator.pop(context);
          },
        );
      case 2:
        return SearchByThemeWidget(
          onActionTheme: (InputDataSearchModel data) {
            widget.onActionTheme(data);
          },
        );
      case 3:
        return SearchByCharacterWidget();
      default:
        return Container();
    }
  }

  // 🔥 TAB BAR HORIZONTAL PARA MÓVIL
  Widget _buildHorizontalTabBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            spreadRadius: 0,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: TabBar(
        isScrollable: true,
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
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        tabs: tabs.asMap().entries.map((entry) {
          int index = entry.key;
          var tab = entry.value;
          return Tab(
            height: 32.sp,
            child: Container(
              width: 100,
              constraints: BoxConstraints(maxWidth: 100),
              decoration: BoxDecoration(
                color: _selectedIndex == index ? Colors.orange : Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Center(
                child: Text(
                  tab["title"],
                  maxLines: 1,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 🔥 CONTENIDO DE TAB BAR VIEW PARA MÓVIL
  List<Widget> _buildTabViewChildren() {
    return [
      SearchByBookWidget(
        version: widget.currentVersion,
        book: widget.currentBook,
        chapter: widget.currentChapter,
        onActionBook: (InputDataSearchModel data) {
          if (kDebugMode) {
            print(data.versionId);
          }
          widget.onActionBook(data);
          Navigator.pop(context);
        },
      ),
      SearchByTextWidget(
        onActionTabText: (InputDataSearchModel data) {
          if (kDebugMode) {
            print(data.versionId);
          }
          widget.onActionTabText(data);
          Navigator.pop(context);
        },
      ),
      SearchByThemeWidget(
        onActionTheme: (InputDataSearchModel data) {
          widget.onActionTheme(data);
        },
      ),
      SearchByCharacterWidget(),
    ];
  }

  // 🔥 MÉTODO PARA CONSTRUIR TAB BAR RESPONSIVE
  Widget _buildTabBar() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            spreadRadius: 0,
            offset: const Offset(0, 4),
          )
        ],
        borderRadius: isTablet(context) ? BorderRadius.zero : BorderRadius.zero,
      ),
      child: TabBar(
        isScrollable: isTablet(context) ? false : true, // Scroll solo en móvil
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        unselectedLabelColor: Colors.white,
        labelColor: Colors.white,
        labelStyle: isTablet(context)
            ? StylesApp(context).textStyleBody14
            : StylesApp(context).textStyleBody12,
        indicatorSize: TabBarIndicatorSize.tab,
        automaticIndicatorColorAdjustment: true,
        indicatorWeight: 0,
        indicatorPadding: EdgeInsets.all(0),
        padding: isTablet(context)
            ? EdgeInsets.symmetric(horizontal: 20)
            : EdgeInsets.all(0),
        dividerColor: Color(0XFFFFFDFD),
        dividerHeight: 0,
        labelPadding:
            EdgeInsets.symmetric(horizontal: isTablet(context) ? 8 : 2),
        indicator: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        tabs: tabs.asMap().entries.map((entry) {
          int index = entry.key;
          var tab = entry.value;
          return Tab(
            height: isTablet(context) ? 40 : 32.sp,
            child: Container(
              width: isTablet(context) ? null : 100, // Ancho fijo solo en móvil
              constraints: isTablet(context)
                  ? BoxConstraints(minWidth: 80)
                  : BoxConstraints(maxWidth: 100),
              decoration: BoxDecoration(
                color: _selectedIndex == index ? Colors.orange : Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet(context) ? 16 : 8,
                vertical: isTablet(context) ? 8 : 4,
              ),
              child: Center(
                child: Text(
                  tab["title"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: isTablet(context)
                      ? StylesApp(context).textStyleBody14
                      : StylesApp(context).textStyleBody12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // 🔥 ICONOS PARA LOS TABS VERTICALES
  IconData _getTabIcon(int index) {
    switch (index) {
      case 0:
        return Icons.book;
      case 1:
        return Icons.search;
      case 2:
        return Icons.category;
      case 3:
        return Icons.people;
      default:
        return Icons.circle;
    }
  }
}

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
                              baseUrl: GraphQLConfig.urlServidor,
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
