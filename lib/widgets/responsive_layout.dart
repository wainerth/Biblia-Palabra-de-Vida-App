import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:flutter/material.dart';

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