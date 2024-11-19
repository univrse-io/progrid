import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrid/components/alert.dart';

import 'package:progrid/components/my_button.dart';
import 'package:progrid/components/my_loader.dart';
import 'package:progrid/components/my_textfield.dart';
import 'package:progrid/pages/forgot_password_page.dart';

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
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");

      if (mounted) {
        Navigator.pop(context);
        displayMessage(e.code, context);
      }
      _passwordController.clear();
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

                // email textfield
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
                const SizedBox(height: 18),

                // link to register page
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not a member? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    GestureDetector(
                      onTap: widget.onTapSwitchPage,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 7),

                // forgot password?
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
