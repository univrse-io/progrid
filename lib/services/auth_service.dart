import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:progrid/components/my_loader.dart';
import 'package:progrid/pages/admin/home_page.dart';
import 'package:progrid/pages/debug/home_page.dart';
import 'package:progrid/pages/engineer/home_page.dart';
import 'package:progrid/pages/login_page.dart';
import 'package:progrid/pages/register_page.dart';
import 'package:progrid/pages/sapura/home_page.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/models/user_information.dart';

// the 'AuthService' class always runs in the background
// uses a streambuilder to monitor firebaseauth state, useful for login and logout from any location in the application
// the entire app is run on a scaffold on this page

class AuthService extends StatefulWidget {
  const AuthService({super.key});

  @override
  State<AuthService> createState() => _AuthServiceState();
}

class _AuthServiceState extends State<AuthService> {
  bool onLoginPage = true;

  void toggleLoginPage() {
    setState(() {
      onLoginPage = !onLoginPage;
    });
  }

  // fetch relevant database information
  Future<void> _fetchFromDatabase(User user) async {
    try {
      // call singletons
      await UserInformation().fetchUserInfo(user);
      await TowerService().fetchTowers();
    } catch (e) {
      print("Error Fetching Information: $e");
    }
  }

  Future<void> _autoLogin() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      // reload local user cache
      await user.reload();
      // if (mounted) Navigator.pop(context);
    } catch (e) {
      print("Error during AutoLogin: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = snapshot.data;

          if (user != null) {
            // wait for database fetching to complete
            return FutureBuilder<void>(
              future: _fetchFromDatabase(user),
              builder: (context, fetchSnapshot) {
                if (fetchSnapshot.connectionState == ConnectionState.waiting) {
                  // wait for data to fetch
                  return const MyLoadingIndicator();
                } else if (fetchSnapshot.hasError) {
                  return const Center(
                    child: Text("Failed to fetch data from database"),
                  );
                }

                // successful data load, navigate based on user type
                switch (UserInformation().userType) {
                  case 'engineer':
                    return const EngineerHomePage();
                  case 'sapura':
                    return const SapuraHomePage();
                  case 'admin':
                    return const AdminHomePage();
                  case 'debug':
                    return const DebugHomePage();
                  default:
                    throw Exception("Could not Determine User Type");
                }
              },
            );
          }

          // case that user is not logged in
          return Scaffold(
            body: onLoginPage
                ? LoginPage(
                    onTapSwitchPage: toggleLoginPage,
                  )
                : RegisterPage(
                    onTapSwitchPage: toggleLoginPage,
                  ),
          );
        },
      ),
    );
  }
}
