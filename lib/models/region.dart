import 'package:flutter/material.dart';

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
  String toString() => name.replaceAllMapped(RegExp('^([a-z])|[A-Z]'),
      (Match m) => m[1] == null ? " ${m[0]}" : m[1]!.toUpperCase());
}
