import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrid/widgets/my_alert.dart';
import 'package:progrid/widgets/my_button.dart';
import 'package:progrid/widgets/my_textfield.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  // forgot password
  Future<void> forgotPassword() async {
    final String email = _emailController.text.trim();

    if (email.isEmpty) {
      displayMessage("Please Enter an Email Address", context);
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (mounted) {
        Navigator.pop(context);
        displayMessage("Password reset email sent. Check your inbox", context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) displayMessage(e.message!, context);
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
            padding: const EdgeInsets.all(20),
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
                // forgot password text
                Text(
                  'Forgot Password?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 14),

                // email field
                MyTextField(
                  hintText: 'Email',
                  controller: _emailController,
                ),
                const SizedBox(height: 10),

                // confirm button
                MyButton(
                  onTap: forgotPassword,
                  text: 'Confirm',
                ),
                const SizedBox(height: 14),

                // back link
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    }, // go back to login
                    child: Text(
                      "Go Back",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
