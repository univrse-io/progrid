import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:progrid/models/providers/towers_provider.dart';
import 'package:progrid/models/providers/user_provider.dart';
import 'package:progrid/pages/issues/issues_list_page.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

class TowerPage extends StatefulWidget {
  final String towerId;

  const TowerPage({super.key, required this.towerId});

  @override
  State<TowerPage> createState() => _TowerPageState();
}

class _TowerPageState extends State<TowerPage> {
  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);
    final selectedTower = towersProvider.towers.firstWhere(
      (tower) => tower.id == widget.towerId,
      orElse: () => throw Exception("Tower not found"),
    );

    final _notesController = TextEditingController();
    _notesController.text =
        towersProvider.towers.firstWhere((tower) => tower.id == widget.towerId).notes ?? 'Enter text here...'; // get tower notes

    Timer? _debounceTimer;
    final int _maxNotesLength = 500;
    final int _maxImages = 2; // maximum number of images
    final int _minImages = 1; // minimum number of images

    final List<File> _images = [];
    final _picker = ImagePicker();

    // utility
    bool _isLoading = false;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedTower.id,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 5),
              // tower name
              Text(
                selectedTower.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),

              // tower geopoint
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'LatLong:',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${selectedTower.position.latitude.toStringAsFixed(6)}, ${selectedTower.position.longitude.toStringAsFixed(6)}',
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // tower survey status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Survey:',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(width: 5),

                  // dropdown
                  Container(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: selectedTower.surveyStatus == 'surveyed'
                          ? AppColors.green
                          : selectedTower.surveyStatus == 'in-progress'
                              ? AppColors.yellow
                              : AppColors.red,
                    ),
                    child: DropdownButton(
                      isDense: true,
                      value: selectedTower.surveyStatus,
                      onChanged: (value) async {
                        if (value != null && value != selectedTower.surveyStatus) {
                          await FirebaseFirestore.instance.collection('towers').doc(selectedTower.id).update({'surveyStatus': value});
                          selectedTower.surveyStatus = value; // update local as well
                        }
                      },
                      items: const [
                        DropdownMenuItem(
                          value: 'surveyed',
                          child: Text('Surveyed'),
                        ),
                        DropdownMenuItem(
                          value: 'in-progress',
                          child: Text('In-Progress'),
                        ),
                        DropdownMenuItem(
                          value: 'unsurveyed',
                          child: Text('Unsurveyed'),
                        ),
                      ],
                      iconEnabledColor: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      dropdownColor: selectedTower.surveyStatus == 'surveyed'
                          ? AppColors.green
                          : selectedTower.surveyStatus == 'in-progress'
                              ? AppColors.yellow
                              : AppColors.red,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // tower drawing status (temp)
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'Drawing: ',
              //       style: TextStyle(
              //         fontStyle: FontStyle.italic,
              //         fontSize: 17,
              //       ),
              //     ),
              //     const SizedBox(width: 5),

              //     // dropdown
              //     Container(
              //       padding: const EdgeInsets.only(left: 14, right: 10),
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(24),
              //         color: selectedTower.drawingStatus == 'complete'
              //             ? AppColors.green
              //             : selectedTower.drawingStatus == 'submitted'
              //                 ? AppColors.yellow
              //                 : AppColors.red,
              //       ),
              //       child: DropdownButton(
              //         isDense: true,
              //         value: selectedTower.drawingStatus,
              //         onChanged: (value) async {
              //           if (value != null && value != selectedTower.drawingStatus) {
              //             await FirebaseFirestore.instance.collection('towers').doc(selectedTower.id).update({'drawingStatus': value});
              //             selectedTower.drawingStatus = value; // update local as well
              //           }
              //         },
              //         items: const [
              //           DropdownMenuItem(
              //             value: 'complete',
              //             child: Text('Complete'),
              //           ),
              //           DropdownMenuItem(
              //             value: 'submitted',
              //             child: Text('Submitted'),
              //           ),
              //           DropdownMenuItem(
              //             value: 'incomplete',
              //             child: Text('Incomplete'),
              //           ),
              //         ],
              //         iconEnabledColor: Theme.of(context).colorScheme.surface,
              //         borderRadius: BorderRadius.circular(24),
              //         dropdownColor: selectedTower.drawingStatus == 'complete'
              //             ? AppColors.green
              //             : selectedTower.drawingStatus == 'submitted'
              //                 ? AppColors.yellow
              //                 : AppColors.red,
              //         style: TextStyle(
              //           color: Theme.of(context).colorScheme.surface,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 14),

              Divider(),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Text(
                    'Site Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    Icons.list,
                    size: 27,
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // site address
              _buildDetailRow('Address:', selectedTower.address, true),
              // site region
              _buildDetailRow('Region:', selectedTower.region, false),
              // site type
              _buildDetailRow('Type:', selectedTower.type, false),
              // site owner
              _buildDetailRow('Owner:', selectedTower.owner, false),
              const SizedBox(height: 10),

              // pictures section title
              const Text(
                'Pictures',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // gallery
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              const SizedBox(height: 2),

              // sign-in status indicator
              Row(
                children: [
                  Text(
                    ' Status:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Signed-out', // TODO: replace with actual indicator
                    style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontStyle: FontStyle.italic),
                  )
                ],
              ),
              const SizedBox(height: 10),

              // notes section title
              const Text(
                'Additional Notes',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // notes text field
              SizedBox(
                height: 120, // control text box height here
                child: TextField(
                  controller: _notesController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  maxLength: _maxNotesLength,
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 14),
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
                    hintText: 'Enter text here...',
                    alignLabelWithHint: true,
                    hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  ),
                  onChanged: (text) async {
                    // cancel any previous debounce timer
                    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

                    _debounceTimer = Timer(const Duration(milliseconds: 2000), () {
                      // update notes every one second of changes
                      // TODO: check if database updating is happening when there are no updates
                      // UNDONE: ISSUE, text field loses focus on rebuild; cursor disappears
                      towersProvider.updateNotes(widget.towerId, text);
                    });
                  },
                ),
              ),

              // Expanded(child: const SizedBox()),
              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Select Image Source',
                                textAlign: TextAlign.center,
                              ),
                              titleTextStyle:
                                  TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                              titlePadding: EdgeInsets.only(top: 20, right: 20, left: 20),
                              contentPadding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
                              content: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: () {
                                        // TODO: implement camera upload function
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.camera_alt_outlined,
                                        size: 30,
                                      ),
                                      style: FilledButton.styleFrom(
                                        textStyle: TextStyle(fontWeight: FontWeight.w600),
                                        minimumSize: Size.fromHeight(120),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: () {
                                        // TODO: implement gallery upload function
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.file_upload_outlined,
                                        size: 30,
                                      ),
                                      style: FilledButton.styleFrom(
                                        textStyle: TextStyle(fontWeight: FontWeight.w600),
                                        minimumSize: Size.fromHeight(120),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text('Sign-In'),
                      style: FilledButton.styleFrom(
                          textStyle: TextStyle(fontWeight: FontWeight.w600),
                          minimumSize: Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)))),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        // TODO: implement sign-out
                      },
                      child: Text('Sign-Out'),
                      style: FilledButton.styleFrom(
                          textStyle: TextStyle(fontWeight: FontWeight.w600),
                          minimumSize: Size.fromHeight(45),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)))),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),

              FilledButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IssuesListPage(towerId: selectedTower.id),
                    ),
                  );
                },
                child: Text("View Issues"),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // TODO: make function for image upload; sign-in/sign-out
  

  // UI function to build a detail row format
  Widget _buildDetailRow(String label, String content, bool isLink) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // label
          SizedBox(
            width: 90,
            child: Text(
              label,
              textAlign: TextAlign.right,
              style: TextStyle(
                // decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // content
          Expanded(
            child: isLink
                ? GestureDetector(
                    onTap: () async {
                      // TODO: implement google maps link here
                    },
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.blue,
                      ),
                    ),
                  )
                : Text(
                    content,
                    style: TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
