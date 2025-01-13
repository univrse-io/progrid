import 'package:flutter/material.dart';
import 'package:progrid/utils/themes.dart';

enum DrawingStatus {
  inprogress(AppColors.yellow, 'In Progress'),
  submitted(AppColors.green, 'Submitted');

  final Color color;
  final String _text;

  const DrawingStatus(this.color, this._text);

  @override
  String toString() => _text;
}
