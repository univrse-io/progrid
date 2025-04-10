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
import 'pages/dashboard/dashboard_page.dart';
import 'pages/map_page.dart';
import 'pages/user_verification_page.dart';
import 'services/firebase_firestore.dart';
import 'utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(
    MultiProvider(
      providers: [
        StreamProvider<List<Issue>>(
          initialData: const [],
          create: (_) => FirebaseFirestoreService().issuesStream,
        ),
        StreamProvider<List<Tower>>(
          initialData: const [],
          create: (_) => FirebaseFirestoreService().towersStream,
        ),
        StreamProvider<User?>(
          initialData: null,
          create: (_) => FirebaseAuth.instance.userChanges(),
        ),
        FutureProvider<bool>(
          initialData: false,
          create: (context) async {
            final user = context.read<User?>();
            final token = await user?.getIdTokenResult();
            final isAdmin = token?.claims?['admin'] as bool?;

            return isAdmin ?? false;
          },
        ),
      ],
      child: const Progrid(),
    ),
  );
}

class Progrid extends StatelessWidget {
  const Progrid({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Progrid',
        theme: lightTheme,
        home: Consumer<User?>(
          builder: (_, user, __) => user == null
              ? const LoginPage()
              : !user.emailVerified
                  ? const UserVerificationPage()
                  : kIsWeb
                      ? const DashboardPage()
                      : const MapPage(),
        ),
      );
}
