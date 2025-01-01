import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:progrid/firebase_options.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/providers/issues_provider.dart';
import 'package:progrid/providers/towers_provider.dart';
import 'package:progrid/providers/user_provider.dart';
import 'package:progrid/services/auth_wrapper.dart';
import 'package:progrid/services/firestore.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = Settings(persistenceEnabled: true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          if (kIsWeb)
            StreamProvider<List<Tower>>(
                create: (_) => FirestoreService.towersStream, initialData: []),
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
