import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dashboard_page.dart';
import 'profile_page.dart';
import 'site_progress_page.dart';

class WebPage extends StatefulWidget {
  const WebPage({super.key});

  @override
  State<WebPage> createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  late final carbonToken = Theme.of(context).extension<CarbonToken>();

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
      backgroundColor: carbonToken?.layer01,
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/progrid_black.png', height: 35),
            const Expanded(
              child: TabBar(
                isScrollable: true,
                tabs: [
                  Tab(icon: Text('Dashboard')),
                  Tab(icon: Text('Site Progress')),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Card.filled(
            color: Colors.black12,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CarbonIcon.calendar),
                  const Spacing.$3(),
                  StreamBuilder<DateTime>(
                    stream: currentUpdatedTime(),
                    builder:
                        (context, snapshot) => Text(
                          DateFormat(
                            'dd/MM/y  hh:mm a',
                          ).format(snapshot.data ?? DateTime.now()),
                        ),
                  ),
                  const Spacing.$3(),
                ],
              ),
            ),
          ),
          const Spacing.$2(),
          IconButton(
            onPressed:
                () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const ProfilePage())),
            icon: const Icon(CarbonIcon.user),
          ),
          const Spacing.$2(),
        ],
      ),
      body: const TabBarView(children: [DashboardPage(), SiteProgressPage()]),
    ),
  );
}
