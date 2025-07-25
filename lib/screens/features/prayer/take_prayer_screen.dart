import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class TakePrayerScreen extends StatefulWidget {
  const TakePrayerScreen({super.key});

  @override
  State<TakePrayerScreen> createState() => _TakePrayerScreenState();
}

class _TakePrayerScreenState extends State<TakePrayerScreen> {
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
        centerTitle: true,
        leading: IconButton.filled(
          style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(StyleColor.orange),
              foregroundColor: WidgetStatePropertyAll(StyleColor.white)),
          padding: EdgeInsets.all(0),
          onPressed: () {
            Navigator.pop(context);
          },
          splashColor: StyleColor.orange,
          color: StyleColor.white,
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
        ),
        backgroundColor: StyleColor.turquoise,
        title: Text(
          'Pedidos de Oración',
          style: StylesApp(context)
              .textStyleBody16
              .copyWith(color: StyleColor.white),
        ),
        actions: [
          Image.asset(
            "assets/kawaii_fire.png",
            height: 52.0,
            fit: BoxFit.contain,
          )
        ],
      ),
      backgroundColor: StyleColor.turquoise,
      body: Container(
        child: Text("$groupId"),
      ),
    );
  }

  void _loadData(BuildContext context) {
    final prayerParam = ModalRoute.of(context)!.settings.arguments;
    setState(() {
      groupId = (prayerParam as Map<String, dynamic>)['groupId'];
    });
  }
}
