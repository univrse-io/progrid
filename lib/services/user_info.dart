// singleton class that stores current user information
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInformation {
  UserInformation._privateConstructor();
  static final UserInformation _instance = UserInformation._privateConstructor();

  factory UserInformation() {
    return _instance;
  }

  // assigned on autologin
  String userId = 'undefined';
  String email = 'undefined';
  String userType = 'undefined';

  void updateUserInfo(String id, String email, String userType) {
    userId = id;
    this.email = email;
    this.userType = userType;
  }

  void reset() {
    userId  = 'undefined';
    email = 'undefined';
    userType = 'undefined';
  }

  // fetches user information from database given auth user
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
      print("Failed to fetch user infe: $e");
    }
  }
}
