import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/issue.dart';
import '../../models/issue_status.dart';
import '../../services/firestore.dart';

class IssuePage extends StatefulWidget {
  final String towerId;
  final String issueId;

  const IssuePage({required this.issueId, required this.towerId, super.key});

  @override
  State<IssuePage> createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  @override
  Widget build(BuildContext context) {
    final issue = Provider.of<List<Issue>>(context)
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
                children: issue.tags
                    .map(
                      (tag) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
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
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 10),
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
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            if (issue.authorId == Provider.of<User?>(context)!.uid)
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
                      FirestoreService.updateIssue(
                        issue.id,
                        data: {'status': value.name},
                      );
                      issue.status = value;
                    }
                  },
                  items: const [
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
                  color: issue.status.color,
                ),
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
