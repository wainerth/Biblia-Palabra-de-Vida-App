import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeadScreenNotAvatar extends StatelessWidget {
  final String title;
  final void Function()? onRoute;
  const HeadScreenNotAvatar({
    super.key,
    required this.title,
    required this.onRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/elipsisTop.png"),
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
                    onPressed: onRoute,
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35.0,
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 48.0,
              ),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  title,
                  style: StylesApp(context).textStyleTitleOrange,
                ),
              ),
              SizedBox(
                height: 35.sp,
              )
            ],
          ),
          Positioned(
              top: 0,
              bottom: 0,
              right: 15,
              child: Column(
                children: [
                  Image.asset(
                    "assets/kawaii_fire.png",
                    height: 52.0,
                    fit: BoxFit.contain,
                  )
                ],
              ))
        ],
      ),
    );
  }
}
