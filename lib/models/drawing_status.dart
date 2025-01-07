import 'package:flutter/material.dart';

enum DrawingStatus {
  incomplete(Colors.red, 'Incomplete'),
  inprogress(Colors.amber, 'In Progress'),
  submitted(Colors.green, 'Submitted');

  final Color color;
  final String _text;

  const DrawingStatus(this.color, this._text);

  @override
  String toString() => _text;
}
