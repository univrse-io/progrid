import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        foregroundImage: NetworkImage(
                          'https://api.dicebear.com/9.x/dylan/png?seed=${user?.displayName}&scale=80',
                        ),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user?.displayName}',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          // TODO: Admin checker
                          // Text(
                          //   '${user.role[0].toUpperCase()}${user.role.substring(1)}',
                          // ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.email_outlined),
                    title: Text('${user?.email}'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone_outlined),
                    title: Text('${user?.phoneNumber}'),
                  ),
                  // TODO: Team checker
                  // ListTile(
                  //   leading: const Icon(Icons.group),
                  //   title: Text(user.team),
                  // ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) Navigator.pop(context);
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
