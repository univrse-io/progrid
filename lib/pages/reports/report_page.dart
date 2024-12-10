import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progrid/models/providers/reports_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ReportPage extends StatefulWidget {
  final String towerId;
  final String reportId;

  const ReportPage({super.key, required this.reportId, required this.towerId});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? _selectedImageUrl;

  // TODO: make overlay encapsulate whole screen, including appbar (new page?)

  // close overlay
  void _closeOverlay() {
    setState(() {
      _selectedImageUrl = null;
    });
  }

  // TODO: fix download permissions, it always returns denied?
  Future<void> _downloadImage(String url) async {
    try {
      // request storage permission
      final status = await Permission.storage.status;

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
            const SnackBar(content: Text('Storage permission is required to save the image.')),
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
        throw Exception('Failed to download the image. Status code: ${response.statusCode}');
      }

      // get directory
      final externalDir = Directory('/storage/emulated/0/Download'); // download folder on android
      if (!await externalDir.exists()) {
        await externalDir.create(recursive: true);
      }

      final fileName = url.split('/').last; // extract file name from URL
      final file = File('${externalDir.path}/$fileName');

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
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = Provider.of<ReportsProvider>(context).reports.firstWhere((report) => report.id == widget.reportId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.reportId,
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
                if (report.images.isNotEmpty)
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(
                      height: report.images.length <= 2
                          ? 170 // height if 1 row
                          : 250, // height if more
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // columns count
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: report.images.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImageUrl = report.images[index];
                              });
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                report.images[index],
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // description
                Row(
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                    ),
                    const SizedBox(width: 5),
                    const Icon(Icons.file_copy, size: 24),
                  ],
                ),
                Text(
                  report.notes,
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
            )
        ],
      ),
    );
  }
}
