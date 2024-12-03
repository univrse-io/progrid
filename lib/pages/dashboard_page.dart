import 'package:flutter/material.dart';
import 'package:progrid/models/providers/tower_provider.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text('SAPURA GIRN - PROJECT MONITORING REPORT')),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...context
                  .watch<TowersProvider>()
                  .towers
                  .map((tower) => Text(tower.toString())),
            ],
          ),
        ),
      );
}
