import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

enum BibleThemeType { light, dark, sepia, nightBlue, greenPaper, highContrast }

class BibleTheme {
  final Color backgroundColor;
  final Color disabledColor;
  final Color textColor;
  final Color appBarColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color verseHighlightColor;
  final String name;

  BibleTheme({
    required this.backgroundColor,
    required this.disabledColor,
    required this.textColor,
    required this.appBarColor,
    required this.verseHighlightColor,
    required this.name,
    required this.buttonColor,
    required this.buttonTextColor,
  });

  static Map<BibleThemeType, BibleTheme> themes = {
    BibleThemeType.light: BibleTheme(
      name: "Claro",
      backgroundColor: StyleColor.white,
      disabledColor: StyleColor.grayMedium,
      textColor: StyleColor.black,
      appBarColor: StyleColor.turquoise,
      buttonColor: StyleColor.turquoise,
      buttonTextColor: StyleColor.white,
      verseHighlightColor: Colors.yellow[200]!,
    ),
    BibleThemeType.dark: BibleTheme(
      name: "Oscuro",
      backgroundColor: Colors.grey[850]!,
      disabledColor: StyleColor.grayMedium,
      textColor: StyleColor.white,
      appBarColor: Colors.grey[900]!,
      buttonColor: StyleColor.turquoise,
      buttonTextColor: StyleColor.white,
      verseHighlightColor: Colors.blueGrey[800]!,
    ),
    BibleThemeType.sepia: BibleTheme(
      name: "Sepia",
      backgroundColor: const Color(0xFFF4ECD8),
      disabledColor: StyleColor.grayMedium,
      textColor: const Color(0xFF5B4636),
      appBarColor: const Color(0xFFC4B393),
      buttonColor: StyleColor.turquoise,
      buttonTextColor: StyleColor.brownMedium,
      verseHighlightColor: const Color(0xFFE4D5B7),
    ),
    BibleThemeType.nightBlue: BibleTheme(
      name: "Azul Nocturno",
      backgroundColor: const Color(0xFF0F1B2D),
      disabledColor: StyleColor.grayMedium,
      textColor: const Color(0xFFE0E9FF),
      appBarColor: const Color(0xFF1A2D4D),
      buttonColor: StyleColor.turquoise,
      buttonTextColor: StyleColor.white,
      verseHighlightColor: const Color(0xFF2D4A7D),
    ),
    BibleThemeType.greenPaper: BibleTheme(
      name: "Papel Verde",
      backgroundColor: const Color(0xFFE8F5E9),
      disabledColor: StyleColor.grayMedium,
      textColor: const Color(0xFF1B5E20),
      appBarColor: const Color(0xFFA5D6A7),
      buttonColor: StyleColor.turquoise,
      buttonTextColor: StyleColor.greenMedium,
      verseHighlightColor: const Color(0xFFC8E6C9),
    ),
    BibleThemeType.highContrast: BibleTheme(
      name: "Alto Contraste",
      backgroundColor: StyleColor.black,
      disabledColor: StyleColor.grayMedium,
      textColor: StyleColor.white,
      appBarColor: StyleColor.black,
      buttonColor: StyleColor.turquoise,
      buttonTextColor: StyleColor.white,
      verseHighlightColor: Colors.yellow,
    ),
  };
}
