import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/tower.dart';

class FirestoreService {
  static final issuesCollection =
      FirebaseFirestore.instance.collection('issues_dev');
  static final towersCollection =
      FirebaseFirestore.instance.collection('towers_dev');
  static final usersCollection = FirebaseFirestore.instance.collection('users_dev');

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

  static Future<void> createUser(String id, {required Map<String, dynamic> data}) async {
    try {
      await usersCollection
          .doc(id)
          .set(data)
          .then((_) => log('Successfully created user.'))
          .catchError((e) => log('Failed creating user.', error: e));
    } catch (e) {
      log('Error creating user: $e');
    }
  }
}
