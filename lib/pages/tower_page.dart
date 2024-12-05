import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progrid/models/providers/tower_provider.dart';
import 'package:progrid/models/report.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/pages/issues/issues_list_page.dart';
import 'package:progrid/pages/reports/report_creation_page.dart';
import 'package:progrid/pages/reports/report_page.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

class TowerPage extends StatelessWidget {
  final String towerId;

  const TowerPage({super.key, required this.towerId});

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);
    final selectedTower = towersProvider.towers.firstWhere(
      (tower) => tower.id == towerId,
      orElse: () => throw Exception("Tower not found"),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedTower.id,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 5),
            // tower name
            Text(
              selectedTower.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),

            // tower geopoint
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'LatLong:',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  '${selectedTower.position.latitude.toStringAsFixed(6)}, ${selectedTower.position.longitude.toStringAsFixed(6)}',
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // tower status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Status:',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: selectedTower.status == 'surveyed' ? AppColors.green : AppColors.red,
                  ),
                  child: Text(
                    '${selectedTower.status[0].toUpperCase()}${selectedTower.status.substring(1)}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            Divider(),
            const SizedBox(height: 24),
            Row(
              children: [
                const Text(
                  'Site Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                Icon(
                  Icons.list,
                  size: 32,
                ),
              ],
            ),
            const SizedBox(height: 4),

            // site address
            _buildDetailRow('Address:', selectedTower.address),
            // site region
            _buildDetailRow('Region:', selectedTower.region),
            // site type
            _buildDetailRow('Type:', selectedTower.type),
            // site owner
            _buildDetailRow('Owner:', selectedTower.owner),
            const SizedBox(height: 20),

            const Text(
              'Site Reports',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ReportCreationPage(towerId: selectedTower.id))),
              child: Text(
                'Create New Report',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 5),

            Expanded(
              child: selectedTower.reports.isEmpty
                  ? Center(child: Text("No Report History..."))
                  : ListView.builder(
                      itemCount: selectedTower.reports.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final report = selectedTower.reports[index];
                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(report.authorId).get(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Error: ${snapshot.error}'));
                            } else if (!snapshot.hasData || !snapshot.data!.exists) {
                              return Center(child: Text('Author not found.'));
                            } else {
                              final authorName = snapshot.data!['name'] as String;

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReportPage(
                                        towerId: selectedTower.id,
                                        reportId: report.id,
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: SafeArea(
                                    minimum: EdgeInsets.all(12),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // left side
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            // report id
                                            Text(report.id,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                            // author name
                                            Text(
                                              authorName,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            // photo count
                                            Text(
                                              '${report.images.length} Photo(s)',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.secondary,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FontStyle.italic,
                                                fontSize: 13,
                                              ),
                                            )
                                          ],
                                        ),
                                        // right side
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              DateFormat('dd/MM/yy').format(report.dateTime.toDate()),
                                              style: TextStyle(fontSize: 15),
                                            ),
                                            const SizedBox(height: 10),
                                            Icon(
                                              Icons.arrow_right,
                                              size: 36,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
            ),

            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => IssuesListPage(towerId: selectedTower.id),
                  ),
                );
              },
              child: Text("View Issues"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // UI function to build a detail row format
  Widget _buildDetailRow(String label, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          SizedBox(
            width: 90,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // content
          Expanded(
            child: Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
