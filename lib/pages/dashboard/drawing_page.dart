import 'package:flutter/material.dart';
import 'package:progrid/models/tower.dart';

class DrawingScreen extends StatelessWidget {
  final List<Tower> towers;
  const DrawingScreen({super.key, required this.towers});

  @override
  Widget build(BuildContext context) {
    return Text(towers.toString());
  }
}
