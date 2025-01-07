import 'package:flutter/material.dart';
import 'package:progrid/utils/themes.dart';

enum SurveyStatus {
  unsurveyed(AppColors.red, 'Unsurveyed'),
  inprogress(AppColors.yellow, 'In Progress'),
  surveyed(AppColors.green, 'Surveyed');

  final Color color;
  final String text;

  const SurveyStatus(this.color, this.text);

  @override
  String toString() => text;
}
