import 'package:flutter/material.dart';

class StartStatusWidget extends StatelessWidget {
  final double unLockLevel;
  final double containerWidth;
  const StartStatusWidget({
    super.key,
    required this.unLockLevel,
    required this.containerWidth,
  });

  @override
  Widget build(BuildContext context) {
    final starSize = 30.0; // Adjust star size as needed
    final starSpacing = (containerWidth - (3 * starSize)) / 3;
    return Center(
      child: SizedBox(
        height: 50.0,
        child: Stack(
          children: [
            if (unLockLevel > 99) ...[
              Positioned(
                top: starSpacing,
                left: 0.0,
                child: Image.asset(
                  "/star_complete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
              Positioned(
                top: 0,
                left: starSpacing + starSize + starSpacing,
                child: Image.asset(
                  "/star_complete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
              Positioned(
                top: starSpacing,
                left: starSpacing + (2 * starSize) + (2 * starSpacing),
                child: Image.asset(
                  "/star_complete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
            ] else if (unLockLevel > 50) ...[
              Positioned(
                top: starSpacing,
                left: 0.0,
                child: Image.asset(
                  "/star_disabled.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
              Positioned(
                top: 0,
                left: starSpacing + starSize + starSpacing,
                child: Image.asset(
                  "/star_disabled.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
            ] else if (unLockLevel > 0) ...[
              Positioned(
                top: starSpacing,
                left: 0.0,
                child: Image.asset(
                  "/star_incomplete.png",
                  width: starSize,
                  height: starSize,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}