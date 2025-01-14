import 'package:flutter/material.dart';
import 'package:progrid/models/survey_status.dart';
import 'package:progrid/models/tower.dart';
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
  static void showTowerDialog(
    BuildContext context,
    List<Tower> towers,
    String towerId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final selectedTower = towers.firstWhere(
          (tower) => tower.id == towerId,
          orElse: () => throw Exception("Tower not found"),
        );

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
                        const SizedBox(width: 5),

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
                    const SizedBox(height: 3),

                    // tower geolocation
                    Text(
                      '${selectedTower.position.latitude.toStringAsFixed(6)}, ${selectedTower.position.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // site address
                    _buildDetailRow('Address:', selectedTower.address),
                    // site region
                    _buildDetailRow('Region:', selectedTower.region.toString()),
                    // site type
                    _buildDetailRow('Type:', selectedTower.type),

                    // images
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
