import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:progrid/pages/authentication/forgot_password_page.dart';
import 'package:progrid/services/firestore.dart';
import 'package:progrid/utils/themes.dart';

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
  Future<void> _login() async {
    print('running login function');

    // try to sign in
    try {
      // firebase auth
      final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      await FirestoreService.updateUser(credentials.user!.uid, data: {'lastLogin': Timestamp.now()});

      print('login success');
    } on FirebaseAuthException catch (e) {
      print("Error: ${e.message}");

      if (mounted) showDialog(context: context, builder: (_) => AlertDialog(title: Text(e.code)));
      _passwordController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        minimum: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // app logo
                Image.asset(
                  'assets/images/progrid_black.png',
                  width: 300,
                  // fit: BoxFit.cover,
                ),
                const SizedBox(height: 15),
            
                Container(
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
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // welcome text
                        Text(
                          'Welcome Back!\nGlad to see you again.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                          ),
                          controller: _passwordController,
                        ),
                        const SizedBox(height: 7),
            
                        // forgot password?
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Align(
                            alignment: Alignment.centerRight,
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
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.italic,
                                  decoration: TextDecoration.underline,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        FilledButton(onPressed: _login, child: Text('Login')),
                        const SizedBox(height: 14),
            
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
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 15),
            
                // logos bottom set
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // sapura logo
                    Image.asset(
                      'assets/images/sapura.png',
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
            
                    // binasat logo
                    Image.asset(
                      'assets/images/binasat.png',
                      width: 55,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
            
                    // uos logo
                    Image.asset(
                      'assets/images/uos.png',
                      width: 55,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 12),
            
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'Powered by ',
                      style: TextStyle(color: AppColors.onSurface),
                    ),
                    Text(
                      'UniVRse',
                      style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
