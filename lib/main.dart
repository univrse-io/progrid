import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:progrid/models/user_provider.dart';
import 'package:progrid/services/auth_wrapper.dart';
import 'package:progrid/services/themes.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: GlobalThemeData.lightThemeData,
        home: const AuthWrapper(),
      ),
    );
  }
}
