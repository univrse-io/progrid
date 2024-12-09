import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progrid/models/providers/issues_provider.dart';
import 'package:progrid/pages/issues/issue_creation_page.dart';
import 'package:progrid/pages/issues/issue_page.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

class IssuesListPage extends StatelessWidget {
  final String towerId; // id of selected tower

  const IssuesListPage({super.key, required this.towerId});

  @override
  Widget build(BuildContext context) {
    final issuesProvider = Provider.of<IssuesProvider>(context);
    final issues = issuesProvider.issues.where((issue) => issue.id.startsWith('$towerId-I'));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Text(
          towerId,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),

            const Text(
              "Site Issues",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            const SizedBox(height: 0),

            // new issue ticket link
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IssueCreationPage(towerId: towerId),
                    ));
              },
              child: Text(
                "Create New Ticket",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  decoration: TextDecoration.underline,
                  fontSize: 14,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // issues list
            Expanded(
              child: issues.isEmpty
                  ? Center(child: Text("No Issues Found"))
                  : ListView.builder(
                      itemCount: issues.length,
                      itemBuilder: (context, index) {
                        final issue = issues.toList()[index];
                        final tagsDisplay = issue.tags.join(', ');

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(issue.authorId).get(),
                          builder: (context, authorSnapshot) {
                            final authorName = authorSnapshot.hasData && authorSnapshot.data!.exists
                                ? authorSnapshot.data!['name'] as String
                                : "Unknown Author";

                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => IssuePage(
                                      issueId: issue.id,
                                      towerId: towerId,
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
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 70,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  width: 14,
                                                  height: 14,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: issue.status == 'resolved' ? AppColors.green : AppColors.red,
                                                  ),
                                                ),
                                                const SizedBox(width: 7),
                                                Text(
                                                  issue.id,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              tagsDisplay,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  authorName,
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.secondary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const Text(", "),
                                                Text(
                                                  '${issue.status[0].toUpperCase()}${issue.status.substring(1)}',
                                                  style: TextStyle(
                                                    color: Theme.of(context).colorScheme.secondary,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 30,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              DateFormat('dd/MM/yy').format(issue.dateTime.toDate()),
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                            const SizedBox(height: 10),
                                            const Icon(
                                              Icons.arrow_right,
                                              size: 36,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
