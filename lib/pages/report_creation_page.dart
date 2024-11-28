import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:progrid/models/user_provider.dart';
import 'package:provider/provider.dart';

class ReportCreationPage extends StatefulWidget {
  final String towerId; // id of selected tower

  const ReportCreationPage({super.key, required this.towerId});

  @override
  State<ReportCreationPage> createState() => _ReportCreationPageState();
}

class _ReportCreationPageState extends State<ReportCreationPage> {
  final _notesController = TextEditingController();
  final int _maxNotesLength = 500;
  // TODO: implement pictures

  Future<void> _createReport() async {
    if (_notesController.text.isEmpty) {
      // TODO: replace all warnings with snackbars
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final towersProvider = Provider.of<TowersProvider>(context, listen: false);

    // create new report instance
    final report = Report(
      dateTime: Timestamp.now(),
      authorId: userProvider.userId,
      authorName: userProvider.name,
      notes: _notesController.text,
    );

    try {
      // save to firestore, assign id
      await report.saveToDatabase(widget.towerId);

      // update provider's state
      towersProvider.addReportToTower(widget.towerId, report);

      // clear fields
      _notesController.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Report created successfully!")),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to create report")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.towerId, // replace with instancing?
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            // pictures upload
            Expanded(
              child: Container(
                height: 150,
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                child: Stack(
                  children: [
                    // picture gallery wrap


                    // button controls
                      // upload link
                      // camera link
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // notes text field
            SizedBox(
              height: 200, // control text box height here
              child: TextField(
                controller: _notesController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                maxLength: _maxNotesLength,
                buildCounter: (context, {required currentLength, maxLength, required isFocused}) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
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
                  hintText: 'Notes',
                  alignLabelWithHint: true,
                  hintStyle:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () => _createReport(),
              child: Text("Create Report"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
