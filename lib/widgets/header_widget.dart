import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';

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
    return Container(
      constraints: BoxConstraints(minHeight: 90.0),
      decoration: BoxDecoration(
        color: Color(0XFFFD8C43),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(0.0),
      child: Row(
        spacing: 0,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 61.0,
                    width: 61.0,
                    child: CircleAvatar(
                      radius: 61,
                      backgroundImage: AssetImage(
                        "/avatar.png",
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Robinson",
                    style: StylesApp(context).textStyleBody5,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  textAlign: TextAlign.left,
                  style: StylesApp(context).textStyleBody8,
                  TextSpan(
                    children: [TextSpan(text: "Exp:"), TextSpan(text: "571")],
                  ),
                ),
                Text.rich(
                  style: StylesApp(context).textStyleBody8,
                  TextSpan(
                    children: [
                      TextSpan(text: "Racha:"),
                      TextSpan(text: "0 días")
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  children: [
                    Text(
                      "3",
                      style: StylesApp(context).textStyleBody8,
                    ),
                    Icon(
                      size: 21.0,
                      Icons.star,
                      color: Colors.white,
                    )
                  ],
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/detailProfilePage');
                    },
                    padding: EdgeInsets.all(0),
                    iconSize: 20.0,
                    icon: Icon(
                      size: 30.0,
                      Icons.fast_forward_sharp,
                      color: Colors.white,
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
