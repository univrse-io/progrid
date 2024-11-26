import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Tower List Provider
class TowersProvider extends ChangeNotifier {
  List<Tower> towers = [];

  // run this to refresh towers list
  Future<void> fetchTowers() async {
    try {
      towers = []; // reset list
      final snapshot = await FirebaseFirestore.instance.collection('towers').get();

      // fetch each tower
      for (final doc in snapshot.docs) {
        final Tower tower = await Tower.fetchFromDatabase(doc);
        towers.add(tower);
      }
      notifyListeners();
    } catch (e) {
      print("Error Fetching Towers: $e");
    }
  }
}

// Tower Model
class Tower {
  String id;
  String name;
  String region;
  String type;
  String owner;
  String address;
  GeoPoint position;
  String status;
  String notes;

  // TODO: implement ticket objects (inspection and issues)
  List<Report> reports;

  // constructor
  Tower({
    this.id = 'undefined',
    this.name = 'undefined',
    this.region = 'undefined',
    this.type = 'undefined',
    this.owner = 'undefined',
    this.address = 'undefined',
    this.position = const GeoPoint(0, 0),
    this.status = 'undefined',
    this.notes = 'no notes',
    this.reports = const [],
  });

  // given a tower document, fetch from database
  static Future<Tower> fetchFromDatabase(DocumentSnapshot doc) async {
    final data = doc.data()! as Map<String, dynamic>;

    // fetch reports
    final List<Report> reports = [];
    final reportSnapshot = await FirebaseFirestore.instance
        .collection('towers')
        .doc(doc.id)
        .collection('reports')
        .get();

    for (final reportDoc in reportSnapshot.docs) {
      final report = Report.fetchFromDatabase(reportDoc);
      reports.add(report);
    }

    return Tower(
      id: doc.id, // firebase document id = tower id
      name: data['name'] as String? ?? 'undefined',
      region: data['region'] as String? ?? 'undefined',
      type: data['type'] as String? ?? 'undefined',
      owner: data['owner'] as String? ?? 'undefined',
      address: data['address'] as String? ?? 'undefined',
      position: data['position'] is GeoPoint ? data['position'] as GeoPoint : GeoPoint(0, 0), // fix
      status: data['status'] as String? ?? 'undefined',
      notes: data['notes'] as String? ?? 'no notes',
      reports: reports,
    );
  }
}

// Report Model
class Report {
  String id;
  Timestamp dateTime;
  String authorId;
  // List<String> pictures;
  String notes;

  // constructor
  Report({
    required this.id,
    required this.dateTime,
    required this.authorId,
    // this.pictures = const [], // default empty
    this.notes = 'no notes', // default
  });

  factory Report.fetchFromDatabase(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return Report(
      id: doc.id,
      dateTime: data['dateTime'] as Timestamp,
      authorId: data['authorId'] as String,
      // pictures: data['pictures'] != null ? data['pictures'] as List<String> : [],
      notes: data['notes'] as String? ?? 'no notes',
    );
  }
}
