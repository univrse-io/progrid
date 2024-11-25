import 'package:flutter/material.dart';
import 'package:progrid/components/my_button.dart';
import 'package:progrid/models/user_provider.dart';
import 'package:progrid/pages/main/towers_list_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 20, top: 15),
          icon: Icon(Icons.logout, size: 31),
          onPressed: () => userProvider.logout(),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 20, top: 15),
            icon: Icon(Icons.person, size: 34),
            onPressed: () {}, // TODO: implement profile page
          ),
          IconButton(
            padding: EdgeInsets.only(right: 20, top: 15),
            icon: Icon(Icons.settings, size: 34),
            onPressed: () {}, // TODO: implement settings page
          ),
        ],
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 40,
              child: Container(),
            ),
            Text(
              "Welcome! '${userProvider.name}'",
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 4),
            const Text(
              'Qeury Database',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10),

            // search button
            Hero(
              tag: 'searchBar',
              child: Material(
                color: Colors.transparent,
                child: MyButton(
                  text: 'Open List',
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const TowersListPage(),
                        transitionsBuilder: (_, animation, __, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              flex: 60,
              child: Container(),
            ),
          ],
        ),
      ),
    );
  }
}
