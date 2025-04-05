import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/issue.dart';
import 'models/tower.dart';
import 'pages/authentication/login_page.dart';
import 'pages/authentication/register_page.dart';
import 'pages/dashboard/dashboard_page.dart';
import 'pages/map_page.dart';
import 'pages/user_verification_page.dart';
import 'services/firestore.dart';
import 'utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const Progrid());
}

class Progrid extends StatelessWidget {
  const Progrid({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          StreamProvider<List<Issue>>(
            initialData: const [],
            create: (_) => FirestoreService.issuesStream,
          ),
          StreamProvider<List<Tower>>(
            initialData: const [],
            create: (_) => FirestoreService.towersStream,
          ),
          StreamProvider<User?>(
            initialData: null,
            create: (_) => FirebaseAuth.instance.userChanges(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Progrid',
          theme: lightTheme,
          // darkTheme: darkTheme,
          home: const AuthWrapper(),
        ),
      );
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _onLoginPage = true;

  void _toggleLoginPage() => setState(() => _onLoginPage = !_onLoginPage);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (user != null) {
      if (!user.emailVerified) {
        // !!do not implement any sort of push navigation in this class!!
        // go to email verification page
        _onLoginPage = true;
        return const UserVerificationPage();
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _onLoginPage = true; // reset to login page in background
      });

      return kIsWeb ? const DashboardPage() : const MapPage();
    }
    return _onLoginPage
        ? LoginPage(onTapSwitchPage: _toggleLoginPage)
        : RegisterPage(onTapSwitchPage: _toggleLoginPage);
  }
}
