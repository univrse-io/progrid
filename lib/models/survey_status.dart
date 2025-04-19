import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';

enum SurveyStatus {
  surveyed(CarbonColor.green60, 'Surveyed'),
  inprogress(CarbonColor.yellow, 'In Progress'),
  unsurveyed(CarbonColor.red60, 'Unsurveyed');

  final Color color;
  final String _text;

  const SurveyStatus(this.color, this._text);

  @override
  String toString() => _text;
}
