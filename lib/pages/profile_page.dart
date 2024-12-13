import 'package:flutter/material.dart';
import 'package:progrid/models/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        foregroundImage: NetworkImage('https://api.dicebear.com/9.x/dylan/png?seed=${userProvider.name}&scale=80'),
                      ),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(userProvider.name, style: Theme.of(context).textTheme.headlineSmall),
                          Text('${userProvider.role[0].toUpperCase()}${userProvider.role.substring(1)}'), // capitalize
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.email_outlined),
                    title: Text(userProvider.email),
                  ),
                  ListTile(
                    leading: Icon(Icons.phone_outlined),
                    title: Text(userProvider.phone),
                  ),
                  ListTile(
                    leading: Icon(Icons.group),
                    title: Text(userProvider.team),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: FilledButton(
                onPressed: () async {
                  await userProvider.logout();
                  if (context.mounted) Navigator.pop(context);
                },
                child: Text('Logout')),
          )
        ],
      ),
    );
  }
}
