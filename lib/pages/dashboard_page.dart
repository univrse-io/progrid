import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/tower.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

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
                      Expanded(flex: 5, child: Placeholder()), // map
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
                                      Text('Tower Status',
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
                                                title: 'Surveyed',
                                                titlePositionPercentageOffset:
                                                    2,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.status ==
                                                        'surveyed')
                                                    .length
                                                    .toDouble(),
                                                radius: 50,
                                                color: Colors.green,
                                              ),
                                              PieChartSectionData(
                                                title: 'Unsurveyed',
                                                titlePositionPercentageOffset:
                                                    2,
                                                value: towers
                                                    .where((tower) =>
                                                        tower.status ==
                                                        'unsurveyed')
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
                                                color: Colors.pink,
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
