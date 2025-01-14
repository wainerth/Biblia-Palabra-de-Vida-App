import 'package:flutter/material.dart';

class AppTheme {
  final String name;
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final Color alternateColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;
  final Color primaryBackgroundColor;
  final Color secondaryBackgroundColor;
  final Color accent1;
  final Color accent2;
  final Color accent3;
  final Color accent4;
  final Color successColor;
  final Color errorColor;
  final Color warningColor;
  final Color infoColor;

  const AppTheme({
    required this.name,
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.alternateColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.primaryBackgroundColor,
    required this.secondaryBackgroundColor,
    required this.accent1,
    required this.accent2,
    required this.accent3,
    required this.accent4,
    required this.successColor,
    required this.errorColor,
    required this.warningColor,
    required this.infoColor,
  });

  ThemeData toThemeData() {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: primaryBackgroundColor,
      textTheme: TextTheme(
          bodyLarge: TextStyle(color: primaryTextColor),
          bodyMedium: TextStyle(color: secondaryTextColor)),
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: secondaryBackgroundColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: primaryTextColor,
        ),
      ),
    );
  }
}

const List<AppTheme> themes = [
  AppTheme(
    name: 'Deep Purple',
    primaryColor: Color(0xFF673AB7),
    secondaryColor: Color(0xFF512DA8),
    tertiaryColor: Color(0xFF9575CD),
    alternateColor: Color(0xFFD1C4E9),
    primaryTextColor: Color(0xFF212121),
    secondaryTextColor: Color(0xFF757575),
    primaryBackgroundColor: Color(0xFFFFFFFF),
    secondaryBackgroundColor: Color(0xFFF3E5F5),
    accent1: Color(0xFFB388FF),
    accent2: Color(0xFF7C4DFF),
    accent3: Color(0xFF651FFF),
    accent4: Color(0xFF6200EA),
    successColor: Color(0xFF4CAF50),
    errorColor: Color(0xFFF44336),
    warningColor: Color(0xFFFF9800),
    infoColor: Color(0xFF2196F3),
  ),
  // Otros temas...
];

