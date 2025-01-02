import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/tower.dart';

class FirestoreService {
  static final issuesCollection =
      FirebaseFirestore.instance.collection('issues');
  static final towersCollection =
      FirebaseFirestore.instance.collection('towers');
  static final usersCollection = FirebaseFirestore.instance.collection('users');

  static final issuesStream = issuesCollection
      .snapshots()
      .map((list) => list.docs.map((doc) => Issue.fromFirestore(doc)).toList());
  static final towersStream = towersCollection
      .snapshots()
      .map((list) => list.docs.map((doc) => Tower.fromFirestore(doc)).toList());

  static Future<void> updateIssue(String id,
          {required Map<String, dynamic> data}) async =>
      issuesCollection
          .doc(id)
          .update(data)
          .then((_) => log('Successfully updated issue.'))
          .catchError((e) => log('Failed updating issue.', error: e));

  static Future<void> updateTower(String id,
          {required Map<String, dynamic> data}) async =>
      towersCollection
          .doc(id)
          .update(data)
          .then((_) => log('Successfully updated tower.'))
          .catchError((e) => log('Failed updating tower.', error: e));

  static Future<void> updateUser(String id,
          {required Map<String, dynamic> data}) async =>
      usersCollection
          .doc(id)
          .update(data)
          .then((_) => log('Successfully updated user.'))
          .catchError((e) => log('Failed updating user.', error: e));
}
