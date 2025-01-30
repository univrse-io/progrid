import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Region {
  central(Color(0xFF3F5164)),
  northern(Color(0xFF644444)),
  southern(Color(0xFF52724C)),
  eastern(Color(0xFF867C4F)),
  sabah(Color(0xFF3E5858)),
  sarawak(Color(0xFFA36E5A));

  final Color color;

  const Region(this.color);

  @override
  String toString() => toBeginningOfSentenceCase(name);
}
