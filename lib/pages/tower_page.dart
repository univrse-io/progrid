import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gal/gal.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progrid/models/drawing_status.dart';
import 'package:progrid/models/survey_status.dart';
import 'package:progrid/pages/issues/issues_list_page.dart';
import 'package:progrid/providers/issues_provider.dart';
import 'package:progrid/providers/towers_provider.dart';
import 'package:progrid/providers/user_provider.dart';
import 'package:progrid/services/firestore.dart';
import 'package:progrid/utils/dialog_utils.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class TowerPage extends StatefulWidget {
  final String towerId;

  const TowerPage({super.key, required this.towerId});

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
    final towersProvider = Provider.of<TowersProvider>(context);
    final selectedTower = towersProvider.towers.firstWhere(
      (tower) => tower.id == widget.towerId,
      orElse: () => throw Exception("Tower not found"),
    );

    final issuesProvider = Provider.of<IssuesProvider>(context);
    final issues = issuesProvider.issues
        .where((issue) => issue.id.startsWith('${widget.towerId}-I')); // query all elements in this list, check if any are unresolved

    _notesController.text = selectedTower.notes ?? ''; // get tower notes

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
                  GestureDetector(
                    onTap: () async {
                      // TODO: implement apple maps
                      final towersProvider = Provider.of<TowersProvider>(context, listen: false);
                      final selectedTower = towersProvider.towers.firstWhere(
                        (tower) => tower.id == widget.towerId,
                        orElse: () => throw Exception("Tower not found"),
                      );

                      final uri = Uri(
                          scheme: "google.navigation",
                          queryParameters: {'q': "${selectedTower.position.latitude}, ${selectedTower.position.longitude}"});
                      if (await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                      } else {
                        print('unable to launch google maps');
                      }
                    },
                    child: Text(
                      '${selectedTower.position.latitude.toStringAsFixed(6)}, ${selectedTower.position.longitude.toStringAsFixed(6)}',
                      style: TextStyle(
                          fontSize: 16,
                          color: AppColors.blue,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  )
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
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: selectedTower.surveyStatus.color),
                    child: DropdownButton<SurveyStatus>(
                      // type specifics required
                      isDense: true,
                      value: selectedTower.surveyStatus,
                      onChanged: (value) {
                        if (value != null && value != selectedTower.surveyStatus) {
                          FirestoreService.updateTower(selectedTower.id, data: {'surveyStatus': value.name});
                          selectedTower.surveyStatus = value; // update local as well
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
                  ),
                ],
              ),
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
              _buildDetailRow('Address:', selectedTower.address),
              // site region
              _buildDetailRow('Region:', selectedTower.region.toString()),
              // site type
              _buildDetailRow('Type:', selectedTower.type),

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
                            onTap: () => DialogUtils.showImageDialog(
                                context, selectedTower.images[index], _downloadImage, _deleteImage),
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
                          ),
                        ],
                      ),
                    );
                  },
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
                      onPressed: selectedTower.images.isNotEmpty
                          ? null
                          : () async {
                              await _signIn();
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
                      // added condition to check if there are any unresolved issues
                      onPressed: selectedTower.images.length != 1 || issues.any((issue) => issue.status != 'resolved')
                          ? null // add text indicator to show what is missing? maybe move conditional logic to signout function itself
                          : () async {
                              await _signOut();
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

  Future<void> _signIn() async {
    try {
      final towersProvider = Provider.of<TowersProvider>(context, listen: false);
      final selectedTower = towersProvider.towers.firstWhere(
        (tower) => tower.id == widget.towerId,
        orElse: () => throw Exception("Tower not found"),
      );

      // check if there is already one image
      if (selectedTower.images.length == 1) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tower has already been signed-in'),
            ),
          );
        }
        return;
      }

      // do image upload stuff here
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Image Source',
              textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            titlePadding: EdgeInsets.only(top: 20, right: 20, left: 20),
            contentPadding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      _pickImage(ImageSource.camera, false);
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
                      // Navigator.pop(context);
                      _pickImage(ImageSource.gallery, false);
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
    } catch (e) {
      throw Exception('failed to call sign-in: $e');
    }
  }

  Future<void> _signOut() async {
    try {
      final towersProvider = Provider.of<TowersProvider>(context, listen: false);
      final selectedTower = towersProvider.towers.firstWhere(
        (tower) => tower.id == widget.towerId,
        orElse: () => throw Exception("Tower not found"),
      );

      // check if there is already one image
      if (selectedTower.images.length != 1) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please sign-in first'),
            ),
          );
        }
        return;
      }

      // do image upload stuff here
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Image Source',
              textAlign: TextAlign.center,
            ),
            titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
            titlePadding: EdgeInsets.only(top: 20, right: 20, left: 20),
            contentPadding: EdgeInsets.only(top: 10, left: 20, right: 20, bottom: 20),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      // Navigator.pop(context);
                      _pickImage(ImageSource.camera, true);
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
                      // Navigator.pop(context);
                      _pickImage(ImageSource.gallery, true);
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
    } catch (e) {
      throw Exception('failed to call sign-out: $e');
    }
  }

  Future<void> _pickImage(ImageSource source, bool isSignOut) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
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
              content: Text(status.isPermanentlyDenied
                  ? 'Location permission is permanently denied. Please enable it in settings.'
                  : 'Location permission is required to add location data.'),
              action: status.isPermanentlyDenied
                  ? SnackBarAction(
                      label: 'Settings',
                      onPressed: () => openAppSettings(),
                    )
                  : null,
            ),
          );
        }
        return;
      }

      // load image
      final File imageFile = File(pickedFile.path);
      final decodeImage = img.decodeImage(imageFile.readAsBytesSync());
      if (decodeImage == null) {
        throw 'Failed to decode image';
      }

      // scale image if too small or too big
      const minWidth = 600; // min width
      const maxWidth = 1080; // max width
      const minHeight = 600; // min height
      const maxHeight = 1920; // max height

      img.Image scaledImage = decodeImage;

      if (decodeImage.width < minWidth || decodeImage.height < minHeight) {
        // scale up
        final aspectRatio = decodeImage.height / decodeImage.width;
        scaledImage = img.copyResize(
          decodeImage,
          width: minWidth,
          height: (minWidth * aspectRatio).toInt(),
        );
      } else if (decodeImage.width > maxWidth || decodeImage.height > maxHeight) {
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
      final String tempImagePath = '${tempDir.path}/temp_${pickedFile.name}';
      final File tempImageFile = File(tempImagePath);
      await tempImageFile.writeAsBytes(img.encodeJpg(scaledImage));

      final int scaledImageSize = await tempImageFile.length();
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
      final compressedImage = img.decodeImage(await tempImageFile.readAsBytes());
      if (compressedImage == null) {
        print('Failed to decode compressed image');
        return;
      }

      // get current date/time
      final now = DateTime.now();
      final formattedDateTime = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      // get current device location
      final position = await Geolocator.getCurrentPosition();
      final latitude = position.latitude.toStringAsFixed(6);
      final longitude = position.longitude.toStringAsFixed(6);

      // add watermark to image
      final watermarkText = '$formattedDateTime\nLat: $latitude, Lon: $longitude';
      final x = compressedImage.width - 10;
      final y = compressedImage.height - 50;

      img.fillRect(compressedImage,
          x1: compressedImage.width - 400,
          y1: compressedImage.height - 60,
          x2: compressedImage.width,
          y2: compressedImage.height,
          color: img.ColorRgb8(0, 0, 0));
      img.drawString(compressedImage, watermarkText, font: img.arial24, x: x, y: y, color: img.ColorRgb8(255, 255, 255), rightJustify: true);

      // save image locally
      final watermarkedImagePath = '${(await getTemporaryDirectory()).path}/watermarked_${pickedFile.name}';
      await File(watermarkedImagePath).writeAsBytes(img.encodeJpg(compressedImage));

      // upload image to firebase storage
      final String fileName = '${DateTime.now().microsecondsSinceEpoch}'; // unique
      final Reference storageRef = FirebaseStorage.instance.ref('towers/${widget.towerId}/$fileName');

      final UploadTask uploadTask = storageRef.putFile(File(watermarkedImagePath));

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // update Firebase database and local
      if (mounted) {
        final towersProvider = Provider.of<TowersProvider>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await towersProvider.updateAuthorId(widget.towerId, userProvider.userId);
        await towersProvider.addImage(widget.towerId, downloadUrl);

        // update tower status
        if (isSignOut) {
          await towersProvider.updateSurveyStatus(widget.towerId, SurveyStatus.surveyed);
          await towersProvider.updateSignOut(widget.towerId, Timestamp.fromDate(DateTime.now()));
        } else {
          await towersProvider.updateSurveyStatus(widget.towerId, SurveyStatus.inprogress);
          await towersProvider.updateDrawingStatus(widget.towerId, DrawingStatus.inprogress);
          await towersProvider.updateSignIn(widget.towerId, Timestamp.fromDate(DateTime.now()));
        }
      } else {
        throw Exception("provider addImage not mounted");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error Adding Image: $e")),
        );
      }
    } finally {
      if (mounted) Navigator.pop(context); // close loading dialog
    }
  }

  // delete image from tower
  Future<void> _deleteImage(String url) async {
    try {
      // confirmation dialog
      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm Deletion"),
            content: Text("Are you sure you want to delete this image? This action cannot be undone."),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false), // cancel
                child: Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold),),
                style: TextButton.styleFrom(
                  textStyle: Theme.of(context).textTheme.labelLarge,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // confirm
                child: Text(
                  'Delete',
                  style: TextStyle(color: AppColors.red, fontWeight: FontWeight.bold),
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

      if (mounted) {
        DialogUtils.showLoadingDialog(context);

        final towersProvider = Provider.of<TowersProvider>(context, listen: false);
        final selectedTower = towersProvider.towers.firstWhere(
          (tower) => tower.id == widget.towerId,
          orElse: () => throw Exception("Tower not found"),
        );

        // check if tower has 1 image
        if (selectedTower.images.length == 1) {
          // delete image reference, image file, signIn time, and authorId
          await FirebaseStorage.instance.refFromURL(url).delete();
          await FirestoreService.updateTower(widget.towerId, data: { 
            'images': FieldValue.delete(),
            'signIn': FieldValue.delete(),
            'authorId': FieldValue.delete(),
          });

          // reset tower status to unsurveyed
          towersProvider.updateSurveyStatus(widget.towerId, SurveyStatus.unsurveyed);
        } else {
          if (url == selectedTower.images.first) {
            Navigator.pop(context);
            throw Exception('Can only delete the latest image');
          }

          // delete image reference, image file, and signOut time
          await FirebaseStorage.instance.refFromURL(url).delete();
          final _updatedImages = List<String>.from(selectedTower.images)..remove(url);
          await FirestoreService.updateTower(widget.towerId, data: {
            'images': _updatedImages,
            'signOut': FieldValue.delete(),
          });

          // set tower status to inprogress
          towersProvider.updateSurveyStatus(widget.towerId, SurveyStatus.inprogress);
        }

        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image deleted successfully')),
          );
        }
      }

      // if tower has 1 image, delete image reference and signIn time
      // else, check if url matches 1st image; if matching throw 'can only delete latest', else delete image reference and signOut time
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete image: $e')),
        );
      }
    } finally {
      if (mounted) Navigator.pop(context);
    }
  }

  // download image from url
  Future<void> _downloadImage(String url) async {
    try {
      if (mounted) DialogUtils.showLoadingDialog(context);

      final permission = Platform.isAndroid
          ? (await DeviceInfoPlugin().androidInfo).version.sdkInt > 32
              ? Permission.photos
              : Permission.storage
          : Permission.photos;

      final status = await permission.request();

      if (status.isDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Storage permission is required to save the image.')),
          );
        }
        return;
      }

      if (status.isPermanentlyDenied) {
        if (mounted) {
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

      // get image
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception('Failed to download the image. Status code: ${response.statusCode}');
      }

      // get temp directory, save there
      final tempDir = await getTemporaryDirectory();
      final filePath = "${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg";

      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // save to main gallery
      await Gal.putImage(filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to Gallery')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download image: $e')),
        );
      }
    } finally {
      if (mounted) Navigator.pop(context);
    }
  }

  // UI function to build a detail row format
  Widget _buildDetailRow(String label, String content) {
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
