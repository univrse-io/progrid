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

  @override
  void dispose() {
    _reportsSubscription?.cancel();
    super.dispose();
  }
}
