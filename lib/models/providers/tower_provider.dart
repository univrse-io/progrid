import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/report.dart';
import 'package:progrid/models/tower.dart';

// Tower List Provider
class TowersProvider extends ChangeNotifier {
  List<Tower> towers = [];

  // initialize towers stream
  // UNDONE: this is very bad, should store stream locally instead and return that, no need to reread database everytime
  Stream<List<Tower>> getTowersStream() {
    return FirebaseFirestore.instance.collection('towers').snapshots().map(
      (snapshot) {
        return snapshot.docs.map((doc) => Tower.fromFirestore(doc)).toList();
      },
    );
  }

  // add a report to a tower
  Future<void> addReportToTower(String towerId, Report report) async {
    try {
      final towerRef = FirebaseFirestore.instance.collection('towers').doc(towerId);
      final towerSnapshot = await towerRef.get();

      if (!towerSnapshot.exists) {
        throw 'Tower not found';
      }

      // custom report id
      final String reportId = await _generateUniqueId(towerId, 'R');
      await towerRef.collection('reports').doc(reportId).set(report.toMap());
      await towerRef.update({'status': 'surveyed'});

      notifyListeners();
    } catch (e) {
      throw 'Error adding report: $e';
    }
  }

  Future<void> addIssueToTower(String towerId, Issue issue) async {
    try {
      final towerRef = FirebaseFirestore.instance.collection('towers').doc(towerId);
      final towerSnapshot = await towerRef.get();

      if (!towerSnapshot.exists) {
        throw 'Tower not found';
      }

      // custom issue id
      final String issueId = await _generateUniqueId(towerId, 'I');
      await towerRef.collection('issues').doc(issueId).set(issue.toMap());

      notifyListeners();
    } catch (e) {
      throw 'Error adding issue: $e';
    }
  }

  // update a tower's issue's status
  void updateIssueStatus(String towerId, String issueId, String status) {
    try {
      final tower = towers.firstWhere((tower) => tower.id == towerId, orElse: () => throw Exception("Tower not found"));
      tower.updateIssueStatus(issueId, status);
      notifyListeners();
    } catch (e) {
      print("Error updating issue status: $e");
    }
  }

  // for retrieving tower instance given an id
  Future<Tower> getTowerById(String towerId) async {
    try {
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      return tower;
    } catch (e) {
      throw Exception("Tower not found with id: $towerId");
    }
  }

  Future<String> _generateUniqueId(String towerId, String type) async {
    String id = 'null';
    bool isUnique = false;

    // on the off-chance of 1/onetrillion that same ids are generated
    while (!isUnique) {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      timestamp = timestamp.substring(timestamp.length - 3); // last 3 digits, TODO: REVIEW METHOD

      // combine
      id = "$towerId-${timestamp}-$type";

      // collision check
      final towerRef = FirebaseFirestore.instance.collection('towers').doc(towerId);
      final collectionRef = towerRef.collection(type == 'R' ? 'reports' : 'issues');
      final docSnapshot = await collectionRef.doc(id).get();

      if (!docSnapshot.exists) {
        isUnique = true; // unique ID found
      }
    }

    return id;
  }
}
