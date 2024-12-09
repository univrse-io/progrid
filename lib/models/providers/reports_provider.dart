import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/report.dart';

class ReportsProvider extends ChangeNotifier {
  List<Report> reports = [];
  StreamSubscription? _reportsSubscription;

  // setup stream subscription
  Future<void> loadReports() async {
    try {
      reports = [];

      _reportsSubscription = FirebaseFirestore.instance.collection('reports').snapshots().listen((snapshot) async {
        reports = await Future.wait(snapshot.docs.map((doc) async => Report.fromFirestore(doc)));
        notifyListeners();
      });
    } catch (e) {
      throw 'Error loading Reports: $e';
    }
  }

  Future<void> addReport(String towerId, Report report) async {
    try {
      final reportId = await _generateUniqueId(towerId, 'R');
      await FirebaseFirestore.instance.collection('reports').doc(reportId).set(report.toMap());

      reports.add(report);
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to add report: $e");
    }
  }

  @override
  void dispose() {
    _reportsSubscription?.cancel();
    super.dispose();
  }

  // to be replaced / centralized
  Future<String> _generateUniqueId(String towerId, String type) async {
    String id = 'null';
    bool isUnique = false;

    // on the off-chance of 1/onetrillion that same ids are generated
    while (!isUnique) {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      timestamp = timestamp.substring(timestamp.length - 3); // last 3 digits

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
