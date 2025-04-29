import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

enum Region {
  central(CarbonColor.purple70, LatLng(3.0147, 101.3747)),
  eastern(CarbonColor.cyan50, LatLng(4.3120, 102.4632)),
  northern(CarbonColor.teal70, LatLng(5.1152, 100.4532)),
  sabah(CarbonColor.magenta70, LatLng(5.9804, 116.0735)),
  sarawak(CarbonColor.red50, LatLng(1.5548, 110.3592)),
  southern(CarbonColor.red90, LatLng(2.0953, 103.0404));

  final Color color;
  final LatLng latlng;

  const Region(this.color, this.latlng);

  @override
  String toString() => toBeginningOfSentenceCase(name);
}
