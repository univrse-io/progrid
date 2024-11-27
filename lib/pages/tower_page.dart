import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:progrid/pages/issues_list_page.dart';
import 'package:progrid/pages/report_creation_page.dart';
import 'package:progrid/utils/themes.dart';

class TowerPage extends StatelessWidget {
  final Tower tower;

  const TowerPage({super.key, required this.tower});

  @override
  Widget build(BuildContext context) => Scaffold(
        // use appbar for back buttons
        appBar: AppBar(
          leading: IconButton(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            icon: Icon(Icons.arrow_back, size: 34),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            tower.id,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: SafeArea(
          minimum: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 5),

              // columns exists solely for animation
              // TODO: fix renderflex overflow on transition
              Hero(
                tag: 'item ${tower.id}',
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      // tower name
                      Text(
                        tower.name,
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
                            // :)
                            '${tower.position.latitude.toStringAsFixed(6)}, ${tower.position.longitude.toStringAsFixed(6)}',
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: tower.status == 'Surveyed'
                                  ? AppColors.green
                                  : AppColors.red,
                            ),
                            child: Text(
                              tower.status,
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
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: double.infinity,
                height: 1,
                child: Container(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
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
                  // IconButton(
                  //   icon: Icon(Icons.edit_note, size: 34),
                  //   onPressed: () {
                  //     // implement engineer-side site editing?
                  //   },
                  // )
                ],
              ),
              const SizedBox(height: 4),

              // site address
              _buildDetailRow('Address:', tower.address),
              // site region
              _buildDetailRow('Region:', tower.region),
              // site type
              _buildDetailRow('Type:', tower.type),
              // site owner
              _buildDetailRow('Owner:', tower.owner),
              const SizedBox(height: 20),

              const Text(
                'Site Reports',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    // Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => ReportCreationPage(towerId: selectedTower.id))),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ReportCreationPage(towerId: tower.id))),
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
              // reports list
              Expanded(
                child: tower.reports.isEmpty
                    ? Center(
                        child: Text(
                          "No Report History...",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14),
                        ),
                      )
                    : ListView.builder(
                        itemCount: tower.reports.length,
                        itemBuilder: (context, index) {
                          final report = tower.reports[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SafeArea(
                              minimum: EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // left side
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // report id
                                      Text(
                                        report.id,
                                      ),
                                      Text(
                                        report.authorName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // right side
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        DateFormat('dd/MM/yy')
                                            .format(report.dateTime.toDate()),
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
                          );
                        },
                      ),
              ),
              // TODO: implement site issues
              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IssuesListPage(towerId: tower.id),
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
                fontSize: 17,
              ),
            ),
          ),
          const SizedBox(width: 5),

          // content (potentially multiline)
          Expanded(
            flex: 20,
            child: Text(
              content,
              style: TextStyle(
                fontSize: 17,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
