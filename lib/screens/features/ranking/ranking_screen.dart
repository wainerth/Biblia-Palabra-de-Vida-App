import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/catalogue_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
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
    return isLoading
        ? Container()
        : errorMessage != null
            ? Center(
                child: BuildErrorWidget(
                  errorMessage: errorMessage ?? '',
                  onRetry: () async => _generateData(context),
                  onBack: () => Navigator.pop(context),
                ),
              )
            : DefaultTabController(
                length: leagues.length,
                child: RankingScreenView(ranking: leagues),
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
  List<MemberModel> members = [];
  String activeLeagueId = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialMembers(context);
    });
  }

  void _loadInitialMembers(BuildContext context) {
    activeLeagueId = widget.ranking[DefaultTabController.of(context).index].id;
    loadMembers(activeLeagueId, context);
  }

  @override
  void didUpdateWidget(covariant RankingScreenView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ranking != widget.ranking) {
      _loadInitialMembers(context);
    }
  }

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
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .30),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TabBar(
                        dividerColor: Colors.transparent,
                        tabAlignment: TabAlignment.start,
                        indicatorPadding: EdgeInsets.all(0),
                        indicatorColor: Colors.transparent,
                        indicatorSize: TabBarIndicatorSize.label,
                        isScrollable: true,
                        onTap: (tab) async {
                          loadMembers(widget.ranking[tab].id, context);
                        },
                        tabs: widget.ranking
                            .map(
                              (league) => Tab(
                                height: 109,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 60,
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(
                                            "0xFF${league.colorBack}")),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(int.parse(
                                                "0xFF${league.colorFront}")),
                                            spreadRadius: 0,
                                            blurRadius: 0,
                                            offset: Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: Container(
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Color(int.parse(
                                              "0xFF${league.colorFront}")),
                                        ),
                                        child: Image.network(
                                            GraphQLConfig.urlServidor +
                                                league.img.urlImg),
                                      ),
                                    ),
                                    if (DefaultTabController.of(context)
                                            .index ==
                                        widget.ranking.indexOf(league)) ...{
                                      SizedBox(
                                        height: 8,
                                      ),
                                      ClipOval(
                                        child: Container(
                                          width: 80,
                                          height: 9,
                                          decoration: BoxDecoration(
                                              color: Colors.amber),
                                        ),
                                      )
                                    } else ...{
                                      SizedBox(
                                        height: 5,
                                      ),
                                    },
                                    Text(
                                      league.name,
                                      style: StylesApp(context)
                                          .textStyleBody14
                                          .copyWith(
                                            color:
                                                DefaultTabController.of(context)
                                                            .index ==
                                                        widget.ranking
                                                            .indexOf(league)
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
                              .map((league) =>
                                  _buildRankingList(context, members))
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

  Widget _buildRankingList(BuildContext context, members) {
    // Cargar los miembros de la liga
    return ListView.builder(
      shrinkWrap: true,
      itemCount: members.length, // Ejemplo: 10 usuarios en el ranking
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
                  spacing: 10,
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
                      radius: 20,
                      backgroundImage: NetworkImage(GraphQLConfig.urlServidor +
                          members[index]
                              .profilePicture), // Reemplaza con la imagen del usuario
                    ),
                    Text(
                      members[index].username,
                      style: StylesApp(context)
                          .textStyleBody18
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),

                Text(
                  'exp ${members[index].currentPoints}',
                  style: StylesApp(context)
                      .textStyleBody18
                      .copyWith(color: Colors.black),
                ), // Reemplaza con el exp del usuario
              ],
            ),
          );
        }
      },
    );
  }

  void loadMembers(activeLeagueId, BuildContext context) async {
    LoadingService().showLoading(context);
    final memberResponse = await getLeagueMembers(activeLeagueId);
    if (memberResponse.error != null) {
      LoadingService().hideLoading();
      await showCustomDialog(context,
          message: memberResponse.error!, dialogType: DialogType.error);
      return;
    }
    setState(() {
      members = memberResponse.data
          .map((member) => MemberModel.fromJson(removeTypename(member)))
          .cast<MemberModel>()
          .toList();
    });
    LoadingService().hideLoading();
  }
}
