import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

enum Region {
  central(Color(0xFF3F5164), LatLng(3.0147, 101.3747)),
  eastern(Color(0xFF867C4F), LatLng(4.3120, 102.4632)),
  northern(Color(0xFF644444), LatLng(5.1152, 100.4532)),
  sabah(Color(0xFF3E5858), LatLng(5.9804, 116.0735)),
  sarawak(Color(0xFFA36E5A), LatLng(1.5548, 110.3592)),
  southern(Color(0xFF52724C), LatLng(2.0953, 103.0404));

  final Color color;
  final LatLng latlng;

  const Region(this.color, this.latlng);

  @override
  String toString() => toBeginningOfSentenceCase(name);
}
