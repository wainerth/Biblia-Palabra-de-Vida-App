// models/custom_theme_model.dart
import 'dart:ui';

class CustomTheme {
  final String id;
  final String name;
  final Color backgroundColor;
  final Color textColor;
  final Color appBarColor;
  final Color buttonColor;
  final Color buttonTextColor;
  final Color verseHighlightColor;

  CustomTheme({
    required this.id,
    required this.name,
    required this.backgroundColor,
    required this.textColor,
    required this.appBarColor,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.verseHighlightColor,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'backgroundColor':
          '#${backgroundColor.toARGB32().toRadixString(16)}', // backgroundColor.toARGB32(),
      'textColor': '#${textColor.toARGB32().toRadixString(16)}', // textColor.toARGB32(),
      'appBarColor':
          '#${appBarColor.toARGB32().toRadixString(16)}', //appBarColor.toARGB32(),
      'buttonColor':
          '#${buttonColor.toARGB32().toRadixString(16)}', //buttonColor.toARGB32(),
      'buttonTextColor':
          '#${buttonTextColor.toARGB32().toRadixString(16)}', //buttonTextColor.toARGB32(),
      'verseHighlightColor':
          '#${verseHighlightColor.toARGB32().toRadixString(16)}', // verseHighlightColor,
    };
  }

  factory CustomTheme.fromJson(Map<String, dynamic> json) {
    return CustomTheme(
      id: json['id'],
      name: json['name'],
      backgroundColor:
          Color(int.parse(json['backgroundColor'].substring(1), radix: 16)),
      textColor: Color(int.parse(json['textColor'].substring(1), radix: 16)),
      appBarColor:
          Color(int.parse(json['appBarColor'].substring(1), radix: 16)),
      buttonColor:
          Color(int.parse(json['buttonColor'].substring(1), radix: 16)),
      buttonTextColor:
          Color(int.parse(json['buttonTextColor'].substring(1), radix: 16)),
      verseHighlightColor:
          Color(int.parse(json['verseHighlightColor'].substring(1), radix: 16)),
    );
  }
}
