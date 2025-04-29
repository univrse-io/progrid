import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/issue.dart';
import '../models/tower.dart';

class FirebaseFirestoreService {
  final _issuesCollection = FirebaseFirestore.instance.collection(
    kDebugMode ? 'issues_dev' : 'issues',
  );
  final _towersCollection = FirebaseFirestore.instance.collection(
    kDebugMode ? 'towers_dev' : 'towers',
  );
  final _usersCollection = FirebaseFirestore.instance.collection('users');

  Stream<List<Issue>> get issuesStream => _issuesCollection.snapshots().map(
    (snapshot) => snapshot.docs.map(Issue.fromFirestore).toList(),
  );
  Stream<List<Tower>> get towersStream => _towersCollection.snapshots().map(
    (snapshot) => snapshot.docs.map(Tower.fromFirestore).toList(),
  );

  Future<void> createIssue(
    String id, {
    required Map<String, dynamic> data,
  }) async => _issuesCollection
      .doc(id)
      .set(data)
      .then((_) => log('Successfully created issue.'))
      .catchError((e) => log('Failed to create issue.', error: e));

  Future<void> createUser(
    String id, {
    required Map<String, dynamic> data,
  }) async => _usersCollection
      .doc(id)
      .set(data)
      .then((_) => log('Successfully created user.'))
      .catchError((e) => log('Failed to create user.', error: e));

  Future<void> updateIssue(
    String id, {
    required Map<String, dynamic> data,
  }) async {
    data['updatedAt'] = DateTime.now();

    return _issuesCollection
        .doc(id)
        .update(data)
        .then((_) => log('Successfully updated issue.'))
        .catchError((e) => log('Failed to update issue.', error: e));
  }

  Future<void> updateTower(
    String id, {
    required Map<String, dynamic> data,
  }) async => _towersCollection
      .doc(id)
      .update(data)
      .then((_) => log('Successfully updated tower.'))
      .catchError((e) => log('Failed to update tower.', error: e));

  Future<void> updateUser(
    String id, {
    required Map<String, dynamic> data,
  }) async => _usersCollection
      .doc(id)
      .update(data)
      .then((_) => log('Successfully updated user.'))
      .catchError((e) => log('Failed to update user.', error: e));
}
