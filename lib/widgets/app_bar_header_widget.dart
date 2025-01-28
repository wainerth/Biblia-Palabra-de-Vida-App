import 'package:flutter/material.dart';


class AppBarHeaderWidget extends StatelessWidget {
  final String title;
  final Color backColor;
  final Color textButtonColor;
  final Color buttonColor;
  final TextStyle styleText;
  final Function()? onRoute;
  const AppBarHeaderWidget({
    super.key,
    required this.title,
    this.onRoute,
    this.backColor = Colors.white,
    this.buttonColor = Colors.white,
    this.textButtonColor = Colors.black,
    required this.styleText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(minHeight: 44.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      width: double.infinity,
      decoration: BoxDecoration(color: backColor),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 0,
            left: 10,
            child: Container(
              width: 32.0,
              height: 32.0,
              decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: BorderRadius.circular(32.0)),
              child: Center(
                child: IconButton(
                  padding: EdgeInsets.all(0),
                  iconSize: 30.0,
                  onPressed: onRoute,
                  icon: Icon(
                    Icons.arrow_back,
                    size: 30,
                    color: textButtonColor,
                  ),
                ),
              ),
            ),
          ),
          Center(
            child: Text(
              title,
              style: styleText,
            ),
          )
        ],
      ),
    );
  }
}