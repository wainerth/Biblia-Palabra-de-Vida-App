import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:flutter/material.dart';

class HeadWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final double heightContent;
  final bool showLeftStar;
  final bool showRightStar;

  const HeadWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.showLeftStar,
    required this.showRightStar,
    this.heightContent = 269,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage("assets/elipsisTop.png"),
              fit: StylesApp(context).fitImage,
            ),
          ),
          width: double.infinity,
          child: Column(
            children: [
              const SizedBox(height: 28),
              Center(
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: StylesApp(context).textStyleTitleBlue,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: StylesApp(context).textStyleTitleOrange,
              ),
              const SizedBox(
                height: 41,
              )
            ],
          ),
        ),
        if (showLeftStar)
          Positioned(
            top: 107,
            left: -12,
            child: Image.asset(
              'assets/start.png',
              height: 90,
              fit: BoxFit.fill,
            ),
          ),
        if (showRightStar)
          Positioned(
            top: 20,
            right: -12,
            child: Image.asset(
              'assets/start.png',
              height: 90,
              fit: BoxFit.fill,
            ),
          ),
      ],
    );
  }
}
