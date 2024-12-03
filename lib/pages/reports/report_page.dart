import 'package:flutter/material.dart';
import 'package:progrid/models/providers/tower_provider.dart';
import 'package:progrid/models/report.dart';
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  final String towerId;
  final String reportId;

  const ReportPage({super.key, required this.reportId, required this.towerId});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  late Report selectedReport;

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);

    // fetch report from provider
    selectedReport = towersProvider.towers
        .firstWhere(
          (tower) => tower.id == widget.towerId,
          orElse: () => throw Exception('Tower not found'),
        )
        .reports
        .firstWhere(
          (report) => report.id == widget.reportId,
          orElse: () => throw Exception('Report not found'),
        );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reportId,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5),

            // display report images
            Row(
              children: [
                const Text(
                  'Pictures',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.image, size: 24),
              ],
            ),
            if (selectedReport.images.isNotEmpty)
              Container(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: selectedReport.images.length,
                  itemBuilder: (context, index) {
                    return Image.network(selectedReport.images[index]);
                  },
                ),
              ),
            const SizedBox(height: 20,),

            // report description
            Row(
              children: [
                const Text(
                  'Description',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.file_copy, size: 24),
              ],
            ),
            Text(
              selectedReport.notes,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
