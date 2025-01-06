import 'package:flutter/material.dart';

enum SurveyStatus {
  unsurveyed(Colors.red),
  inprogress(Colors.amber),
  surveyed(Colors.green);

  final Color color;

  const SurveyStatus(this.color);

  @override
  String toString() => name.replaceAllMapped(RegExp('^([a-z])|[A-Z]'),
      (Match m) => m[1] == null ? " ${m[0]}" : m[1]!.toUpperCase());
}
