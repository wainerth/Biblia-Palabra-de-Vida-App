import 'dart:async';

import 'package:biblia_palabra_de_vida_app/config/graphql_config.dart';
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
  final Future<void> Function(InputDataSearchModel data) onActionBook;
  final Future<void> Function(InputDataSearchModel data) onActionTabText;
  final Future<void> Function(InputDataSearchModel data) onActionTheme;
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          color: currentTheme.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isTablet(context) ? 20 : 0),
            topRight: Radius.circular(isTablet(context) ? 20 : 0),
          ),
        ),
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
                    width: MediaQuery.sizeOf(context).width * 0.25,
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
    // Header con botón de cerrar
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: currentTheme.appBarColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isTablet(context) ? 20 : 0),
          topRight: Radius.circular(isTablet(context) ? 20 : 0),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            height: isTablet(context) ? 40 : 25,
            width: isTablet(context) ? 40 : 25,
            decoration: BoxDecoration(
              color: StyleColor.orange,
              borderRadius: BorderRadius.circular(isTablet(context) ? 40 : 25),
            ),
            child: IconButton(
              constraints: BoxConstraints(
                maxHeight: isTablet(context) ? 40 : 25,
                maxWidth: isTablet(context) ? 40 : 25,
              ),
              padding: EdgeInsets.all(0),
              iconSize: isTablet(context) ? 30 : 20,
              color: Colors.white,
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close),
            ),
          ),
          SizedBox(width: 16),
          Text(
            'Buscar en la Biblia',
            style: StylesApp(context).textStyleBody18.copyWith(
                  color: currentTheme.buttonTextColor,
                  fontWeight: FontWeight.bold,
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
          version: widget.currentVersion,
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
        tabAlignment: TabAlignment.start,
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
        version: widget.currentVersion,
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
