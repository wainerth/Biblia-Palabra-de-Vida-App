import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      padding: EdgeInsets.symmetric(horizontal:  0.0, vertical: 5.0),
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
                    height: 50.0,
                    width: 50.0,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: AssetImage(
                        "assets/avatar.png",
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Robinson",
                    style: StylesApp(context).textStyleBody14,
                  ),
                )
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
                  style: StylesApp(context).textStyleBody17,
                  TextSpan(
                    children: [TextSpan(text: "Exp:"), TextSpan(text: "571")],
                  ),
                ),
                Text.rich(
                  style: StylesApp(context).textStyleBody17,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Text(
                      "3",
                      style: StylesApp(context).textStyleBody18,
                    ),
                    Icon(
                      size: 21.sp,
                      Icons.star,
                      color: Colors.white,
                    )
                  ],
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/profilePage');
                  },
                  padding: EdgeInsets.all(0),
                  iconSize: 20.sp,
                  icon: Icon(
                    size: 30.sp,
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
