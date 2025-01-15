// import 'dart:html' as html;
import 'dart:developer';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:progrid/models/drawing_status.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/survey_status.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/pages/dashboard/home_page.dart';
import 'package:progrid/pages/dashboard/site_progress_page.dart';
import 'package:progrid/pages/profile_page.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final pageController = PageController()
    ..addListener(() => Navigator.pop(context));

  Future<void> downloadReport() async {
    final towers = Provider.of<List<Tower>>(context, listen: false);
    final issues = Provider.of<List<Issue>>(context, listen: false);
    final pdf1 = pw.Document();
    final pdf2 = pw.Document();
    final sapuraImg = await rootBundle
        .load('assets/images/sapura.png')
        .then((img) => img.buffer.asUint8List());
    final binasatImg = await rootBundle
        .load('assets/images/binasat.png')
        .then((img) => img.buffer.asUint8List());
    final uosImg = await rootBundle
        .load('assets/images/uos.png')
        .then((img) => img.buffer.asUint8List());
    final onSiteAuditStatusChart = await screenshotController1.capture();
    final onSiteAuditRegionalChart = await screenshotController2.capture();
    final asBuiltDrawingStatusChart = await screenshotController3.capture();
    final asBuiltDrawingRegionalChart = await screenshotController4.capture();
    final mapDisplay = await screenshotController5.capture();
    final onSiteAuditVsAsBuiltDrawing = await screenshotController6.capture();

    pdf1.addPage(pw.Page(
        build: (context) => pw.Column(children: [
              pw.Row(
                children: [
                  pw.Image(pw.MemoryImage(sapuraImg), height: 40),
                  pw.SizedBox(width: 30),
                  pw.Text('Daily Progress Report',
                      style: pw.TextStyle(fontSize: 20)),
                  pw.SizedBox(width: 30),
                  pw.Image(pw.MemoryImage(binasatImg), height: 40),
                  pw.SizedBox(width: 30),
                  pw.Image(pw.MemoryImage(uosImg), height: 40),
                  pw.SizedBox(width: 30),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                  decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border:
                          pw.Border.all(color: PdfColor.fromInt(0xFF9C27B0))),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text('On-Site Audit')),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Total'),
                                  pw.SizedBox(height: 5),
                                  pw.Text('${towers.length}',
                                      style: pw.TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('In Progress'),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress).length}',
                                      style: pw.TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Completed'),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.surveyStatus == SurveyStatus.surveyed).length}',
                                      style: pw.TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Balance'),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress || tower.surveyStatus == SurveyStatus.unsurveyed).length}',
                                      style: pw.TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.SizedBox.square(
                                  dimension: 200,
                                  child: pw.Image(
                                      pw.MemoryImage(onSiteAuditStatusChart!))),
                              pw.SizedBox.square(
                                  dimension: 200,
                                  child: pw.Image(pw.MemoryImage(
                                      onSiteAuditRegionalChart!)))
                            ])
                      ])),
              pw.SizedBox(height: 10),
              pw.Container(
                  decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border:
                          pw.Border.all(color: PdfColor.fromInt(0xFF4CAF50))),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.Padding(
                            padding: pw.EdgeInsets.all(10),
                            child: pw.Text('As-Built Drawing')),
                        pw.Row(
                          children: [
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Total'),
                                  pw.SizedBox(height: 5),
                                  pw.Text('${towers.length}',
                                      style: pw.TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('In Progress'),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress).length}',
                                      style: pw.TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Submitted'),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.drawingStatus == DrawingStatus.submitted).length}',
                                      style: pw.TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Balance'),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress || tower.drawingStatus == null).length}',
                                      style: pw.TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            children: [
                              pw.SizedBox.square(
                                  dimension: 200,
                                  child: pw.Image(pw.MemoryImage(
                                      asBuiltDrawingStatusChart!))),
                              pw.SizedBox.square(
                                  dimension: 200,
                                  child: pw.Image(pw.MemoryImage(
                                      asBuiltDrawingRegionalChart!)))
                            ])
                      ])),
              pw.SizedBox(height: 10),
              pw.Row(children: [
                pw.Expanded(
                    child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border:
                          pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E))),
                  child: pw.Column(children: [
                    pw.Text('Site Location'),
                    pw.SizedBox(height: 10),
                    pw.SizedBox(
                        height: 200,
                        width: 200,
                        child: pw.Image(pw.MemoryImage(mapDisplay!))),
                  ]),
                )),
                pw.SizedBox(width: 10),
                pw.Expanded(
                    child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border:
                          pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E))),
                  child: pw.Column(children: [
                    pw.Text('On-Site Audit vs As-Built Drawing'),
                    pw.SizedBox(height: 10),
                    pw.SizedBox(
                        height: 200,
                        width: 200,
                        child: pw.Image(
                            pw.MemoryImage(onSiteAuditVsAsBuiltDrawing!))),
                  ]),
                )),
              ]),
            ])));

    pdf1.addPage(pw.Page(
        build: (context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text('Ticket Issues'),
                  pw.SizedBox(height: 10),
                  pw.TableHelper.fromTextArray(
                      headers: [
                        'Site ID',
                        'Site Name',
                        'Region',
                        'Site Type',
                        'Issues'
                      ],
                      data: issues.map((issue) {
                        final tower = towers.singleWhere(
                            (tower) => tower.id == issue.id.split('-').first);

                        return [
                          tower.id,
                          tower.name,
                          tower.region,
                          tower.type,
                          issue.tags.join()
                        ];
                      }).toList(),
                      headerDecoration:
                          pw.BoxDecoration(color: PdfColor.fromInt(0xFF000000)),
                      headerStyle:
                          pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
                  pw.SizedBox(height: 20),
                  pw.Text(
                      'Last Update: ${DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now())}',
                      textAlign: pw.TextAlign.right),
                ])));

    final pdf1Bytes = await pdf1.save();
    try {
      await FileSaver.instance.saveFile(
          name: 'Daily Progress Report',
          bytes: pdf1Bytes,
          mimeType: MimeType.pdf,
          ext: ".pdf");
      print('PDF saved successfully');
    } catch (e) {
      print('Error saving PDF: $e');
    }

    pdf2.addPage(pw.Page(
        build: (context) => pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Row(
                    children: [
                      pw.Image(pw.MemoryImage(sapuraImg), height: 40),
                      pw.SizedBox(width: 30),
                      pw.Text('Site Completed',
                          style: pw.TextStyle(fontSize: 20)),
                      pw.SizedBox(width: 30),
                      pw.Image(pw.MemoryImage(binasatImg), height: 40),
                      pw.SizedBox(width: 30),
                      pw.Image(pw.MemoryImage(uosImg), height: 40),
                      pw.SizedBox(width: 30),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text('On-Site Audit'),
                  pw.SizedBox(height: 10),
                  pw.TableHelper.fromTextArray(
                      headers: [
                        'Site ID',
                        'Site Name',
                        'Region',
                        'Site Type',
                        'Base',
                        'Equipment Shelter',
                        'Latitude',
                        'Longitude',
                        'Date'
                      ],
                      data: towers
                          .where((tower) =>
                              tower.surveyStatus == SurveyStatus.surveyed)
                          .map((tower) {
                        log(tower.id);
                        return [
                          tower.id,
                          tower.name,
                          tower.region,
                          tower.type,
                          tower.base,
                          tower.equipmentShelter,
                          tower.position.latitude.toString(),
                          tower.position.longitude.toString(),
                          if (tower.signOut == null)
                            ''
                          else
                            DateFormat('dd.M.yyyy')
                                .format(tower.signOut!.toDate())
                        ];
                      }).toList(),
                      headerDecoration:
                          pw.BoxDecoration(color: PdfColor.fromInt(0xFF000000)),
                      cellStyle: pw.TextStyle(fontSize: 5),
                      headerStyle: pw.TextStyle(
                          fontSize: 5, color: PdfColor.fromInt(0xFFFFFFFF))),
                  pw.SizedBox(height: 20),
                  pw.Text('As-Built Drawing'),
                  pw.SizedBox(height: 10),
                  pw.TableHelper.fromTextArray(
                      headers: [
                        'Site ID',
                        'Site Name',
                        'Region',
                        'Site Type',
                        'Base',
                        'Equipment Shelter',
                        'Latitude',
                        'Longitude',
                        'Date'
                      ],
                      data: towers
                          .where((tower) =>
                              tower.drawingStatus == DrawingStatus.submitted)
                          .map((tower) {
                        log(tower.id);

                        return [
                          tower.id,
                          tower.name,
                          tower.region,
                          tower.type,
                          tower.base,
                          tower.equipmentShelter,
                          tower.position.latitude.toString(),
                          tower.position.longitude.toString(),
                          if (tower.signOut == null)
                            ''
                          else
                            DateFormat('dd.M.yyyy')
                                .format(tower.signOut!.toDate()),
                        ];
                      }).toList(),
                      headerDecoration:
                          pw.BoxDecoration(color: PdfColor.fromInt(0xFF000000)),
                      cellStyle: pw.TextStyle(fontSize: 5),
                      headerStyle: pw.TextStyle(
                          fontSize: 5, color: PdfColor.fromInt(0xFFFFFFFF))),
                  pw.SizedBox(height: 20),
                  pw.Text(
                      'Last Update: ${DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now())}',
                      textAlign: pw.TextAlign.right),
                ])));

    final pdf2Bytes = await pdf2.save();
    try {
      await FileSaver.instance.saveFile(
          name: 'Site Completed',
          bytes: pdf2Bytes,
          mimeType: MimeType.pdf,
          ext: ".pdf");
      print('PDF saved successfully');
    } catch (e) {
      print('Error saving PDF: $e');
    }

    // final blob = html.Blob([pdfBytes], 'application/pdf');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // html.AnchorElement(href: url)
    //   ..setAttribute('download', 'Report.pdf')
    //   ..click();
    // html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/sapura.png', height: 40),
            SizedBox(width: 20),
            Image.asset('assets/images/binasat.png', height: 40),
            SizedBox(width: 20),
            Image.asset('assets/images/uos.png', height: 40),
            SizedBox(width: 20),
            Text('PROJECT MONITORING REPORT',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          OutlinedButton(onPressed: downloadReport, child: Text('Report')),
          SizedBox(width: 10),
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const ProfilePage())),
              icon: Icon(Icons.person)),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              title: const Text('Home'),
              onTap: () => pageController.jumpToPage(0),
            ),
            ListTile(
              title: const Text('Site Progress'),
              onTap: () => pageController.jumpToPage(1),
            ),
          ],
        ),
      ),
      body: PageView(
          controller: pageController,
          children: [
            HomePage(),
            SiteProgressPage(),
          ],
          physics: NeverScrollableScrollPhysics()));
}
