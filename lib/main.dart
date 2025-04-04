import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/issue.dart';
import 'models/tower.dart';
import 'providers/user_provider.dart';
import 'services/auth_wrapper.dart';
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
          ChangeNotifierProvider(create: (_) => UserProvider()),
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
