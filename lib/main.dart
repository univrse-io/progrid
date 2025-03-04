import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/issue.dart';
import 'models/tower.dart';
import 'providers/issues_provider.dart';
import 'providers/towers_provider.dart';
import 'providers/user_provider.dart';
import 'services/auth_wrapper.dart';
import 'services/firestore.dart';
import 'utils/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
  //     overlays: [SystemUiOverlay.bottom]); // disable ios top bar
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          if (kIsWeb)
            StreamProvider<List<Issue>>(
              create: (_) => FirestoreService.issuesStream,
              initialData: const [],
            ),
          if (kIsWeb)
            StreamProvider<List<Tower>>(
              create: (_) => FirestoreService.towersStream,
              initialData: const [],
            ),
          ChangeNotifierProvider(create: (_) => UserProvider()),
          if (!kIsWeb) ChangeNotifierProvider(create: (_) => TowersProvider()),
          if (!kIsWeb) ChangeNotifierProvider(create: (_) => IssuesProvider()),
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
