import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progrid/models/providers/records_provider.dart';
import 'package:progrid/models/providers/towers_provider.dart';
import 'package:progrid/models/providers/user_provider.dart';
import 'package:progrid/pages/issues/issues_list_page.dart';
import 'package:progrid/models/record.dart';
import 'package:progrid/pages/records/record_page.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

class TowerPage extends StatefulWidget {
  final String towerId;

  const TowerPage({super.key, required this.towerId});

  @override
  State<TowerPage> createState() => _TowerPageState();
}

class _TowerPageState extends State<TowerPage> {
  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);
    final selectedTower = towersProvider.towers.firstWhere(
      (tower) => tower.id == widget.towerId,
      orElse: () => throw Exception("Tower not found"),
    );

    final recordsProvider = Provider.of<RecordsProvider>(context);
    final records = recordsProvider.records.where((record) => record.id.startsWith('${widget.towerId}-R'));

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

            // tower survey status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Survey:',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(width: 5),

                // dropdown
                Container(
                  padding: const EdgeInsets.only(left: 14, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: selectedTower.surveyStatus == 'surveyed'
                        ? AppColors.green
                        : selectedTower.surveyStatus == 'in-progress'
                            ? AppColors.yellow
                            : AppColors.red,
                  ),
                  child: DropdownButton(
                    isDense: true,
                    value: selectedTower.surveyStatus,
                    onChanged: (value) async {
                      if (value != null && value != selectedTower.surveyStatus) {
                        await FirebaseFirestore.instance.collection('towers').doc(selectedTower.id).update({'surveyStatus': value});
                        selectedTower.surveyStatus = value; // update local as well
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'surveyed',
                        child: Text('Surveyed'),
                      ),
                      DropdownMenuItem(
                        value: 'in-progress',
                        child: Text('In-Progress'),
                      ),
                      DropdownMenuItem(
                        value: 'unsurveyed',
                        child: Text('Unsurveyed'),
                      ),
                    ],
                    iconEnabledColor: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    dropdownColor: selectedTower.surveyStatus == 'surveyed'
                        ? AppColors.green
                        : selectedTower.surveyStatus == 'in-progress'
                            ? AppColors.yellow
                            : AppColors.red,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),

            // tower drawing status
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Drawing: ',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                  ),
                ),
                const SizedBox(width: 5),

                // dropdown
                Container(
                  padding: const EdgeInsets.only(left: 14, right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: selectedTower.drawingStatus == 'complete'
                        ? AppColors.green
                        : selectedTower.drawingStatus == 'submitted'
                            ? AppColors.yellow
                            : AppColors.red,
                  ),
                  child: DropdownButton(
                    isDense: true,
                    value: selectedTower.drawingStatus,
                    onChanged: (value) async {
                      if (value != null && value != selectedTower.drawingStatus) {
                        await FirebaseFirestore.instance.collection('towers').doc(selectedTower.id).update({'drawingStatus': value});
                        selectedTower.drawingStatus = value; // update local as well
                      }
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'complete',
                        child: Text('Complete'),
                      ),
                      DropdownMenuItem(
                        value: 'submitted',
                        child: Text('Submitted'),
                      ),
                      DropdownMenuItem(
                        value: 'incomplete',
                        child: Text('Incomplete'),
                      ),
                    ],
                    iconEnabledColor: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(24),
                    dropdownColor: selectedTower.drawingStatus == 'complete'
                        ? AppColors.green
                        : selectedTower.drawingStatus == 'submitted'
                            ? AppColors.yellow
                            : AppColors.red,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.surface,
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
              'Sign-In/Sign-Out',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RecordCreationPage(towerId: selectedTower.id))),
              onTap: () async {
                // TODO: implement popup

                final userProvider = Provider.of<UserProvider>(context, listen: false);
                final recordsProvider = Provider.of<RecordsProvider>(context, listen: false);

                // create new record instance
                final record = Record(
                  authorId: userProvider.userId,
                );

                try {
                  // add record to record provider and local list
                  await recordsProvider.addRecord(widget.towerId, record);

                  // update associated tower survey status to 'in-progress'
                  await towersProvider.updateSurveyStatus(widget.towerId, 'in-progress');

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Record Created Successfully!"),
                    ));
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error creating record: $e")),
                    );
                  }
                }
              },
              child: Text(
                'Create New Record',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontStyle: FontStyle.italic,
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 5),

            Expanded(
              child: records.isEmpty
                  ? Center(child: Text("No Record History"))
                  : ListView.builder(
                      itemCount: records.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final record = records.toList()[index];

                        // Default author name if not found
                        String authorName = 'Unknown Author';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecordPage(
                                  towerId: selectedTower.id,
                                  recordId: record.id,
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
                              minimum: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // left side
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // record id
                                      Text(
                                        record.id,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // author name (fallback to default if FutureBuilder fails)
                                      FutureBuilder<DocumentSnapshot>(
                                        future: FirebaseFirestore.instance.collection('users').doc(record.authorId).get(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data!.exists) {
                                            authorName = snapshot.data!['name'] as String;
                                          }
                                          return Text(
                                            authorName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          );
                                        },
                                      ),
                                      // photo count
                                      Text(
                                        '${record.images.length} Photo(s)',
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.secondary,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                  // right side
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        record.signIn != null
                                            ? DateFormat('dd/MM/yy').format(record.signIn!.toDate())
                                            : 'Not Signed-In',
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(height: 10),
                                      const Icon(
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
