import 'package:cloud_firestore/cloud_firestore.dart';
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
        appBar: AppBar(title: Text('SAPURA GIRN - PROJECT MONITORING REPORT')),
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

                return SingleChildScrollView(
                  child: Column(
                    children: [...towers.map((tower) => Text(tower.id))],
                  ),
                );
              } else {
                return CircularProgressIndicator();
              }
            }),
      );
}
