import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/issue.dart';
import '../models/issue_status.dart';
import '../models/tower.dart';
import '../services/firebase_firestore.dart';

class NewIssuePage extends StatefulWidget {
  final Tower? tower;
  final Tower? issue;

  /// Create a new issue ticket for the selected tower.
  const NewIssuePage.create({required this.tower, super.key}) : issue = null;

  /// Update the selected issue ticket details.
  const NewIssuePage.update({required this.issue, super.key}) : tower = null;

  @override
  State<NewIssuePage> createState() => _NewIssuePageState();
}

class _NewIssuePageState extends State<NewIssuePage> {
  final tags = <String>[
    'Permit',
    'Logistics',
    'Key',
    'Access',
    'Hazard',
    'FSC',
    'Other(s)',
  ];
  final selectedTags = <String>[];
  late final descriptionController =
      TextEditingController()..addListener(() => setState(() {}));

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create Issue')),
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tags', style: CarbonTextStyle.headingCompact01),
                const Spacing.$3(),
                Wrap(
                  children: [
                    ...tags.map(
                      (tag) => SizedBox(
                        width: 160,
                        child: CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          value: selectedTags.contains(tag),
                          onChanged: (isSelected) {
                            isSelected ?? false
                                ? selectedTags.add(tag)
                                : selectedTags.remove(tag);
                            setState(() {});
                          },
                          title: Text(tag, style: CarbonTextStyle.body01),
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacing.$3(),
                Text('Description', style: CarbonTextStyle.headingCompact01),
                const Spacing.$3(),
                CarbonTextInput(
                  controller: descriptionController,
                  maxCharacters: 200,
                  keyboardType: TextInputType.multiline,
                ),
                const Spacing.$3(),
                // Text('Status', style: CarbonTextStyle.headingCompact01),
                // const Spacing.$3(),
                // CarbonDropdown<IssueStatus>(
                //   inputDecorationTheme: const InputDecorationTheme(
                //     filled: true,
                //     fillColor: Colors.amber,
                //   ),
                //   dropdownMenuEntries: [
                //     ...IssueStatus.values.map(
                //       (status) => DropdownMenuEntry(
                //         value: status,
                //         label: status.toString(),
                //       ),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: FilledButton(
            onPressed:
                selectedTags.isEmpty || descriptionController.text.isEmpty
                    ? null
                    : () async {
                      final user = context.read<User?>();
                      final issues = context.read<List<Issue>>();
                      var i = 1;

                      String uniqueId() =>
                          '${widget.tower?.id}-I${i.toString().padLeft(3, '0')}';

                      while (true) {
                        if (issues
                            .where((issue) => issue.id == uniqueId())
                            .isEmpty) {
                          break;
                        }
                        i++;
                      }

                      final issue = Issue(
                        id: uniqueId(),
                        status: IssueStatus.unresolved,
                        authorId: user!.uid,
                        description:
                            '[${DateFormat('y-m-d HH:mm').format(DateTime.now())}] ${descriptionController.text}',
                        createdAt: Timestamp.now(),
                        authorName: user.displayName,
                        tags: selectedTags,
                      );

                      await FirebaseFirestoreService().createIssue(
                        issue.id,
                        data: issue.toJson(),
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Issue Created Successfully!'),
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
            child: const Text('Submit'),
          ),
        ),
      ],
    ),
  );
}
