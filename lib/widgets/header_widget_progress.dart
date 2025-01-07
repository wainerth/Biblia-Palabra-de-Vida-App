import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';

class HeaderWidgetProgress extends StatelessWidget {
  const HeaderWidgetProgress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    double score = 10000;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("/elipsisTopColor.png"),
          fit: StylesApp(context).fitImage,
          alignment: Alignment.topCenter,
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
                        constraints:
                            BoxConstraints(maxWidth: 160, minHeight: 160),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(160),
                            border: Border.all(
                                width: 6.0, color: Color(0XFFFFFFFF))),
                        child: Image.asset(
                          "/avatar.png",
                          fit: BoxFit.fill,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(
                "Robinson",
                style: StylesApp(context).textStyleTitleWithe,
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          Positioned(
              top: 30,
              bottom: 0,
              right: 15,
              child: Column(
                children: [
                  Image.asset(
                    "/kawaii_fire.png",
                    height: calculateHeight(score),
                    fit: BoxFit.contain,
                  ),
                  Text(
                    "${score}",
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
      return 112; // Alto fijo cuando el puntaje es mayor o igual a 1000
    } else {
      double width = ((maxPossibleHeight * 100)) / 112;

      return width > 30 ? ((maxPossibleHeight * 100)) / 112 : 40;
    }
  }
}