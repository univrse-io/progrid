import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/drawing_status.dart';
import '../models/issue.dart';
import '../models/survey_status.dart';
import '../models/tower.dart';
import '../services/firebase_firestore_service.dart';

class EditTowerPage extends StatefulWidget {
  final Tower tower;

  const EditTowerPage(this.tower, {super.key});

  @override
  State<EditTowerPage> createState() => _EditTowerPageState();
}

class _EditTowerPageState extends State<EditTowerPage> {
  late final descriptionController =
      TextEditingController()..addListener(() => setState(() {}));
  late final carbonToken = Theme.of(context).extension<CarbonToken>();
  late final issues = Provider.of<List<Issue>>(context, listen: false);
  late final user = Provider.of<User?>(context, listen: false);
  late final isAdmin = Provider.of<bool>(context, listen: false);
  late SurveyStatus? surveyStatus = widget.tower.surveyStatus;
  late DrawingStatus? drawingStatus = widget.tower.drawingStatus;

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(
        isAdmin
            ? 'Update Tower'
            : widget.tower.surveyStatus == SurveyStatus.unsurveyed
            ? 'Sign In'
            : 'Sign Out',
      ),
    ),
    body: Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Photo', style: CarbonTextStyle.headingCompact01),
                const Spacing.$3(),
                Material(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder:
                            (context) => AlertDialog(
                              title: const Text('Upload image'),
                              content: const Text(
                                'Which source do you want to upload from?',
                              ),
                              actions: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Expanded(
                                      child: CarbonSecondaryButton(
                                        onPressed: () {},
                                        label: 'Open Camera',
                                      ),
                                    ),
                                    Expanded(
                                      child: CarbonPrimaryButton(
                                        onPressed: () {},
                                        label: 'From Gallery',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      );
                    },
                    child: Ink(
                      width: 120,
                      height: 120,
                      color: carbonToken?.field01,
                      child: const Icon(CarbonIcon.add),
                    ),
                  ),
                ),
                // SizedBox(
                //   height: 120,
                //   child: ListView.separated(
                //     scrollDirection: Axis.horizontal,
                //     separatorBuilder: (_, __) => const Spacing.$2(),
                //     itemCount: widget.tower.images.length,
                //     itemBuilder:
                //         (context, index) => Image.network(
                //           widget.tower.images[index],
                //           fit: BoxFit.cover,
                //           width: 120,
                //           errorBuilder:
                //               (_, __, ___) => IgnorePointer(
                //                 child: Container(
                //                   width: 120,
                //                   color: carbonToken?.field01,
                //                   padding: const EdgeInsets.all(8),
                //                   child: const Text('Image not available.'),
                //                 ),
                //               ),
                //         ),
                //   ),
                // ),
                const Spacing.$3(),
                Text('Notes', style: CarbonTextStyle.headingCompact01),
                const Spacing.$3(),
                CarbonTextInput(
                  controller: descriptionController,
                  maxCharacters: 200,
                  keyboardType: TextInputType.multiline,
                ),
                const Spacing.$3(),
                if (isAdmin) ...[
                  Text(
                    'Survey Status',
                    style: CarbonTextStyle.headingCompact01,
                  ),
                  const Spacing.$3(),
                  CarbonDropdown<SurveyStatus>(
                    initialSelection: surveyStatus,
                    inputDecorationTheme: InputDecorationTheme(
                      isCollapsed: true,
                      filled: true,
                      fillColor: surveyStatus?.color.withValues(alpha: 0.1),
                    ),
                    onSelected: (value) {
                      if (value != null) setState(() => surveyStatus = value);
                    },
                    dropdownMenuEntries: [
                      ...SurveyStatus.values.map(
                        (status) => DropdownMenuEntry(
                          value: status,
                          label: status.toString(),
                        ),
                      ),
                    ],
                  ),
                  const Spacing.$3(),
                  Text(
                    'Drawing Status',
                    style: CarbonTextStyle.headingCompact01,
                  ),
                  const Spacing.$3(),
                  CarbonDropdown<DrawingStatus>(
                    initialSelection: drawingStatus,
                    inputDecorationTheme: InputDecorationTheme(
                      isCollapsed: true,
                      filled: true,
                      fillColor: drawingStatus?.color.withValues(alpha: 0.1),
                    ),
                    onSelected: (value) {
                      if (value != null) setState(() => drawingStatus = value);
                    },
                    dropdownMenuEntries: [
                      ...DrawingStatus.values.map(
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
                descriptionController.text.isEmpty
                    ? null
                    : () async {
                      await FirebaseFirestoreService().updateTower(
                        widget.tower.id,
                        data: {
                          // 'status': selectedStatus.name,
                          // 'notes':
                          //     '${widget.issue!.notes}\n'
                          //     '[${DateFormat('y-m-d HH:mm').format(DateTime.now())}] ${descriptionController.text}',
                          // 'tags': selectedTags,
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
