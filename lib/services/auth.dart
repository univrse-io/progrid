import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:progrid/components/my_loader.dart';
import 'package:progrid/pages/engineer/home_page.dart';
import 'package:progrid/pages/login_page.dart';
import 'package:progrid/pages/register_page.dart';

// stores currently logged-in user information
class UserInformation {
  String id;
  String email;
  String userType;

  UserInformation({
    required this.id,
    required this.email,
    required this.userType,
  });

  Future<void> fetchUserInfo() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(id).get();

    if (userDoc.exists) {
      final data = userDoc.data()!;
      email = data['email'] ?? '';
      userType = data['userType'] ?? 'default';
    }
  }

  // update user info (restrictive)
  void updateUserInfo(String userType) {
    this.userType = userType;
  }

  // create instance from firebaseauth
  factory UserInformation.fromFirebaseAuthUser(User user) {
    return UserInformation(
      id: user.uid,
      email: user.email!,
      userType: 'undefined',
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  UserInformation? userInformation;
  bool onLoginPage = true;

  void togglePages() {
    setState(() {
      onLoginPage = !onLoginPage;
    });
  }

  Future<void> _autoLogin() async {
    User? user = FirebaseAuth.instance.currentUser;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const MyLoadingIndicator(),
        );
      }

      try {
        if (user != null) {
          // refresh user token
          await user.reload();
        }
      } catch (e) {
        print("Error during auto-login: $e");
      } finally {
        if (mounted) {
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // attempt autologin on app start
    _autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = FirebaseAuth.instance.currentUser;

          // user has already logged in
          if (user != null) {
            // TODO: Implement multiple home pages
            return const Scaffold(
              body: EngineerHomePage(),
            );
          }

          // user not logged in
          return Scaffold(
            body: onLoginPage
                ? LoginPage(
                    onTapSwitchPage: togglePages,
                  )
                : RegisterPage(
                    onTapSwitchPage: togglePages,
                  ),
          );
        },
      ),
    );
  }
}
