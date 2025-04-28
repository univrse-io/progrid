import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/issue.dart';
import '../models/issue_status.dart';
import '../services/firebase_firestore.dart';

class IssueDetailsPage extends StatefulWidget {
  final Issue issue;

  const IssueDetailsPage({required this.issue, super.key});

  @override
  State<IssueDetailsPage> createState() => _IssueDetailsPageState();
}

class _IssueDetailsPageState extends State<IssueDetailsPage> {
  late IssueStatus currentStatus = widget.issue.status;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(widget.issue.id)),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tags',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          if (widget.issue.tags.isNotEmpty)
            Wrap(
              spacing: 5,
              runSpacing: 5,
              children:
                  widget.issue.tags
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
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          Text(
            widget.issue.description,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 10),
          const Text(
            'Status',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 7),
          if (widget.issue.authorId == Provider.of<User?>(context)!.uid)
            Container(
              padding: const EdgeInsets.only(left: 14, right: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: currentStatus.color,
              ),
              child: DropdownButton<IssueStatus>(
                isDense: true,
                value: currentStatus,
                onChanged: (value) {
                  if (value != null && value != currentStatus) {
                    FirebaseFirestoreService().updateIssue(
                      widget.issue.id,
                      data: {'status': value.name},
                    );
                    setState(() => currentStatus = value);
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
                dropdownColor: currentStatus.color,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.surface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                color: currentStatus.color,
              ),
              child: Text(
                currentStatus.toString(),
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
