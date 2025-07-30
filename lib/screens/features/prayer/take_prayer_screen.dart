import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/query.dart';
import 'package:biblia_palabra_de_vida_app/models/prayer_model.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class TakePrayerScreen extends StatefulWidget {
  const TakePrayerScreen({super.key});

  @override
  State<TakePrayerScreen> createState() => _TakePrayerScreenState();
}

class _TakePrayerScreenState extends State<TakePrayerScreen> {
  String? groupId;
  String? errorMessage;
  bool isLoading = true;
  List<PrayerModel> listRequest = [];
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generateData(context);
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
        actions: [
          Image.asset(
            "assets/kawaii_fire.png",
            height: 52.0,
            fit: BoxFit.contain,
          )
        ],
      ),
      backgroundColor: StyleColor.turquoise,
      body: Column(
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
          Container(
            child: Text("$groupId"),
          ),
        ],
      ),
    );
  }

  void _generateData(BuildContext context) async {
    setState(() {
      errorMessage = null;
      isLoading = true;
    });
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userData = userProvider.currentUser;
    try {
      final responseListRequest =
          await getAllRequestPrayerByGroupId(userData?.userId);
      if (responseListRequest.error != null) {
        setState(() {
          errorMessage = responseListRequest.error!;
          isLoading = false;
        });
        return;
      }

      setState(() {
        listRequest = responseListRequest.data['data']
            .map<PrayerModel>((request) => PrayerModel.fromJson(request))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
