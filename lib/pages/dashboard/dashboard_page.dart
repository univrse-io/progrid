import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/pages/dashboard/drawing_page.dart';
import 'package:progrid/pages/profile_page.dart';

List<Tower> towers = []; // TODO: Change to provider later on.

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// TOOD: convert to use wrapper provider
class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;
  late final List<Widget> _widgetOptions = <Widget>[
    Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('On-Site Audit',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 10),
                          Expanded(
                            child: PieChart(PieChartData(
                                startDegreeOffset: 20,
                                sectionsSpace: 0,
                                centerSpaceRadius: 50,
                                sections: [
                                  PieChartSectionData(
                                    title: 'Completed',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.surveyStatus == 'surveyed')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.green,
                                  ),
                                  PieChartSectionData(
                                    title: 'In Progress',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.surveyStatus == 'in-progress')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.amber,
                                  ),
                                  PieChartSectionData(
                                    title: 'Balance',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.surveyStatus == 'unsurveyed')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.red,
                                  ),
                                ])),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Regional Breakdown (Survey)',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 10),
                          Expanded(
                            child: PieChart(PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 50,
                                sections: [
                                  PieChartSectionData(
                                    title: 'Southern',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Southern' &&
                                            tower.surveyStatus == 'surveyed')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.amber,
                                  ),
                                  PieChartSectionData(
                                    title: 'Northern',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Northern' &&
                                            tower.surveyStatus == 'surveyed')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.blue,
                                  ),
                                  PieChartSectionData(
                                    title: 'Eastern',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Eastern' &&
                                            tower.surveyStatus == 'surveyed')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.pink,
                                  ),
                                  PieChartSectionData(
                                    title: 'Sarawak',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Sarawak' &&
                                            tower.surveyStatus == 'surveyed')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.red,
                                  ),
                                  PieChartSectionData(
                                    title: 'Sabah',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Sabah' &&
                                            tower.surveyStatus == 'surveyed')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.orange,
                                  ),
                                  PieChartSectionData(
                                    title: 'Central',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Central' &&
                                            tower.surveyStatus == 'surveyed')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.purple,
                                  ),
                                ])),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 10),
          Expanded(
              flex: 5,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                              SizedBox(height: 10),
                              Text('${towers.length}',
                                  style:
                                      Theme.of(context).textTheme.displayLarge)
                            ],
                          ),
                        )),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('In Progress',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                      backgroundColor: Colors.amber, radius: 5)
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                  '${towers.where((tower) => tower.surveyStatus == 'in-progress').length}',
                                  style:
                                      Theme.of(context).textTheme.displayLarge)
                            ],
                          ),
                        )),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Completed',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                      backgroundColor: Colors.green, radius: 5)
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                  '${towers.where((tower) => tower.surveyStatus == 'surveyed').length}',
                                  style:
                                      Theme.of(context).textTheme.displayLarge)
                            ],
                          ),
                        )),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Card(
                            child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text('Balance',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600)),
                                  SizedBox(width: 10),
                                  CircleAvatar(
                                      backgroundColor: Colors.red, radius: 5)
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(
                                  '${towers.where((tower) => tower.surveyStatus == 'unsurveyed').length}',
                                  style:
                                      Theme.of(context).textTheme.displayLarge)
                            ],
                          ),
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: FlutterMap(
                        options: MapOptions(
                            initialCenter: LatLng(3.1408, 101.6932),
                            initialZoom: 11,
                            interactionOptions: InteractionOptions(
                                flags: ~InteractiveFlag.doubleTapZoom)),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                          ),
                          MarkerLayer(markers: [
                            ...towers.map((tower) => Marker(
                                  point: LatLng(tower.position.latitude,
                                      tower.position.longitude),
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // marker icon
                                        Icon(
                                          Icons.cell_tower,
                                          color: switch (
                                              tower.region.toLowerCase()) {
                                            'southern' =>
                                              Color.fromARGB(255, 82, 114, 76),
                                            'northern' =>
                                              Color.fromARGB(255, 100, 68, 68),
                                            'eastern' =>
                                              Color.fromARGB(255, 134, 124, 79),
                                            'central' =>
                                              Color.fromARGB(255, 63, 81, 100),
                                            'western' =>
                                              Color.fromARGB(255, 104, 71, 104),
                                            'sabah' =>
                                              Color.fromARGB(255, 62, 88, 88),
                                            'sarawak' =>
                                              Color.fromARGB(255, 163, 110, 90),
                                            _ => Colors.grey
                                          },
                                          size: 36,
                                        ),

                                        // information box
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.black.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // status indicator
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: switch (
                                                        tower.surveyStatus) {
                                                      'surveyed' =>
                                                        Colors.green,
                                                      'in-progress' =>
                                                        Colors.amber,
                                                      _ => Colors.red
                                                    }),
                                              ),
                                              const SizedBox(width: 4),

                                              // tower id
                                              Text(
                                                tower.id,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                ),
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ])
                        ]),
                  ),
                ],
              )),
          SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('As-Built Drawing',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 10),
                          Expanded(
                            child: PieChart(PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 50,
                                startDegreeOffset: 40,
                                sections: [
                                  PieChartSectionData(
                                    title: 'Incomplete',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.drawingStatus == 'incomplete')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.red,
                                  ),
                                  PieChartSectionData(
                                    title: 'Completed',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.drawingStatus == 'completed')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.amber,
                                  ),
                                  PieChartSectionData(
                                    title: 'Submitted',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.drawingStatus == 'submitted')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.green,
                                  ),
                                ])),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Regional Breakdown (Drawing)',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 10),
                          Expanded(
                            child: PieChart(PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 50,
                                sections: [
                                  PieChartSectionData(
                                    title: 'Southern',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Southern' &&
                                            tower.drawingStatus == 'submitted')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.amber,
                                  ),
                                  PieChartSectionData(
                                    title: 'Northern',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Northern' &&
                                            tower.drawingStatus == 'submitted')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.blue,
                                  ),
                                  PieChartSectionData(
                                    title: 'Eastern',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Eastern' &&
                                            tower.drawingStatus == 'submitted')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.pink,
                                  ),
                                  PieChartSectionData(
                                    title: 'Sarawak',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Sarawak' &&
                                            tower.drawingStatus == 'submitted')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.red,
                                  ),
                                  PieChartSectionData(
                                    title: 'Sabah',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Sabah' &&
                                            tower.drawingStatus == 'submitted')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.orange,
                                  ),
                                  PieChartSectionData(
                                    title: 'Central',
                                    titlePositionPercentageOffset: 1.8,
                                    value: towers
                                        .where((tower) =>
                                            tower.region == 'Central' &&
                                            tower.drawingStatus == 'submitted')
                                        .length
                                        .toDouble(),
                                    radius: 50,
                                    color: Colors.purple,
                                  ),
                                ])),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    ),
    DrawingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    Navigator.pop(context);
  }

  late final Future<QuerySnapshot<Map<String, dynamic>>> _future =
      FirebaseFirestore.instance.collection('towers').get();

  @override
  Widget build(BuildContext context) => FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          towers = snapshot.data!.docs
              .map((doc) => Tower(
                    id: doc.id,
                    name: doc['name'] as String? ?? 'undefined',
                    region: doc['region'] as String? ?? 'undefined',
                    type: doc['type'] as String? ?? 'undefined',
                    owner: doc['owner'] as String? ?? 'undefined',
                    address: doc['address'] as String? ?? 'undefined',
                    position: doc['position'] is GeoPoint ? doc['position'] as GeoPoint : GeoPoint(0, 0),
                    surveyStatus: doc['surveyStatus'] as String? ?? 'undefined',
                    drawingStatus: doc['drawingStatus'] as String? ?? 'undefined',

                    signIn: doc.data().containsKey('signIn') ? doc['signIn'] as Timestamp : null,
                    signOut: doc.data().containsKey('signOut') ? doc['signOut'] as Timestamp : null,
                    authorId: doc.data().containsKey('authorId') ? doc['authorId'] as String : null,
                    notes: doc.data().containsKey('notes') ? doc['notes'] as String : '',
                  ))
              .toList();

          return Scaffold(
              backgroundColor: Colors.grey.shade100,
              appBar: AppBar(
                title: Row(
                  children: [
                    Image.asset('assets/images/sapura.png', height: 40),
                    SizedBox(width: 20),
                    Text('PROJECT MONITORING REPORT',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                actions: [
                  OutlinedButton(
                      onPressed: () {
                        final excel = Excel.createExcel();
                        final sheet = excel[excel.getDefaultSheet()!];

                        sheet
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 0, rowIndex: 0))
                              .value = TextCellValue('ID')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 1, rowIndex: 0))
                              .value = TextCellValue('Name')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 2, rowIndex: 0))
                              .value = TextCellValue('Region')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 3, rowIndex: 0))
                              .value = TextCellValue('Type')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 4, rowIndex: 0))
                              .value = TextCellValue('Owner')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 5, rowIndex: 0))
                              .value = TextCellValue('Address')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 6, rowIndex: 0))
                              .value = TextCellValue('Position')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 7, rowIndex: 0))
                              .value = TextCellValue('Survey Status')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 8, rowIndex: 0))
                              .value = TextCellValue('Drawing Status')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 9, rowIndex: 0))
                              .value = TextCellValue('Sign In')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 10, rowIndex: 0))
                              .value = TextCellValue('Sign Out')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 11, rowIndex: 0))
                              .value = TextCellValue('Author ID')
                          ..cell(CellIndex.indexByColumnRow(
                                  columnIndex: 12, rowIndex: 0))
                              .value = TextCellValue('Notes');

                        for (final tower in towers) {
                          final rowIndex = towers.indexOf(tower) + 1;

                          sheet
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 0, rowIndex: rowIndex))
                                .value = TextCellValue(tower.id)
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 1, rowIndex: rowIndex))
                                .value = TextCellValue(tower.name)
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 2, rowIndex: rowIndex))
                                .value = TextCellValue(tower.region)
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 3, rowIndex: rowIndex))
                                .value = TextCellValue(tower.type)
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 4, rowIndex: rowIndex))
                                .value = TextCellValue(tower.owner)
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 5, rowIndex: rowIndex))
                                .value = TextCellValue(tower.address)
                            ..cell(CellIndex.indexByColumnRow(
                                        columnIndex: 6, rowIndex: rowIndex))
                                    .value =
                                TextCellValue('${tower.position.latitude}/${tower.position.longitude}')
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 7, rowIndex: rowIndex))
                                .value = TextCellValue(tower.surveyStatus)
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 8, rowIndex: rowIndex))
                                .value = TextCellValue(tower.drawingStatus)
                            ..cell(CellIndex.indexByColumnRow(columnIndex: 9, rowIndex: rowIndex)).value = TextCellValue(
                                tower.signIn != null ? DateFormat('ddMMyy HH:mm:ss').format(tower.signIn!.toDate()) : '')
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 10, rowIndex: rowIndex))
                                .value = TextCellValue(tower.signOut != null ? DateFormat('ddMMyy HH:mm:ss').format(tower.signOut!.toDate()) : '')
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 11, rowIndex: rowIndex))
                                .value = TextCellValue(tower.authorId ?? '')
                            ..cell(CellIndex.indexByColumnRow(
                                    columnIndex: 12, rowIndex: rowIndex))
                                .value = TextCellValue(tower.notes ?? '');
                        }

                        excel.save(fileName: 'Reports.xlsx');
                      },
                      child: Text('Download')),
                  SizedBox(width: 10),
                  IconButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage())),
                      icon: Icon(Icons.person)),
                  SizedBox(width: 10),
                ],
              ),
              drawer: Drawer(
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: [
                    ListTile(
                      title: const Text('Monitoring Report'),
                      onTap: () => _onItemTapped(0),
                    ),
                    ListTile(
                      title: const Text('On-Site Audit'),
                      onTap: () => _onItemTapped(1),
                    ),
                  ],
                ),
              ),
              body: _widgetOptions[_selectedIndex]);
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      });
}
