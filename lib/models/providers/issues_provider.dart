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
}
