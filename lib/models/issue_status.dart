import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../utils/themes.dart';

enum IssueStatus {
  unresolved(AppColors.red),
  resolved(AppColors.green);

  final Color color;

  const IssueStatus(this.color);

  @override
  String toString() => toBeginningOfSentenceCase(name);
}
