import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progrid/models/report.dart';

class ReportPage extends StatelessWidget {
  final String towerId;
  final String reportId;

  const ReportPage({super.key, required this.reportId, required this.towerId});

  @override
  Widget build(BuildContext context) {
    // fetch reports stream directly given towerId
    final reportsStream = FirebaseFirestore.instance
        .collection('towers')
        .doc(towerId)
        .collection('reports')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          reportId,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: StreamBuilder<List<Report>>(
          stream: reportsStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No reports data found.'));
            }

            // fine report
            final report = snapshot.data!.firstWhere(
              (report) => report.id == reportId,
              orElse: () => throw Exception('Report not found'),
            );

            // display report data
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 5),

                // images
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
                if (report.images.isNotEmpty)
                  Container(
                    height: 200,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: report.images.length,
                      itemBuilder: (context, index) {
                        return Image.network(report.images[index]);
                      },
                    ),
                  ),
                const SizedBox(height: 20),

                // description
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
                  report.notes,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
