import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Region {
  central(Color.fromARGB(255, 63, 81, 100)),
  northern(Color.fromARGB(255, 100, 68, 68)),
  southern(Color.fromARGB(255, 82, 114, 76)),
  eastern(Color.fromARGB(255, 134, 124, 79)),
  sabah(Color.fromARGB(255, 62, 88, 88)),
  sarawak(Color.fromARGB(255, 163, 110, 90));

  final Color color;

  const Region(this.color);

  @override
  String toString() => toBeginningOfSentenceCase(name);
}
