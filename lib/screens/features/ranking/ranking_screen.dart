import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<League> leagues = [];
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context);
    });
  }

  Future<void> _generateData(BuildContext context) async {
    LoadingService().showLoading(context);
    setState(() {
      errorMessage = null;
    });

    try {
      leagues = Provider.of<CatalogueProvider>(context, listen: false)
          .allLeagues
          .map((league) => league)
          .toList();
      if (leagues.isEmpty) {
        setState(() {
          errorMessage = "No se encontraron ligas";
        });
      }
    
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      LoadingService().hideLoading();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return leagues.length > 0
        ? DefaultTabController(
            length: leagues.length,
            child: RankingScreenView(ranking: leagues),
          )
        : Center(
            child: BuildErrorWidget(
              errorMessage: errorMessage ?? '',
              onRetry: () async => _generateData(context),
              onBack: () => Navigator.pop(context),
            ),
          );
  }
}

class RankingScreenView extends StatefulWidget {
  final List<League> ranking;
  const RankingScreenView({super.key, required this.ranking});

  @override
  State<RankingScreenView> createState() => _RankingScreenViewState();
}

class _RankingScreenViewState extends State<RankingScreenView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: StyleColor.turquoise,
      body: SafeArea(
        child: Column(
          children: [
            // body
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    // Pestañas
                    Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: TabBar(
                        tabAlignment: TabAlignment.start,
                        indicatorPadding: EdgeInsets.all(0),
                        indicatorSize: TabBarIndicatorSize.label,
                        isScrollable: true,
                        onTap: (tab)=>{
                          print(tab)
                        },
                        tabs: widget.ranking
                            .map(
                              (league) => Tab(
                                height: 90,
                                child: Column(
                                  children: [
                                    Container(
                                      height: 60,
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(
                                                "0xFF${league.color}"))
                                            .withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(int.parse(
                                                "0xFF${league.color}")),
                                            spreadRadius: 1,
                                            blurRadius: 7,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        height: 38,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Color(
                                              int.parse("0xFF${league.color}")),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey
                                                  .withValues(alpha: 0.5),
                                              spreadRadius: 1,
                                              blurRadius: 7,
                                              offset: Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: Image.network(
                                            GraphQLConfig.urlServidor +
                                                league.img.urlImg),
                                      ),
                                    ),
                                    if (DefaultTabController.of(context)
                                            .index ==
                                        widget.ranking.indexOf(league))
                                      Container(
                                        width: 30,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: Colors.amber,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    Text(
                                      league.name,
                                      style: StylesApp(context)
                                          .textStyleBody14
                                          .copyWith(
                                            color:
                                                DefaultTabController.of(context)
                                                            .index ==
                                                        widget.ranking.indexOf(league)
                                                    ? StyleColor.turquoise
                                                    : StyleColor.orange,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8, top: 0, right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: TabBarView(
                          children: widget.ranking
                              .map((league) => _buildRankingList(context))
                              .toList(),
                        ),
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

  Widget _buildRankingList(BuildContext context) {
    int activeTabIndex = DefaultTabController.of(context).index;
    String activeLeagueId = widget.ranking[activeTabIndex].id;
    print("activeTabIndex: $activeTabIndex, activeLeagueId: $activeLeagueId");
    loadMembers(activeLeagueId);
      // Cargar los miembros de la liga
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 15, // Ejemplo: 10 usuarios en el ranking
      itemBuilder: (context, index) {
        if (index == 5) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.arrow_upward_rounded, color: Colors.green),
                Text(
                  'Zona de Ascenso',
                  style: StylesApp(context)
                      .textStyleBody14
                      .copyWith(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.arrow_upward_rounded, color: Colors.green),
              ],
            ),
          );
        } else if (index == 15) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.arrow_downward_rounded, color: Colors.red),
                Text(
                  'Zona de Descenso',
                  style: StylesApp(context)
                      .textStyleBody14
                      .copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
                Icon(Icons.arrow_downward_rounded, color: Colors.red),
              ],
            ),
          );
        } else {
          String mono = '';
          if (index == 0) {
            mono = 'assets/position1.png';
          } else if (index == 1) {
            mono = 'assets/position2.png';
          } else if (index == 2) {
            mono = 'assets/position3.png';
          }
          Color color;
          if (index < 5) {
            color = Colors.green;
          } else if (index > 15) {
            color = Colors.red;
          } else {
            color = Colors.black;
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Container(
                            width: 45,
                            height: 45,
                            child: Center(
                              child: Text("${index + 1}",
                                  style: StylesApp(context)
                                      .textStyleBody20
                                      .copyWith(color: color)),
                            ),
                          ),
                        ),
                        if (index < 3)
                          Image.asset(
                            mono,
                            height: 45,
                            fit: BoxFit.fill,
                          ),
                      ],
                    ),
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(
                          'assets/avatar.png'), // Reemplaza con la imagen del usuario
                    ),
                    Text(
                      'Robinson',
                      style: StylesApp(context)
                          .textStyleBody20
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),

                Text(
                  'exp ${500 - index * 10}',
                  style: StylesApp(context)
                      .textStyleBody14
                      .copyWith(color: Colors.black),
                ), // Reemplaza con el exp del usuario
              ],
            ),
          );
        }
      },
    );
  }

  void loadMembers(activeLeagueId) async {
    final membersLeague = await getLeagueMembers(activeLeagueId);
  }
}
