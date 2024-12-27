import 'package:cloud_firestore/cloud_firestore.dart';

sealed class FirestoreService {
  static final towersCollection =
      FirebaseFirestore.instance.collection('towers');

  static Stream<QuerySnapshot<Map<String, dynamic>>> get towersStream =>
      towersCollection.snapshots();
}
