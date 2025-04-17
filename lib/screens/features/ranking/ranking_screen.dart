import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/querys.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
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
            : RankingScreenView(ranking: leagues);
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
    final userData = Provider.of<UserProvider>(context, listen: false);
    // activeLeagueId = widget.ranking[DefaultTabController.of(context).index].id;
    if (userData != null && userData.currentUser != null) {
      activeLeagueId = userData.currentUser!.currentLeagueId!;
    }
    loadMembers(activeLeagueId, context);
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
                    LeagueTimeRemaining(),
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
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.ranking.length,
                          itemBuilder: (BuildContext context, index) {
                            return GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return SingleChildScrollView(
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              widget.ranking[index].name,
                                              style: StylesApp(context)
                                                  .textStyleBody18
                                                  .copyWith(
                                                      color: StyleColor.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                            ),
                                            SizedBox(height: 10),
                                            Image.network(
                                              GraphQLConfig.urlServidor +
                                                  widget.ranking[index].img
                                                      .urlImg,
                                              height: 120,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Color de Fondo: ${widget.ranking[index].colorBack}',
                                              style: StylesApp(context)
                                                  .textStyleBody14
                                                  .copyWith(
                                                      color: StyleColor.black),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'Color de Frente: ${widget.ranking[index].colorFront}',
                                              style: StylesApp(context)
                                                  .textStyleBody14
                                                  .copyWith(
                                                      color: StyleColor.black),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              'ID de Liga: ${widget.ranking[index].id}',
                                              style: StylesApp(context)
                                                  .textStyleBody14
                                                  .copyWith(
                                                      color: StyleColor.black),
                                            ),
                                            SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                height: 109,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: 60,
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: Color(int.parse(
                                            "0xFF${widget.ranking[index].colorBack}")),
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(int.parse(
                                                "0xFF${widget.ranking[index].colorFront}")),
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
                                              "0xFF${widget.ranking[index].colorFront}")),
                                        ),
                                        child: Image.network(GraphQLConfig
                                                .urlServidor +
                                            widget.ranking[index].img.urlImg),
                                      ),
                                    ),
                                    if (widget.ranking[index].id ==
                                        activeLeagueId) ...{
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
                                      widget.ranking[index].name,
                                      style: StylesApp(context)
                                          .textStyleBody14
                                          .copyWith(
                                            color: widget.ranking[index].id ==
                                                    activeLeagueId
                                                ? StyleColor.turquoise
                                                : StyleColor.orange,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 8, top: 0, right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: _buildRankingList(context, members),
                      ),
                      //   TabBarView(
                      //     physics:
                      //         const NeverScrollableScrollPhysics(),
                      //     children: widget.ranking
                      //         .map((league) =>
                      //         .toList(),
                      //   ),
                      // ),
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
                    SizedBox(
                      width: 130,
                      child: Text(
                        members[index].username,
                        overflow: TextOverflow.ellipsis,
                        style: StylesApp(context)
                            .textStyleBody18
                            .copyWith(color: Colors.black),
                      ),
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
      // await showCustomDialog(context,
      //     message: memberResponse.error!, dialogType: DialogType.error);
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

class LeagueTimeRemaining extends StatelessWidget {
  const LeagueTimeRemaining({super.key});

  DateTime _getFechaFinDeSemana() {
    final now = DateTime.now();
    final currentWeekday = now.weekday; // 1 para Lunes, 7 para Domingo
    // Calcular cuántos días faltan hasta el Domingo (último día de la semana)
    final daysUntilEndOfWeek = DateTime.daysPerWeek - currentWeekday;
    final endOfWeek = now.add(Duration(days: daysUntilEndOfWeek));
    // Establecer la hora al final del día (23:59:59)
    return DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day, 23, 59, 59);
  }
String _formatTwoDigits(int number) {
    return number.toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1), (_) {
        final now = DateTime.now();
        final fechaFin = _getFechaFinDeSemana();
        final difference = fechaFin.difference(now);
        // Asegurarse de que la diferencia no sea negativa
        return difference.isNegative ? Duration.zero : difference;
      }),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Text(
            'Cargando...',
            style: StylesApp(context).textStyleBody18.copyWith(
                  color: Colors.white,
                ),
          );
        }
        final difference = snapshot.data as Duration;
        final days = _formatTwoDigits(difference.inDays);
        final hours = _formatTwoDigits(difference.inHours % 24);
        final minutes = _formatTwoDigits(difference.inMinutes % 60);
        final seconds = _formatTwoDigits(difference.inSeconds % 60);

        return Text.rich(
          TextSpan(children: [
            TextSpan(text: "Tiempo Restante:  ", style: StylesApp(context).textStyleBody14),
            TextSpan(text:'$days días $hours:$minutes:$seconds',
          style: StylesApp(context).textStyleBody14.copyWith(
                color: Colors.white,
              ), )
          ],)
        ) ;
  
      },
    );
  }
}
