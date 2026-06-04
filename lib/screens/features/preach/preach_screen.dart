import 'dart:async';

import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/constants/app_constants.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';

class PreachScreen extends StatefulWidget {
  const PreachScreen({super.key});

  @override
  State<PreachScreen> createState() => _PreachScreenState();
}

class _PreachScreenState extends State<PreachScreen> {
  var _selectedIndex = 0;
  String? errorMessage;
  bool isLoading = true;
  LoginUser? userData;
  Map<String, List<Preach>> groupedPreaches = {};
  final List<Preach> favorites = [];
  List tabs = AppConstants.tabsPreach;
  final _translationProvider = AppTranslationProvider();
  // Función para determinar si es tablet
  bool get isTablet {
    final width = MediaQuery.of(context).size.width;
    return width >= 600;
  }

  List<Preach> preaches = [];
  TextEditingController _searchController = TextEditingController();

  groupByMonthYear() {
    for (var preach in preaches) {
      List<String> dateParts = preach.createdAt!.split('/');
      String monthYear =
          '${_getMonthName(int.parse(dateParts[1]))} ${dateParts[2]}';
      if (!groupedPreaches.containsKey(monthYear)) {
        groupedPreaches[monthYear] = [];
      }
      groupedPreaches[monthYear]!.add(preach);
    }
  }

  _getMonthName(month) {
    return _translationProvider.tr('preach_screen.month_names.$month');
  }

