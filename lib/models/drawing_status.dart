import 'package:flutter/material.dart';

enum DrawingStatus {
  incomplete(Colors.red, 'Incomplete'),
  completed(Colors.amber, 'Completed'),
  submitted(Colors.green, 'Submitted');

  final Color color;
  final String text;

  const DrawingStatus(this.color, this.text);

  @override
  String toString() => text;
}
