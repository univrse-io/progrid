import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/report.dart';
import 'package:progrid/models/tower.dart';

// TODO: major refactor needed
// UNDONE: every time 'towers' stream is called, it needs to read the entire database; of 600. need to reduce this count

// Tower List Provider
class TowersProvider extends ChangeNotifier {
  List<Tower> towers = [];
  // List<Tower> get towers => _towers;

  // on app start, load entire database
  Future<void> loadTowers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('towers').get();

      // load multiple simultaneously
      towers = await Future.wait(snapshot.docs.map((doc) async {
        return await Tower.fromFirestore(doc);
      }));
      notifyListeners();

      // // load multiple individually
      // for (final doc in snapshot.docs) {
      //   // Convert doc to a Tower object
      //   final Tower tower = await Tower.fromFirestore(doc);
      //   towers.add(tower);
      //   notifyListeners();
      // }
    } catch (e) {
      throw 'Error loading towers: $e';
    }
  }

  // add a report to a tower
  // Future<void> addReportToTower(String towerId, Report report) async {
  //   try {
  //     final towerRef = FirebaseFirestore.instance.collection('towers').doc(towerId);
  //     final towerSnapshot = await towerRef.get();

  //     if (!towerSnapshot.exists) {
  //       throw 'Tower not found';
  //     }

  //     // update database, singly
  //     final String reportId = await _generateUniqueId(towerId, 'R');
  //     await towerRef.collection('reports').doc(reportId).set(report.toMap());
  //     await towerRef.update({'status': 'surveyed'});

  //     // update local cache tower status
  //     final towerIndex = _towers.indexWhere((tower) => tower.id == towerId);
  //     if (towerIndex != -1) {
  //       // TODO: add cache report 
  //       _towers[towerIndex].reports?.listen((reports) {
  //         reports.add(report);
  //       });

  //       // update cache status
  //       _towers[towerIndex].status = 'surveyed';
  //       notifyListeners();
  //     }

  //     notifyListeners();
  //   } catch (e) {
  //     throw 'Error adding report: $e';
  //   }
  // }

  // Future<void> addIssueToTower(String towerId, Issue issue) async {
  //   try {
  //     final towerRef = FirebaseFirestore.instance.collection('towers').doc(towerId);
  //     final towerSnapshot = await towerRef.get();

  //     if (!towerSnapshot.exists) {
  //       throw 'Tower not found';
  //     }

  //     // custom issue id
  //     final String issueId = await _generateUniqueId(towerId, 'I');
  //     await towerRef.collection('issues').doc(issueId).set(issue.toMap());

  //     // TODO: add isse to local tower cache

  //     notifyListeners();
  //   } catch (e) {
  //     throw 'Error adding issue: $e';
  //   }
  // }

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
