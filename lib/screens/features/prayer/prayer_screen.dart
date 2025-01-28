import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PrayerScreen extends StatefulWidget {
  const PrayerScreen({super.key});

  @override
  State<PrayerScreen> createState() => _PrayerScreenState();
}

class _PrayerScreenState extends State<PrayerScreen> {
  List requestTypes = [
    {"label": "Salud", "value": "1"},
    {"label": "Encontrar Paz", "value": "2"},
    {"label": "Familia", "value": "3"},
    {"label": "Protección", "value": "4"},
    {"label": "Trabajo", "value": "5"},
    {"label": "Finanzas", "value": "6"},
    {"label": "Libertad de los Vicios", "value": "7"},
    {"label": "Espirituales", "value": "8"},
    {"label": "Otro", "value": "9"},
  ];
  goToRequest(type) {
    Navigator.pushNamed(context, '/requestPage', arguments: type);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(color: Color(0XFF12CBC4)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                HeadScreenNotAvatar(
                  title: "Pedidos de Oración",
                  onRoute: () {
                    Navigator.pushNamed(context, "/layoutPage");
                  },
                ),
                SizedBox(
                  height: 7.sp,
                ),
                ButtonThemeWidget(
                  text: "Ver respuestas de tus Pedidos de oración",
                  width: 264.sp,
                  height: 52.sp,
                  buttonStyle: StylesApp(context).btnWidgetSmall,
                  textCenter: true,
                  onPressed: (){
                    Navigator.popAndPushNamed(context, "/listRequestPage");
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
                _buildButtonActions(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildButtonActions(BuildContext context) {
    var isWideScreen = MediaQuery.of(context).size.width > 600;
    return isWideScreen
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
            text: requestTypes[index]["label"],
            buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
                backgroundColor: WidgetStatePropertyAll(generateColor(index)),
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
          for (var index = 0; index < requestTypes.length; index++) ...{
          ButtonThemeWidget(
            text: requestTypes[index]["label"],
            buttonStyle: StylesApp(context).btnWidgetSmall.copyWith(
              backgroundColor: WidgetStatePropertyAll(generateColor(index)),
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
        );
  }
}


