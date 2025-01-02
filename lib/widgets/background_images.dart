import 'package:flutter/material.dart';

class BackgroundImages extends StatelessWidget {
  final List<String> backImages;
  const BackgroundImages({super.key, required this.backImages});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          if (backImages.length > 1)
            Positioned(
              left: 0.0,
              top: 44.0,
              child: Image.asset(backImages[1], height: 70 , fit: BoxFit.contain),
            ),
          Positioned(
            right: 0.0,
            top: 27.0,
            child: Image.asset(backImages[0], height: 70 , fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}