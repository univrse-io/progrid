import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum IssueStatus {
  unresolved(CarbonColor.red60),
  resolved(CarbonColor.green60);

  final Color color;

  const IssueStatus(this.color);

  @override
  String toString() => toBeginningOfSentenceCase(name);
}
