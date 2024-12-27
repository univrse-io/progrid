import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progrid/models/tower.dart';

sealed class FirestoreService {
  static final towersCollection =
      FirebaseFirestore.instance.collection('towers');

  static Stream<List<Tower>> get towersStream => towersCollection
      .snapshots()
      .map((list) => list.docs.map((doc) => Tower.fromFirestore(doc)).toList());
}
