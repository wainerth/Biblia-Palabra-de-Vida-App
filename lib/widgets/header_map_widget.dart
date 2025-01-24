import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HeaderMapWidget extends StatelessWidget {
  final String title;
  final String subtitleStage;
  final int indexStage;
  final void Function()? onRouteBack;
  final void Function()? onShowInfoCourse;
  final void Function()? onShowInfoStage;
  final void Function()? onScroller;
  const HeaderMapWidget({
    super.key,
    this.onRouteBack,
    required this.title,
    this.onShowInfoCourse,
    required this.indexStage,
    required this.subtitleStage,
    this.onScroller,
    this.onShowInfoStage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Color(0XFF739EC7),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onRouteBack,
                icon: Icon(Icons.cancel_outlined),
                color: Colors.white,
              ),
              Center(
                child: Text(
                  textAlign: TextAlign.center,
                  title,
                  style: StylesApp(context).textStyleBody4.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
              IconButton(
                onPressed: onShowInfoCourse,
                color: Colors.white,
                icon: Icon(
                  Icons.info_outline,
                  size: 25.sp,
                ),
              ),
            ],
          ),
        ),
        Container(
          constraints: BoxConstraints(
            minHeight: 79,
          ),
          decoration: BoxDecoration(
            color: Color(0XFF7688C2),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          margin: EdgeInsets.only(left: 6.0, right: 6.0, top: 6.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 12.0, right: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 0.0,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      'Etapa $indexStage',
                      style: StylesApp(context).textStyleBody4.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(
                      height: 30.0,
                      child: IconButton(
                        padding: EdgeInsets.all(0.0),
                        // iconSize: 20.0,
                        onPressed: onShowInfoStage,
                        icon: Icon(Icons.chat_bubble),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      subtitleStage,
                      style: StylesApp(context).textStyleBody4.copyWith(
                            color: Colors.white,
                          ),
                    ),
                    SizedBox(
                      height: 30.0,
                      child: IconButton(
                        padding: EdgeInsets.all(0.0),
                        onPressed: onScroller,
                        icon: Icon(Icons.arrow_downward),
                        color: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}