import 'package:flutter/material.dart';

class MedalModel {
  final String id;
  final String name;
  final String description;
  final String icon;
  final Color color;
  final bool isAchieved;
  final DateTime? achievedDate;
  final int requiredRacha; // 0 = no requiere racha

  MedalModel({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.isAchieved = false,
    this.achievedDate,
    this.requiredRacha = 0,
  });
}