import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/app_providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HeadScoreWidget extends StatefulWidget {
  final Function() onRoute;
  const HeadScoreWidget({
    super.key,
    required this.onRoute,
  });

  @override
  State<HeadScoreWidget> createState() => _HeadScoreWidgetState();
}

class _HeadScoreWidgetState extends State<HeadScoreWidget> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final LoginUser? userData = userProvider.currentUser;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.0),
      decoration: BoxDecoration(
        color: StyleColor.orange,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text.rich(
            TextSpan(
              style: StylesApp(context).textStyleBody12,
              children: [
                TextSpan(text: "Exp: "),
                TextSpan(text: "${userData!.expTotalUser}"),
              ],
            ),
          ),
          Text.rich(
            TextSpan(
              style: StylesApp(context).textStyleBody12,
              children: [
                TextSpan(text: "Racha: "),
                TextSpan(text: "${userData.streakDaysCount} días"),
              ],
            ),
          ),
          SizedBox(
            width: 40.0,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    "1",
                    style: StylesApp(context).textStyleBody12,
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Icon(
                    Icons.star,
                    color: Colors.white,
                    size: 12.0,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            iconSize: 31.0,
            icon: Icon(
              Icons.fast_forward_rounded,
              color: Colors.white,
            ),
            onPressed: widget.onRoute,
          ),
        ],
      ),
    );
  }
}
