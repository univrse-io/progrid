import 'package:flutter/material.dart';
import 'package:progrid/models/issue_status.dart';
import 'package:progrid/providers/issues_provider.dart';
import 'package:progrid/providers/user_provider.dart';
import 'package:progrid/services/firestore.dart';
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
    final issue = Provider.of<IssuesProvider>(context)
        .issues
        .firstWhere((issue) => issue.id == widget.issueId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.issueId,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  color: issue.status.color,
                ),
                child: DropdownButton<IssueStatus>(
                  isDense: true,
                  value: issue.status,
                  onChanged: (value) {
                    if (value != null && value != issue.status) {
                      FirestoreService.updateIssue(issue.id,
                          data: {'status': value});

                      // update local as well
                      issue.status = value;
                    }
                  },
                  items: [
                    DropdownMenuItem(
                      value: IssueStatus.unresolved,
                      child: Text('Unresolved'),
                    ),
                    DropdownMenuItem(
                      value: IssueStatus.resolved,
                      child: Text('Resolved'),
                    ),
                  ],
                  iconEnabledColor: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  dropdownColor: issue.status.color,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    color: issue.status.color),
                child: Text(
                  issue.status.toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
