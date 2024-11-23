import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// I combined the model and provider into a single class as there should only be a single user logged in at any time
class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  // implement other user information here
  String userId = 'undefined';
  String email = 'undefined';
  String phone = 'undefined';
  String altEmail = 'undefined';
  String role = 'undefined';
  Timestamp? lastLogin; // tbf

  void logout() {
    userId = 'undefined';
    email = 'undefined';
    phone = 'undefined';
    altEmail = 'undefined';
    role = 'undefined';
    lastLogin = null;

    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  // called on login
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // fetch user information from database given an auth user
  Future<void> fetchUserInfoFromDatabase(User user) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;

        userId = userDoc.id;
        email = data['email'] as String? ?? 'undefined';
        phone = data['phone'] as String? ?? 'undefined';
        altEmail = data['altEmail'] as String? ?? 'undefined';
        role = data['role'] as String? ?? 'undefined';
        lastLogin = data['lastLogin'] as Timestamp?;
      } else {
        throw Exception("User Document does not Exist");
      }
    } catch (e) {
      print("Failed to fetch user info: $e");
    }
  }
}
