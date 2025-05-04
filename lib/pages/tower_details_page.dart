import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_saver/file_saver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
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
import '../services/firebase_firestore_service.dart';
import 'edit_tower_page.dart';
import 'issues_page.dart';

class TowerDetailsPage extends StatefulWidget {
  final Tower tower;

  const TowerDetailsPage(this.tower, {super.key});

  @override
  State<TowerDetailsPage> createState() => _TowerDetailsPageState();
}

class _TowerDetailsPageState extends State<TowerDetailsPage> {
  late final noteController = TextEditingController(text: widget.tower.notes);
  late final carbonToken = Theme.of(context).extension<CarbonToken>();
  late final issues = Provider.of<List<Issue>>(context, listen: false);
  late final isAdmin = Provider.of<bool>(context, listen: false);

  Future<void> downloadImage(String imageUrl) async {
    try {
      if (!kIsWeb) {
        final permission =
            Platform.isAndroid
                ? (await DeviceInfoPlugin().androidInfo).version.sdkInt > 32
                    ? Permission.photos
                    : Permission.storage
                : Permission.photos;

        final status = await permission.request();

        if (status.isDenied) {
          if (mounted) {
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
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Permission permanently denied. Please allow it from the settings.',
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

      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode != 200) {
        throw Exception('Network error. Status code: ${response.statusCode}');
      }

      if (kIsWeb) {
        await FileSaver.instance.saveFile(
          name: 'test ${DateTime.now().millisecondsSinceEpoch}',
          bytes: response.bodyBytes,
          mimeType: MimeType.jpeg,
          ext: 'jpg',
        );
        return;
      } else {
        final tempDir = await getTemporaryDirectory();
        final path =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
        final file = await File(path).writeAsBytes(response.bodyBytes);

        await Gal.putImage(file.path);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image saved to the gallery.')),
          );
        }
      }
    } catch (e) {
      log('Failed to download image.', error: e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to download the image.')),
        );
      }
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Row(
        children: [
          Spacing.$4(color: widget.tower.surveyStatus.color),
          const Spacing.$3(),
          Text(widget.tower.id),
        ],
      ),
    ),
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.tower.name,
            textAlign: TextAlign.center,
            style: CarbonTextStyle.heading04,
          ),
          const Spacing.$2(),
          Text(widget.tower.description, textAlign: TextAlign.center),
          const Spacing.$6(),
          const Divider(),
          const Spacing.$6(),
          Text('Address', style: CarbonTextStyle.headingCompact01),
          const Spacing.$3(),
          SelectableText(widget.tower.address),
          const Spacing.$3(),
          Text('Region', style: CarbonTextStyle.headingCompact01),
          const Spacing.$3(),
          Text(widget.tower.region.toString()),
          const Spacing.$3(),
          Text('Type', style: CarbonTextStyle.headingCompact01),
          const Spacing.$3(),
          Text(widget.tower.type),
          const Spacing.$3(),
          Text('LatLong', style: CarbonTextStyle.headingCompact01),
          const Spacing.$3(),
          CarbonLink(
            onPressed: () async {
              if (kIsWeb) return;
              final latlng =
                  '${widget.tower.position.latitude},${widget.tower.position.longitude}';
              final googleMaps =
                  'https://www.google.com/maps/search/?api=1&query=$latlng';
              final appleMaps = 'https://maps.apple.com/?q=$latlng';
              final url = Platform.isAndroid ? googleMaps : appleMaps;

              if (!await launchUrl(Uri.parse(url))) {
                throw Exception('Could not launch $url');
              }
            },
            label:
                '${widget.tower.position.latitude.toStringAsFixed(4)}, '
                '${widget.tower.position.longitude.toStringAsFixed(4)}',
            icon: CarbonIcon.arrow_up_right,
          ),
          const Spacing.$3(),
          Text('Survey Status', style: CarbonTextStyle.headingCompact01),
          const Spacing.$3(),
          Text(
            widget.tower.surveyStatus.toString(),
            style: TextStyle(color: widget.tower.surveyStatus.color),
          ),
          const Spacing.$3(),
          if (widget.tower.drawingStatus != null) ...[
            Text('Drawing Status', style: CarbonTextStyle.headingCompact01),
            const Spacing.$3(),
            Text(
              widget.tower.drawingStatus.toString(),
              style: TextStyle(color: widget.tower.drawingStatus?.color),
            ),
            const Spacing.$3(),
          ],
          if (widget.tower.images.isNotEmpty) ...[
            Text('Photos', style: CarbonTextStyle.headingCompact01),
            const Spacing.$3(),
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const Spacing.$2(),
                itemCount: widget.tower.images.length,
                itemBuilder:
                    (context, index) => GestureDetector(
                      onTap: () {
                        final imageUrl = widget.tower.images[index];

                        showDialog(
                          context: context,
                          builder:
                              (context) => Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(24),
                                child: Stack(
                                  children: [
                                    Image.network(imageUrl),
                                    Positioned(
                                      bottom: 5,
                                      left: 5,
                                      child: FloatingActionButton.small(
                                        tooltip: 'Download',
                                        elevation: 0,
                                        onPressed:
                                            () => downloadImage(imageUrl),
                                        child: const Icon(CarbonIcon.download),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                      child: Image.network(
                        widget.tower.images[index],
                        fit: BoxFit.cover,
                        width: 120,
                        errorBuilder:
                            (_, __, ___) => IgnorePointer(
                              child: Container(
                                width: 120,
                                color: carbonToken?.field01,
                                padding: const EdgeInsets.all(8),
                                child: const Text('Image not available.'),
                              ),
                            ),
                      ),
                    ),
              ),
            ),
            const Spacing.$3(),
          ],
          if (widget.tower.notes != null) ...[
            Text('Notes', style: CarbonTextStyle.headingCompact01),
            const Spacing.$3(),
            SelectableText(widget.tower.notes!),
            const Spacing.$3(),
          ],
          const Spacing.$6(),
          if (isAdmin)
            CarbonPrimaryButton(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditTowerPage(widget.tower),
                    ),
                  ),
              label: 'Update Tower',
              icon: CarbonIcon.edit,
            )
          else if (widget.tower.surveyStatus == SurveyStatus.unsurveyed)
            CarbonPrimaryButton(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditTowerPage(widget.tower),
                    ),
                  ),
              label: 'Sign In',
              icon: CarbonIcon.login,
            )
          else if (widget.tower.surveyStatus == SurveyStatus.inprogress)
            CarbonPrimaryButton(
              // added condition to check if there are any unresolved issues
              onPressed:
                  widget.tower.images.length != 1 ||
                          issues.any(
                            (issue) => issue.status == IssueStatus.unresolved,
                          )
                      ? null // add text indicator to show what is missing? maybe move conditional logic to signout function itself
                      : () async {
                        await _signOut();
                      },
              label: 'Sign Out',
              icon: CarbonIcon.logout,
            ),
          if (isAdmin || widget.tower.surveyStatus != SurveyStatus.surveyed)
            const Spacing.$5(),
          CarbonSecondaryButton(
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => IssuesPage(tower: widget.tower),
                  ),
                ),
            label: 'View Issues',
            icon: CarbonIcon.document_multiple_01,
          ),
        ],
      ),
    ),
  );

  Future<void> _signIn() async {
    try {
      if (widget.tower.images.length == 1) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tower has already been signed-in')),
          );
        }
        return;
      }

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
      if (widget.tower.images.length != 1) {
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
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;

    if (mounted) Navigator.pop(context);
    // if (mounted) DialogUtils.showLoadingDialog(context);

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
        'towers/${widget.tower}/$fileName',
      );

      final uploadTask = storageRef.putFile(File(watermarkedImagePath));

      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();

      if (mounted) {
        final user = Provider.of<User?>(context, listen: false);
        await FirebaseFirestoreService().updateTower(
          widget.tower.id,
          data: {'authorId': user?.uid ?? ''},
        );
        await FirebaseFirestoreService().updateTower(
          widget.tower.id,
          data: {
            'images': FieldValue.arrayUnion([downloadUrl]),
          },
        );
        if (isSignOut) {
          await FirebaseFirestoreService().updateTower(
            widget.tower.id,
            data: {
              'signOut': Timestamp.fromDate(DateTime.now()),
              'surveyStatus': SurveyStatus.surveyed.name,
            },
          );
        } else {
          await FirebaseFirestoreService().updateTower(
            widget.tower.id,
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

  //       if (widget.tower.images.length == 1) {
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
  //         if (url == widget.tower.images.first) {
  //           Navigator.pop(context);
  //           throw Exception('Can only delete the latest image');
  //         }

  //         // delete image reference, image file, and signOut time
  //         await FirebaseStorage.instance.refFromURL(url).delete();
  //         final _updatedImages = List<String>.from(widget.tower.images)..remove(url);
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
}
