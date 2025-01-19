import 'package:flutter/material.dart';
import 'package:progrid/models/drawing_status.dart';
import 'package:progrid/models/region.dart';
import 'package:progrid/models/survey_status.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/services/firestore.dart';
import 'package:progrid/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

class SiteProgressPage extends StatefulWidget {
  const SiteProgressPage({super.key});

  @override
  State<SiteProgressPage> createState() => _SiteProgressPageState();
}

class _SiteProgressPageState extends State<SiteProgressPage>
    with AutomaticKeepAliveClientMixin {
  final searchController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final surveyStatusFilter = <SurveyStatus>[SurveyStatus.surveyed];
  final drawingStatusFilter = <DrawingStatus>[];
  final regionFilter = <Region>[];
  DateTime? fromDateTime;
  DateTime? toDateTime;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final towers = Provider.of<List<Tower>>(context)
        .where((tower) =>
            (tower.name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                tower.id
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase())) &&
            (surveyStatusFilter.isEmpty ||
                surveyStatusFilter.contains(tower.surveyStatus)) &&
            (drawingStatusFilter.isEmpty ||
                drawingStatusFilter.contains(tower.drawingStatus)) &&
            (regionFilter.isEmpty || regionFilter.contains(tower.region)))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(),
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
                    ...SurveyStatus.values.map((status) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(status.toString()),
                        value: surveyStatusFilter.contains(status),
                        onChanged: (value) => setState(() => value!
                            ? surveyStatusFilter.add(status)
                            : surveyStatusFilter.remove(status)))),
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
                            : drawingStatusFilter.remove(status)))),
                    SizedBox(height: 15),
                    Text('Region'),
                    ...Region.values.map((region) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(region.toString()),
                        value: regionFilter.contains(region),
                        onChanged: (value) => setState(() => value!
                            ? regionFilter.add(region)
                            : regionFilter.remove(region)))),
                    SizedBox(height: 15),
                    TextField(
                      controller: fromController,
                      decoration: InputDecoration(
                        labelText: 'From',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          size: 15,
                        ),
                      ),
                      readOnly: true,
                      onTap: () => showDatePicker(
                              context: context,
                              firstDate: DateTime(2025),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            fromDateTime = value;
                            if (fromDateTime!
                                .isAfter(toDateTime ?? DateTime.now())) {
                              toDateTime = null;
                              toController.clear();
                            }
                            fromController.text =
                                value.toString().split(' ').first;
                          });
                        }
                      }),
                    ),
                    SizedBox(height: 15),
                    TextField(
                      controller: toController,
                      decoration: InputDecoration(
                        labelText: 'To',
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          size: 15,
                        ),
                      ),
                      readOnly: true,
                      onTap: () => showDatePicker(
                              context: context,
                              firstDate: fromDateTime ?? DateTime(2025),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            toDateTime = value;
                            toController.text =
                                value.toString().split(' ').first;
                          });
                        }
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                              hintText: 'Search tower by name or id',
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              prefixIcon: Icon(Icons.search)),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    shape: RoundedRectangleBorder(),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text('Tower'),
                          Spacer(),
                          Text('On-Site Audit'),
                          SizedBox(width: 100),
                          Text('As-Built Drawing'),
                          SizedBox(width: 50),
                        ],
                      ),
                    )),
                Expanded(
                  child: ListView.builder(
                      itemCount: towers.length,
                      itemBuilder: (context, index) {
                        final tower = towers[index];

                        return Container(
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(color: Colors.black12))),
                          child: ListTile(
                              onTap: () => DialogUtils.showTowerDialog(
                                  context, tower.id),
                              title: Row(
                                children: [
                                  CircleAvatar(
                                      radius: 5,
                                      backgroundColor:
                                          tower.surveyStatus.color),
                                  SizedBox(width: 10),
                                  Text(tower.name),
                                ],
                              ),
                              subtitle: Text(tower.id),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownMenu<SurveyStatus>(
                                      requestFocusOnTap: false,
                                      textAlign: TextAlign.center,
                                      initialSelection: tower.surveyStatus,
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        filled: true,
                                        fillColor: tower.surveyStatus.color
                                            .withValues(alpha: 0.1),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: tower.surveyStatus.color
                                                    .withValues(alpha: 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      ),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      onSelected: (value) {
                                        if (value != null) {
                                          FirestoreService.updateTower(tower.id,
                                              data: {
                                                'surveyStatus': value.name
                                              });
                                        }
                                      },
                                      dropdownMenuEntries: [
                                        ...SurveyStatus.values.map((status) =>
                                            DropdownMenuEntry(
                                                value: status,
                                                label: status.toString()))
                                      ]),
                                  SizedBox(width: 20),
                                  DropdownMenu<DrawingStatus>(
                                      requestFocusOnTap: false,
                                      textAlign: TextAlign.center,
                                      initialSelection: tower.drawingStatus,
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        filled: true,
                                        fillColor: tower.drawingStatus?.color
                                            .withValues(alpha: 0.1),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: tower
                                                        .drawingStatus?.color
                                                        .withValues(
                                                            alpha: 0.5) ??
                                                    Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      ),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      onSelected: (value) {
                                        if (value != null) {
                                          FirestoreService.updateTower(tower.id,
                                              data: {
                                                'drawingStatus': value.name
                                              });
                                        }
                                      },
                                      dropdownMenuEntries: [
                                        ...DrawingStatus.values.map((status) =>
                                            DropdownMenuEntry(
                                                value: status,
                                                label: status.toString()))
                                      ]),
                                ],
                              )),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
