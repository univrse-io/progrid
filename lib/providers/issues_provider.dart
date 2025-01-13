import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/services/firestore.dart';

class IssuesProvider extends ChangeNotifier {
  List<Issue> issues = [];
  StreamSubscription? _issuesSubscription;

  // setup stream subscription
  Future<void> loadIssues() async {
    try {
      issues = [];

      _issuesSubscription = FirestoreService.issuesCollection
          .snapshots()
          .listen((snapshot) async {
        issues = await Future.wait(
            snapshot.docs.map((doc) async => Issue.fromFirestore(doc)));
        notifyListeners();
      });
    } catch (e) {
      throw 'Error loading Issues: $e';
    }
  }

  Future<void> addIssue(String towerId, Issue issue) async {
    try {
      final issueId = await _generateUniqueId(towerId, 'I');
      issue.id = issueId;
      await FirestoreService.issuesCollection.doc(issueId).set(issue.toJson());

      notifyListeners();
    } catch (e) {
      throw Exception("Failed to add issue: $e");
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
      id = "$towerId-$type$timestamp";

      // collision check
      final collectionRef =
          FirestoreService.towersCollection.doc(towerId).collection('issues');
      final docSnapshot = await collectionRef.doc(id).get();

      if (!docSnapshot.exists) {
        isUnique = true; // unique ID found
      }
    }

    return id;
  }
}
