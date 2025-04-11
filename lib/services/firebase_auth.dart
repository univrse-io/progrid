import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import 'firebase_firestore.dart';

class FirebaseAuthService {
  Future<void> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;

      await FirebaseFirestoreService().updateUser(
        user.uid,
        data: user.toJson(),
      );

      log('Successfully logged in.');
    } on FirebaseAuthException catch (e) {
      log('Failed to login.', error: e);
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
      await FirebaseFirestoreService().createUser(user.uid, data: json);

      log('Successfully registered.');
    } on FirebaseAuthException catch (e) {
      log('Failed to register.', error: e);
      rethrow;
    }
  }
}
