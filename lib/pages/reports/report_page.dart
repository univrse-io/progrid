import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progrid/models/report.dart';

class ReportPage extends StatefulWidget {
  final String towerId;
  final String reportId;

  const ReportPage({super.key, required this.reportId, required this.towerId});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? _selectedImageUrl;

  // close overlay
  void _closeOverlay() {
    setState(() {
      _selectedImageUrl = null;
    });
  }

  // download an image
  Future<void> _downloadImage(String url) async {
    try {
      final Dio dio = Dio();

      // as image names aren't saved in database, we need to define the name ourselves
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String savePath = '${appDocDir.path}/image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      await dio.download(url, savePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image Downloaded...')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to download image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // fetch reports stream directly given towerId
    final reportsStream = FirebaseFirestore.instance
        .collection('towers')
        .doc(widget.towerId)
        .collection('reports')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Report.fromFirestore(doc)).toList());

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
            child: StreamBuilder<List<Report>>(
              stream: reportsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No reports data found.'));
                }

                // find report
                final report = snapshot.data!.firstWhere(
                  (report) => report.id == widget.reportId,
                  orElse: () => throw Exception('Report not found'),
                );

                // display report data
                return Column(
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
                );
              },
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
