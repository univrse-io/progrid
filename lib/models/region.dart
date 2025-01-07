import 'package:flutter/material.dart';

enum Region {
  // central(Colors.purple),
  // northern(Colors.blue),
  // southern(Colors.amber),
  // eastern(Colors.pink),
  // sabah(Colors.red),
  // sarawak(Colors.orange);

  central(Color.fromARGB(255, 63, 81, 100)),
  northern(Color.fromARGB(255, 100, 68, 68)),
  southern(Color.fromARGB(255, 82, 114, 76)),
  eastern(Color.fromARGB(255, 134, 124, 79)),
  sabah(Color.fromARGB(255, 62, 88, 88)),
  sarawak(Color.fromARGB(255, 163, 110, 90));

  final Color color;

  const Region(this.color);

  @override
  String toString() => name.replaceAllMapped(RegExp('^([a-z])|[A-Z]'),
      (Match m) => m[1] == null ? " ${m[0]}" : m[1]!.toUpperCase());
}
