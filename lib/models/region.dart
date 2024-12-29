import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Region {
  central(Colors.purple),
  northern(Colors.blue),
  southern(Colors.amber),
  eastern(Colors.pink),
  sabah(Colors.red),
  sarawak(Colors.orange);

  final Color color;

  const Region(this.color);

  @override
  String toString() => toBeginningOfSentenceCase(name);
}
