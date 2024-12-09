import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/tower.dart';

// Tower List Provider
class TowersProvider extends ChangeNotifier {
  List<Tower> towers = [];
  StreamSubscription? _towersSubscription;

  // setup stream subscription
  Future<void> loadTowers() async {
    try {
      towers = [];

      // currently redownloads entire list everytime there is an update
      _towersSubscription = FirebaseFirestore.instance.collection('towers').snapshots().listen((snapshot) async {
        towers = await Future.wait(snapshot.docs.map((doc) async => await Tower.fromFirestore(doc)));
        notifyListeners();
      });
    } catch (e) {
      throw 'Error loading Towers: $e';
    }
  }

  Future<void> updateTowerStatus(String towerId, String status) async {
    try {
      // update database
      await FirebaseFirestore.instance.collection('towers').doc(towerId).update({'status': status});

      // update local
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      tower.status = status;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to update tower status: $e");
    }
  }

  @override
  void dispose() {
    _towersSubscription?.cancel(); // safe stop
    super.dispose();
  }

  // Future<String> _generateUniqueId(String towerId, String type) async {
  //   String id = 'null';
  //   bool isUnique = false;

  //   // on the off-chance of 1/onetrillion that same ids are generated
  //   while (!isUnique) {
  //     String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  //     timestamp = timestamp.substring(timestamp.length - 3); // last 3 digits

  //     // combine
  //     id = "$towerId-${timestamp}-$type";

  //     // collision check
  //     final towerRef = FirebaseFirestore.instance.collection('towers').doc(towerId);
  //     final collectionRef = towerRef.collection(type == 'R' ? 'reports' : 'issues');
  //     final docSnapshot = await collectionRef.doc(id).get();

  //     if (!docSnapshot.exists) {
  //       isUnique = true; // unique ID found
  //     }
  //   }

  //   return id;
  // }
}
