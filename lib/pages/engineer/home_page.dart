import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrid/components/my_button.dart';
import 'package:progrid/services/user_info.dart';

// Standard Engineer Home Page
class EngineerHomePage extends StatefulWidget {
  const EngineerHomePage({super.key});

  @override
  State<EngineerHomePage> createState() => _EngineerHomePageState();
}

class _EngineerHomePageState extends State<EngineerHomePage> {
  void logout() {
    UserInformation().reset();
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final userInformation = UserInformation();

    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Engineer Home Page"),
            const SizedBox(height: 10),

            Text("User ID: ${userInformation.userId}"),
            Text("Email: ${userInformation.email}"),
            Text("User Type: ${userInformation.userType}"),

            const SizedBox(height: 10),

            // logout button
            MyButton(
              onTap: logout,
              text: "Logout",
            )
          ],
        )),
      ),
    );
  }
}
