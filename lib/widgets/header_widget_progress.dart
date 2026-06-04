import 'package:biblia_palabra_de_vida_app/config/api_config.dart';
import 'package:biblia_palabra_de_vida_app/config/graphql_config.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';


import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class HeaderWidgetProgress extends StatelessWidget {
  const HeaderWidgetProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final LoginUser? userData = userProvider.currentUser;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/elipsisTopColor.png"),
          fit: BoxFit.cover,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 15,
            child: Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                    color: Color(0XFFFD8C43),
                    borderRadius: BorderRadius.circular(35.0)),
                child: IconButton(
                    constraints: BoxConstraints(maxHeight: 35.0),
                    padding: EdgeInsets.all(0),
                    iconSize: 35.0,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pushNamed(context, "/layoutPage");
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35.0,
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: SizedBox(
                  child: Stack(
                    children: [
                      Container(
                        constraints: BoxConstraints(
                            maxWidth: 115.0,
                            minHeight: 115.0,
                            maxHeight: 115.0),
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(115.0),
                            border: Border.all(
                                width: 6.0, color: Color(0XFFFFFFFF))),
                        child: ClipOval(
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              imageUrl: userData!.imgProfileUser != null
                              ? ApiConfig.baseUrl+userData.imgProfileUser!.urlImg
                              : 'assets/no-image.jpg',
                              placeholder:(context, url ) => Image.asset('assets/no-image.jpg'),
                              errorWidget:(context, url , error) => Image.asset('assets/no-image.jpg')
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Text(
                 textAlign: TextAlign.center,
                softWrap: true,
                userData.name.split(' ')[0][0].toUpperCase() + userData.name.split(' ')[0].substring(1),
                style: StylesApp(context).textStyleTitleWithe24,
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          Positioned(
              top: userData.energyPoints >= 1000 ? 0 : 30,
              bottom: 0,
              right: 15,
              child: Column(
                children: [
                  Image.asset(
                    "assets/kawaii_fire.png",
                    height: calculateHeight(
                        double.parse("${userData.energyPoints}")),
                    fit: BoxFit.contain,
                  ),
                  Text(
                    userData.energyPoints.toString(),
                    style: StylesApp(context)
                        .textStyleBody4
                        .copyWith(color: Color(0XFFFD8C43)),
                  )
                ],
              ))
        ],
      ),
    );
  }

  double calculateHeight(double score) {
    score = score.abs();

    double maxPossibleHeight = score / 1000 * 112;

    if (score >= 1000) {
      return 100; // Alto fijo cuando los puntos son mayores o iguales a 1000
    } else {
      double width = ((maxPossibleHeight * 100)) / 112;

      return width > 30 ? ((maxPossibleHeight * 100)) / 112 : 40;
    }
  }
}
