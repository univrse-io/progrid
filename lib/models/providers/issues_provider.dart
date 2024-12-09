import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/issue.dart';

class IssuesProvider extends ChangeNotifier {
  List<Issue> issues = [];
  StreamSubscription? _issuesSubscription;

  // setup stream subscription
  Future<void> loadIssues() async {
    try {
      issues = [];

      _issuesSubscription = FirebaseFirestore.instance.collection('issues').snapshots().listen((snapshot) async {
        issues = await Future.wait(snapshot.docs.map((doc) async => Issue.fromFirestore(doc)));
        notifyListeners();
      });
    } catch (e) {
      throw 'Error loading Issues: $e';
    }
  }

  @override
  void dispose() {
    _issuesSubscription?.cancel();
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
