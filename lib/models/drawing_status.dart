import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';

enum DrawingStatus {
  inprogress(CarbonColor.yellow, 'In Progress'),
  submitted(CarbonColor.green60, 'Submitted');

  final Color color;
  final String _text;

  const DrawingStatus(this.color, this._text);

  @override
  String toString() => _text;
}
