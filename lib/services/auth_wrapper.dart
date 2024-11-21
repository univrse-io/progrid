import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:progrid/components/my_loader.dart';
import 'package:progrid/models/user_provider.dart';
import 'package:progrid/pages/debug/home_page.dart';
import 'package:progrid/pages/login_page.dart';
import 'package:progrid/pages/register_page.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _onLoginPage = true;

  void _toggleLoginPage() {
    setState(() {
      _onLoginPage = !_onLoginPage;
    });
  }

  // fetch from database

  // autologin

  // init

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MyLoadingIndicator();
        }

        final user = snapshot.data;

        if (user != null) {
          // Update the user in the provider after the frame has been built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final userProvider = Provider.of<UserProvider>(context, listen: false);
            userProvider.setUser(user);
          });

          return const DebugHomePage();
        }

        // Show Login or Register page
        return _onLoginPage 
            ? LoginPage(onTapSwitchPage: _toggleLoginPage)
            : RegisterPage(onTapSwitchPage: _toggleLoginPage);
      },
    );
  }
}
