import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/issue.dart';
import '../models/tower.dart';

sealed class FirestoreService {
  static final issuesCollection = FirebaseFirestore.instance
      .collection(kDebugMode ? 'issues_dev' : 'issues');
  static final towersCollection = FirebaseFirestore.instance
      .collection(kDebugMode ? 'towers_dev' : 'towers');

  /// NOTE: Users collection is shared across all environments.
  static final usersCollection = FirebaseFirestore.instance.collection('users');
  static final issuesStream = issuesCollection
      .snapshots()
      .map((snapshot) => snapshot.docs.map(Issue.fromFirestore).toList());
  static final towersStream = towersCollection
      .snapshots()
      .map((snapshot) => snapshot.docs.map(Tower.fromFirestore).toList());

  static Future<void> createIssue(
    String id, {
    required Map<String, dynamic> data,
  }) async =>
      issuesCollection
          .doc(id)
          .set(data)
          .then((_) => log('Successfully created issue.'))
          .catchError((e) => log('Failed creating issue.', error: e));

  static Future<void> createUser(
    String id, {
    required Map<String, dynamic> data,
  }) async =>
      usersCollection
          .doc(id)
          .set(data)
          .then((_) => log('Successfully created user.'))
          .catchError((e) => log('Failed creating user.', error: e));

  static Future<void> updateIssue(
    String id, {
    required Map<String, dynamic> data,
  }) async =>
      issuesCollection
          .doc(id)
          .update(data)
          .then((_) => log('Successfully updated issue.'))
          .catchError((e) => log('Failed updating issue.', error: e));

  static Future<void> updateTower(
    String id, {
    required Map<String, dynamic> data,
  }) async =>
      towersCollection
          .doc(id)
          .update(data)
          .then((_) => log('Successfully updated tower.'))
          .catchError((e) => log('Failed updating tower.', error: e));

  static Future<void> updateUser(
    String id, {
    required Map<String, dynamic> data,
  }) async =>
      usersCollection
          .doc(id)
          .update(data)
          .then((_) => log('Successfully updated user.'))
          .catchError((e) => log('Failed updating user.', error: e));
}
