import 'package:flutter/material.dart';
import 'package:progrid/utils/themes.dart';

enum SurveyStatus {
  unsurveyed(AppColors.red, 'Unsurveyed'),
  inprogress(AppColors.yellow, 'In Progress'),
  surveyed(AppColors.green, 'Surveyed');

  final Color color;
  final String _text;

  const SurveyStatus(this.color, this._text);

  @override
  String toString() => _text;

  String toEnumString() {
    return name;
  }
}
