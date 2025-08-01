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
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: StyleColor.white,
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
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
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.white,
        actions: [
          Image.asset(
            "assets/kawaii_fire.png",
            height: 52.0,
            fit: BoxFit.contain,
          )
        ],
      ),
      backgroundColor: StyleColor.turquoise,
      body: SafeArea(
        //  HeadScreenNotAvatar(
        //           title: "Pedidos de Oración",
        //           onRoute: () {
        //             Navigator.pushNamed(context, "/layoutPage");
        //           },
        //         ),
        child: isLoading
            ? LoadingIndicator()
            : Column(
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
                        SizedBox(
                          height: 48.0,
                        ),
                        Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            'Pedidos de Oración',
                            style: StylesApp(context).textStyleTitleOrange,
                          ),
                        ),
                        SizedBox(
                          height: 35.sp,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 40,
                      decoration: BoxDecoration(
                        color: Color(0XFF12CBC4),
              
                      ),
                      child: Center(
                          child: isPrayerGroup && !showRequestPrayer
                              ? _buildPrayerStart(context)
                              : _buildButtonActions(context)),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  _buildButtonActions(BuildContext context) {
    var isWideScreen = MediaQuery.of(context).size.width > 600;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (isLoading) ...{
            Center(
              child: LoadingIndicator(),
            )
          } else ...{
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
            SizedBox(
              height: 84.0,
            ),
            Text(
              "Hacer Pedido de Oración",
              style: StylesApp(context).textStyleBody5,
            ),
            SizedBox(
              height: 5.0,
            ),
            isWideScreen
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.sp,
                        mainAxisSpacing: 10.sp,
                        childAspectRatio: 3,
                      ),
                      itemCount: requestTypes.length,
                      itemBuilder: (context, index) {
                        return ButtonThemeWidget(
                          text: requestTypes[index].label,
                          buttonStyle:
                              StylesApp(context).btnWidgetSmall.copyWith(
                                    backgroundColor: WidgetStatePropertyAll(
                                        generateColor(index)),
                                  ),
                          width: 285.sp,
                          height: 30,
                          onPressed: () => goToRequest(requestTypes[index]),
                        );
                      },
                    ),
                  )
                : Column(
                    children: [
                      for (var index = 0;
                          index < requestTypes.length;
                          index++) ...{
                        ButtonThemeWidget(
                          textCenter: true,
                          text: requestTypes[index].label,
                          buttonStyle:
                              StylesApp(context).btnWidgetSmall.copyWith(
                                    backgroundColor: WidgetStatePropertyAll(
                                        generateColor(index)),
                                  ),
                          width: 285.sp,
                          height: StylesApp(context).btnHeight.height,
                          onPressed: () => goToRequest(requestTypes[index]),
                        ),
                        SizedBox(
                          height: 8.sp,
                        )
                      }
                    ],
                  ),
          }
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
        setState(() {
          isLoading = true;
        });
        await showCustomDialog(
          context,
          message: prayerTypeResponse.error!,
          dialogType: DialogType.error,
        );
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
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      await showCustomDialog(
        context,
        message: e.toString(),
        dialogType: DialogType.error,
      );
    } finally {

      setState(() {
        isLoading = false;
      });
    }






    
  }

  Future<void> funcIsPrayerGroup() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userId = userProvider.currentUser?.userId ?? '';
    if (userId.isEmpty) {
      isPrayerGroup = false;
    }
    final response = await isMemberPrayerGroup(userId);
    if (response.error != null) {
      await showCustomDialog(
        context,
        message: response.error!,
        dialogType: DialogType.error,
      );
      return;
    }
    setState(() {
      isPrayerGroup = response.data['successful'];
      groupId = response.data['id'];
    });
  }

  Widget _buildPrayerStart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ButtonThemeWidget(
            text: "Tomar Pedidos de oración",
            width: 264.sp,
            height: 52.sp,
            buttonStyle: StylesApp(context).btnWidgetSmall,
            textCenter: true,
            onPressed: () {
              Navigator.pushNamed(context, "/takePrayerPage", arguments: {
                "groupId": groupId,
              });
            },
          ),
          SizedBox(height: 10.sp),
          ButtonThemeWidget(
            text: "Hacer Pedido de Oración",
            width: 264.sp,
            height: 52.sp,
            buttonStyle: StylesApp(context).btnWidgetSmall,
            textCenter: true,
            onPressed: () {
              setState(() {
                showRequestPrayer = true;
              });
            },
          ),
        ],
      ),
    );
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
    return color[position];
  }
}
