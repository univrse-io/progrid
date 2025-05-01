import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/survey_status.dart';
import '../models/tower.dart';
import '../services/firebase_firestore.dart';

sealed class DialogUtils {
  static void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // cannot be dismissed on tap
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
  }

  static void showImageDialog(
    BuildContext context,
    String imageUrl,
    String towerId,
  ) {
    log(imageUrl);
    showDialog(
      context: context,
      builder:
          (context) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Stack(
                  children: [
                    // image object
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) => const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                    ),
                    Positioned(
                      bottom: 5,
                      left: 5,
                      child: Row(
                        children: [
                          FloatingActionButton.small(
                            onPressed: () => _downloadImage(context, imageUrl),
                            child: const Icon(Icons.download),
                          ),
                          const SizedBox(width: 2),
                          FloatingActionButton.small(
                            onPressed: () => _deleteImage(context, imageUrl),
                            child: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  // TODO: fix context inheritance issue
  static void showTowerDialog(BuildContext context, String towerId) {
    showDialog(
      context: context,
      builder: (context) {
        final towers = Provider.of<List<Tower>>(context);
        final selectedTower = towers.firstWhere(
          (tower) => tower.id == towerId,
          orElse: () => throw Exception('Tower not found'),
        );
        Timer? debounceTimer;

        return Dialog(
          elevation: 10,
          child: StatefulBuilder(
            builder:
                (context, setState) => ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500, // set a max width
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // tower id
                            Text(
                              selectedTower.id,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            const SizedBox(width: 10),
                            // survey status dropdown
                            Container(
                              padding: const EdgeInsets.only(
                                left: 14,
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(24),
                                color: selectedTower.surveyStatus.color,
                              ),
                              child: DropdownButton<SurveyStatus>(
                                isDense: true,
                                value: selectedTower.surveyStatus,
                                onChanged:
                                    context.watch<bool>()
                                        ? null
                                        : (value) {
                                          if (value != null &&
                                              value !=
                                                  selectedTower.surveyStatus) {
                                            FirebaseFirestoreService()
                                                .updateTower(
                                                  selectedTower.id,
                                                  data: {
                                                    'surveyStatus': value.name,
                                                  },
                                                );
                                            setState(
                                              () =>
                                                  selectedTower.surveyStatus =
                                                      value,
                                            );
                                          }
                                        },
                                items:
                                    SurveyStatus.values
                                        .map(
                                          (status) => DropdownMenuItem(
                                            value: status,
                                            child: Text(status.toString()),
                                          ),
                                        )
                                        .toList(),
                                iconEnabledColor:
                                    Theme.of(context).colorScheme.surface,
                                borderRadius: BorderRadius.circular(24),
                                icon:
                                    context.watch<bool>()
                                        ? null
                                        : const SizedBox(),
                                dropdownColor: selectedTower.surveyStatus.color,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          selectedTower.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${selectedTower.position.latitude.toStringAsFixed(6)}, ${selectedTower.position.longitude.toStringAsFixed(6)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        _buildDetailRow('Address:', selectedTower.address),
                        _buildDetailRow(
                          'Region:',
                          selectedTower.region.toString(),
                        ),
                        _buildDetailRow('Type:', selectedTower.type),
                        const SizedBox(height: 10),
                        Container(
                          height: 130,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color:
                                Theme.of(context).colorScheme.onInverseSurface,
                          ),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedTower.images.length,
                            itemBuilder:
                                (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 5,
                                  ),
                                  child: Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showImageDialog(
                                            context,
                                            selectedTower.images[index],
                                            towerId,
                                          );
                                        },
                                        // TODO: implement image onTap
                                        // onTap: () => DialogUtils.showImageDialog(context, selectedTower.images[index], onDownload, onDelete),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          child: ConstrainedBox(
                                            constraints: const BoxConstraints(
                                              maxHeight: 400,
                                            ),
                                            child: Image.network(
                                              // UNDONE: not sure why image won't show, though the url works
                                              selectedTower.images[index],
                                              fit: BoxFit.cover,
                                              height: 120,
                                              width: 120,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const ColoredBox(
                                                    color: Colors.grey,
                                                    child: Icon(
                                                      Icons.error,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              ' Status:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              selectedTower.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // notes
                        SizedBox(
                          height: 120,
                          child: TextField(
                            controller: TextEditingController(
                              text: selectedTower.notes,
                            ),
                            maxLines: null,
                            expands: true,
                            textAlignVertical: TextAlignVertical.top,
                            maxLength: 500,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14,
                            ),
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
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            decoration: InputDecoration(
                              hintText: 'Enter notes here...',
                              alignLabelWithHint: true,
                              hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 14,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                            ),
                            onChanged: (text) async {
                              // cancel any previous debounce timer
                              if (debounceTimer?.isActive ?? false) {
                                debounceTimer?.cancel();
                              }

                              debounceTimer = Timer(
                                const Duration(milliseconds: 2000),
                                () {
                                  // update notes every one second of changes
                                  FirebaseFirestoreService().updateTower(
                                    towerId,
                                    data: {'notes': text},
                                  );
                                  setState(() => selectedTower.notes = text);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ),
        );
      },
    );
  }

  static Widget _buildDetailRow(String label, String content) => Padding(
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
            style: const TextStyle(
              // decoration: TextDecoration.underline,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // content
        Expanded(child: Text(content, style: const TextStyle(fontSize: 16))),
      ],
    ),
  );

  static Future<void> _deleteImage(BuildContext context, String url) async {
    try {
      // confirmation dialog
      final confirm = await showDialog<bool>(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text(
                'Are you sure you want to delete this image? This action cannot be undone.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ), // confirm
                  child: const Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
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
    } finally {}
  }

  static Future<void> _downloadImage(BuildContext context, String url) async {
    try {
      showLoadingDialog(context);

      if (!kIsWeb) {
        final permission =
            Platform.isAndroid
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
                  'Storage permission is required to save the image.',
                ),
              ),
            );
          }
          return;
        }

        if (status.isPermanentlyDenied) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Permission permanently denied. Please allow it from settings.',
                ),
                action: SnackBarAction(
                  label: 'Settings',
                  onPressed: openAppSettings,
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
          'Failed to download the image. Status code: ${response.statusCode}',
        );
      }

      if (kIsWeb) {
        // download file via browser
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Downloading via browser...')),
          );
        }

        final uri = Uri.parse(url);
        await launchUrl(uri);
        // return;
      } else {
        final tempDir = await getTemporaryDirectory();
        final filePath =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Save to gallery (implement your Gal.putImage logic here)
        await Gal.putImage(filePath);

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image saved to Gallery')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to download image: $e')));
      }
    } finally {
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pop(context); // exit image
      }
    }
  }
}
