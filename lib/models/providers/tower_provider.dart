import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/report.dart';
import 'package:progrid/models/tower.dart';

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
        final Tower tower = await Tower.fromFirestore(doc);
        towers.add(tower);
      }
      notifyListeners();
    } catch (e) {
      print("Error Fetching Towers: $e");
    }
  }

  // update issue status in a tower
  void updateIssueStatus(String towerId, String issueId, String status) {
    try {
      final tower = towers.firstWhere((tower) => tower.id == towerId, orElse: () => throw Exception("Tower not found"));
      tower.updateIssueStatus(issueId, status);
      notifyListeners();
    } catch (e) {
      print("Error updating issue status: $e");
    }
  }

  // add a report to a tower
  Future<void> addReportToTower(String towerId, Report report) async {
    final tower = towers.firstWhere((tower) => tower.id == towerId, orElse: () => throw Exception("Tower not found"));
    tower.addReport(report);
    notifyListeners();
  }

  // add an issue to a tower
  Future<void> addIssueToTower(String towerId, Issue issue) async {
    final tower = towers.firstWhere((tower) => tower.id == towerId);
    tower.addIssue(issue);
    notifyListeners();
  }
}
