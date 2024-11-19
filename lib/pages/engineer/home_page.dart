import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrid/components/my_button.dart';

// Standard Engineer Home Page
class EngineerHomePage extends StatelessWidget {
  const EngineerHomePage({super.key});

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Engineer Home Page"),
              const SizedBox(height: 10),

              // logout button
              MyButton(
                onTap: logout,
                text: "Logout",
              )
            ],
          )
        ),
      ),
    );
  }
}