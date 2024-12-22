import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:progrid/models/tower.dart';

// Tower List Provider
class TowersProvider extends ChangeNotifier {
  List<Tower> towers = [];
  StreamSubscription? _towersSubscription;

  // setup stream subscription
  Future<void> loadTowers() async {
    if (kIsWeb) return;
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

  Future<void> updateSurveyStatus(String towerId, String surveyStatus) async {
    try {
      // update database
      await FirebaseFirestore.instance.collection('towers').doc(towerId).update({'surveyStatus': surveyStatus});

      // update local
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      tower.surveyStatus = surveyStatus;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to update tower survey status: $e");
    }
  }

  Future<void> updateDrawingStatus(String towerId, String drawingStatus) async {
    try {
      // update database
      await FirebaseFirestore.instance.collection('towers').doc(towerId).update({'drawingStatus': drawingStatus});

      // update local
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      tower.drawingStatus = drawingStatus;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to update tower drawing status: $e");
    }
  }

  Future<void> updateNotes(String towerId, String notes) async {
    try {
      // update database
      await FirebaseFirestore.instance.collection('towers').doc(towerId).update({'notes': notes});

      // update local
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      tower.notes = notes;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to update tower notes: $e");
    }
  }

  @override
  void dispose() {
    _towersSubscription?.cancel(); // safe stop
    super.dispose();
  }
}