  FutureOr<Iterable<String>> _getSuggestions(String value, String filter) {
    if (value.isEmpty) return [];

    final searchTerm = value.toLowerCase().trim();

    if (_translationProvider.tr("preach_screen.tabs.message") == filter) {
      return preaches
          .where((element) =>
              element.title?.toLowerCase().contains(searchTerm) ?? false)
          .map((e) => e.title)
          .cast<String>()
          .toList();
    } else if (_translationProvider.tr("preach_screen.tabs.preacher") ==
        filter) {
      return preaches
          .where((element) =>
              element.preachers?.toLowerCase().contains(searchTerm) ?? false)
          .map((e) => e.preachers)
          .where((preacher) => preacher != null && preacher.isNotEmpty)
          .cast<String>()
          .toList();
    } else if (_translationProvider.tr("preach_screen.tabs.favorites") ==
        filter) {
      return favorites
          .where((element) {
            final matchesPreacher =
                element.preachers?.toLowerCase().contains(searchTerm) ?? false;
            final matchesTitle =
                element.title?.toLowerCase().contains(searchTerm) ?? false;
            return matchesPreacher || matchesTitle;
          })
          .map((e) {
            if (e.preachers?.toLowerCase().contains(searchTerm) ?? false) {
              return e.preachers;
            } else {
              return e.title;
            }
          })
          .where((result) => result != null && result.isNotEmpty)
          .cast<String>()
          .toList();
    }

    return [];
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _generateData(context);
    });
  }

  Future<void> _generateData(BuildContext context) async {
    LoadingService().showLoading(context);
    final user = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      errorMessage = null;
      userData = user.currentUser;
    });

    try {
      final responsePreach = await getAllPreach(userData!.userId);
      if (responsePreach.error != null) {
        setState(() {
          errorMessage = responsePreach.error;
        });
      }
      if (responsePreach.data != null) {
        setState(() {
          preaches = responsePreach.data.map<Preach>((preach) {
            return Preach.fromJson(preach);
          }).toList();
          favorites
              .addAll(preaches.where((preach) => preach.isFavorite == true));
        });

        groupByMonthYear();
      }
    } catch (e) {
      errorMessage =
          "${_translationProvider.tr("preach_screen.messages.error_occurred")} $e";
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addToFavorite(preach) async {
    final responseAddFavorite =
        await addToFavoritePreach(userData!.userId, preach.id);
    if (responseAddFavorite.error != null) {
      if (mounted) {
        await showCustomDialog(context,
            message: responseAddFavorite.error!, dialogType: DialogType.error);
      }
      return;
    }
    setState(() {
      favorites.add(preach);
    });
  }

  Future<void> removeFavorite(preach) async {
    final responseRemoveFavorite =
        await removePreachFavorite(userData!.userId, preach.id);
    if (responseRemoveFavorite.error != null) {
      if (mounted) {
        await showCustomDialog(context,
            message: responseRemoveFavorite.error!,
            dialogType: DialogType.error);
      }
      return;
    }
    setState(() {
      favorites.removeWhere((x) => x.id == preach.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobile: _buildMobileLayout(), tablet: _buildTabletLayout());
  }

  _buildMobileLayout() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              AppBarHeaderWidget(
                backColor: StyleColor.turquoise,
                buttonColor: StyleColor.orange,
                textButtonColor: Colors.white,
                title: _translationProvider.tr('preach_screen.title'),
                styleText: StylesApp(context).textStyleBody7,
                onRoute: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.only(right: 65),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  )
                ]),
                child: TabBar(
                  onTap: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  labelStyle: StylesApp(context).textStyleBody12,
                  indicatorSize: TabBarIndicatorSize.label,
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
                        width: double.infinity,
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
                            child: Text(_translationProvider.tr(tab["title"]))),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // Barra de búsqueda
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                padding: const EdgeInsets.all(0.0),
                child: Autocomplete<String>(
                  optionsBuilder: (TextEditingValue textEditingValue) async {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return _getSuggestions(textEditingValue.text,
                        _translationProvider.tr(tabs[_selectedIndex]["title"]));
                  },
                  onSelected: (String selection) {
                    final searchResults = groupedPreaches.values
                        .expand((list) => list)
                        .where((preach) {
                      return preach.title == selection ||
                          preach.preachers == selection;
                    }).toList();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoPlayerScreen(data: searchResults[0]),
                      ),
                    ).then((_) {
                      // 👇 Cuando regrese de la pantalla, limpiar el campo de búsqueda
                      _searchController.clear();

                      // Opcional: quitar el foco del teclado
                      FocusScope.of(context).unfocus();

                      // Forzar rebuild para que el Autocomplete sepa que está vacío
                      setState(() {});
                    });
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    _searchController =
                        textEditingController; // Guardar el controlador para limpiar después
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: _translationProvider
                            .tr(tabs[_selectedIndex]["placeholder"]),
                        suffixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Contenido
              if (isLoading) ...{
                Container()
              } else ...{
                if (errorMessage != null) ...{
                  BuildErrorWidget(
                    errorMessage: errorMessage!,
                    onRetry: () async => _generateData(context),
                    onBack: () => Navigator.pop(context),
                  )
                } else ...{
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildContentForTab(_translationProvider
                            .tr("preach_screen.tabs.message")),
                        _buildContentForTab(_translationProvider
                            .tr("preach_screen.tabs.preacher")),
                        _buildContentForTab(_translationProvider
                            .tr("preach_screen.tabs.favorites")),
                      ],
                    ),
                  ),
                }
              },
            ],
          ),
        ),
      ),
    );
  }

  _buildTabletLayout() {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBarHeaderWidget(
              backColor: StyleColor.turquoise,
              buttonColor: StyleColor.orange,
              textButtonColor: Colors.white,
              title: _translationProvider.tr('preach_screen.title'),
              styleText:
                  StylesApp(context).textStyleBody7.copyWith(fontSize: 24),
              onRoute: () {
                Navigator.pop(context);
              },
            ),

            // Layout de dos columnas para tablet
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // COLUMNA IZQUIERDA: Tabs verticales
                    Container(
                      width: 250,
                      margin: EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Text(
                            _translationProvider
                                .tr('preach_screen.categories_title'),
                            style: StylesApp(context).textStyleBody18.copyWith(
                                  color: StyleColor.turquoise,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: tabs.length,
                              itemBuilder: (context, index) {
                                final tab = tabs[index];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: _selectedIndex == index
                                          ? StyleColor.turquoise
                                          : Colors.grey[100],
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _selectedIndex == index
                                            ? StyleColor.orange
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          tab["icon"],
                                          color: _selectedIndex == index
                                              ? Colors.white
                                              : StyleColor.grayDark,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _translationProvider
                                                .tr(tab["title"]),
                                            style: StylesApp(context)
                                                .textStyleBody14
                                                .copyWith(
                                                  color: _selectedIndex == index
                                                      ? Colors.white
                                                      : StyleColor.grayDark,
                                                  fontWeight:
                                                      _selectedIndex == index
                                                          ? FontWeight.bold
                                                          : FontWeight.normal,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // COLUMNA DERECHA: Contenido y búsqueda
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Barra de búsqueda para tablet
                          Container(
                            margin: EdgeInsets.only(bottom: 20),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.search,
                                      color: StyleColor.turquoise,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      _translationProvider
                                          .tr(tabs[_selectedIndex]["title"]),
                                      style: StylesApp(context)
                                          .textStyleBody18
                                          .copyWith(
                                            color: StyleColor.turquoise,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Autocomplete<String>(
                                  optionsBuilder:
                                      (TextEditingValue textEditingValue) {
                                    if (textEditingValue.text.isEmpty) {
                                      return const Iterable<String>.empty();
                                    }
                                    return _getSuggestions(
                                        textEditingValue.text,
                                        _translationProvider
                                            .tr(tabs[_selectedIndex]["title"]));
                                  },
                                  onSelected: (String selection) {
                                    final searchResults = groupedPreaches.values
                                        .expand((list) => list)
                                        .where((preach) {
                                      return preach.title == selection ||
                                          preach.preachers == selection;
                                    }).toList();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => VideoPlayerScreen(
                                            data: searchResults[0]),
                                      ),
                                    ).then((_) {
                                      // 👇 Cuando regrese de la pantalla, limpiar el campo de búsqueda
                                      _searchController.clear();

                                      // Opcional: quitar el foco del teclado
                                      FocusScope.of(context).unfocus();

                                      // Forzar rebuild para que el Autocomplete sepa que está vacío
                                      setState(() {});
                                    });
                                  },
                                  fieldViewBuilder: (BuildContext context,
                                      TextEditingController
                                          textEditingController,
                                      FocusNode focusNode,
                                      VoidCallback onFieldSubmitted) {
                                    _searchController = textEditingController;
                                    // Guardar el controlador para limpiar después
                                    return TextField(
                                      controller: textEditingController,
                                      focusNode: focusNode,
                                      decoration: InputDecoration(
                                        hintText: _translationProvider.tr(
                                            tabs[_selectedIndex]
                                                ["placeholder"]),
                                        hintStyle: StylesApp(context)
                                            .textStyleBody12
                                            .copyWith(
                                                color: StyleColor.grayMedium),
                                        filled: true,
                                        fillColor: Colors.grey[50],
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 12),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        suffixIcon: Container(
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: StyleColor.turquoise,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Contenido de predicaciones
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: _buildContentTablet(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método para construir contenido de tablet
  Widget _buildContentTablet() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return BuildErrorWidget(
        errorMessage: errorMessage!,
        onRetry: () async => _generateData(context),
        onBack: () => Navigator.pop(context),
      );
    }

    final currentTab = _translationProvider.tr(tabs[_selectedIndex]["title"]);

    if (currentTab == _translationProvider.tr("preach_screen.tabs.favorites") &&
        favorites.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              _translationProvider.tr("preach_screen.empty_favorites"),
              style: StylesApp(context).textStyleBody18.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: groupedPreaches.length,
      itemBuilder: (context, index) {
        List<String> dates = groupedPreaches.keys.toList();
        final items = groupedPreaches[dates[index]]!.where((preach) {
          if (currentTab ==
              _translationProvider.tr("preach_screen.tabs.favorites")) {
            return favorites.any((element) => element.id == preach.id);
          }
          return true;
        }).toList();

        if (items.isEmpty) return SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 12, top: index > 0 ? 16 : 0),
              decoration: BoxDecoration(
                color: StyleColor.turquoise.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: StyleColor.turquoise,
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: StyleColor.turquoise,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Text(
                    dates[index],
                    style: StylesApp(context).textStyleBody16.copyWith(
                          color: StyleColor.turquoise,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1,
              ),
              itemCount: items.length,
              itemBuilder: (context, itemIndex) {
                final preach = items[itemIndex];
                return MessageCardTablet(
                  preach: preach,
                  isFavorite:
                      favorites.any((element) => element.id == preach.id),
                  onToggleFavorite: () {
                    if (favorites.any((element) => element.id == preach.id)) {
                      removeFavorite(preach);
                    } else {
                      addToFavorite(preach);
                    }
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Método para construir contenido de móvil (mantener original)
  Widget _buildContentForTab(String tabTitle) {
    return ListView.builder(
      itemCount: groupedPreaches.length,
      itemBuilder: (context, index) {
        List<String> dates = groupedPreaches.keys.toList();
        final items = groupedPreaches[dates[index]]!.where((preach) {
          if (tabTitle ==
              _translationProvider.tr("preach_screen.tabs.favorites")) {
            return favorites.any((element) => element.id == preach.id);
          }
          return true;
        }).toList();

        if (items.isEmpty) return SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                dates[index],
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: StyleColor.turquoise,
                    ),
              ),
            ),
            ...items.map((preach) {
              return MessageCard(
                id: preach.id!,
                imageUrl:
                    "${ApiConfig.baseUrl}${preach.video!.img!.urlImg}",
                urlVideo: preach.video!.url!,
                title: preach.title!,
                author: preach.preachers!,
                date: preach.createdAt!,
                references: preach.references,
                iconFavorite: Icon(
                  favorites.any((element) => element.id == preach.id)
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: favorites.any((element) => element.id == preach.id)
                      ? Colors.red
                      : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    if (!favorites.any((element) => element.id == preach.id)) {
                      addToFavorite(preach);
                    } else {
                      removeFavorite(preach);
                    }
                  });
                },
              );
            }),
          ],
        );
      },
    );
  }
}

// Nuevo widget para tarjetas de tablet
class MessageCardTablet extends StatelessWidget {
  final Preach preach;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const MessageCardTablet({
    super.key,
    required this.preach,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    final _translationProvider = AppTranslationProvider();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoPlayerScreen(data: preach),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen de la predicación
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Stack(
                  children: [
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image:
                          "${ApiConfig.baseUrl}${preach.video!.img!.urlImg}",
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          iconSize: 20,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: onToggleFavorite,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Información de la predicación
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      preach.title!,
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: StyleColor.turquoise,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      preach.preachers!,
                      style: StylesApp(context).textStyleBody12.copyWith(
                            color: StyleColor.orange,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        SizedBox(width: 4),
                        Text(
                          preach.createdAt!,
                          style: StylesApp(context).textStyleBody12.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        Spacer(),
                        if (preach.references != null &&
                            preach.references!.isNotEmpty)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  StyleColor.turquoise.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "${preach.references!.length} ${_translationProvider.tr("preach_screen.card.references")}",
                              style:
                                  StylesApp(context).textStyleBody10.copyWith(
                                        color: StyleColor.turquoise,
                                      ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
