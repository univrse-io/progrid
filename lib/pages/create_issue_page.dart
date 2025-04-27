import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/issue.dart';
import '../models/issue_status.dart';
import '../models/tower.dart';
import '../services/firebase_firestore.dart';

class CreateIssuePage extends StatefulWidget {
  final Tower tower;

  const CreateIssuePage({required this.tower, super.key});

  @override
  State<CreateIssuePage> createState() => _CreateIssuePageState();
}

class _CreateIssuePageState extends State<CreateIssuePage> {
  final List<String> _availableTags = [
    'Permit',
    'Logistics',
    'Key',
    'Access',
    'Hazard',
    'FSC',
    'Other(s)',
  ];
  final List<String> _selectedTags = [];
  String? _selectedTag;
  final _descriptionController = TextEditingController();
  final int _maxDescriptionLength = 750;

  Future<void> _createIssue() async {
    if (_selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one tag')),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please add a description')));
      return;
    }

    final user = Provider.of<User?>(context, listen: false);
    final issues = Provider.of<List<Issue>>(context, listen: false);
    var i = 1;

    String uniqueId() => '${widget.tower.id}-I${i.toString().padLeft(3, '0')}';

    while (true) {
      if (issues.where((issue) => issue.id == uniqueId()).isEmpty) break;
      i++;
    }

    final issue = Issue(
      id: uniqueId(),
      dateTime: Timestamp.now(),
      authorId: user!.uid,
      tags: _selectedTags,
      description: _descriptionController.text,
      status: IssueStatus.unresolved,
    );

    try {
      await FirebaseFirestoreService().createIssue(
        issue.id,
        data: issue.toJson(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Issue Created Successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating Issue: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Create Issue')),
    body: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Tags section (Dropdown)
          DropdownButton<String>(
            isExpanded: true,
            value: _selectedTag,
            hint: const Text('Tags*'),
            items:
                _availableTags
                    .map(
                      (tag) => DropdownMenuItem(value: tag, child: Text(tag)),
                    )
                    .toList(),
            onChanged: (newTag) {
              if (newTag != null && !_selectedTags.contains(newTag)) {
                setState(() {
                  _selectedTags.add(newTag);
                  _selectedTag = null; // Reset selection
                });
              }
            },
            dropdownColor: Theme.of(context).colorScheme.surface,
          ),
          const SizedBox(height: 3),

          // Display selected tags
          if (_selectedTags.isNotEmpty)
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 5,
                runSpacing: 5,
                children:
                    _selectedTags
                        .map(
                          (tag) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTags.remove(
                                  tag,
                                ); // Remove tag on click
                              });
                            },
                            child: Container(
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
                          ),
                        )
                        .toList(),
              ),
            ),
          const SizedBox(height: 17),
          Expanded(
            child: TextField(
              controller: _descriptionController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              expands: true,
              textAlignVertical: TextAlignVertical.top,
              maxLength: _maxDescriptionLength,
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    maxLength,
                  }) => Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$currentLength/$maxLength',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              decoration: InputDecoration(
                hintText: 'Description*',
                alignLabelWithHint: true,
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(onPressed: _createIssue, child: const Text('Submit')),
        ],
      ),
    ),
  );
}
