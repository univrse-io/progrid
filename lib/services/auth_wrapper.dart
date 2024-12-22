import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/providers/issues_provider.dart';
import 'package:progrid/models/providers/towers_provider.dart';
import 'package:progrid/models/providers/user_provider.dart';
import 'package:progrid/pages/authentication/login_page.dart';
import 'package:progrid/pages/authentication/register_page.dart';
import 'package:progrid/pages/dashboard/dashboard_page.dart';
import 'package:progrid/pages/map_page.dart';
import 'package:progrid/pages/user_verification_page.dart';
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

  // autologin
  Future<void> _autoLogin() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return;

    try {
      // reload user cache
      await user.reload();
    } catch (e) {
      print("Error during AutoLogin: $e");
    }
  }

  // init
  @override
  void initState() {
    super.initState();
    _autoLogin();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user != null) {
          // check email user verification status
          if (!user.emailVerified) {
            // !!do not implement any sort of push navigation in this class!!
            // go to email verification page
            _onLoginPage = true;
            return UserVerificationPage();
          }

          // fetch user info and set user provider
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              // load user information
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.setUser(user);
              userProvider.fetchUserInfoFromDatabase(user);

              // connect to database
              Provider.of<TowersProvider>(context, listen: false).loadTowers();
              Provider.of<IssuesProvider>(context, listen: false).loadIssues();

              // reset to login page in background
              _onLoginPage = true;
            },
          );

          return kIsWeb ? DashboardPage() : MapPage();
        }

        // if no user authenticated
        return _onLoginPage
            ? LoginPage(onTapSwitchPage: _toggleLoginPage)
            : RegisterPage(onTapSwitchPage: _toggleLoginPage);
      },
    );
  }
}
