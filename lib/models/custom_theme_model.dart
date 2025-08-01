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
      'backgroundColor': backgroundColor,
      'textColor': textColor,
      'appBarColor': appBarColor,
      'buttonColor': buttonColor,
      'buttonTextColor': buttonTextColor,
      'verseHighlightColor': verseHighlightColor,
    };
  }

  factory CustomTheme.fromJson(Map<String, dynamic> json) {
    return CustomTheme(
      id: json['id'],
      name: json['name'],
      backgroundColor: Color(json['backgroundColor']),
      textColor: Color(json['textColor']),
      appBarColor: Color(json['appBarColor']),
      buttonColor: Color(json['buttonColor']),
      buttonTextColor: Color(json['buttonTextColor']),
      verseHighlightColor: Color(json['verseHighlightColor']),
    );
  }
}
