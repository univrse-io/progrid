import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrid/services/firestore.dart';

// I combined the model and provider into a single class as there should only be a single user logged in at any time
class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  // implement other user information here
  String userId = 'undefined';
  String email = 'undefined';
  String name = 'undefined';
  String phone = 'undefined';
  String team = 'undefined';
  String role = 'undefined';
  Timestamp? lastLogin;

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      _user = null; // reset firebase user reference

      userId = 'undefined';
      email = 'undefined';
      name = 'undefined';
      phone = 'undefined';
      team = 'undefined';
      role = 'undefined';
      lastLogin = null;

      notifyListeners();
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  // called on login
  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // fetch user information from database given an auth user
  Future<void> fetchUserInfoFromDatabase(User user) async {
    try {
      final userDoc = await FirestoreService.usersCollection.doc(user.uid).get();

      if (userDoc.exists) {
        final data = userDoc.data()!;

        userId = userDoc.id;
        email = data['email'] as String? ?? 'undefined';
        name = data['name'] as String? ?? 'undefined';
        phone = data['phone'] as String? ?? 'undefined';
        team = data['team'] as String? ?? 'undefined';
        role = data['role'] as String? ?? 'undefined';
        lastLogin = data['lastLogin'] as Timestamp?;

        notifyListeners();
      } else {
        throw Exception("User Document does not Exist");
      }
    } catch (e) {
      print("Failed to fetch user info: $e");
      // logout();
    }
  }
}
