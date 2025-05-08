import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/issue.dart';
import '../models/issue_status.dart';
import '../models/survey_status.dart';
import '../models/tower.dart';
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
          if (widget.tower.surveyStatus == SurveyStatus.unsurveyed)
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
              onPressed: () {
                final unresolvedIssues = context.read<List<Issue>>().where(
                  (issue) =>
                      issue.id.startsWith(widget.tower.id) &&
                      issue.status == IssueStatus.unresolved,
                );

                if (unresolvedIssues.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'You must resolve all the issues first before sign out.',
                      ),
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditTowerPage(widget.tower),
                    ),
                  );
                }
              },
              label: 'Sign Out',
              icon: CarbonIcon.logout,
            ),
          if (widget.tower.surveyStatus != SurveyStatus.surveyed)
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
}
