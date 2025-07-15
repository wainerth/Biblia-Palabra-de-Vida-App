import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
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
  bool noActiveLigue = false;

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
    if (userData.currentUser != null) {
      if (userData.currentUser!.currentLeague != null ) {
        activeLeagueId = userData.currentUser!.currentLeague!.id;
        loadMembers(activeLeagueId, userData.currentUser!.userId, context);
      } else {
        // Si no hay una liga activa, puedes manejarlo como desees
        setState(() {
          noActiveLigue = true;
        });
      }
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
              child: SizedBox(
                child: Column(
                  children: [
                    // Pestañas
                    if (!noActiveLigue) LeagueTimeRemaining(),
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
                      child: SizedBox(
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
                                                      !.urlImg,
                                              height: 120,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              widget.ranking[index].description,
                                              style: StylesApp(context)
                                                  .textStyleBody14
                                                  .copyWith(
                                                      color: StyleColor.black),
                                            ),
                                            SizedBox(height: 10),
                                            // Text(
                                            //   'Máximo de Participantes: ${widget.ranking[index].maxMembers}',
                                            //   style: StylesApp(context)
                                            //       .textStyleBody14
                                            //       .copyWith(
                                            //           color: StyleColor.black),
                                            // ),
                                            // SizedBox(height: 10),
                                            // Text(
                                            //   'ID de Liga: ${widget.ranking[index].id}',
                                            //   style: StylesApp(context)
                                            //       .textStyleBody14
                                            //       .copyWith(
                                            //           color: StyleColor
                                            //               .black),
                                            // ),
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
                                            widget.ranking[index].img!.urlImg,
                                            ),
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
                        child: noActiveLigue
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 56, 54, 54),
                                          borderRadius:
                                              BorderRadius.circular(100),
                                        ),
                                        child: Image.asset(
                                          'assets/go-aventure.gif',
                                          height: 100,
                                        ),
                                      ),
                                      Text(
                                        'No tienes una liga activa',
                                        style: StylesApp(context)
                                            .textStyleBody18
                                            .copyWith(
                                              color: const Color.fromARGB(
                                                  255, 22, 22, 22),
                                            ),
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        'Juega Aventuras para conseguir una liga',
                                        style: StylesApp(context)
                                            .textStyleBody15
                                            .copyWith(
                                              color: const Color.fromARGB(
                                                  255, 22, 22, 22),
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : _buildRankingList(context, members),
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

        if (index == 5) {
          return Column(
            children: [
              if (!isLastLeague())
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_upward_rounded, color: Colors.green),
                      Text(
                        'Zona de Ascenso',
                        style: StylesApp(context).textStyleBody15.copyWith(
                              color: StyleColor.greenDark,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.arrow_upward_rounded, color: Colors.green),
                    ],
                  ),
                ),
              Padding(
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
                              child: SizedBox(
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
                          backgroundImage: NetworkImage(GraphQLConfig
                                  .urlServidor +
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
              )
            ],
          );
        } else if (index == 10) {
          return Column(
            children: [
              if (!isFirstLeague())
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_downward_rounded, color: Colors.red),
                      Text(
                        'Zona de Descenso',
                        style: StylesApp(context).textStyleBody15.copyWith(
                              color: StyleColor.redDark,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      Icon(Icons.arrow_downward_rounded, color: Colors.red),
                    ],
                  ),
                ),
              Padding(
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
                              child: SizedBox(
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
                          backgroundImage: NetworkImage(GraphQLConfig
                                  .urlServidor +
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
              )
            ],
          );
        } else {
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
                          child: SizedBox(
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
                      width: 140,
                      child: index <= 2
                          ? TextWithGradient(
                              text: members[index]
                                      .username
                                      .split(' ')[0][0]
                                      .toUpperCase() +
                                  members[index]
                                      .username
                                      .split(' ')[0]
                                      .substring(1),
                              colorList: getColorsGradient(index),
                              font: StylesApp(context).textStyleBody18.copyWith(
                                    overflow: TextOverflow.ellipsis,
                                  ),
                            )
                          : Text(
                              members[index]
                                      .username
                                      .split(' ')[0][0]
                                      .toUpperCase() +
                                  members[index]
                                      .username
                                      .split(' ')[0]
                                      .substring(1),
                              overflow: TextOverflow.ellipsis,
                              style: StylesApp(context)
                                  .textStyleBody18
                                  .copyWith(color: Colors.black),
                            ),
                    ),
                  ],
                ),
                index <= 2
                    ? TextWithGradient(
                        text: 'exp ${members[index].currentPoints}',
                        colorList: getColorsGradient(index),
                        font: StylesApp(context).textStyleBody18.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                      )
                    : Text(
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

  void loadMembers(activeLeagueId, userId, BuildContext context) async {
    LoadingService().showLoading(context);
    final memberResponse = await getLeagueMembers(activeLeagueId, userId);
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

  List<Color> getColorsGradient(int index) {
    List<Color> colors = [];
    if (index == 0) {
      colors = [
        Color(0xFF775D0C),
        Color(0xFFA07D11),
        Color(0xFFBA9113),
        Color(0XFFDDAC17)
      ];
    } else if (index == 1) {
      colors = [
        Color(0xFF3D3D3D),
        Color(0xFF676767),
        Color(0XFFB7B6B4),
        Color(0xFF8B8B8B)
      ];
    } else if (index == 2) {
      colors = [
        Color(0xFFA97654),
        Color(0xFF875E43),
        Color(0xFF6C4B35),
        Color(0xFF432F21)
      ];
    }

    return colors;
  }

  bool isFirstLeague() {
    final leagues = Provider.of<CatalogueProvider>(context, listen: false)
        .allLeagues
        .map((league) => league)
        .toList();
    if (leagues.first.id == activeLeagueId) {
      return true;
    }
    return false;
  }

  bool isLastLeague() {
    final leagues = Provider.of<CatalogueProvider>(context, listen: false)
        .allLeagues
        .map((league) => league)
        .toList();
    if (leagues.last.id == activeLeagueId) {
      return true;
    }
    return false;
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

        return Text.rich(TextSpan(
          children: [
            TextSpan(
                text: "Tiempo Restante:  ",
                style: StylesApp(context).textStyleBody14),
            TextSpan(
              text: '$days días $hours:$minutes:$seconds',
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: Colors.white,
                  ),
            )
          ],
        ));
      },
    );
  }
}
