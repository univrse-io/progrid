import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Tower Model
class Tower {
  String towerId = 'undefined';
  String name = 'undefined';
  String address = 'undefined';
  String status = 'undefined';
  String notes = 'NaN';

  // TODO: implement ticket objects (inspection and issues)

  // constructor
  Tower({
    required this.towerId,
    required this.name,
    required this.address,
    required this.status,
    required this.notes,
  });

  factory Tower.fetchTowerInfoFromDatabase(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Tower(
      towerId: doc.id,
      name: data['name'],
      address: data['address'],
      status: data['status'],
      notes: data['notes'],
    );
  }
}

// Tower List Provider
class TowerProvider extends ChangeNotifier {
  List<Tower> towers = [];

  // run this to refresh towers list
  Future<void> fetchTowers() async {
    try {
      towers = [];
      final snapshot = await FirebaseFirestore.instance.collection('towers').get();

      // fetch each tower
      for (var doc in snapshot.docs) {
        Tower tower = Tower.fetchTowerInfoFromDatabase(doc);
        towers.add(tower);
      }
    } catch (e) {
      print("Error Fetching Towers: $e");
    }
  }
}
