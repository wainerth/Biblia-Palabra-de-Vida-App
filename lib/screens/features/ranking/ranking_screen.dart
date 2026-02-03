import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
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
      final catalogueProvider =
          Provider.of<CatalogueProvider>(context, listen: false);

      if (catalogueProvider.allLeagues.isEmpty) {
        await catalogueProvider.loadLeagues();
      }

      leagues = List.from(catalogueProvider.allLeagues);

      if (leagues.isEmpty) {
        setState(() => errorMessage = "No se encontraron ligas");
      }
    } catch (e) {
      setState(() => errorMessage = e.toString());
    } finally {
      LoadingService().hideLoading();
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return Container();
    if (errorMessage != null) {
      return BuildErrorWidget(
        errorMessage: errorMessage!,
        onRetry: () => _generateData(context),
        onBack: () => Navigator.pop(context),
      );
    }
    return RankingScreenView(ranking: leagues);
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
  UserProvider? userData;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialMembers(context);
    });
  }

  void _loadInitialMembers(BuildContext context) {
    userData = Provider.of<UserProvider>(context, listen: false);

    if (userData?.currentUser != null) {
      if (userData?.currentUser!.currentLeague != null) {
        activeLeagueId = userData!.currentUser!.currentLeague!.id;
        loadMembers(activeLeagueId, userData?.currentUser!.userId, context);
      } else {
        setState(() => noActiveLigue = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _isTablet = isTablet(context);

    return Scaffold(
      backgroundColor: StyleColor.turquoise,
      body: SafeArea(
        child: ResponsiveLayout(
          mobile: _buildMobileLayout(),
          tablet: _buildTabletLayout(),
        ),
      ),
    );
  }

  // Layout para móvil (manteniendo el diseño actual)
  Widget _buildMobileLayout() {
    return Column(
      children: [
        Expanded(
          child: SizedBox(
            child: Column(
              children: [
                if (!noActiveLigue) LeagueTimeRemaining(),
                _buildLeagueTabs(),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8, top: 0, right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: noActiveLigue
                        ? _buildNoLeagueWidget()
                        : _buildRankingList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Layout para tablet con 2 columnas
  Widget _buildTabletLayout() {
    return Row(
      children: [
        // Columna izquierda: Ligas y tabs (30% del ancho)
        Container(
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Colors.black, width: 1.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(2, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              if (!noActiveLigue)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: LeagueTimeRemaining(),
                ),
              _buildTabletLeagueList(),
            ],
          ),
        ),

        // Columna derecha: Ranking (70% del ancho)
        Expanded(
          child: Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: noActiveLigue ? _buildNoLeagueWidget() : _buildRankingList(),
          ),
        ),
      ],
    );
  }

  // Lista de ligas optimizada para tablet
  Widget _buildTabletLeagueList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.ranking.length,
        itemBuilder: (context, index) => _buildTabletLeagueItem(index),
      ),
    );
  }

  Widget _buildTabletLeagueItem(int index) {
    final league = widget.ranking[index];
    final isActive = league.id == activeLeagueId;

    return GestureDetector(
      onTap: () => _showLeagueDetails(league),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive
              ? StyleColor.turquoise.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? StyleColor.turquoise : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Icono de la liga
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Color(int.parse("0xFF${league.colorBack}")),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Color(int.parse("0xFF${league.colorFront}")),
                    blurRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Color(int.parse("0xFF${league.colorFront}")),
                ),
                child: Image.network(
                  GraphQLConfig.urlServidor + league.img!.urlImg,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            SizedBox(width: 12),
            // Nombre de la liga
            Expanded(
              child: Text(
                league.name,
                style: StylesApp(context).textStyleBody16.copyWith(
                      color: isActive ? StyleColor.turquoise : Colors.black,
                      fontWeight:
                          isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tabs de ligas para móvil (manteniendo el diseño original)
  Widget _buildLeagueTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border:
            const Border(bottom: BorderSide(color: Colors.black, width: 1.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: 120,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: widget.ranking.length,
          itemBuilder: (context, index) => _buildLeagueTabItem(index),
        ),
      ),
    );
  }

  Widget _buildLeagueTabItem(int index) {
    final league = widget.ranking[index];
    final isActive = league.id == activeLeagueId;

    return GestureDetector(
      onTap: () => _showLeagueDetails(league),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 109,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Icono de la liga
            Container(
              height: 60,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Color(int.parse("0xFF${league.colorBack}")),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Color(int.parse("0xFF${league.colorFront}")),
                    blurRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Color(int.parse("0xFF${league.colorFront}")),
                ),
                child: Image.network(
                  GraphQLConfig.urlServidor + league.img!.urlImg,
                ),
              ),
            ),
            // Indicador activo
            SizedBox(height: isActive ? 8 : 5),
            if (isActive)
              ClipOval(
                child: Container(
                  width: 80,
                  height: 9,
                  color: Colors.amber,
                ),
              ),
            // Nombre de la liga
            Text(
              league.name,
              style: StylesApp(context).textStyleBody14.copyWith(
                    color: isActive ? StyleColor.turquoise : StyleColor.orange,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoLeagueWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 56, 54, 54),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Image.asset(
                'assets/go-aventure.gif',
                height: 100,
              ),
            ),
            Text(
              'No tienes una liga activa',
              style: StylesApp(context).textStyleBody18.copyWith(
                    color: const Color.fromARGB(255, 22, 22, 22),
                  ),
            ),
            Text(
              textAlign: TextAlign.center,
              'Juega Aventuras para conseguir una liga',
              style: StylesApp(context).textStyleBody15.copyWith(
                    color: const Color.fromARGB(255, 22, 22, 22),
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: members.length,
      itemBuilder: (context, index) => _buildRankingItem(index),
    );
  }

  Widget _buildRankingItem(int index) {
    final member = members[index];
    final isCurrentUser =
        (members[index].userId == userData?.currentUser?.userId &&
            members[index].username == userData?.currentUser?.username);
    final position = index + 1;

    if (position == 6) return _buildPromotionZone(index);
    if (position == 11) return _buildRelegationZone(index);

    return _buildMemberRow(
      index: index,
      member: member,
      isCurrentUser: isCurrentUser,
      showSpecialZones: false,
    );
  }

  Widget _buildPromotionZone(int index) {
    return Column(
      children: [
        if (!_isLastLeague())
          _buildZoneHeader(
            text: 'Zona de Ascenso',
            icon: Icons.arrow_upward_rounded,
            color: StyleColor.turquoise,
          ),
        _buildMemberRow(
          index: index,
          member: members[index],
          isCurrentUser:
              (members[index].userId == userData?.currentUser?.userId &&
                  members[index].username == userData?.currentUser?.username),
          showSpecialZones: true,
        ),
      ],
    );
  }

  Widget _buildRelegationZone(int index) {
    return Column(
      children: [
        if (!_isFirstLeague())
          _buildZoneHeader(
            text: 'Zona de Descenso',
            icon: Icons.arrow_downward_rounded,
            color: StyleColor.redDark,
          ),
        _buildMemberRow(
          index: index,
          member: members[index],
          isCurrentUser:
              (members[index].userId == userData?.currentUser?.userId &&
                  members[index].username == userData?.currentUser?.username),
          showSpecialZones: true,
        ),
      ],
    );
  }

  Widget _buildZoneHeader(
      {required String text, required IconData icon, required Color color}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          Text(
            text,
            style: StylesApp(context).textStyleBody15.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
          Icon(icon, color: color),
        ],
      ),
    );
  }

  Widget _buildMemberRow({
    required int index,
    required MemberModel member,
    required bool isCurrentUser,
    required bool showSpecialZones,
  }) {
    final position = index + 1;
    _getPositionColor(position);
    final isTopThree = position <= 3;

    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser ? StyleColor.blueMedium.withAlpha(70) : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Información del usuario
            Row(
              children: [
                _buildPositionIndicator(position, isTopThree),
                const SizedBox(width: 10),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    GraphQLConfig.urlServidor + member.profilePicture,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 140,
                  child: isTopThree
                      ? TextWithGradient(
                          text: _formatUsername(member.username),
                          colorList: _getColorsGradient(index),
                          font: StylesApp(context).textStyleBody18.copyWith(
                                overflow: TextOverflow.ellipsis,
                              ),
                        )
                      : Text(
                          _formatUsername(member.username),
                          overflow: TextOverflow.ellipsis,
                          style: StylesApp(context).textStyleBody18.copyWith(
                                color: Colors.black,
                              ),
                        ),
                ),
              ],
            ),
            // Puntos del usuario
            isTopThree
                ? TextWithGradient(
                    text: 'exp ${member.currentPoints}',
                    colorList: _getColorsGradient(index),
                    font: StylesApp(context).textStyleBody18,
                  )
                : Text(
                    'exp ${member.currentPoints}',
                    style: StylesApp(context).textStyleBody18.copyWith(
                          color: Colors.black,
                        ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildPositionIndicator(int position, bool isTopThree) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 45,
          height: 45,
          child: Center(
            child: Text(
              "$position",
              style: StylesApp(context).textStyleBody20.copyWith(
                    color: _getPositionColor(position),
                  ),
            ),
          ),
        ),
        if (isTopThree)
          Image.asset(
            _getPositionImage(position),
            height: 45,
            fit: BoxFit.fill,
          ),
      ],
    );
  }

  String _formatUsername(String username) {
    final firstName = username.split(' ')[0];
    return firstName[0].toUpperCase() + firstName.substring(1);
  }

  Color _getPositionColor(int position) {
    if (position < 5) return StyleColor.orange;
    if (position > 15) return Colors.red;
    return Colors.black;
  }

  String _getPositionImage(int position) {
    switch (position) {
      case 1:
        return 'assets/position1.png';
      case 2:
        return 'assets/position2.png';
      case 3:
        return 'assets/position3.png';
      default:
        return '';
    }
  }

  List<Color> _getColorsGradient(int index) {
    switch (index) {
      case 0:
        return [
          const Color(0xFF775D0C),
          const Color(0xFFA07D11),
          const Color(0xFFBA9113),
          const Color(0XFFDDAC17),
        ];
      case 1:
        return [
          const Color(0xFF3D3D3D),
          const Color(0xFF676767),
          const Color(0XFFB7B6B4),
          const Color(0xFF8B8B8B),
        ];
      case 2:
        return [
          const Color(0xFFA97654),
          const Color(0xFF875E43),
          const Color(0xFF6C4B35),
          const Color(0xFF432F21),
        ];
      default:
        return [];
    }
  }

  void _showLeagueDetails(League league) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                league.name,
                style: StylesApp(context).textStyleBody18.copyWith(
                      color: StyleColor.black,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 10),
              Image.network(
                GraphQLConfig.urlServidor + league.img!.urlImg,
                height: 120,
              ),
              const SizedBox(height: 10),
              Text(
                league.description,
                style: StylesApp(context).textStyleBody14.copyWith(
                      color: StyleColor.black,
                    ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void loadMembers(
      String activeLeagueId, String? userId, BuildContext context) async {
    LoadingService().showLoading(context);
    final memberResponse = await getLeagueMembers(activeLeagueId, userId!);

    if (memberResponse.error != null) {
      LoadingService().hideLoading();
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

  bool _isFirstLeague() {
    return widget.ranking.first.id == activeLeagueId;
  }

  bool _isLastLeague() {
    return widget.ranking.last.id == activeLeagueId;
  }
}

class LeagueTimeRemaining extends StatelessWidget {
  const LeagueTimeRemaining({super.key});

  DateTime _getFechaFinDeSemana() {
    final now = DateTime.now();
    final currentWeekday = now.weekday;
    final daysUntilEndOfWeek = DateTime.daysPerWeek - currentWeekday;
    final endOfWeek = now.add(Duration(days: daysUntilEndOfWeek));
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
