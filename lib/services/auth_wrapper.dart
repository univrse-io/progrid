import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrid/components/my_loader.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:progrid/models/user_provider.dart';
import 'package:progrid/pages/authentication/login_page.dart';
import 'package:progrid/pages/authentication/register_page.dart';
import 'package:progrid/pages/main/towers_list_page.dart';
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
  Future<void> _fetchFromDatabase(User user) async {
    try {
      await Provider.of<UserProvider>(context, listen: false).fetchUserInfoFromDatabase(user);
    } catch (e) {
      print("Error Fetching Information: $e");
    }
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

    // autologin then load towers, order is ensured
    _autoLogin().then((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<TowersProvider>(context, listen: false).fetchTowers();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        if (user != null) {
          return FutureBuilder(
            future: _fetchFromDatabase(user),
            builder: (context, fetchSnapshot) {
              if (fetchSnapshot.connectionState == ConnectionState.waiting) {
                return const MyLoadingIndicator();
              }

              // successful data load
              // update user after frame built
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  final userProvider = Provider.of<UserProvider>(context, listen: false);
                  userProvider.setUser(user); // this should set to 'null' if user is signed out
                },
              );

              // multi user type fallback
              switch (Provider.of<UserProvider>(context, listen: false).role) {
                case 'debug':
                  return const TowersListPage();
                default:
                  return const Center(child: Text("Placeholder Page"));
              }
            },
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: _onLoginPage ? LoginPage(onTapSwitchPage: _toggleLoginPage) : RegisterPage(onTapSwitchPage: _toggleLoginPage),
        );
      },
    );
  }
}
