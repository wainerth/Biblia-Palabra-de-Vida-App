import 'package:biblia_palabra_de_vida_app/themes/text_styles.dart';
import 'package:flutter/material.dart';

class HeadScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final double heightContent;
  final bool showLeftStar;
  final bool showRightStar;

  const HeadScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.showLeftStar,
    required this.showRightStar, this.heightContent= 269,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            minHeight: this.heightContent,
            minWidth: double.infinity,
          ),
        
          width: double.infinity,
          child: Image.asset(
            '/elipsisTop.png',
            fit: BoxFit.fitHeight,
          ),
        ),
        if (showLeftStar)
          Positioned(
            child: Image.asset(
              '/start.png',
              height: 90,
              fit: BoxFit.fill,
            ),
            top: 107,
            left: -12,
          ),
        if (showRightStar)
          Positioned(
            child: Image.asset(
              '/start.png',
              height: 90,
              fit: BoxFit.fill,
            ),
            top: 20,
            right: -12,
          ),
        Column(
          children: [
            const SizedBox(height: 54),
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStylesApp(context).textStyleTitleBlue,
              ),
            ),
            const SizedBox(height: 41),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStylesApp(context).textStyleTitleOrange,
            ),
          ],
        ),
      ],
    );
  }
}