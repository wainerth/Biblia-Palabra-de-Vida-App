import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/screens/screens.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/foundation.dart';
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
  final List<Preach> favorites = [
    // DataPreach(
    //   id: '1',
    //   title: 'Amor, Fidelidad y Compromiso',
    //   author: 'Pr. Eduardo Castro',
    //   date: '13/01/2025',
    //   urlVideo: 'https://youtu.be/1ASoPx-r_Xo?list=PL27339DE7B0837012',
    // ),
  ];
  List tabs = [
    {
      "title": 'Mensaje',
      "placeholder": 'Mensaje a buscar',
    },
    {
      "title": 'Predicador',
      "placeholder": 'Nombre del predicador a buscar',
    },
    {
      "title": 'Favoritas',
      "placeholder": 'Favorito a buscar',
    }
  ];

  List<Preach> preaches = [];
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
    return {
      1: 'Enero',
      2: 'Febrero',
      3: 'Marzo',
      4: 'Abril',
      5: 'Mayo',
      6: 'Junio',
      7: 'Julio',
      8: 'Agosto',
      9: 'Septiembre',
      10: 'Octubre',
      11: 'Noviembre',
      12: 'Diciembre',
    }[month];
  }

  _getSuggestions(value, String filter) {
    switch (filter) {
      case "Mensaje":
        return preaches
            .where((element) =>
                element.title!.toLowerCase().contains(value.toLowerCase()))
            .map((e) => e.title);
      case "Predicador":
        return preaches
            .where((element) =>
                element.preachers!.toLowerCase().contains(value.toLowerCase()))
            .map((e) => e.preachers);
      case "Favoritas":
        return favorites
            .where((element) =>
                element.preachers!
                    .toLowerCase()
                    .contains(value.toLowerCase()) ||
                element.title!.toLowerCase().contains(value.toLowerCase()))
            .map((e) => e.preachers!.toLowerCase().contains(value.toLowerCase())
                ? e.preachers
                : e.title);
    }
  }

  // void _onItemTapped(int index) {
  //   if (index.toString() == 2.toString()) {
  //     Navigator.pushNamed(context, '/prayerPage');
  //     return;
  //   }
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

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
      errorMessage = "An error occurred: $e";
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
      await showCustomDialog(context,
          message: responseAddFavorite.error!, dialogType: DialogType.error);
      return;
    }
    setState(() {
      favorites.add(preach);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                title: 'Predicas',
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
                        child: Center(child: Text(tab["title"])),
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
                  optionsBuilder: (TextEditingValue textEditingValue) {
                    if (textEditingValue.text.isEmpty) {
                      return const Iterable<String>.empty();
                    }
                    return _getSuggestions(
                        textEditingValue.text, tabs[_selectedIndex]["title"]);
                  },
                  onSelected: (String selection) {
                    if (kDebugMode) {
                      print('You just selected $selection');
                    }
                    setState(() {
                      preaches = groupedPreaches.values
                          .expand((list) => list)
                          .where((preach) {
                        return preach.title == selection ||
                            preach.preachers == selection;
                      }).toList();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              VideoPlayerScreen(data: preaches[0]),
                        ),
                      );
                    });
                  },
                  fieldViewBuilder: (BuildContext context,
                      TextEditingController textEditingController,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted) {
                    return TextField(
                      controller: textEditingController,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: tabs[_selectedIndex]["placeholder"],
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
              // Título de sección

              // Lista de mensajes
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
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: groupedPreaches.length,
                                itemBuilder: (context, index) {
                                  List<String> dates =
                                      groupedPreaches.keys.toList();
                                  // Construir los elementos agrupados por fecha
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                          dates[index],
                                          style: StylesApp(context)
                                              .textStyleBody14
                                              .copyWith(
                                                color: StyleColor.turquoise,
                                              ),
                                        ),
                                      ),
                                      ...groupedPreaches[dates[index]]!
                                          .map((preach) {
                                        return MessageCard(
                                          id: preach.id!,
                                          imageUrl:
                                              "${GraphQLConfig.urlServidor}${preach.video!.img!.urlImg}",
                                          // "https://placehold.co/100x80.png",
                                          urlVideo: preach.video!.url!,
                                          title: preach.title!,
                                          author: preach.preachers!,
                                          date: preach.createdAt!,
                                          iconFavorite: Icon(
                                            favorites.any((element) =>
                                                    element.id == preach.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: favorites.any((element) =>
                                                    element.id == preach.id)
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              if (!favorites.any((element) =>
                                                  element.id == preach.id)) {
                                                addToFavorite(preach);
                                              }
                                            });
                                          },
                                        );
                                      }),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: groupedPreaches.length,
                                itemBuilder: (context, index) {
                                  List<String> dates =
                                      groupedPreaches.keys.toList();
                                  // Construir los elementos agrupados por fecha
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0, vertical: 8.0),
                                        child: Text(
                                          dates[index],
                                          style: StylesApp(context)
                                              .textStyleBody14
                                              .copyWith(
                                                color: StyleColor.turquoise,
                                              ),
                                        ),
                                      ),
                                      ...groupedPreaches[dates[index]]!
                                          .map((preach) {
                                        return MessageCard(
                                          id: preach.id!,
                                          imageUrl:
                                              "${GraphQLConfig.urlServidor}${preach.video!.img!.urlImg}",
                                          urlVideo: preach.video!.url!,
                                          title: preach.title!,
                                          author: preach.preachers!,
                                          date: preach.createdAt!,
                                          iconFavorite: Icon(
                                            favorites.any((element) =>
                                                    element.id == preach.id)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: favorites.any((element) =>
                                                    element.id == preach.id)
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              addToFavorite(preach);
                                            });
                                          },
                                        );
                                      }),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        // Show favorite list
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                itemCount: groupedPreaches.length,
                                itemBuilder: (context, index) {
                                  List<String> dates =
                                      groupedPreaches.keys.toList();
                                  var items = groupedPreaches[dates[index]]!
                                      .where((preach) => favorites.any(
                                          (element) =>
                                              element.id == preach.id));
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (items.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 8.0),
                                          child: Text(
                                            dates[index],
                                            style: StylesApp(context)
                                                .textStyleBody14
                                                .copyWith(
                                                  color: StyleColor.turquoise,
                                                ),
                                          ),
                                        ),
                                      ...items.map((preach) {
                                        return MessageCard(
                                          id: "${preach.id}",
                                          imageUrl:
                                              "${GraphQLConfig.urlServidor}${preach.video!.img!.urlImg}",
                                          urlVideo: preach.video!.url!,
                                          title: preach.title!,
                                          author: preach.preachers!,
                                          date: preach.createdAt!,
                                          iconFavorite: Icon(
                                            Icons.favorite,
                                            color: Colors.red,
                                          ),
                                        );
                                      }),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                }
              },
            ],
          ),
        ),
        //  bottomNavigationBar: CustomBottomNavigationBarWidget(
        //     type: BottomNavigationBarType.fixed,
        //     showUnselectedLabels: true,
        //     backgroundColor: Color(0XFF7D7878),
        //     selectedItemColor: Color(0XFF12CBC4),
        //     unselectedItemColor: Colors.white,
        //     selectedLabelStyle: StylesApp(context).textStyleBody10,
        //     unselectedLabelStyle: StylesApp(context).textStyleBody10,
        //     items: getBottomNavigationBarItems(context),
        //     currentIndex: _selectedIndex,
        // onTap: _onItemTapped)
      ),
    );
  }
}

