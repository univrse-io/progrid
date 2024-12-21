import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_watermark/image_watermark.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progrid/models/providers/records_provider.dart';
import 'package:provider/provider.dart';

class RecordPage extends StatefulWidget {
  final String towerId;
  final String recordId;

  const RecordPage({super.key, required this.recordId, required this.towerId});

  @override
  State<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends State<RecordPage> {
  final _notesController = TextEditingController();
  final int _maxNotesLength = 500;
  final int _maxImages = 2; // maximum number of images
  final int _minImages = 1; // minimum number of images

  // images
  final List<File> _newImages = [];
  final _picker = ImagePicker();

  double _uploadProgress = 0;
  bool _isLoading = false;

  // TODO: implement image download
  // TODO: reimplement upload/download loading bar

  Future<void> _pickImage(ImageSource source) async {
    // restrict max images
    if (_newImages.length >= _maxImages) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only upload up to $_maxImages pictures.")),
      );
      return;
    }

    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      try {
        setState(() {
          _isLoading = true;
        });

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

        // get current date/time
        final now = DateTime.now();
        final formattedDateTime = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

        // get current device location
        final position = await Geolocator.getCurrentPosition();
        final latitude = position.latitude.toStringAsFixed(6);
        final longitude = position.longitude.toStringAsFixed(6);

        // compress if larger than 10mb
        File imageFile = File(pickedFile.path);
        final int imageSize = await imageFile.length(); // file size in bytes

        if (imageSize > 10 * 1024 * 1024) {
          // if image is larger than 10 MB, compress the image
          final compressedBytes = await FlutterImageCompress.compressWithFile(
            imageFile.path,
            quality: 70, // set compression quality
          );

          if (compressedBytes != null) {
            imageFile = File('${(await getTemporaryDirectory()).path}/${pickedFile.name}');
            await imageFile.writeAsBytes(compressedBytes);
          }
        }

        // add watermark
        final watermarkText = '$formattedDateTime\nLat: $latitude, Lon: $longitude';
        final bytes = await ImageWatermark.addTextWatermark(
          imgBytes: await imageFile.readAsBytes(),
          dstX: 10,
          dstY: 10,
          watermarkText: watermarkText,
        );

        // save with watermark
        final tempDir = await getTemporaryDirectory();
        final file = await File('${tempDir.path}/${pickedFile.name}').writeAsBytes(bytes);

        setState(() {
          _newImages.add(file);
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error adding watermark: $e")),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // upload image to firebase storage
  Future<String> _uploadImage(File imageFile) async {
    try {
      final String fileName = DateTime.now().microsecondsSinceEpoch.toString(); // unique filename
      final Reference storageRef = FirebaseStorage.instance.ref('towers/${widget.towerId}/$fileName');

      final UploadTask uploadTask = storageRef.putFile(imageFile);

      // monitor upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred.toDouble() / snapshot.totalBytes.toDouble();
        });
      });

      final TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw 'Image upload failed: $e';
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final record = Provider.of<RecordsProvider>(context).records.firstWhere((record) => record.id == widget.recordId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recordId,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          // cross axis alignment stretch?
          children: [
            const SizedBox(height: 5),

            // images title
            Row(
              children: [
                const Text(
                  'Pictures',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 5),
                const Icon(Icons.image, size: 24),
              ],
            ),

            // images display
            Expanded(
              child: Container(
                height: 400,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                child: Stack(
                  children: [
                    // picture gallery
                    ListView.builder(
                      itemCount: record.images.length + _newImages.length,
                      itemBuilder: (context, index) {
                        final isOldImage = index < record.images.length;
                        final imageUrl = isOldImage ? record.images[index] : _newImages[index - record.images.length].path;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  // setState(() {
                                  //   _selectedImageUrl = imageUrl;
                                  // });
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: isOldImage
                                      ? Image.network(
                                          imageUrl,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        )
                                      : Image.file(
                                          File(imageUrl),
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                        ),
                                ),
                              ),
                              if (!isOldImage)
                                Positioned(
                                  top: 5,
                                  right: 5,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _newImages.removeAt(index - record.images.length);
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black.withOpacity(0.7),
                                      ),
                                      padding: const EdgeInsets.all(3),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),

                    // button controls
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: Row(
                        children: [
                          FloatingActionButton(
                            heroTag: 'camera',
                            onPressed: () => _pickImage(ImageSource.camera),
                            child: Icon(Icons.camera_alt),
                            mini: true,
                          ),
                          SizedBox(width: 2),
                          FloatingActionButton(
                            heroTag: 'gallery',
                            onPressed: () => _pickImage(ImageSource.gallery),
                            child: Icon(Icons.photo),
                            mini: true,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),

            // notes text field
            SizedBox(
              height: 200, // control text box height here
              child: TextField(
                controller: _notesController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                maxLength: _maxNotesLength,
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
                  hintText: 'Notes',
                  alignLabelWithHint: true,
                  hintStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 10),

            FilledButton(
              onPressed: () {
                // TODO: implement sign-in here
              },
              child: Text("Sign-In"),
            ),
            const SizedBox(height: 5),
            FilledButton(
              onPressed: () {
                // TODO: implement sign-out here
              },
              child: Text("Sign-Out"),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
