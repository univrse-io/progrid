import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'firestore.dart';

class AuthService {
  Future<void> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      final user = credential.user!;

      await FirestoreService().updateUser(user.uid, data: user.toJson());
    } on FirebaseAuthException catch (e) {
      log('Failed to log the user in.', error: e);
      rethrow;
    }
  }

  Future<void> register(String name, String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = credential.user!;
      final json = user.toJson()..update('displayName', (_) => name);

      await user.updateDisplayName(name);
      await user.sendEmailVerification();
      await FirestoreService().createUser(user.uid, data: json);
    } on FirebaseAuthException catch (e) {
      log('Failed to register the user.', error: e);
      rethrow;
    }
  }
}

extension UserExtension on User {
  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'email': email,
        'isEmailVerified': emailVerified,
        'isAnonymous': isAnonymous,
        'creationTime': metadata.creationTime != null
            ? Timestamp.fromDate(metadata.creationTime!)
            : null,
        'lastSignInTime': metadata.lastSignInTime != null
            ? Timestamp.fromDate(metadata.lastSignInTime!)
            : null,
        'phoneNumber': phoneNumber,
        'photoURL': tenantId,
        'uid': uid,
      };
}
