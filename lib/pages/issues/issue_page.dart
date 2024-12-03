import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/providers/user_provider.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

class IssuePage extends StatefulWidget {
  final String towerId;
  final String issueId;

  const IssuePage({super.key, required this.issueId, required this.towerId});

  @override
  State<IssuePage> createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  @override
  Widget build(BuildContext context) {
    // stream to get selected issue
    final issueStream = FirebaseFirestore.instance
        .collection('towers')
        .doc(widget.towerId)
        .collection('issues')
        .doc(widget.issueId)
        .snapshots()
        .map((doc) => doc.exists ? Issue.fromFirestore(doc) : null);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.issueId,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: StreamBuilder<Issue?>(
          stream: issueStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Issue not found.'));
            }

            final issue = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),

                // tags
                const Text(
                  'Tags',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),

                if (issue.tags.isNotEmpty)
                  Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: issue.tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 10),

                // description
                const Text(
                  'Description',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  issue.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),

                // status
                const Text(
                  'Status',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 7),
                if (issue.authorId == Provider.of<UserProvider>(context).userId)
                  Container(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: issue.status == 'resolved' ? AppColors.green : AppColors.red,
                    ),
                    child: DropdownButton(
                      isDense: true,
                      value: issue.status,
                      onChanged: (newStatus) async {
                        if (newStatus != null && newStatus != issue.status) {
                          await FirebaseFirestore.instance
                                .collection('towers')
                                .doc(widget.towerId)
                                .collection('issues')
                                .doc(widget.issueId)
                                .update({'status': newStatus});
                        }
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'unresolved',
                          child: Text(
                            'Unresolved',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'resolved',
                          child: Text(
                            'Resolved',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                      iconEnabledColor: Theme.of(context).colorScheme.surface,
                      style: TextStyle(
                        // UNDONE: this color is broken
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: issue.status == 'resolved' ? AppColors.green : AppColors.red,
                    ),
                    child: Text(
                      '${issue.status[0].toUpperCase()}${issue.status.substring(1)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
