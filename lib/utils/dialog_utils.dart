import 'dart:async';

import 'package:flutter/material.dart';
import 'package:progrid/models/survey_status.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/providers/towers_provider.dart';
import 'package:progrid/services/firestore.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

class DialogUtils {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // cannot be dismissed on tap
      builder: (BuildContext context) {
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  static void showImageDialog(
    BuildContext context,
    String imageUrl,
    Future<void> Function(String) onDownload,
    Future<void> Function(String) onDelete,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: Center(
              child: Stack(
                children: [
                  // image object
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: AppColors.red),
                      );
                    },
                  ),

                  Positioned(
                    bottom: 5,
                    left: 5,
                    child: Row(
                      children: [
                        // download button
                        FloatingActionButton(
                          onPressed: () => onDownload(imageUrl),
                          child: Icon(Icons.download),
                          mini: true,
                        ),
                        SizedBox(width: 2),

                        // delete button
                        FloatingActionButton(
                          onPressed: () => onDelete(imageUrl),
                          child: Icon(Icons.delete, color: AppColors.red),
                          mini: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // TODO: fix context inheritance issue
  // TODO: implement live provider here instead
  static void showTowerDialog(
    BuildContext context,
    List<Tower> towers,
    String towerId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // final towersProvider = Provider.of<TowersProvider>(context, listen: true);
        // final selectedTower =
        //     towersProvider.towers.firstWhere(
        //   (tower) => tower.id == towerId,
        //   orElse: () => throw Exception("Tower not found"),
        // );

        final selectedTower = towers.firstWhere(
          (tower) => tower.id == towerId,
          orElse: () => throw Exception("Tower not found"),
        );

        final notesController = TextEditingController(text: selectedTower.notes);
        Timer? _debounceTimer;

        return Dialog(
          elevation: 10,
          child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 500, // set a max width
              ),
              child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // tower id
                        Text(
                          selectedTower.id,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        const SizedBox(width: 10),

                        // survey status dropdown
                        Container(
                          padding: const EdgeInsets.only(left: 14, right: 10),
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: selectedTower.surveyStatus.color),
                          child: DropdownButton<SurveyStatus>(
                            // require type specifics
                            isDense: true,
                            value: selectedTower.surveyStatus,
                            onChanged: (value) {
                              if (value != null && value != selectedTower.surveyStatus) {
                                FirestoreService.updateTower(selectedTower.id, data: {'surveyStatus': value.name});
                                setState(() {
                                  selectedTower.surveyStatus = value;
                                });
                              }
                            },
                            items: SurveyStatus.values.map((status) {
                              return DropdownMenuItem(
                                value: status,
                                child: Text(status.toString()),
                              );
                            }).toList(),
                            iconEnabledColor: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(24),
                            dropdownColor: selectedTower.surveyStatus.color,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    ),

                    // tower name
                    Text(
                      selectedTower.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // tower geolocation
                    Text(
                      '${selectedTower.position.latitude.toStringAsFixed(6)}, ${selectedTower.position.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),

                    // site address
                    _buildDetailRow('Address:', selectedTower.address),
                    // site region
                    _buildDetailRow('Region:', selectedTower.region.toString()),
                    // site type
                    _buildDetailRow('Type:', selectedTower.type),
                    const SizedBox(height: 10),

                    // gallery
                    Container(
                      height: 130,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedTower.images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {},
                                    // onTap: () => DialogUtils.showImageDialog(context, selectedTower.images[index], onDownload, onDelete),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ConstrainedBox(
                                        constraints: BoxConstraints(maxHeight: 400),
                                        child: Image.network(
                                          selectedTower.images[index],
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 120,
                                          errorBuilder: (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey,
                                              child: Icon(Icons.error, color: AppColors.red),
                                            ); // if image fails to load
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ));
                        },
                      ),
                    ),
                    const SizedBox(height: 2),

                    // sign-in status indicator
                    Row(
                      children: [
                        Text(
                          ' Status:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary, fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          selectedTower.images.isEmpty
                              ? 'Unsurveyed' // No images
                              : selectedTower.images.length == 1
                                  ? 'Signed-in' // Exactly 1 image
                                  : 'Signed-out', // More than 1 image
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontStyle: FontStyle.italic,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),

                    // notes
                    SizedBox(
                      height: 120,
                      child: TextField(
                        controller: notesController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        maxLength: 500,
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
                          hintText: 'Enter notes here...',
                          alignLabelWithHint: true,
                          hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 14),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        ),
                        onChanged: (text) async {
                          // cancel any previous debounce timer
                          if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();

                          _debounceTimer = Timer(const Duration(milliseconds: 2000), () {
                            // update notes every one second of changes
                            FirestoreService.towersCollection.doc(towerId).update({'notes': text});

                            // update local
                            setState(() {
                              selectedTower.notes = text;
                            });
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  static Widget _buildDetailRow(String label, String content) {
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
            child: Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
