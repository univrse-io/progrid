import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/drawing_status.dart';
import '../models/issue.dart';
import '../models/issue_status.dart';
import '../models/survey_status.dart';
import '../models/tower.dart';
import '../services/firebase_firestore.dart';
import '../utils/dialog_utils.dart';
import '../utils/themes.dart';
import 'issues/issues_list_page.dart';

class TowerPage extends StatefulWidget {
  final String towerId;

  const TowerPage({required this.towerId, super.key});

  @override
  State<TowerPage> createState() => _TowerPageState();
}

class _TowerPageState extends State<TowerPage> {
  final _notesController = TextEditingController();

  Timer? _debounceTimer;
  final int _maxNotesLength = 500;
  final _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final towers = Provider.of<List<Tower>>(context);
    final selectedTower = towers.firstWhere(
      (tower) => tower.id == widget.towerId,
    );

    final issues = Provider.of<List<Issue>>(context);

    _notesController.text = selectedTower.notes ?? ''; // get tower notes

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedTower.id,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                selectedTower.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'LatLong:',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () async {
                      // TODO: implement apple maps
                      final towers = Provider.of<List<Tower>>(
                        context,
                        listen: false,
                      );
                      final selectedTower = towers.firstWhere(
                        (tower) => tower.id == widget.towerId,
                      );

                      final uri = Uri(
                        scheme: 'google.navigation',
                        queryParameters: {
                          'q':
                              '${selectedTower.position.latitude}, ${selectedTower.position.longitude}',
                        },
                      );
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        log('unable to launch google maps');
                      }
                    },
                    child: Text(
                      '${selectedTower.position.latitude.toStringAsFixed(6)}, ${selectedTower.position.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // tower survey status
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Survey:',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 17),
                  ),
                  const SizedBox(width: 5),

                  // dropdown
                  Container(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: selectedTower.surveyStatus.color,
                    ),
                    child: DropdownButton<SurveyStatus>(
                      // type specifics required
                      isDense: true,
                      value: selectedTower.surveyStatus,
                      onChanged: (value) {
                        if (value != null &&
                            value != selectedTower.surveyStatus) {
                          FirebaseFirestoreService().updateTower(
                            selectedTower.id,
                            data: {'surveyStatus': value.name},
                          );
                          selectedTower.surveyStatus = value;
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
                      iconEnabledColor: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(24),
                      dropdownColor: selectedTower.surveyStatus.color,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Text(
                    'Site Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.list, size: 27),
                ],
              ),
              const SizedBox(height: 4),
              _buildDetailRow('Address:', selectedTower.address),
              _buildDetailRow('Region:', selectedTower.region.toString()),
              _buildDetailRow('Type:', selectedTower.type),
              const SizedBox(height: 10),
              const Text(
                'Pictures',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 130,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.tertiary,
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
                              onTap:
                                  () => DialogUtils.showImageDialog(
                                    context,
                                    selectedTower.images[index],
                                    widget.towerId,
                                  ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxHeight: 400,
                                  ),
                                  child: Image.network(
                                    selectedTower.images[index],
                                    fit: BoxFit.cover,
                                    height: 120,
                                    width: 120,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const ColoredBox(
                                              color: Colors.grey,
                                              child: Icon(
                                                Icons.error,
                                                color: AppColors.red,
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
                    selectedTower.images.isEmpty
                        ? 'Unsurveyed' // No images
                        : selectedTower.images.length == 1
                        ? 'Signed-in' // Exactly 1 image
                        : 'Signed-out', // More than 1 image
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Additional Notes',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 120, // control text box height here
                child: TextField(
                  controller: _notesController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  maxLength: _maxNotesLength,
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
                            color: Theme.of(context).colorScheme.secondary,
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
                    if (_debounceTimer?.isActive ?? false) {
                      _debounceTimer?.cancel();
                    }

                    _debounceTimer = Timer(
                      const Duration(milliseconds: 2000),
                      () {
                        // update notes every one second of changes
                        FirebaseFirestoreService().updateTower(
                          widget.towerId,
                          data: {'notes': text},
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed:
                          selectedTower.images.isNotEmpty
                              ? null
                              : () async {
                                await _signIn();
                              },
                      style: FilledButton.styleFrom(
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                        minimumSize: const Size.fromHeight(45),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text('Sign-In'),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: FilledButton(
                      // added condition to check if there are any unresolved issues
                      onPressed:
                          selectedTower.images.length != 1 ||
                                  issues.any(
                                    (issue) =>
                                        issue.status == IssueStatus.unresolved,
                                  )
                              ? null // add text indicator to show what is missing? maybe move conditional logic to signout function itself
                              : () async {
                                await _signOut();
                              },
                      style: FilledButton.styleFrom(
                        textStyle: const TextStyle(fontWeight: FontWeight.w600),
                        minimumSize: const Size.fromHeight(45),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                      ),
                      child: const Text('Sign-Out'),
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
                      builder:
                          (context) =>
                              IssuesListPage(towerId: selectedTower.id),
                    ),
                  );
                },
                child: const Text('View Issues'),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    try {
      final towers = Provider.of<List<Tower>>(context, listen: false);
      final selectedTower = towers.firstWhere(
        (tower) => tower.id == widget.towerId,
        orElse: () => throw Exception('Tower not found'),
      );

      // check if there is already one image
      if (selectedTower.images.length == 1) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tower has already been signed-in')),
          );
        }
        return;
      }

      // do image upload stuff here
      unawaited(
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text(
                  'Select Image Source',
                  textAlign: TextAlign.center,
                ),
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                titlePadding: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                ),
                contentPadding: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          // Navigator.pop(context);
                          _pickImage(ImageSource.camera, false);
                        },
                        style: FilledButton.styleFrom(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          minimumSize: const Size.fromHeight(120),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 30),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          // Navigator.pop(context);
                          _pickImage(ImageSource.gallery, false);
                        },
                        style: FilledButton.styleFrom(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          minimumSize: const Size.fromHeight(120),
                        ),
                        child: const Icon(Icons.file_upload_outlined, size: 30),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      );
    } catch (e) {
      throw Exception('failed to call sign-in: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      final towers = Provider.of<List<Tower>>(context, listen: false);
      final selectedTower = towers.firstWhere(
        (tower) => tower.id == widget.towerId,
      );

      // check if there is already one image
      if (selectedTower.images.length != 1) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Please sign-in first')));
        }
        return;
      }

      // do image upload stuff here
      unawaited(
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text(
                  'Select Image Source',
                  textAlign: TextAlign.center,
                ),
                titleTextStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                titlePadding: const EdgeInsets.only(
                  top: 20,
                  right: 20,
                  left: 20,
                ),
                contentPadding: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          // Navigator.pop(context);
                          _pickImage(ImageSource.camera, true);
                        },
                        style: FilledButton.styleFrom(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          minimumSize: const Size.fromHeight(120),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 30),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          // Navigator.pop(context);
                          _pickImage(ImageSource.gallery, true);
                        },
                        style: FilledButton.styleFrom(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          minimumSize: const Size.fromHeight(120),
                        ),
                        child: const Icon(Icons.file_upload_outlined, size: 30),
                      ),
                    ),
                  ],
                ),
              ),
        ),
      );
    } catch (e) {
      throw Exception('failed to call sign-out: $e');
    }
  }

  Future<void> _pickImage(ImageSource source, bool isSignOut) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    if (mounted) Navigator.pop(context);
    if (mounted) DialogUtils.showLoadingDialog(context);

    try {
      // request location permission
      final status = await Permission.locationWhenInUse.request();
      if (!status.isGranted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                status.isPermanentlyDenied
                    ? 'Location permission is permanently denied. Please enable it in settings.'
                    : 'Location permission is required to add location data.',
              ),
              action:
                  status.isPermanentlyDenied
                      ? const SnackBarAction(
                        label: 'Settings',
                        onPressed: openAppSettings,
                      )
                      : null,
            ),
          );
        }
        return;
      }

      // load image
      final imageFile = File(pickedFile.path);
      final decodeImage = img.decodeImage(imageFile.readAsBytesSync());
      if (decodeImage == null) {
        throw Exception('Failed to decode image');
      }

      // scale image if too small or too big
      const minWidth = 600; // min width
      const maxWidth = 1080; // max width
      const minHeight = 600; // min height
      const maxHeight = 1920; // max height

      var scaledImage = decodeImage;

      if (decodeImage.width < minWidth || decodeImage.height < minHeight) {
        // scale up
        final aspectRatio = decodeImage.height / decodeImage.width;
        scaledImage = img.copyResize(
          decodeImage,
          width: minWidth,
          height: (minWidth * aspectRatio).toInt(),
        );
      } else if (decodeImage.width > maxWidth ||
          decodeImage.height > maxHeight) {
        // scale down
        final aspectRatio = decodeImage.height / decodeImage.width;
        scaledImage = img.copyResize(
          decodeImage,
          width: maxWidth,
          height: (maxWidth * aspectRatio).toInt(),
        );
      }

      // compress if image is larger than 10mb
      final tempDir = await getTemporaryDirectory();
      final tempImagePath = '${tempDir.path}/temp_${pickedFile.name}';
      final tempImageFile = File(tempImagePath);
      await tempImageFile.writeAsBytes(img.encodeJpg(scaledImage));

      final scaledImageSize = await tempImageFile.length();
      if (scaledImageSize > 10 * 1024 * 1024) {
        final compressedBytes = await FlutterImageCompress.compressWithFile(
          tempImageFile.path,
          quality: 70,
        );

        if (compressedBytes != null) {
          await tempImageFile.writeAsBytes(compressedBytes);
        }
      }

      // reload image
      final compressedImage = img.decodeImage(
        await tempImageFile.readAsBytes(),
      );
      if (compressedImage == null) {
        log('Failed to decode compressed image');
        return;
      }

      // get current date/time
      final now = DateTime.now();
      final formattedDateTime =
          '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // get current device location
      final position = await Geolocator.getCurrentPosition();
      final latitude = position.latitude.toStringAsFixed(6);
      final longitude = position.longitude.toStringAsFixed(6);

      // add watermark to image
      final watermarkText =
          '$formattedDateTime\nLat: $latitude, Lon: $longitude';
      final x = compressedImage.width - 10;
      final y = compressedImage.height - 50;

      img.fillRect(
        compressedImage,
        x1: compressedImage.width - 400,
        y1: compressedImage.height - 60,
        x2: compressedImage.width,
        y2: compressedImage.height,
        color: img.ColorRgb8(0, 0, 0),
      );
      img.drawString(
        compressedImage,
        watermarkText,
        font: img.arial24,
        x: x,
        y: y,
        color: img.ColorRgb8(255, 255, 255),
        rightJustify: true,
      );

      // save image locally
      final watermarkedImagePath =
          '${(await getTemporaryDirectory()).path}/watermarked_${pickedFile.name}';
      await File(
        watermarkedImagePath,
      ).writeAsBytes(img.encodeJpg(compressedImage));

      // upload image to firebase storage
      final fileName = '${DateTime.now().microsecondsSinceEpoch}'; // unique
      final storageRef = FirebaseStorage.instance.ref(
        'towers/${widget.towerId}/$fileName',
      );

      final uploadTask = storageRef.putFile(File(watermarkedImagePath));

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      if (mounted) {
        final user = Provider.of<User?>(context, listen: false);
        await FirebaseFirestoreService().updateTower(
          widget.towerId,
          data: {'authorId': user?.uid ?? ''},
        );
        await FirebaseFirestoreService().updateTower(
          widget.towerId,
          data: {
            'images': FieldValue.arrayUnion([downloadUrl]),
          },
        );
        if (isSignOut) {
          await FirebaseFirestoreService().updateTower(
            widget.towerId,
            data: {
              'signOut': Timestamp.fromDate(DateTime.now()),
              'surveyStatus': SurveyStatus.surveyed.name,
            },
          );
        } else {
          await FirebaseFirestoreService().updateTower(
            widget.towerId,
            data: {
              'drawingStatus': DrawingStatus.inprogress.name,
              'signIn': Timestamp.fromDate(DateTime.now()),
              'surveyStatus': SurveyStatus.inprogress.name,
            },
          );
        }
      } else {
        throw Exception('provider addImage not mounted');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error Adding Image: $e')));
      }
    } finally {
      if (mounted) Navigator.pop(context);
    }
  }

  // delete image from tower
  // Future<void> _deleteImage(BuildContext context, String url) async {
  //   try {
  //     // confirmation dialog
  //     final confirm = await showDialog<bool>(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text("Confirm Deletion"),
  //           content: Text("Are you sure you want to delete this image? This action cannot be undone."),
  //           actions: <Widget>[
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, false), // cancel
  //               child: Text(
  //                 'Cancel',
  //                 style: TextStyle(fontWeight: FontWeight.bold),
  //               ),
  //               style: TextButton.styleFrom(
  //                 textStyle: Theme.of(context).textTheme.labelLarge,
  //               ),
  //             ),
  //             TextButton(
  //               onPressed: () => Navigator.pop(context, true), // confirm
  //               child: Text(
  //                 'Delete',
  //                 style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
  //               ),
  //               style: TextButton.styleFrom(
  //                 textStyle: Theme.of(context).textTheme.labelLarge,
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     );

  //     if (confirm != true) return;

  //     if (mounted) {
  //       DialogUtils.showLoadingDialog(context);

  //       final towers = Provider.of<List<Tower>>(context, listen: false);
  //       final selectedTower = towers.firstWhere(
  //         (tower) => tower.id == widget.towerId,
  //         orElse: () => throw Exception("Tower not found"),
  //       );

  //       // check if tower has 1 image
  //       if (selectedTower.images.length == 1) {
  //         // delete image reference, image file, signIn time, and authorId
  //         await FirebaseStorage.instance.refFromURL(url).delete();
  //         await FirestoreService.updateTower(widget.towerId, data: {
  //           'images': FieldValue.delete(),
  //           'signIn': FieldValue.delete(),
  //           'authorId': FieldValue.delete(),
  //         });

  //         // reset tower status to unsurveyed
  //         towers.updateSurveyStatus(widget.towerId, SurveyStatus.unsurveyed);
  //       } else {
  //         if (url == selectedTower.images.first) {
  //           Navigator.pop(context);
  //           throw Exception('Can only delete the latest image');
  //         }

  //         // delete image reference, image file, and signOut time
  //         await FirebaseStorage.instance.refFromURL(url).delete();
  //         final _updatedImages = List<String>.from(selectedTower.images)..remove(url);
  //         await FirestoreService.updateTower(widget.towerId, data: {
  //           'images': _updatedImages,
  //           'signOut': FieldValue.delete(),
  //         });

  //         // set tower status to inprogress
  //         towers.updateSurveyStatus(widget.towerId, SurveyStatus.inprogress);
  //       }

  //       if (mounted) {
  //         Navigator.pop(context);
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Image deleted successfully')),
  //         );
  //       }
  //     }

  //     // if tower has 1 image, delete image reference and signIn time
  //     // else, check if url matches 1st image; if matching throw 'can only delete latest', else delete image reference and signOut time
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to delete image: $e')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) Navigator.pop(context);
  //   }
  // }

  // // download image from url
  // Future<void> _downloadImage(BuildContext context, String url) async {
  //   try {
  //     if (mounted) DialogUtils.showLoadingDialog(context);

  //     final permission = Platform.isAndroid
  //         ? (await DeviceInfoPlugin().androidInfo).version.sdkInt > 32
  //             ? Permission.photos
  //             : Permission.storage
  //         : Permission.photos;

  //     final status = await permission.request();

  //     if (status.isDenied) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Storage permission is required to save the image.')),
  //         );
  //       }
  //       return;
  //     }

  //     if (status.isPermanentlyDenied) {
  //       if (mounted) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: const Text(
  //               'Permission permanently denied. Please allow it from settings.',
  //             ),
  //             action: SnackBarAction(
  //               label: 'Settings',
  //               onPressed: () {
  //                 openAppSettings();
  //               },
  //             ),
  //           ),
  //         );
  //       }
  //       return;
  //     }

  //     // get image
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode != 200) {
  //       throw Exception('Failed to download the image. Status code: ${response.statusCode}');
  //     }

  //     // get temp directory, save there
  //     final tempDir = await getTemporaryDirectory();
  //     final filePath = "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

  //     final file = File(filePath);
  //     await file.writeAsBytes(response.bodyBytes);

  //     // save to main gallery
  //     await Gal.putImage(filePath);

  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Image saved to Gallery')),
  //       );
  //     }
  //   } catch (e) {
  //     if (mounted) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text('Failed to download image: $e')),
  //       );
  //     }
  //   } finally {
  //     if (mounted) Navigator.pop(context);
  //     if (mounted) Navigator.pop(context); // pop out of image
  //   }
  // }

  Widget _buildDetailRow(String label, String content) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(content, style: const TextStyle(fontSize: 16))),
      ],
    ),
  );
}
