import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progrid/pages/dashboard/dashboard_page.dart';

final _drawingStatus = ['completed', 'submitted'];

class DrawingScreen extends StatefulWidget {
  const DrawingScreen({super.key});

  @override
  State<DrawingScreen> createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  @override
  Widget build(BuildContext context) {
    print('build');
    return SingleChildScrollView(
      child: Column(
        children: [
          ...towers.map((tower) => Visibility(
                visible: tower.status == 'surveyed',
                child: Card(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ListTile(
                    trailing: ToggleButtons(
                        borderRadius: BorderRadius.circular(20),
                        onPressed: (index) {
                          tower.drawingStatus = _drawingStatus[index];
                          towers[towers.indexWhere((x) => x.id == tower.id)] =
                              tower;

                          setState(() {});
                        },
                        fillColor: Colors.green.shade100,
                        selectedBorderColor: Colors.green.shade700,
                        children: [
                          ..._drawingStatus.map((status) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(toBeginningOfSentenceCase(status)),
                              )),
                        ],
                        isSelected: [
                          ..._drawingStatus
                              .map((status) => tower.drawingStatus == status)
                        ]),
                    title: Text(tower.name),
                    subtitle: Text(tower.id),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
