import 'package:carbon_design_system/carbon_design_system.dart';
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
  late final user = Provider.of<User?>(context);
  late final isAdmin = Provider.of<bool>(context);

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Spacing.$4(color: widget.issue.status.color),
          const Spacing.$3(),
          Text(widget.issue.id),
        ],
      ),
    ),
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Tags', style: CarbonTextStyle.headingCompact01),
                const Spacing.$3(),
                Text(widget.issue.tags.join(', ')),
                const Spacing.$3(),
                Text('Description', style: CarbonTextStyle.headingCompact01),
                const Spacing.$3(),
                SelectableText(widget.issue.description),
                const Spacing.$3(),
                Text('Status', style: CarbonTextStyle.headingCompact01),
                const Spacing.$3(),
                Text(widget.issue.status.toString()),
                const Spacing.$3(),
              ],
            ),
          ),
        ),
        Visibility(
          visible: widget.issue.authorId == user!.uid || isAdmin,
          child: Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: FilledButton(
              onPressed: () async {
                await FirebaseFirestoreService().updateIssue(
                  widget.issue.id,
                  data: {
                    'status': IssueStatus.resolved.name,
                    'authorId': user!.uid,
                    'authorName': user!.displayName,
                  },
                );
                setState(() => widget.issue.status = IssueStatus.resolved);
              },
              child: const Text('Update Issue'),
            ),
          ),
        ),
      ],
    ),
  );
}
