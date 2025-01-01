import 'package:flutter/material.dart';

enum DrawingStatus {
  incomplete(Colors.red),
  completed(Colors.amber),
  submitted(Colors.green);

  final Color color;

  const DrawingStatus(this.color);

  @override
  String toString() => name.replaceAllMapped(RegExp('^([a-z])|[A-Z]'),
      (Match m) => m[1] == null ? " ${m[0]}" : m[1]!.toUpperCase());
}
