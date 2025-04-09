// import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Stream<DateTime> currentUpdatedTime() async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      yield DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: Colors.grey.shade200,
            appBar: AppBar(
              title: Row(mainAxisSize: MainAxisSize.min, children: [
                Image.asset('assets/images/uos.png', height: 45),
                SizedBox(width: 20),
                Text('PROJECT MONITORING REPORT SYSTEM',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: TabBar(
                      isScrollable: true,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorColor: Colors.blueAccent.shade700,
                      labelStyle: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                      unselectedLabelStyle: TextStyle(color: Colors.black45),
                      indicatorWeight: 3,
                      dividerHeight: 0,
                      tabs: [
                        Tab(icon: Text('Home')),
                        Tab(icon: Text('Site Progress')),
                      ]),
                ),
              ]),
              actions: [
                Card.filled(
                  color: Colors.black12,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.schedule),
                        SizedBox(width: 5),
                        StreamBuilder<DateTime>(
                            stream: currentUpdatedTime(),
                            builder: (context, snapshot) => Text(
                                DateFormat('d/M/y h:m a')
                                    .format(snapshot.data ?? DateTime.now()))),
                        SizedBox(width: 5),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5),
                IconButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage())),
                    icon: Icon(Icons.person)),
                SizedBox(width: 5),
              ],
            ),
            body: TabBarView(children: [
              HomePage(),
              SiteProgressPage(),
            ])),
      );
}
