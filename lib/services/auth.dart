import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrid/pages/login_page.dart';
import 'package:progrid/pages/register_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // user has already logged in before
          if (snapshot.hasData) {
            // TODO: Implement the home page
            return const Center(child: Text("Home Page (User logged in)"));
          }

          // user not logged in
          else {
            if (showLoginPage) {
              return LoginPage(
                onTapSwitchPage: togglePages,
              );
            } else {
              return RegisterPage(
                onTapSwitchPage: togglePages,
              );
            }
          }
        },
      ),
    );
  }
}
