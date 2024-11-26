import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:progrid/pages/report_creation_page.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

class TowerPage extends StatefulWidget {
  final String towerId; // id of the selected tower
  // had to implement this over indexing due to query system that is already in place, and I wanted to solely rely on the provider

  const TowerPage({super.key, required this.towerId});

  @override
  State<TowerPage> createState() => _TowerPageState();
}

class _TowerPageState extends State<TowerPage> {
  late Tower selectedTower; // TODO: instancing might cause update problems

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);

    // fetch tower from provider
    selectedTower = towersProvider.towers.firstWhere(
      (tower) => tower.id == widget.towerId,
      orElse: () => throw Exception('Tower not found'),
    );

    return Scaffold(
      // use appbar for back buttons
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          icon: Icon(Icons.arrow_back, size: 34),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          selectedTower.id,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Hero(
        // TODO: fix expanded transition overflow
        tag: 'item ${selectedTower.id}',
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
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
                      // :)
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: selectedTower.status == 'Surveyed'
                            ? AppColors.green
                            : AppColors.red,
                      ),
                      child: Text(
                        selectedTower.status,
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

                SizedBox(
                  width: double.infinity,
                  height: 1,
                  child: Container(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 20),

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
                    IconButton(
                      icon: Icon(Icons.edit_note, size: 34),
                      onPressed: () {
                        // TODO: implement engineer-side site editing
                      },
                    )
                  ],
                ),
                const SizedBox(height: 0),

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
                  'All Site Reports',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                              ReportCreationPage(towerId: selectedTower.id))),
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
                  // TODO: fix overflow issues
                  child: selectedTower.reports.isEmpty
                      ? Center(
                          child: Text(
                          "...",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14),
                        ))
                      : ListView.builder(
                          itemCount: selectedTower.reports.length,
                          itemBuilder: (context, index) {
                            final report = selectedTower.reports[index];
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
                                        const SizedBox(height: 5),
                                        Text(
                                          report.authorId,
                                        ),
                                      ],
                                    ),

                                    // right side
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
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
                FilledButton(onPressed: () {}, child: Text("View Issues")),
                const SizedBox(height: 20),
              ],
            ),
          ),
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
