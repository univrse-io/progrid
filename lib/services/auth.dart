import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:progrid/components/my_loader.dart';
import 'package:progrid/pages/engineer/home_page.dart';
import 'package:progrid/pages/login_page.dart';
import 'package:progrid/pages/register_page.dart';
import 'package:progrid/pages/sapura/home_page.dart';
import 'package:progrid/services/user.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool onLoginPage = true;

  void togglePages() {
    setState(() {
      onLoginPage = !onLoginPage;
    });
  }

  Future<void> _fetchAndLogin() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // reload user auth
        await user.reload();

        // fetch user information from firestore here
        await UserInformation().fetchUserInfo(user);
      } catch (e) {
        print("Error during auto-login: $e");
      }
    });
  }

  @override
  void initState() {
    super.initState();

    // attempt autologin on app start
    _fetchAndLogin();
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
            return FutureBuilder(
              future: UserInformation().fetchUserInfo(user),
              builder: (context, AsyncSnapshot<void> fetchSnapshot) {
                if (fetchSnapshot.connectionState == ConnectionState.waiting) {
                  return const MyLoadingIndicator();
                } else if (fetchSnapshot.hasError) {
                  return const Center(
                    child: Text("Failed to load user information."),
                  );
                }

                switch (UserInformation().userType) {
                  case 'engineer':
                    return const EngineerHomePage();
                  case 'sapura':
                    return const SapuraHomePage();
                  default:
                    throw Exception("Could not Determine User Type");
                }
              },
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
