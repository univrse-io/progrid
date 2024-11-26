import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:progrid/models/user_provider.dart';
import 'package:progrid/widgets/my_button.dart';
import 'package:provider/provider.dart';

class ReportCreationPage extends StatefulWidget {
  final String towerId; // id of selected tower

  const ReportCreationPage({super.key, required this.towerId});

  @override
  State<ReportCreationPage> createState() => _ReportCreationPageState();
}

class _ReportCreationPageState extends State<ReportCreationPage> {
  final _notesController = TextEditingController();
  // TODO: implement pictures

  Future<void> _createReport() async {
    if (_notesController.text.isEmpty) {
      // TODO: replace all warnings with snackbars
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields.")),
      );
      return;
    }

    // create new report instance
    final report = Report(
      dateTime: Timestamp.now(),
      authorId: Provider.of<UserProvider>(context).userId,
      notes: _notesController.text,
    );

    try {
      // save to firestore, assign id
      await report.saveToDatabase(widget.towerId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Report created successfully!")),
        );
      }

      // clear fields
      _notesController.clear();
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
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          icon: Icon(Icons.arrow_back, size: 34),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.towerId, // replace with instancing?
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            // Notes
            TextField(
              controller: _notesController,
              decoration: InputDecoration(hintText: 'Notes'),
            ),
            const SizedBox(height: 20),

            // Submit
            MyButton(
              onTap: () {
                _createReport();
                Navigator.pop(context);
              },
              text: "Create Report",
            )
          ],
        ),
      ),
    );
  }
}
