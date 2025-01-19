import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progrid/models/survey_status.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/services/firestore.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
    String towerId,
    // Future<void> Function(BuildContext, String) onDownload,
    // Future<void> Function(BuildContext, String) onDelete,
  ) {
    print(imageUrl);
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
                          // onPressed: () => onDownload(context, imageUrl),
                          onPressed: () => _downloadImage(context, imageUrl),
                          child: Icon(Icons.download),
                          mini: true,
                        ),
                        SizedBox(width: 2),

                        // delete button
                        FloatingActionButton(
                          // onPressed: () => onDelete(context, imageUrl),
                          onPressed: () => _deleteImage(context, imageUrl),
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
    // List<Tower> towers,
    String towerId,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final towers = Provider.of<List<Tower>>(context);
        final selectedTower = towers.firstWhere((tower) => tower.id == towerId,
            orElse: () => throw Exception("Tower not found"));

        // final selectedTower = towers.firstWhere(
        //   (tower) => tower.id == towerId,
        //   orElse: () => throw Exception("Tower not found"),
        // );

        final notesController =
            TextEditingController(text: selectedTower.notes);
        Timer? _debounceTimer;

        return Dialog(
          elevation: 10,
          child: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
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
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                        const SizedBox(width: 10),

                        // survey status dropdown
                        Container(
                          padding: const EdgeInsets.only(left: 14, right: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: selectedTower.surveyStatus.color),
                          child: DropdownButton<SurveyStatus>(
                            // require type specifics
                            isDense: true,
                            value: selectedTower.surveyStatus,
                            onChanged: (value) {
                              if (value != null &&
                                  value != selectedTower.surveyStatus) {
                                FirestoreService.updateTower(selectedTower.id,
                                    data: {'surveyStatus': value.name});
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
                            iconEnabledColor:
                                Theme.of(context).colorScheme.surface,
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedTower.images.length,
                        itemBuilder: (context, index) {
                          return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showImageDialog(context,
                                          selectedTower.images[index], towerId);
                                    },
                                    // TODO: implement image onTap
                                    // onTap: () => DialogUtils.showImageDialog(context, selectedTower.images[index], onDownload, onDelete),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: ConstrainedBox(
                                        constraints:
                                            BoxConstraints(maxHeight: 400),
                                        child: Image.network(
                                          // UNDONE: not sure why image won't show, though the url works
                                          selectedTower.images[index],
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 120,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey,
                                              child: Icon(Icons.error,
                                                  color: AppColors.red),
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
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          selectedTower.images.isEmpty
                              ? 'Unsurveyed' // No images
                              : selectedTower.images.length == 1
                                  ? 'Signed in at ${DateFormat('hh:mm a, d MMM y').format(selectedTower.signIn!.toDate())}' // Exactly 1 image
                                  : 'Signed out at ${DateFormat('hh:mm a, d MMM y').format(selectedTower.signOut!.toDate())}', // More than 1 image
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
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 14),
                        buildCounter: (context,
                            {required currentLength,
                            maxLength,
                            required isFocused}) {
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
                          hintStyle: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: 14),
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                        ),
                        onChanged: (text) async {
                          // cancel any previous debounce timer
                          if (_debounceTimer?.isActive ?? false)
                            _debounceTimer?.cancel();

                          _debounceTimer =
                              Timer(const Duration(milliseconds: 2000), () {
                            // update notes every one second of changes
                            FirestoreService.towersCollection
                                .doc(towerId)
                                .update({'notes': text});

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

  static Future<void> _deleteImage(BuildContext context, String url) async {
    try {
      // confirmation dialog
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm Deletion"),
            content: Text(
                "Are you sure you want to delete this image? This action cannot be undone."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false), // cancel
                child: Text(
                  'Cancel',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // confirm
                child: Text(
                  'Delete',
                  style: TextStyle(
                      color: AppColors.red, fontWeight: FontWeight.bold),
                ),
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ],
          );
        },
      );

      if (confirm != true) return;

      if (context.mounted) showLoadingDialog(context);

      // do deletion here
      // final towers = Provider.of<List<Tower>>(context, listen: false);
      // final selectedTower = towers.firstWhere(
      //   (tower) => tower.id == towerId,
      //   orElse: () => throw Exception("Tower not found"),
      // );

      // check if tower has 1 image
    } catch (e) {
    } finally {}
  }

  static Future<void> _downloadImage(BuildContext context, String url) async {
    try {
      showLoadingDialog(context);

      if (!kIsWeb) {
        final permission = Platform.isAndroid
            ? (await DeviceInfoPlugin().androidInfo).version.sdkInt > 32
                ? Permission.photos
                : Permission.storage
            : Permission.photos;

        final status = await permission.request();

        if (status.isDenied) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Storage permission is required to save the image.')),
            );
          }
          return;
        }

        if (status.isPermanentlyDenied) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  'Permission permanently denied. Please allow it from settings.',
                ),
                action: SnackBarAction(
                  label: 'Settings',
                  onPressed: () {
                    openAppSettings();
                  },
                ),
              ),
            );
          }
          return;
        }
      }

      // get image
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download the image. Status code: ${response.statusCode}');
      }

      if (kIsWeb) {
        // download file via browser
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Downloading via browser...')),
          );
        }

        final Uri uri = Uri.parse(url);
        await launchUrl(uri);
        // return;
      } else {
        final tempDir = await getTemporaryDirectory();
        final filePath =
            "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Save to gallery (implement your Gal.putImage logic here)
        await Gal.putImage(filePath);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image saved to Gallery')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download image: $e')),
        );
      }
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context); // exit image
      }
    }
  }
}
