import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/providers/tower_provider.dart';
import 'package:progrid/models/providers/user_provider.dart';
import 'package:provider/provider.dart';

class IssueCreationPage extends StatefulWidget {
  final String towerId;

  const IssueCreationPage({super.key, required this.towerId});

  @override
  State<IssueCreationPage> createState() => _IssueCreationPageState();
}

class _IssueCreationPageState extends State<IssueCreationPage> {
  final List<String> _availableTags = ["Permit", "Logistics", "Key", "Access", "Hazard", "FSC"];
  final List<String> _selectedTags = [];
  String? _selectedTag;
  final _descriptionController = TextEditingController();
  final int _maxDescriptionLength = 750;

  Future<void> _createIssue() async {
    if (_selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one tag")),
      );
      return;
    }

    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please add a description")),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final towersProvider = Provider.of<TowersProvider>(context, listen: false);

    final issue = Issue(
      dateTime: Timestamp.now(),
      authorId: userProvider.userId,
      tags: _selectedTags,
      description: _descriptionController.text,
      status: 'unresolved',
    );

    try {
      // TODO: fix this
      // await towersProvider.addIssueToTower(widget.towerId, issue);
      _descriptionController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Issue created successfully!")),
        );
        Navigator.pop(context); // go back
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create issue")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.towerId,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            // Tags section (Dropdown)
            DropdownButton<String>(
              isExpanded: true,
              value: _selectedTag,
              hint: Text("Tags*"),
              items: _availableTags.map((tag) {
                return DropdownMenuItem(
                  value: tag,
                  child: Text(tag),
                );
              }).toList(),
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
              Container(
                width: double.infinity,
                child: Wrap(
                  spacing: 5,
                  runSpacing: 5,
                  children: _selectedTags.map((tag) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedTags.remove(tag); // Remove tag on click
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                    );
                  }).toList(),
                ),
              ),
            const SizedBox(height: 17),

            // Description box
            Expanded(
              child: TextField(
                controller: _descriptionController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                maxLength: _maxDescriptionLength,
                buildCounter: (context, {required currentLength, maxLength, required isFocused}) {
                  return Padding(
                    padding: EdgeInsets.only(top: 4),
                    child: Text(
                      '$currentLength/$maxLength',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                decoration: InputDecoration(
                  hintText: "Description*",
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Create issue button
            FilledButton(
              onPressed: () => _createIssue(),
              child: Text("Create Issue"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
