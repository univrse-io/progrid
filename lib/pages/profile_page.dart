import 'dart:developer';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// TODO: Edit displayName, photoURL and phoneNumber.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    if (user != null) log(user.toString());

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: ListTileTheme(
        tileColor: Colors.transparent,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(kIsWeb ? 24 : 16),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    foregroundImage: NetworkImage(
                      user?.photoURL ??
                          'https://api.dicebear.com/9.x/dylan/png?seed=${user?.displayName}&scale=80',
                    ),
                  ),
                  const Spacing.$6(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user?.displayName ?? 'N/A',
                        style: CarbonTextStyle.heading04,
                      ),
                      if (user?.metadata.creationTime != null)
                        Text(
                          'Since ${DateFormat('d MMMM y').format(user!.metadata.creationTime!)}',
                        ),
                    ],
                  ),
                ],
              ),
              const Spacing.$5(),
              const Divider(),
              ListTile(
                leading: const Icon(CarbonIcon.email),
                title: Text(user?.email ?? 'N/A'),
              ),
              ListTile(
                leading: const Icon(CarbonIcon.phone),
                title: Text(user?.phoneNumber ?? 'N/A'),
              ),
              ListTile(
                leading: const Icon(CarbonIcon.user_role),
                title: Text(context.watch<bool>() ? 'Admin' : 'N/A'),
              ),
              const Spacing.$9(),
              FilledButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
