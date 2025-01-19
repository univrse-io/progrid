// import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:progrid/pages/dashboard/home_page.dart';
import 'package:progrid/pages/dashboard/site_progress_page.dart';
import 'package:progrid/pages/profile_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final pageController = PageController()
    ..addListener(() => Navigator.pop(context));

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/sapura.png', height: 40),
            SizedBox(width: 20),
            Image.asset('assets/images/binasat.png', height: 40),
            SizedBox(width: 20),
            Image.asset('assets/images/uos.png', height: 40),
            SizedBox(width: 20),
            Text('PROJECT MONITORING REPORT SYSTEM',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage())),
              icon: Icon(Icons.person)),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () => pageController.jumpToPage(0),
            ),
            ListTile(
              title: const Text('Site Progress'),
              onTap: () => pageController.jumpToPage(1),
            ),
          ],
        ),
      ),
      body: PageView(
          controller: pageController,
          children: [
            HomePage(),
            SiteProgressPage(),
          ],
          physics: NeverScrollableScrollPhysics()));
}
