// screens/search_bible_route_screen.dart
import 'package:biblia_palabra_de_vida_app/constants/app_constants.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_translation_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/bible_themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_book_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_text_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_theme_widget.dart';
import 'package:biblia_palabra_de_vida_app/widgets/search_by_character_widget.dart';
import 'package:biblia_palabra_de_vida_app/providers/bible_theme_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:provider/provider.dart';

class SearchBibleScreen extends StatefulWidget {
  final VersionModel? version;
  final BookModel? book;
  final ChapterModel? chapter;

  const SearchBibleScreen({
    super.key,
    this.version,
    this.book,
    this.chapter,
  });

  @override
  State<SearchBibleScreen> createState() => _SearchBibleScreenState();
}

class _SearchBibleScreenState extends State<SearchBibleScreen> {
  final translationProvider = AppTranslationProvider();

  late BibleTheme currentTheme;
  LoginUser? userData;
  bool isInitialized = false;
  var _selectedIndex = 0;

  List tabs = AppConstants.tabsSearchBible;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeAppData());
  }

  Future<void> _initializeAppData() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userData = userProvider.currentUser;

      final themeProvider = context.read<BibleThemeProvider>();
      currentTheme = themeProvider.themeData;

      setState(() => isInitialized = true);
    } catch (e) {
      if (kDebugMode) {
        print("Error initializing search screen: $e");
      }
    }
  }

  void _handleSearchResult(InputDataSearchModel data) {
    // Navegar de regreso a la biblia con los resultados
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/bibliaPage',
      (route) => route.isFirst,
      arguments: {
        'bibleId': data.versionId,
        'bookId': data.bookId,
        'chapterId': data.chapterId,
        'verseId': data.startVerseId,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isInitialized) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: currentTheme.appBarColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: currentTheme.buttonTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          translationProvider.tr('search_bible_screen.title'),
          style: StylesApp(context).textStyleBody18.copyWith(
                color: currentTheme.buttonTextColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      body: isTablet(context) ? _buildTabletLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Panel lateral izquierdo para tabs
        Expanded(
          flex: 1,
          child: Container(
            // width: 220,
            color: currentTheme.backgroundColor,
            child: Column(
              children: [
                SizedBox(height: 20),
                ...tabs.asMap().entries.map((entry) {
                  int index = entry.key;
                  var tab = entry.value;
                  bool isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? StyleColor.orange
                            : StyleColor.grayMedium,
                        border: Border(
                          right: BorderSide(
                            color: isSelected
                                ? StyleColor.orange
                                : Colors.transparent,
                            width: 4,
                          ),
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                              translationProvider.tr(tab["title"]),
                              style:
                                  StylesApp(context).textStyleBody14.copyWith(
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
                }),
              ],
            ),
          ),
        ),

        // Contenido principal
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildSelectedContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return DefaultTabController(
      length: tabs.length,
      initialIndex: _selectedIndex,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: currentTheme.backgroundColor,
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
              onTap: (index) => setState(() => _selectedIndex = index),
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white,
              labelStyle: StylesApp(context).textStyleBody12,
              indicatorSize: TabBarIndicatorSize.tab,
              tabAlignment: TabAlignment.start,
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
                  height: 32,
                  child: Container(
                    width: 100,
                    constraints: BoxConstraints(maxWidth: 100),
                    decoration: BoxDecoration(
                      color:
                          _selectedIndex == index ? Colors.orange : Colors.grey,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Center(
                      child: Text(
                       translationProvider.tr(tab["title"]),
                        maxLines: 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: TabBarView(
              children: _buildTabViewChildren(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedContent() {
    if (widget.version == null ||
        widget.book == null ||
        widget.chapter == null) {
      return Center(
        child: Text(
          translationProvider.tr('search_bible_screen.messages.data_unavailable'),
          style: TextStyle(color: currentTheme.textColor),
        ),
      );
    }

    switch (_selectedIndex) {
      case 0:
        return SearchByBookWidget(
          version: widget.version!,
          book: widget.book!,
          chapter: widget.chapter!,
          onActionBook: _handleSearchResult,
        );
      case 1:
        return SearchByTextWidget(
          version: widget.version!,
          onActionTabText: _handleSearchResult,
        );
      case 2:
        return SearchByThemeWidget(
          onActionTheme: _handleSearchResult,
        );
      case 3:
        return SearchByCharacterWidget();
      default:
        return Container();
    }
  }

  List<Widget> _buildTabViewChildren() {
    if (widget.version == null ||
        widget.book == null ||
        widget.chapter == null) {
      return List.filled(4, Center(child: Text(translationProvider.tr('search_bible_screen.messages.data_unavailable'))));
    }

    return [
      SearchByBookWidget(
        version: widget.version!,
        book: widget.book!,
        chapter: widget.chapter!,
        onActionBook: _handleSearchResult,
      ),
      SearchByTextWidget(
        version: widget.version!,
        onActionTabText: _handleSearchResult,
      ),
      SearchByThemeWidget(
        onActionTheme: _handleSearchResult,
      ),
      SearchByCharacterWidget(),
    ];
  }

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