class MessageCard extends StatefulWidget {
  final String id;
  final String imageUrl;
  final String urlVideo;
  final String title;
  final String author;
  final String date;
  final Icon iconFavorite;
  final void Function()? onPressed;

  const MessageCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.date,
    required this.urlVideo,
    this.onPressed,
    required this.iconFavorite,
    required this.id,
  });

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    Preach valores = Preach(
      id: widget.id,
      title: widget.title,
      video: VideoPreach(img: null, url: widget.urlVideo),
      preachers: widget.author,
      createdAt: widget.date,
    );
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Imagen
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: GestureDetector(
                  key: GlobalKey(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoPlayerScreen(data: valores),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 200,
                    height: 110,
                    child: FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: widget.imageUrl,
                      width: 100,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  )),
            ),
          ),
          const SizedBox(width: 16),
          // Contenido
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: StyleColor.turquoise,
                      ),
                  overflow: TextOverflow.visible,
                  softWrap: true,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.author.replaceAll(". ", ".\n"),
                  style: StylesApp(context).textStyleBody14.copyWith(
                        color: StyleColor.orange,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.date,
                  style: StylesApp(context).textStyleBody14.copyWith(
                      color: Colors.black, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          IconButton(
            icon: widget.iconFavorite,
            onPressed: widget.onPressed,
          ),
        ],
      ),
    );
  }
}
