import 'package:flutter/material.dart';
import 'package:progrid/utils/themes.dart';

enum SurveyStatus {
  unsurveyed(AppColors.red),
  inprogress(AppColors.yellow),
  surveyed(AppColors.green);

  final Color color;

  const SurveyStatus(this.color);

  @override
  String toString() => name.replaceAllMapped(RegExp('^([a-z])|[A-Z]'),
      (Match m) => m[1] == null ? " ${m[0]}" : m[1]!.toUpperCase());
}
