import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  User? _user;
  User? get user => _user;

  // implement other user information here
  // firestore document id = user id
  String userId = 'undefined';
  String email = 'undefined';
  String userType = 'undefined';

  void updateUserInfo(String id, String email, String userType) {
    userId = id;
    this.email = email;
    this.userType = userType;
    notifyListeners();
  }

  void logout() {
    userId  = 'undefined';
    email = 'undefined';
    userType = 'undefined';

    FirebaseAuth.instance.signOut();
    notifyListeners();
  }

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  // fetch user information from database given auth user
  Future<void> fetchUserInfo(User user) async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      DocumentSnapshot userDoc = await firestore.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        String userType = data['userType'];

        updateUserInfo(user.uid, user.email ?? '', userType);
      } else {
        throw Exception("User Document does not Exist");
      }
    } catch (e) {
      print("Failed to fetch user info: $e");
    }
  }
}
