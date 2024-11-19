import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:progrid/components/my_alert.dart';
import 'package:progrid/components/my_button.dart';
import 'package:progrid/components/my_loader.dart';
import 'package:progrid/components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  // toggle to register page
  final void Function()? onTapSwitchPage;

  const LoginPage({
    super.key,
    required this.onTapSwitchPage,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // login user
  Future<void> login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: MyLoadingIndicator(),
      ),
    );

    // try to sign in
    try {
      // firebase auth
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => MyAlert(
            title: "Login Error",
            content: e.message ?? "An unknown error occurred.",
          ),
        );
      }
      _passwordController.clear();
    } finally {
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 350,
            padding: const EdgeInsets.all(20), // padding inside the box
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                // welcome text
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),

                // username textfield
                MyTextField(
                  hintText: 'email',
                  obscureText: false,
                  controller: _emailController,
                ),
                const SizedBox(height: 10),

                // password textfield
                MyTextField(
                  hintText: 'password',
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 10),

                // log in button
                MyButton(
                  onTap: login,
                  text: 'Log In',
                  height: 40,
                ),
                const SizedBox(height: 14),

                // link to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTapSwitchPage,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
