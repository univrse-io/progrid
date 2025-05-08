import 'dart:developer';
import 'dart:io';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../models/drawing_status.dart';
import '../models/issue.dart';
import '../models/survey_status.dart';
import '../models/tower.dart';
import '../services/firebase_firestore_service.dart';
import '../services/firebase_storage_service.dart';

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
  late final isSignin = widget.tower.surveyStatus == SurveyStatus.unsurveyed;
  late SurveyStatus surveyStatus = widget.tower.surveyStatus;
  late DrawingStatus? drawingStatus = widget.tower.drawingStatus;
  bool isLoading = false;
  File? uploadImage;

  Future<void> pickImage(ImageSource source) async {
    if (mounted) Navigator.pop(context);
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return;
    setState(() => isLoading = true);

    try {
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

      final imageFile = File(pickedFile.path);
      final decodeImage = img.decodeImage(imageFile.readAsBytesSync());

      if (decodeImage == null) throw Exception('Failed to decode image.');

      const minWidth = 600;
      const maxWidth = 1080;
      const minHeight = 600;
      const maxHeight = 1920;
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
      uploadImage = await File(
        watermarkedImagePath,
      ).writeAsBytes(img.encodeJpg(compressedImage));
    } catch (e) {
      log('Failed to upload image.', error: e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload image.')),
        );
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(isSignin ? 'Sign In' : 'Sign Out')),
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
                InkWell(
                  onTap:
                      isLoading
                          ? null
                          : () => showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: Text(
                                    uploadImage != null
                                        ? 'Replace image'
                                        : 'Upload image',
                                  ),
                                  content: const Text(
                                    'Which source do you want to upload from?',
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Expanded(
                                          child: CarbonSecondaryButton(
                                            onPressed:
                                                () => pickImage(
                                                  ImageSource.camera,
                                                ),
                                            label: 'Open Camera',
                                          ),
                                        ),
                                        Expanded(
                                          child: CarbonPrimaryButton(
                                            onPressed:
                                                () => pickImage(
                                                  ImageSource.gallery,
                                                ),
                                            label: 'From Gallery',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                          ),
                  child: Ink(
                    width: 120,
                    height: 120,
                    color: carbonToken?.field01,
                    child:
                        isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : uploadImage != null
                            ? Image.file(fit: BoxFit.cover, uploadImage!)
                            : const Icon(CarbonIcon.add),
                  ),
                ),
                const Spacing.$3(),
                Text('Notes', style: CarbonTextStyle.headingCompact01),
                const Spacing.$3(),
                CarbonTextInput(
                  controller: descriptionController,
                  maxCharacters: 200,
                  keyboardType: TextInputType.multiline,
                ),
                const Spacing.$3(),
                // TODO: Admins able to update survey status, drawing status, and remove photos.
                // if (isAdmin) ...[
                //   Text(
                //     'Survey Status',
                //     style: CarbonTextStyle.headingCompact01,
                //   ),
                //   const Spacing.$3(),
                //   CarbonDropdown<SurveyStatus>(
                //     initialSelection: surveyStatus,
                //     inputDecorationTheme: InputDecorationTheme(
                //       isCollapsed: true,
                //       filled: true,
                //       fillColor: surveyStatus?.color.withValues(alpha: 0.1),
                //     ),
                //     onSelected: (value) {
                //       if (value != null) setState(() => surveyStatus = value);
                //     },
                //     dropdownMenuEntries: [
                //       ...SurveyStatus.values.map(
                //         (status) => DropdownMenuEntry(
                //           value: status,
                //           label: status.toString(),
                //         ),
                //       ),
                //     ],
                //   ),
                //   const Spacing.$3(),
                //   Text(
                //     'Drawing Status',
                //     style: CarbonTextStyle.headingCompact01,
                //   ),
                //   const Spacing.$3(),
                //   CarbonDropdown<DrawingStatus>(
                //     initialSelection: drawingStatus,
                //     inputDecorationTheme: InputDecorationTheme(
                //       isCollapsed: true,
                //       filled: true,
                //       fillColor: drawingStatus?.color.withValues(alpha: 0.1),
                //     ),
                //     onSelected: (value) {
                //       if (value != null) setState(() => drawingStatus = value);
                //     },
                //     dropdownMenuEntries: [
                //       ...DrawingStatus.values.map(
                //         (status) => DropdownMenuEntry(
                //           value: status,
                //           label: status.toString(),
                //         ),
                //       ),
                //     ],
                //   ),
                //   const Spacing.$3(),
                // ],
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CarbonPrimaryButton(
            onPressed:
                descriptionController.text.isEmpty || uploadImage == null
                    ? null
                    : () async {
                      final downloadUrl = await FirebaseStorageService()
                          .uploadTowerImage(
                            widget.tower.id,
                            file: uploadImage!,
                          );

                      await FirebaseFirestoreService().updateTower(
                        widget.tower.id,
                        data: {
                          'surveyStatus':
                              isSignin
                                  ? SurveyStatus.inprogress.name
                                  : SurveyStatus.surveyed.name,
                          if (isSignin)
                            'signIn': Timestamp.fromDate(DateTime.now()),
                          if (!isSignin)
                            'signOut': Timestamp.fromDate(DateTime.now()),
                          'images':
                              isSignin
                                  ? [downloadUrl]
                                  : FieldValue.arrayUnion([downloadUrl]),
                          'notes':
                              '${widget.tower.notes}\n'
                              '[${DateFormat('y-MM-dd HH:mm').format(DateTime.now())}] ${descriptionController.text}',
                          'authorId': user!.uid,
                          'authorName': user!.displayName,
                        },
                      );

                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isSignin
                                  ? 'Successfully signed in ${widget.tower.id}!'
                                  : 'Successfully signed out ${widget.tower.id}!',
                            ),
                          ),
                        );
                        Navigator.pop(context);
                        Navigator.pop(context);
                      }
                    },
            label: 'Submit',
            icon: CarbonIcon.checkmark,
          ),
        ),
      ],
    ),
  );
}
