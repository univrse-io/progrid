import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // fetch user information from database given an auth user
  Future<void> fetchUserInfoFromDatabase(User user) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;

        userId = userDoc.id;
        email = data['email'] ?? 'undefined';
        phone = data['phone'] ?? 'undefined';
        altEmail = data['altEmail'] ?? 'undefined';
        role = data['role'] ?? 'undefined';
        lastLogin = data['lastLogin'] ?? 'undefined';

      } else {
        throw Exception("User Document does not Exist");
      }
    } catch (e) {
      print("Failed to fetch user info: $e");
    }
  }
}
