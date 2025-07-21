import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/material.dart';

enum BibleThemeType { light, dark, sepia, nightBlue, greenPaper, highContrast, pink,elegantBrown }

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
      verseHighlightColor: StyleColor.turquoise,
    ),
    BibleThemeType.dark: BibleTheme(
      name: "Oscuro",
      backgroundColor: Colors.grey[850]!,
      disabledColor: StyleColor.grayMedium,
      textColor: StyleColor.white,
      appBarColor: Colors.grey[900]!,
      buttonColor: StyleColor.turquoise,
      buttonTextColor: StyleColor.white,
      verseHighlightColor: const Color.fromARGB(255, 104, 191, 235),
    ),
    BibleThemeType.sepia: BibleTheme(
      name: "Café Elegante",
      backgroundColor: const Color(0xFFF4ECD8),
      disabledColor: StyleColor.grayMedium,
      textColor: const Color(0xFF5B4636),
      appBarColor: const Color(0xFFC4B393),
      buttonColor: const Color(0xFF5B4636),// StyleColor.turquoise,
      buttonTextColor: StyleColor.white,
      verseHighlightColor: const Color.fromARGB(255, 56, 44, 19),
    ),
    BibleThemeType.nightBlue: BibleTheme(
      name: "Azul Nocturno",
      backgroundColor: const Color(0xFF0F1B2D),
      disabledColor: StyleColor.grayMedium,
      textColor: const Color(0xFFE0E9FF),
      appBarColor: const Color(0xFF1A2D4D),
      buttonColor: const Color.fromARGB(255, 57, 90, 147),
      buttonTextColor: StyleColor.white,
      verseHighlightColor: const Color.fromARGB(255, 125, 169, 244),
    ),
    BibleThemeType.greenPaper: BibleTheme(
      name: "Papel Grey",
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      disabledColor: StyleColor.grayMedium,
      textColor: const Color.fromARGB(255, 80, 81, 80),
      appBarColor: const Color.fromARGB(255, 209, 211, 209),
      buttonColor: const Color.fromARGB(255, 47, 50, 50),
      buttonTextColor: const Color.fromARGB(255, 255, 255, 255),
      verseHighlightColor: const Color.fromARGB(255, 34, 39, 34),
    ),
    BibleThemeType.pink: BibleTheme(
      name: "Pink Tema",
      backgroundColor: const Color.fromARGB(255, 247, 174, 214),
      disabledColor: StyleColor.grayMedium,
      textColor: const Color.fromARGB(255, 237, 239, 237),
      appBarColor: const Color.fromARGB(255, 182, 97, 200),
      buttonColor: const Color.fromARGB(255, 182, 97, 200),
      buttonTextColor: const Color.fromARGB(255, 255, 255, 255),
      verseHighlightColor: const Color.fromARGB(255, 238, 54, 210),
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
     BibleThemeType.elegantBrown: BibleTheme(
      name: "Café Elegante",
      backgroundColor: const Color(0xFFF8F4E8),
      disabledColor: const Color(0xFFA89F94),
      textColor: const Color(0xFF4A3A2A),
      appBarColor: const Color(0xFF6B4F3A),
      buttonColor: const Color(0xFF8C6A4F),
      buttonTextColor: const Color(0xFFF8F4E8),
      verseHighlightColor: const Color(0xFFD9C7B8),
    ),
  };
}
