import 'package:flutter/material.dart';
import 'package:progrid/models/drawing_status.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/services/firestore.dart';
import 'package:provider/provider.dart';

class AsBuiltDrawingPage extends StatefulWidget {
  const AsBuiltDrawingPage({super.key});

  @override
  State<AsBuiltDrawingPage> createState() => _AsBuiltDrawingPageState();
}

class _AsBuiltDrawingPageState extends State<AsBuiltDrawingPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final towers = Provider.of<List<Tower>>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          ...towers.map((tower) => Visibility(
                visible: tower.surveyStatus == 'surveyed',
                child: Card(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: ListTile(
                    trailing: ToggleButtons(
                        borderRadius: BorderRadius.circular(20),
                        onPressed: (index) =>
                            FirestoreService.updateTower(tower.id, data: {
                              'drawingStatus': DrawingStatus.values
                                  .where((status) =>
                                      status != DrawingStatus.incomplete)
                                  .toList()[index]
                                  .name
                            }),
                        fillColor: Colors.green.shade100,
                        selectedBorderColor: Colors.green.shade700,
                        children: [
                          ...DrawingStatus.values
                              .where((status) =>
                                  status != DrawingStatus.incomplete)
                              .map((status) => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Text(status.toString()),
                                  )),
                        ],
                        isSelected: [
                          ...DrawingStatus.values
                              .where((status) =>
                                  status != DrawingStatus.incomplete)
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
