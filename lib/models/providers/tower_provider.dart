import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/report.dart';
import 'package:progrid/models/tower.dart';

// Tower List Provider
class TowersProvider extends ChangeNotifier {
  List<Tower> towers = [];

  // initialize towers stream
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

      await towerRef.collection('reports').add(report.toMap());
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

      await towerRef.collection('issues').add(issue.toMap());
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
}
