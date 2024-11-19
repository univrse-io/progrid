import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:progrid/components/my_loader.dart';
import 'package:progrid/pages/engineer/home_page.dart';
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

  Future<void> _autoLogin() async {
    User? user = FirebaseAuth.instance.currentUser;

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
            body: showLoginPage
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

  // @override
  // Widget build(BuildContext context) {
  //   final user = FirebaseAuth.instance.currentUser;

  //   if (user != null) {
  //     return const Scaffold(
  //       body: EngineerHomePage(),
  //     );
  //   }

  //   // user not logged in
  //   return Scaffold(
  //     body: showLoginPage
  //         ? LoginPage(
  //             onTapSwitchPage: togglePages,
  //           )
  //         : RegisterPage(
  //             onTapSwitchPage: togglePages,
  //           ),
  //   );
  // }
}
