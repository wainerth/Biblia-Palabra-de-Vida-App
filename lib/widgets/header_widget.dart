import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/models/login_user.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({
    super.key,
  });

  @override
  State<HeaderWidget> createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    final translationProvider = context.read<AppTranslationProvider>();

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final LoginUser? userData = userProvider.currentUser;

    return Container(
      constraints: BoxConstraints(minHeight: 80.0),
      decoration: BoxDecoration(
        color: Color(0XFFFD8C43),
        borderRadius: BorderRadius.circular(8.0),
      ),
      // padding: EdgeInsets.only(left: 4.0, top: 5.0, bottom: 5.0),
      child: Row(
        spacing: 0,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 50.0,
                    width: 50.0,
                    child: userData?.imgProfileUser != null
                        ? CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              "${GraphQLConfig.urlServidor}${userData?.imgProfileUser?.urlImg}?timestamp=${DateTime.now().millisecondsSinceEpoch}",
                            ),
                            onBackgroundImageError: (_, __) {
                              setState(() {});
                            },
                          )
                        : CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/icon.png'),
                          ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text.rich(
                  textAlign: TextAlign.left,
                  style: StylesApp(context).textStyleBody12,
                  TextSpan(
                    children: [
                      TextSpan(
                          text:
                              "${translationProvider.tr('header_adventure.experience')} : "),
                      TextSpan(text: "${userData?.expTotalUser}")
                    ],
                  ),
                ),
                Text.rich(
                  style: StylesApp(context).textStyleBody12,
                  TextSpan(
                    children: [
                      TextSpan(
                          text:
                              "${translationProvider.tr('header_adventure.streak')} : "),
                      TextSpan(
                          text: translationProvider
                              .tr('header_adventure.days')
                              .replaceAll(
                                  "%s", userData!= null ?  userData.streakDaysCount.toString() : ''))
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              spacing: 0,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profilePage');
                  },
                  padding: EdgeInsets.all(0),
                  iconSize: 20.sp,
                  icon: Icon(
                    size: 20.sp,
                    Icons.fast_forward_sharp,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
