import 'package:flutter/material.dart';
import 'package:progrid/models/drawing_status.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/services/firestore.dart';
import 'package:provider/provider.dart';

class SiteProgressPage extends StatefulWidget {
  const SiteProgressPage({super.key});

  @override
  State<SiteProgressPage> createState() => _SiteProgressPageState();
}

class _SiteProgressPageState extends State<SiteProgressPage>
    with AutomaticKeepAliveClientMixin {
  final surveyStatusFilter = <String>[];
  final drawingStatusFilter = <DrawingStatus>[];

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final towers = Provider.of<List<Tower>>(context)
        .where((tower) =>
            (surveyStatusFilter.isEmpty ||
                surveyStatusFilter.contains(tower.surveyStatus.toString())) &&
            (drawingStatusFilter.isEmpty ||
                drawingStatusFilter.contains(tower.drawingStatus)))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Text('On-Site Audit'),
                    CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text('In Progress'),
                        value: surveyStatusFilter.contains('in-progress'),
                        onChanged: (value) => setState(() => value!
                            ? surveyStatusFilter.add('in-progress')
                            : surveyStatusFilter.remove('in-progress'))),
                    CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text('Surveyed'),
                        value: surveyStatusFilter.contains('surveyed'),
                        onChanged: (value) => setState(() => value!
                            ? surveyStatusFilter.add('surveyed')
                            : surveyStatusFilter.remove('surveyed'))),
                    CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text('Unsurveyed'),
                        value: surveyStatusFilter.contains('unsurveyed'),
                        onChanged: (value) => setState(() => value!
                            ? surveyStatusFilter.add('unsurveyed')
                            : surveyStatusFilter.remove('unsurveyed'))),
                    SizedBox(height: 15),
                    Text('As-Built Drawing'),
                    ...DrawingStatus.values.map((status) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(status.toString()),
                        value: drawingStatusFilter.contains(status),
                        onChanged: (value) => setState(() => value!
                            ? drawingStatusFilter.add(status)
                            : drawingStatusFilter.remove(status))))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: ListView.builder(
                itemCount: towers.length,
                itemBuilder: (context, index) {
                  final tower = towers[index];

                  return Card(
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                    child: ListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                              radius: 5,
                              backgroundColor: tower.surveyStatus.color),
                          SizedBox(width: 10),
                          Text(tower.name),
                        ],
                      ),
                      subtitle: Text(tower.id),
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
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
