import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  List<PrayerTypeModel> prayerTypes = [];
  List<ModelData> requestTypes = [];
  bool isLoading = false;
  bool isPrayerGroup = false;
  bool showRequestPrayer = false;
  String? groupId;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _isTablet = isTablet(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: StyleColor.white,
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
            foregroundColor: WidgetStatePropertyAll(StyleColor.white),
          ),
          padding: EdgeInsets.all(0),
          onPressed: () {
            if (showRequestPrayer) {
              setState(() {
                showRequestPrayer = false;
              });
              return;
            }
            Navigator.pushNamed(context, "/layoutPage");
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: _isTablet ? 36 : 30,
          ),
        ),
        backgroundColor: StyleColor.white,
        actions: [
          Image.asset(
            "assets/kawaii_fire.png",
            height: _isTablet ? 64.0 : 52.0,
            fit: BoxFit.contain,
          )
        ],
      ),
      backgroundColor: StyleColor.turquoise,
      body: SafeArea(
        child: isLoading
            ? LoadingIndicator()
            : isPrayerGroup && !showRequestPrayer
                ? _buildPrayerStart(context, _isTablet)
                : _isTablet
                    ? _buildTwoColumnLayout(context)
                    : _buildMobileLayout(context),
      ),
    );
  }

  // DISEÑO DE DOS COLUMNAS PARA TABLET
  Widget _buildTwoColumnLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // COLUMNA IZQUIERDA - Header y acciones principales
        Expanded(
          flex: 5,
          child: Column(
            children: [
              // Header en columna izquierda
              Container(
                width: double.infinity,
                height: 100.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage("assets/elipsisTop.png"),
                    fit: BoxFit.cover,
                    alignment: Alignment.bottomCenter,
                  ),
                ),
                // color: Colors.transparent,
                child: Center(
                  child: Text(
                    'Pedidos de Oración',
                    style: StylesApp(context).textStyleTitleOrange.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              // Contenido de la columna izquierda
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        StyleColor.turquoise.withValues(alpha: 0.9),
                        Color(0XFF12CBC4),
                      ],
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20.0),
                        // Botón "Ver respuestas"
                        ButtonThemeWidget(
                          text: "Ver respuestas de tus Pedidos de oración",
                          width: double.infinity,
                          height: 60,
                          buttonStyle:
                              StylesApp(context).btnWidgetSmall.copyWith(
                                    textStyle: WidgetStatePropertyAll(
                                      TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                          textCenter: true,
                          onPressed: () {
                            Navigator.pushNamed(context, "/listRequestPage");
                          },
                        ),

                        SizedBox(height: 30.0),

                        // Título "Hacer Pedido de Oración"
                        Text(
                          "Hacer Pedido de Oración",
                          style: StylesApp(context).textStyleBody5.copyWith(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: StyleColor.blueDark,
                              ),
                        ),

                        SizedBox(height: 25.0),

                        // Botón para solicitar oración (deshabilita para mostrar categorías)
                        Container(
                          width: double.infinity,
                          constraints: BoxConstraints(minHeight: 100.0),
                          decoration: BoxDecoration(
                            color: StyleColor.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 12,
                                offset: Offset(0, 6),
                              ),
                            ],
                            border: Border.all(
                              color: StyleColor.orange.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                spacing: 10,
                                children: [
                                  Icon(
                                    Icons.handshake_rounded,
                                    size: 40,
                                    color: StyleColor.orange,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Selecciona una categoría",
                                    style: StylesApp(context)
                                        .textStyleBody18
                                        .copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: StyleColor.blueDark,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Elige de la lista a la derecha",
                                style:
                                    StylesApp(context).textStyleBody15.copyWith(
                                          fontSize: 15,
                                          color: Colors.grey[600],
                                        ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 40.0),

                        // Información adicional
                        Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: StyleColor.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: StyleColor.blue.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lightbulb,
                                      color: StyleColor.orange, size: 22),
                                  SizedBox(width: 10),
                                  Text(
                                    "¿Cómo funciona?",
                                    style: StylesApp(context)
                                        .textStyleBody16
                                        .copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: StyleColor.blueDark,
                                        ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                "1. Selecciona una categoría de la lista\n"
                                "2. Completa tu petición de oración\n"
                                "3. Nuestro equipo intercederá por ti\n"
                                "4. Recibirás notificaciones de respuestas",
                                style:
                                    StylesApp(context).textStyleBody12.copyWith(
                                          fontSize: 13,
                                          color: Colors.grey[700],
                                          height: 1.6,
                                        ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 30.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // COLUMNA DERECHA - Categorías
        Expanded(
          flex: 7,
          child: Container(
            color: Color(0XFF12CBC4),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título de categorías
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: StyleColor.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.category,
                            color: StyleColor.orange, size: 24),
                        SizedBox(width: 12),
                        Text(
                          "Categorías de Oración",
                          style: StylesApp(context).textStyleBody20.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: StyleColor.blueDark,
                              ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 15.0),

                  // Lista de categorías
                  Expanded(
                    child: requestTypes.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: StyleColor.orange,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  "Cargando categorías...",
                                  style: StylesApp(context)
                                      .textStyleBody16
                                      .copyWith(
                                        fontSize: 16.sp,
                                        color: Colors.white,
                                      ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: requestTypes.length,
                            itemBuilder: (context, index) {
                              return _buildCategoryListItem(
                                  requestTypes[index], index, context);
                            },
                          ),
                  ),

                  SizedBox(height: 20.0),

                  // Pie de información
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: StyleColor.white.withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "💬 Cada petición es tratada con absoluta confidencialidad y respeto. "
                      "Tu privacidad es nuestra prioridad.",
                      style: StylesApp(context).textStyleBody12.copyWith(
                            // fontSize: 12.sp,
                            color: Colors.grey[700],
                            fontStyle: FontStyle.italic,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Item de categoría para lista vertical
  Widget _buildCategoryListItem(
      ModelData category, int index, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => goToRequest(category),
          child: Container(
            width: double.infinity,
            height: 65,
            decoration: BoxDecoration(
              color: generateColor(index).withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: generateColor(index).withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  // Número de categoría
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        "${index + 1}",
                        style: StylesApp(context).textStyleBody16.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: generateColor(index),
                            ),
                      ),
                    ),
                  ),

                  SizedBox(width: 15),

                  // Nombre de categoría
                  Expanded(
                    child: Text(
                      category.label,
                      style: StylesApp(context).textStyleBody16.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  SizedBox(width: 10),

                  // Flecha indicadora
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // DISEÑO MÓVIL (se mantiene exactamente igual)
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/elipsisTop.png"),
              fit: BoxFit.cover,
              alignment: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 48.0),
              Center(
                child: Text(
                  'Pedidos de Oración',
                  style: StylesApp(context).textStyleTitleOrange,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 35.sp),
            ],
          ),
        ),
        SizedBox(height: 15),
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color(0XFF12CBC4)),
            child: Center(
              child: _buildButtonActionsMobile(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButtonActionsMobile(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ButtonThemeWidget(
            text: "Ver respuestas de tus Pedidos de oración",
            width: 264.sp,
            height: 52.sp,
            buttonStyle: StylesApp(context).btnWidgetSmall,
            textCenter: true,
            onPressed: () {
              Navigator.pushNamed(context, "/listRequestPage");
            },
          ),
          SizedBox(height: 84.0),
          Text(
            "Hacer Pedido de Oración",
            style: StylesApp(context).textStyleBody5,
          ),
          SizedBox(height: 5.0),
          Column(
            children: [
              for (var index = 0; index < requestTypes.length; index++) ...{
                ButtonThemeWidget(
                  textCenter: true,
                  text: requestTypes[index].label,
                  buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                        backgroundColor:
                            WidgetStatePropertyAll(generateColor(index)),
                      ),
                  width: 285.sp,
                  height: StylesApp(context).btnHeight.height,
                  onPressed: () => goToRequest(requestTypes[index]),
                ),
                SizedBox(height: 8.sp)
              }
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerStart(BuildContext context, bool isTablet) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonThemeWidget(
            text: "Tomar Pedidos de oración",
            width: isTablet ? 400 : 264.sp,
            height: isTablet ? 60 : 52.sp,
            buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(fontSize: isTablet ? 18.sp : null),
                  ),
                ),
            textCenter: true,
            onPressed: () {
              Navigator.pushNamed(context, "/takePrayerPage", arguments: {
                "groupId": groupId,
              });
            },
          ),
          SizedBox(height: isTablet ? 25.sp : 10.sp),
          ButtonThemeWidget(
            text: "Hacer Pedido de Oración",
            width: isTablet ? 400 : 264.sp,
            height: isTablet ? 60 : 52.sp,
            buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                  textStyle: WidgetStatePropertyAll(
                    TextStyle(fontSize: isTablet ? 18.sp : null),
                  ),
                ),
            textCenter: true,
            onPressed: () {
              setState(() {
                showRequestPrayer = true;
              });
            },
          ),
          if (isTablet) SizedBox(height: 40.sp),
        ],
      ),
    );
  }

  void _loadData(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    await funcIsPrayerGroup();

    try {
      final prayerTypeResponse = await getAllPrayerRequestTypes();
      if (prayerTypeResponse.error != null) {
        if (mounted) {
          await showCustomDialog(
            context,
            message: prayerTypeResponse.error!,
            dialogType: DialogType.error,
          );
        }
        return;
      }

      setState(() {
        prayerTypes = prayerTypeResponse.data
            .map<PrayerTypeModel>((json) => PrayerTypeModel.fromJson(json))
            .toList();
        requestTypes = prayerTypes
            .map<ModelData>(
                (type) => ModelData(label: type.name, value: type.id))
            .toList();
      });
    } catch (e) {
      if (mounted) {
        await showCustomDialog(
          context,
          message: e.toString(),
          dialogType: DialogType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> funcIsPrayerGroup() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.currentUser?.userId ?? '';
    if (userId.isEmpty) {
      isPrayerGroup = false;
      return;
    }

    final response = await isMemberPrayerGroup(userId);
    if (response.error != null) {
      if (mounted) {
        await showCustomDialog(
          context,
          message: response.error!,
          dialogType: DialogType.error,
        );
      }
      return;
    }

    setState(() {
      isPrayerGroup = response.data['successful'];
      groupId = response.data['id'];
    });
  }

  goToRequest(type) {
    Navigator.pushNamed(context, '/requestPage',
        arguments: {"label": type.label, "value": type.value});
  }

  Color generateColor(position) {
    List<Color> color = [
      StyleColor.skyBlue,
      StyleColor.oceanDepth,
      StyleColor.lavenderMist,
      StyleColor.violetDream,
      StyleColor.electricViolet,
      StyleColor.cosmicBlue,
      StyleColor.galaxyPurple,
      StyleColor.starlightBlue,
      StyleColor.twilightBlue,
    ];
    return color[position % color.length];
  }
}
