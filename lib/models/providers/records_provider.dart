import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/record.dart';

class RecordsProvider extends ChangeNotifier {
  List<Record> records = [];
  StreamSubscription? _recordsSubscription;

  // setup stream subscription
  Future<void> loadRecords() async {
    try {
      records = [];

      _recordsSubscription = FirebaseFirestore.instance.collection('records').snapshots().listen((snapshot) async {
        records = await Future.wait(snapshot.docs.map((doc) async => Record.fromFirestore(doc)));
        notifyListeners();
      });
    } catch (e) {
      throw 'Error loading records: $e';
    }
  }

  Future<void> addRecord(String towerId, Record record) async {
    try {
      final recordId = await _generateUniqueId(towerId, 'R');
      await FirebaseFirestore.instance.collection('records').doc(recordId).set(record.toMap());

      records.add(record);
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to add record: $e");
    }
  }

  @override
  void dispose() {
    _recordsSubscription?.cancel();
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
      id = "$towerId-$type-$timestamp";

      // collision check
      final towerRef = FirebaseFirestore.instance.collection('towers').doc(towerId);
      final collectionRef = towerRef.collection(type == 'R' ? 'records' : 'issues');
      final docSnapshot = await collectionRef.doc(id).get();

      if (!docSnapshot.exists) {
        isUnique = true; // unique ID found
      }
    }

    return id;
  }
}
