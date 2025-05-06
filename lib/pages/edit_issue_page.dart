import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/issue.dart';
import '../models/issue_status.dart';
import '../models/tower.dart';
import '../services/firebase_firestore_service.dart';

class EditIssuePage extends StatefulWidget {
  final Tower? tower;
  final Issue? issue;

  /// Create a new issue ticket for the selected tower.
  const EditIssuePage.create({required this.tower, super.key}) : issue = null;

  /// Update the selected issue ticket details.
  const EditIssuePage.update({required this.issue, super.key}) : tower = null;

  @override
  State<EditIssuePage> createState() => _EditIssuePageState();
}

class _EditIssuePageState extends State<EditIssuePage> {
  final tags = <String>[
    'Permit',
    'Logistics',
    'Key',
    'Access',
    'Hazard',
    'FSC',
    'Other(s)',
  ];
  late final selectedTags = widget.issue?.tags ?? <String>[];
  late final descriptionController =
      TextEditingController()..addListener(() => setState(() {}));
  late final issues = Provider.of<List<Issue>>(context, listen: false);
  late final user = Provider.of<User?>(context, listen: false);
  late IssueStatus selectedStatus =
      widget.issue?.status ?? IssueStatus.unresolved;

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(widget.issue != null ? 'Update Issue' : 'Create Issue'),
    ),
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
                Text('Notes', style: CarbonTextStyle.headingCompact01),
                const Spacing.$3(),
                CarbonTextInput(
                  controller: descriptionController,
                  maxCharacters: 200,
                  keyboardType: TextInputType.multiline,
                ),
                const Spacing.$3(),
                if (widget.issue != null) ...[
                  Text('Status', style: CarbonTextStyle.headingCompact01),
                  const Spacing.$3(),
                  CarbonDropdown<IssueStatus>(
                    initialSelection: selectedStatus,
                    inputDecorationTheme: InputDecorationTheme(
                      isCollapsed: true,
                      filled: true,
                      fillColor: selectedStatus.color.withValues(alpha: 0.1),
                    ),
                    onSelected: (value) {
                      if (value != null) setState(() => selectedStatus = value);
                    },
                    dropdownMenuEntries: [
                      ...IssueStatus.values.map(
                        (status) => DropdownMenuEntry(
                          value: status,
                          label: status.toString(),
                        ),
                      ),
                    ],
                  ),
                  const Spacing.$3(),
                ],
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CarbonPrimaryButton(
            onPressed:
                selectedTags.isEmpty || descriptionController.text.isEmpty
                    ? null
                    : () async {
                      if (widget.issue != null) {
                        await FirebaseFirestoreService().updateIssue(
                          widget.issue!.id,
                          data: {
                            'status': selectedStatus.name,
                            'notes':
                                '${widget.issue!.notes}\n'
                                '[${DateFormat('y-MM-dd HH:mm').format(DateTime.now())}] ${descriptionController.text}',
                            'tags': selectedTags,
                            'authorId': user!.uid,
                            'authorName': user!.displayName,
                          },
                        );

                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Issue Updated Successfully!'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      } else {
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
                          status: selectedStatus,
                          authorId: user!.uid,
                          notes:
                              '[${DateFormat('y-m-d HH:mm').format(DateTime.now())}] ${descriptionController.text}',
                          createdAt: Timestamp.now(),
                          authorName: user!.displayName,
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
                        }
                      }
                      if (context.mounted) Navigator.pop(context);
                    },
            label: 'Submit',
            icon: CarbonIcon.checkmark,
          ),
        ),
      ],
    ),
  );
}
