import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/services/firestore.dart';

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
      _towersSubscription = FirestoreService.towersCollection
          .snapshots()
          .listen((snapshot) async {
        towers = await Future.wait(
            snapshot.docs.map((doc) async => Tower.fromFirestore(doc)));
        notifyListeners();
      });
    } catch (e) {
      throw 'Error loading Towers: $e';
    }
  }

  Future<void> updateSurveyStatus(String towerId, String surveyStatus) async {
    try {
      // update database
      await FirestoreService.towersCollection
          .doc(towerId)
          .update({'surveyStatus': surveyStatus});

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
      await FirestoreService.towersCollection
          .doc(towerId)
          .update({'drawingStatus': drawingStatus});

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
      await FirestoreService.towersCollection
          .doc(towerId)
          .update({'notes': notes});

      // update local
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      tower.notes = notes;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to update tower notes: $e");
    }
  }

  Future<void> updateSignIn(String towerId, Timestamp signIn) async {
    try {
      // update database
      await FirestoreService.towersCollection
          .doc(towerId)
          .update({'signIn': signIn});

      // update local
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      tower.signIn = signIn;
    } catch (e) {
      throw Exception("Failed to add Sign-in Timestamp: $e");
    }
  }

  Future<void> updateSignOut(String towerId, Timestamp signOut) async {
    try {
      // update database
      await FirestoreService.towersCollection
          .doc(towerId)
          .update({'signOut': signOut});

      // update local
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      tower.signIn = signOut;
    } catch (e) {
      throw Exception("Failed to add Sign-in Timestamp: $e");
    }
  }

  Future<void> updateAuthorId(String towerId, String authorId) async {
    try {
      // update database
      await FirestoreService.towersCollection
          .doc(towerId)
          .update({'authorId': authorId});

      // update local
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      tower.authorId = authorId;
    } catch (e) {
      throw Exception("Failed to update authorId: $e");
    }
  }

  Future<void> addImage(String towerId, String imageUrl) async {
    try {
      // update database
      await FirestoreService.towersCollection.doc(towerId).update({
        'images': FieldValue.arrayUnion([imageUrl]),
      });

      // update local
      final tower = towers.firstWhere((tower) => tower.id == towerId);
      tower.images.add(imageUrl); // add to end of array
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to add image URL: $e");
    }
  }

  @override
  void dispose() {
    _towersSubscription?.cancel(); // safe stop
    super.dispose();
  }
}
