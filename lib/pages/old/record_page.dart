// TODO: rework this page for image adding.

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
  String? _selectedImageUrl;
  bool _isLoading = false;

  // close overlay
  void _closeOverlay() {
    setState(() {
      _selectedImageUrl = null;
    });
  }

  // download image and show progress
  Future<void> _downloadImage(String url) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final permission = Platform.isAndroid && androidInfo.version.sdkInt > 32
          ? Permission.photos
          : Permission.storage;
      final status = await permission.request();

      if (await Permission.storage.isRestricted) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Debug Storage Denied')),
          );
        }
      }

      if (status.isDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Storage permission is required to save the image.')),
          );
        }
        return;
      }

      if (status.isPermanentlyDenied) {
        // go to app settings
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Storage permission permanently denied. Please allow it from settings.',
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

      // download image
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) {
        throw Exception(
            'Failed to download the image. Status code: ${response.statusCode}');
      }

      // get directory
      Directory? externalDir = Directory(
          '/storage/emulated/0/Download'); // download folder on android
      if (!externalDir.existsSync()) {
        externalDir = await getExternalStorageDirectory();
      }

      final fileName =
          DateTime.now().millisecondsSinceEpoch; // extract file name from URL
      final file = File('${externalDir!.path}/$fileName');

      // write file
      await file.writeAsBytes(response.bodyBytes);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image saved to ${file.path}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save image: $e')),
        );
      }
    } finally {
      setState(() {
        _isLoading = false; // download complete
      });
    }
  }

  String _formatTimestamp(Timestamp timestamp) {
    final DateTime dateTime = timestamp.toDate();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final record = Provider.of<RecordsProvider>(context)
        .records
        .firstWhere((record) => record.id == widget.recordId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recordId,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            minimum: EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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

                // images grid
                if (record.images.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(
                      height: record.images.length <= 2
                          ? 170 // height if 1 row
                          : 250, // height if more
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // columns count
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: record.images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageUrl = record.images[index];
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                record.images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 15),

                // dates section
                Row(
                  children: [
                    const Text(
                      'Signed In:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _formatTimestamp(record.signIn!),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      'Signed Out:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      record.signIn == null
                          ? 'Not yet signed out' // closedAt placeholder
                          : _formatTimestamp(record.signIn!),
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // description
                Row(
                  children: [
                    const Text(
                      'Description',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.file_copy, size: 24),
                  ],
                ),
                Text(
                  record.notes,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),

          // image preview overlay
          if (_selectedImageUrl != null)
            Stack(
              children: [
                // background overlay
                GestureDetector(
                  onTap: _closeOverlay,
                  child: Container(
                    color: Colors.black.withOpacity(0.6),
                  ),
                ),

                // image set
                SafeArea(
                  minimum: EdgeInsets.symmetric(horizontal: 25),
                  child: Center(
                    child: Stack(
                      children: [
                        // image itself
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            _selectedImageUrl!,
                            fit: BoxFit.contain,
                          ),
                        ),

                        // download button
                        Positioned(
                          bottom: 7,
                          right: 7,
                          child: FloatingActionButton(
                            onPressed: () => _downloadImage(_selectedImageUrl!),
                            child: Icon(Icons.download),
                            mini: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          // loading overlay for downloading
          if (_isLoading)
            Positioned.fill(
              child: Container(
                color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            )
        ],
      ),
    );
  }
}
