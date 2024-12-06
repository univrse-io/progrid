import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:progrid/models/tower.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

// TOOD: convert to use wrapper provider
class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
            title: Text('SAPURA GIRN - PROJECT MONITORING REPORT',
                style: TextStyle(fontWeight: FontWeight.bold))),
        body: FutureBuilder(
            future: FirebaseFirestore.instance.collection('towers').get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final towers = snapshot.data!.docs.map((doc) => Tower(
                      id: doc.id,
                      name: doc['name'] as String? ?? 'undefined',
                      region: doc['region'] as String? ?? 'undefined',
                      type: doc['type'] as String? ?? 'undefined',
                      owner: doc['owner'] as String? ?? 'undefined',
                      address: doc['address'] as String? ?? 'undefined',
                      position: doc['position'] is GeoPoint
                          ? doc['position'] as GeoPoint
                          : GeoPoint(0, 0),
                      status: doc['status'] as String? ?? 'undefined',
                      notes: doc['notes'] as String? ?? 'no notes',
                    ));

                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Plan',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(height: 10),
                                          Text('${towers.length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge)
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Current',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(height: 10),
                                          Text(
                                              '${towers.where((tower) => tower.status == 'surveyed').length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge)
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Balance',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          SizedBox(height: 10),
                                          Text(
                                              '${towers.where((tower) => tower.status == 'unsurveyed').length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .displayLarge)
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
                                            flags: ~InteractiveFlag
                                                .doubleTapZoom)),
                                    children: [
                                      TileLayer(
                                        urlTemplate:
                                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                        userAgentPackageName:
                                            'dev.fleaflet.flutter_map.example',
                                      ),
                                      MarkerLayer(markers: [
                                        ...towers.map((tower) => Marker(
                                              point: LatLng(
                                                  tower.position.latitude,
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
                                                          Color.fromARGB(
                                                              255, 82, 114, 76),
                                                        'northern' =>
                                                          Color.fromARGB(
                                                              255, 100, 68, 68),
                                                        'eastern' =>
                                                          Color.fromARGB(255,
                                                              134, 124, 79),
                                                        'central' =>
                                                          Color.fromARGB(
                                                              255, 63, 81, 100),
                                                        'western' =>
                                                          Color.fromARGB(255,
                                                              104, 71, 104),
                                                        'sabah' =>
                                                          Color.fromARGB(
                                                              255, 62, 88, 88),
                                                        'sarawak' =>
                                                          Color.fromARGB(255,
                                                              163, 110, 90),
                                                        _ => Colors.grey
                                                      },
                                                      size: 36,
                                                    ),

                                                    // information box
                                                    Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black
                                                            .withOpacity(0.7),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4),
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          // status indicator
                                                          Container(
                                                            width: 8,
                                                            height: 8,
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: tower.status ==
                                                                      'surveyed'
                                                                  ? Colors.green
                                                                  : Colors.red,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                              width: 4),

                                                          // tower id
                                                          Text(
                                                            tower.id,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text('On-Site Audit',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(height: 10),
                                      Expanded(
                                        child: PieChart(PieChartData(
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 50,
                                            sections: [
                                              PieChartSectionData(
                                                title: 'Current',
                                                titlePositionPercentageOffset:
                                                    2,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.status ==
                                                        'surveyed')
                                                    .length
                                                    .toDouble(),
                                                radius: 50,
                                                color: Colors.pink,
                                              ),
                                              PieChartSectionData(
                                                title: 'Balance',
                                                titlePositionPercentageOffset:
                                                    2,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.status ==
                                                        'unsurveyed')
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
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text('Regional Breakdown',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                      SizedBox(height: 10),
                                      Expanded(
                                        child: PieChart(PieChartData(
                                            sectionsSpace: 0,
                                            centerSpaceRadius: 50,
                                            sections: [
                                              PieChartSectionData(
                                                title: 'Southern',
                                                titlePositionPercentageOffset:
                                                    1.8,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.region ==
                                                        'Southern')
                                                    .length
                                                    .toDouble(),
                                                radius: 50,
                                                color: Colors.amber,
                                              ),
                                              PieChartSectionData(
                                                title: 'Northern',
                                                titlePositionPercentageOffset:
                                                    1.8,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.region ==
                                                        'Northern')
                                                    .length
                                                    .toDouble(),
                                                radius: 50,
                                                color: Colors.blue,
                                              ),
                                              PieChartSectionData(
                                                title: 'Eastern',
                                                titlePositionPercentageOffset:
                                                    1.8,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.region ==
                                                        'Eastern')
                                                    .length
                                                    .toDouble(),
                                                radius: 50,
                                                color: Colors.green,
                                              ),
                                              PieChartSectionData(
                                                title: 'Sarawak',
                                                titlePositionPercentageOffset:
                                                    1.8,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.region ==
                                                        'Sarawak')
                                                    .length
                                                    .toDouble(),
                                                radius: 50,
                                                color: Colors.red,
                                              ),
                                              PieChartSectionData(
                                                title: 'Sabah',
                                                titlePositionPercentageOffset:
                                                    1.8,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.region == 'Sabah')
                                                    .length
                                                    .toDouble(),
                                                radius: 50,
                                                color: Colors.orange,
                                              ),
                                              PieChartSectionData(
                                                title: 'Central',
                                                titlePositionPercentageOffset:
                                                    1.8,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.region ==
                                                        'Central')
                                                    .length
                                                    .toDouble(),
                                                radius: 50,
                                                color: Colors.brown,
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
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      );
}
