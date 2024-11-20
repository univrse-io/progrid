import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:progrid/components/my_loader.dart';
import 'package:progrid/pages/admin/home_page.dart';
import 'package:progrid/pages/engineer/home_page.dart';
import 'package:progrid/pages/login_page.dart';
import 'package:progrid/pages/register_page.dart';
import 'package:progrid/pages/sapura/home_page.dart';
import 'package:progrid/services/objects/tower.dart';
import 'package:progrid/services/objects/user.dart';

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
      // if (mounted) {
      //   showDialog(
      //     context: context,
      //     builder: (context) => const Center(
      //       child: MyLoadingIndicator(),
      //     ),
      //   );
      // }

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
      // streambuilder listens to auth state at all times
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          final user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            // then, wait for database fetching to complete before moving to main UI
            return FutureBuilder(
              future: _fetchFromDatabase(user),
              builder: (context, AsyncSnapshot<void> fetchSnapshot) {
                if (fetchSnapshot.connectionState == ConnectionState.waiting) {
                  // TODO: resolve this double buffer screen
                  // issue: firebase auth and database fetching are run separately and asynchronously
                  // should be run consecutively, fetch done after login
                  // solution: login() should call fetchuserinfo?
                  
                  // still fetching from database
                  return const MyLoadingIndicator();
                } else if (fetchSnapshot.hasError) {
                  return const Center(
                    // TODO: implement better user feedback here
                    child: Text("Failed to fetch data from database"),
                  );
                }

                // on successful load, navigate to designated page based on user type
                switch (UserInformation().userType) {
                  case 'engineer':
                    return const EngineerHomePage();
                  case 'sapura':
                    return const SapuraHomePage();
                  case 'admin':
                    return const AdminHomePage();
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
