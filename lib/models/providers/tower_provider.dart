import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/report.dart';
import 'package:progrid/models/tower.dart';

// TODO: map updates twice???

// Tower List Provider
class TowersProvider extends ChangeNotifier {
  List<Tower> towers = [];
  StreamSubscription? _towersSubscription;

  // on app start, load entire database
  // also sets up the stream subscription
  Future<void> loadTowers() async {
    try {
      towers = [];
      // track changes, update local
      // _towersSubscription = FirebaseFirestore.instance.collection('towers').snapshots().listen((snapshot) async {
      //   for (final docChange in snapshot.docChanges) {
      //     if (docChange.type == DocumentChangeType.added) {
      //       // new tower added
      //       final newTower = await Tower.fromFirestore(docChange.doc);
      //       towers.add(newTower);
      //     } else if (docChange.type == DocumentChangeType.modified) {
      //       // tower updated
      //       final index = towers.indexWhere((t) => t.id == docChange.doc.id);
      //       if (index != -1) {
      //         final updatedTower = await Tower.fromFirestore(docChange.doc);
      //         towers[index] = updatedTower;
      //       }
      //     } else if (docChange.type == DocumentChangeType.removed) {
      //       // tower deleted
      //       towers.removeWhere((t) => t.id == docChange.doc.id);
      //     }
      //   }

      //   notifyListeners();
      // });

      _towersSubscription = FirebaseFirestore.instance.collection('towers').snapshots().listen((snapshot) async {
        towers = await Future.wait(snapshot.docs.map((doc) async => await Tower.fromFirestore(doc)));
        notifyListeners();
      });
    } catch (e) {
      throw 'Error loading towers: $e';
    }
  }

  @override
  void dispose() {
    _towersSubscription?.cancel(); // safe stop
    super.dispose();
  }

  Future<void> addIssueToTower(String towerId, Issue issue) async {
    try {
      // add to database
      final towerRef = FirebaseFirestore.instance.collection('towers').doc(towerId);
      final towerSnapshot = await towerRef.get();
      if (!towerSnapshot.exists) throw "Tower not found";

      final String issueId = await _generateUniqueId(towerId, 'I');
      await towerRef.collection('issues').doc(issueId).set(issue.toMap());

      // add to local base
      final towerIndex = towers.indexWhere((tower) => tower.id == towerId);
      if (towerIndex != -1) {
        towers[towerIndex].issues.add(issue);
      }
      notifyListeners();
    } catch (e) {
      throw 'Error adding issue: $e';
    }
  }

  Future<void> addReportToTower(String towerId, Report report) async {
    try {
      // add to database
      final towerRef = FirebaseFirestore.instance.collection('towers').doc(towerId);
      final towerSnapshot = await towerRef.get();
      if (!towerSnapshot.exists) throw "Tower not found";

      final String issueId = await _generateUniqueId(towerId, 'R');
      await towerRef.collection('reports').doc(issueId).set(report.toMap());
      await towerRef.update({'status': 'surveyed'});

      // add to local base
      final towerIndex = towers.indexWhere((tower) => tower.id == towerId);
      if (towerIndex != -1) {
        towers[towerIndex].reports.add(report);
        towers[towerIndex].status = 'surveyed';
      }
      notifyListeners();
    } catch (e) {
      throw 'Error adding report: $e';
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
