import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      Colors.primaries[user?.displayName?.length ?? 0],
                  foregroundImage:
                      user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : null,
                  child: Text(
                    '${user?.displayName?.splitMapJoin(' ', onMatch: (_) => '', onNonMatch: (n) => n[0])}',
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
            const Spacing.$6(),
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
              title: Text(context.watch<bool>() ? 'Admin' : 'Engineer'),
            ),
            const Spacing.$6(),
            // TODO: Edit displayName, photoURL and phoneNumber.
            // CarbonPrimaryButton(
            //   onPressed: () async {
            //     await FirebaseAuth.instance.signOut();
            //     if (context.mounted) Navigator.pop(context);
            //   },
            //   label: 'Edit profile',
            //   icon: CarbonIcon.edit,
            // ),
            // const Spacing.$5(),
            CarbonDangerPrimaryButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) Navigator.pop(context);
              },
              label: 'Logout',
              icon: CarbonIcon.logout,
            ),
          ],
        ),
      ),
    );
  }
}
