import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progrid/pages/issues/issue_creation_page.dart';
import 'package:progrid/pages/issues/issue_page.dart';
import 'package:progrid/utils/themes.dart';

class IssuesListPage extends StatelessWidget {
  final String towerId; // id of selected tower

  const IssuesListPage({super.key, required this.towerId});

  @override
  Widget build(BuildContext context) {
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
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('towers')
                    .doc(towerId)
                    .collection('issues')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text("Failed to load issues"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text("No Issues Found"),
                    );
                  }

                  final issues = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: issues.length,
                    itemBuilder: (context, index) {
                      final issueData = issues[index].data()! as Map<String, dynamic>;
                      final issueId = issues[index].id;
                      final tagsDisplay = (issueData['tags'] as List).join(', ');
                      final authorId = issueData['authorId'];
                      final status = issueData['status'] ?? 'open';
                      final issueDate = (issueData['dateTime'] as Timestamp).toDate();

                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(authorId as String)
                            .get(),
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
                                    issueId: issueId,
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
                                                  color: status == 'resolved'
                                                      ? AppColors.green
                                                      : AppColors.red,
                                                ),
                                              ),
                                              const SizedBox(width: 7),
                                              Text(
                                                issueId,
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
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const Text(", "),
                                              Text(
                                                // UNDONE: is type casting really necessary? check model implementation
                                                '${(status as String)[0].toUpperCase()}${status.substring(1)}',
                                                style: TextStyle(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 20,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            DateFormat('dd/MM/yy').format(issueDate),
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
