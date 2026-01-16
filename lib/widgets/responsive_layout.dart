import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/material.dart';

// bool isTablet(BuildContext context) {
//   final data = MediaQueryData.fromView(View.of(context));
//   final shortestSide = data.size.shortestSide;
//   return shortestSide >= 600;
// }

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  
  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
  });
  
  @override
  Widget build(BuildContext context) {
    return isTablet(context) ? tablet : mobile;
  }
}