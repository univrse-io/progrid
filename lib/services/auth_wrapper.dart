import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/providers/tower_provider.dart';
import 'package:progrid/models/providers/user_provider.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/pages/authentication/login_page.dart';
import 'package:progrid/pages/authentication/register_page.dart';
import 'package:progrid/pages/dashboard_page.dart';
import 'package:progrid/pages/map_page.dart';
import 'package:provider/provider.dart';

// TODO: fetch towers only during initialization, no reports or issues
// TODO: fetch issues and reports only when a tower is clicked, should we delete them locally on exit?

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
          // fetch user info and set user provider
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              userProvider.setUser(user);
              userProvider.fetchUserInfoFromDatabase(user);
            },
          );

          // get towers data stream
          return StreamBuilder<List<Tower>>(
            stream: Provider.of<TowersProvider>(context).getTowersStream(),
            builder: (context, towerSnapshot) {
              if (towerSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                    body: Center(child: CircularProgressIndicator()));
              }

              if (towerSnapshot.hasError) {
                return const Scaffold(
                    body: Center(child: Text('Error loading towers')));
              }

              return kIsWeb ? DashboardPage() : MapPage();
            },
          );
        }

        // if no user authenticated
        return _onLoginPage
            ? LoginPage(onTapSwitchPage: _toggleLoginPage)
            : RegisterPage(onTapSwitchPage: _toggleLoginPage);
      },
    );
  }
}
