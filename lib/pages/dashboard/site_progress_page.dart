import 'dart:developer';

import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:progrid/models/drawing_status.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/region.dart';
import 'package:progrid/models/survey_status.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/pages/dashboard/home_page.dart';
import 'package:progrid/services/firestore.dart';
import 'package:progrid/utils/dialog_utils.dart';
import 'package:provider/provider.dart';

class SiteProgressPage extends StatefulWidget {
  const SiteProgressPage({super.key});

  @override
  State<SiteProgressPage> createState() => _SiteProgressPageState();
}

class _SiteProgressPageState extends State<SiteProgressPage>
    with AutomaticKeepAliveClientMixin {
  final searchController = TextEditingController();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final surveyStatusFilter = <SurveyStatus>[SurveyStatus.surveyed];
  final drawingStatusFilter = <DrawingStatus>[];
  final regionFilter = <Region>[];
  DateTime? fromDateTime;
  DateTime? toDateTime;

  @override
  bool get wantKeepAlive => true;

  Future<void> downloadReport() async {
    final towers = Provider.of<List<Tower>>(context, listen: false);
    final issues = Provider.of<List<Issue>>(context, listen: false);
    final pdf1 = pw.Document();
    final pdf2 = pw.Document();
    final filteredTowers = Provider.of<List<Tower>>(context, listen: false)
        .where((tower) =>
            (tower.name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                tower.id
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase())) &&
            (surveyStatusFilter.isEmpty ||
                surveyStatusFilter.contains(tower.surveyStatus)) &&
            (drawingStatusFilter.isEmpty ||
                drawingStatusFilter.contains(tower.drawingStatus)) &&
            (regionFilter.isEmpty || regionFilter.contains(tower.region)) &&
            (fromDateTime == null ||
                (surveyStatusFilter.contains(SurveyStatus.surveyed) &&
                    tower.signOut != null &&
                    tower.signOut!.toDate().isAfter(fromDateTime!)) ||
                (surveyStatusFilter.contains(SurveyStatus.inprogress) &&
                    tower.signIn != null &&
                    tower.signIn!.toDate().isAfter(fromDateTime!))) &&
            (toDateTime == null ||
                (surveyStatusFilter.contains(SurveyStatus.surveyed) &&
                    tower.signOut != null &&
                    tower.signOut!
                        .toDate()
                        .isBefore(toDateTime!.add(Duration(days: 1)))) ||
                (surveyStatusFilter.contains(SurveyStatus.inprogress) &&
                    tower.signIn != null &&
                    tower.signIn!
                        .toDate()
                        .isBefore(toDateTime!.add(Duration(days: 1))))))
        .toList();
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
    final recentTicketIssues = await screenshotController7.capture();

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
                        pw.SizedBox(height: 5),
                        pw.Row(
                          children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text('On-Site Audit',
                                    style: pw.TextStyle(fontSize: 10))),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Total',
                                      style: pw.TextStyle(fontSize: 10)),
                                  pw.SizedBox(height: 5),
                                  pw.Text('${towers.length}',
                                      style: pw.TextStyle(fontSize: 10))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('In Progress',
                                      style: pw.TextStyle(fontSize: 10)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress).length}',
                                      style: pw.TextStyle(fontSize: 10))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Completed',
                                      style: pw.TextStyle(fontSize: 10)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.surveyStatus == SurveyStatus.surveyed).length}',
                                      style: pw.TextStyle(fontSize: 10))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Balance',
                                      style: pw.TextStyle(fontSize: 10)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress || tower.surveyStatus == SurveyStatus.unsurveyed).length}',
                                      style: pw.TextStyle(fontSize: 10))
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),
                        // pw.Row(
                        //     mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       pw.SizedBox.square(
                        //           dimension: 200,
                        //           child: pw.Image(
                        //               pw.MemoryImage(onSiteAuditStatusChart!))),
                        //       pw.SizedBox.square(
                        //           dimension: 200,
                        //           child: pw.Image(pw.MemoryImage(
                        //               onSiteAuditRegionalChart!)))
                        //     ])
                      ])),
              pw.SizedBox(height: 5),
              pw.Container(
                  decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border:
                          pw.Border.all(color: PdfColor.fromInt(0xFF4CAF50))),
                  child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                      children: [
                        pw.SizedBox(height: 5),
                        pw.Row(
                          children: [
                            pw.Padding(
                                padding: pw.EdgeInsets.all(10),
                                child: pw.Text('As-Built Drawing',
                                    style: pw.TextStyle(fontSize: 10))),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Total',
                                      style: pw.TextStyle(fontSize: 10)),
                                  pw.SizedBox(height: 5),
                                  pw.Text('${towers.length}',
                                      style: pw.TextStyle(fontSize: 10))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('In Progress',
                                      style: pw.TextStyle(fontSize: 10)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress).length}',
                                      style: pw.TextStyle(fontSize: 10))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Submitted',
                                      style: pw.TextStyle(fontSize: 10)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.drawingStatus == DrawingStatus.submitted).length}',
                                      style: pw.TextStyle(fontSize: 10))
                                ],
                              ),
                            ),
                            pw.SizedBox(width: 10),
                            pw.Expanded(
                              child: pw.Column(
                                children: [
                                  pw.Text('Balance',
                                      style: pw.TextStyle(fontSize: 10)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress || tower.drawingStatus == null).length}',
                                      style: pw.TextStyle(fontSize: 10))
                                ],
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 5),

                        // pw.Row(
                        //     mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        //     children: [
                        //       pw.SizedBox.square(
                        //           dimension: 200,
                        //           child: pw.Image(pw.MemoryImage(
                        //               asBuiltDrawingStatusChart!))),
                        //       pw.SizedBox.square(
                        //           dimension: 200,
                        //           child: pw.Image(pw.MemoryImage(
                        //               asBuiltDrawingRegionalChart!)))
                        //     ])
                      ])),
              pw.SizedBox(height: 5),
              pw.Container(
                padding: pw.EdgeInsets.all(5),
                decoration: pw.BoxDecoration(
                    borderRadius: pw.BorderRadius.circular(12),
                    border: pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E))),
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                    children: [
                      pw.Text('Site Location',
                          style: pw.TextStyle(fontSize: 10)),
                      pw.SizedBox(height: 5),
                      pw.Image(height: 200, pw.MemoryImage(mapDisplay!)),
                    ]),
              ),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Expanded(
                    child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border:
                          pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E))),
                  child: pw.Column(children: [
                    pw.Text('On-Site Audit', style: pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 10),
                    pw.SizedBox(
                        height: 150,
                        width: 150,
                        child:
                            pw.Image(pw.MemoryImage(onSiteAuditStatusChart!))),
                  ]),
                )),
                pw.SizedBox(width: 5),
                pw.Expanded(
                    child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border:
                          pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E))),
                  child: pw.Column(children: [
                    pw.Text('As-Built Drawing',
                        style: pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 10),
                    pw.SizedBox(
                        height: 150,
                        width: 150,
                        child: pw.Image(
                            pw.MemoryImage(asBuiltDrawingStatusChart!))),
                  ]),
                ))
              ]),
              pw.SizedBox(height: 5),
              pw.Row(children: [
                pw.Expanded(
                    child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border:
                          pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E))),
                  child: pw.Column(children: [
                    pw.Text('Recent Ticket Issues',
                        style: pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 10),
                    pw.SizedBox(
                        height: 150,
                        width: 150,
                        child: pw.Image(pw.MemoryImage(recentTicketIssues!))),
                  ]),
                )),
                pw.SizedBox(width: 5),
                pw.Expanded(
                    child: pw.Container(
                  padding: pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border:
                          pw.Border.all(color: PdfColor.fromInt(0xFF9E9E9E))),
                  child: pw.Column(children: [
                    pw.Text('On-Site Audit vs As-Built Drawing',
                        style: pw.TextStyle(fontSize: 10)),
                    pw.SizedBox(height: 10),
                    pw.SizedBox(
                        height: 150,
                        width: 150,
                        child: pw.Image(
                            pw.MemoryImage(onSiteAuditVsAsBuiltDrawing!))),
                  ]),
                ))
              ]),
              pw.SizedBox(height: 10),
              pw.Text(
                  'Last Update: ${DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now())}',
                  style: pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.right),
            ])));

    // pdf1.addPage(pw.Page(
    //     build: (context) => pw.Column(
    //             crossAxisAlignment: pw.CrossAxisAlignment.stretch,
    //             children: [
    //               pw.Text('Ticket Issues'),
    //               pw.SizedBox(height: 10),
    //               pw.TableHelper.fromTextArray(
    //                   headers: [
    //                     'Site ID',
    //                     'Site Name',
    //                     'Region',
    //                     'Site Type',
    //                     'Issues'
    //                   ],
    //                   data: issues.map((issue) {
    //                     final tower = towers.singleWhere(
    //                         (tower) => tower.id == issue.id.split('-').first);

    //                     return [
    //                       tower.id,
    //                       tower.name,
    //                       tower.region,
    //                       tower.type,
    //                       issue.tags.join()
    //                     ];
    //                   }).toList(),
    //                   headerDecoration:
    //                       pw.BoxDecoration(color: PdfColor.fromInt(0xFF000000)),
    //                   headerStyle:
    //                       pw.TextStyle(color: PdfColor.fromInt(0xFFFFFFFF))),
    //               pw.SizedBox(height: 20),
    //               pw.Text(
    //                   'Last Update: ${DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now())}',
    //                   textAlign: pw.TextAlign.right),
    //             ])));

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

    // filteredTowers.

    final chunks = <List<Tower>>[];
    final chunkSize = 35;
    for (var i = 0; i < filteredTowers.length; i += chunkSize) {
      chunks.add(filteredTowers.sublist(
          i,
          i + chunkSize > filteredTowers.length
              ? filteredTowers.length
              : i + chunkSize));
    }

    for (final chunk in chunks) {
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
                    pw.TableHelper.fromTextArray(
                        headers: [
                          'Site ID',
                          'Site Name',
                          'Region',
                          'Site Type',
                          'Latitude',
                          'Longitude',
                          'Date'
                        ],
                        data: chunk.map((tower) {
                          log(tower.id);
                          return [
                            tower.id,
                            tower.name,
                            tower.region,
                            tower.type,
                            tower.position.latitude.toString(),
                            tower.position.longitude.toString(),
                            if (tower.signOut == null)
                              ''
                            else
                              DateFormat('dd.M.yyyy')
                                  .format(tower.signOut!.toDate())
                          ];
                        }).toList(),
                        headerDecoration: pw.BoxDecoration(
                            color: PdfColor.fromInt(0xFF000000)),
                        cellStyle: pw.TextStyle(fontSize: 5),
                        headerStyle: pw.TextStyle(
                            fontSize: 5, color: PdfColor.fromInt(0xFFFFFFFF))),
                    pw.SizedBox(height: 20),
                    pw.Text(
                        'Last Update: ${DateFormat('dd MMMM yyyy HH:mm').format(DateTime.now())}',
                        textAlign: pw.TextAlign.right),
                  ])));
    }

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
  Widget build(BuildContext context) {
    super.build(context);
    final towers = Provider.of<List<Tower>>(context)
        .where((tower) =>
            (tower.name
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase()) ||
                tower.id
                    .toLowerCase()
                    .contains(searchController.text.toLowerCase())) &&
            (surveyStatusFilter.isEmpty ||
                surveyStatusFilter.contains(tower.surveyStatus)) &&
            (drawingStatusFilter.isEmpty ||
                drawingStatusFilter.contains(tower.drawingStatus)) &&
            (regionFilter.isEmpty || regionFilter.contains(tower.region)) &&
            (fromDateTime == null ||
                (surveyStatusFilter.contains(SurveyStatus.surveyed) &&
                    tower.signOut != null &&
                    tower.signOut!.toDate().isAfter(fromDateTime!)) ||
                (surveyStatusFilter.contains(SurveyStatus.inprogress) &&
                    tower.signIn != null &&
                    tower.signIn!.toDate().isAfter(fromDateTime!))) &&
            (toDateTime == null ||
                (surveyStatusFilter.contains(SurveyStatus.surveyed) &&
                    tower.signOut != null &&
                    tower.signOut!
                        .toDate()
                        .isBefore(toDateTime!.add(Duration(days: 1)))) ||
                (surveyStatusFilter.contains(SurveyStatus.inprogress) &&
                    tower.signIn != null &&
                    tower.signIn!
                        .toDate()
                        .isBefore(toDateTime!.add(Duration(days: 1))))))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: fromController,
                            decoration: InputDecoration(labelText: 'From'),
                            readOnly: true,
                            onTap: () => showDatePicker(
                                    context: context,
                                    firstDate: DateTime(2025),
                                    lastDate: DateTime.now())
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  fromDateTime = value;
                                  if (toDateTime == null) {
                                    toDateTime = DateTime.now();
                                    toController.text =
                                        DateFormat('d/M/y').format(toDateTime!);
                                  }
                                  if (fromDateTime!.isAfter(toDateTime!)) {
                                    toDateTime = null;
                                    toController.clear();
                                  }
                                  fromController.text =
                                      DateFormat('d/M/y').format(value);
                                });
                              }
                            }),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: TextField(
                            controller: toController,
                            decoration: InputDecoration(labelText: 'To'),
                            readOnly: true,
                            onTap: () => showDatePicker(
                                    context: context,
                                    firstDate: fromDateTime ?? DateTime(2025),
                                    lastDate: DateTime.now())
                                .then((value) {
                              if (value != null) {
                                setState(() {
                                  toDateTime = value;
                                  if (fromDateTime == null) {
                                    fromDateTime = value;
                                    fromController.text =
                                        DateFormat('d/M/y').format(value);
                                  }
                                  toController.text =
                                      DateFormat('d/M/y').format(value);
                                });
                              }
                            }),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Filters',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text('On-Site Audit'),
                    ...SurveyStatus.values.map((status) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(status.toString()),
                        value: surveyStatusFilter.contains(status),
                        onChanged: (value) => setState(() => value!
                            ? surveyStatusFilter.add(status)
                            : surveyStatusFilter.remove(status)))),
                    SizedBox(height: 10),
                    Text('As-Built Drawing'),
                    ...DrawingStatus.values.map((status) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(status.toString()),
                        value: drawingStatusFilter.contains(status),
                        onChanged: (value) => setState(() => value!
                            ? drawingStatusFilter.add(status)
                            : drawingStatusFilter.remove(status)))),
                    SizedBox(height: 10),
                    Text('Region'),
                    ...Region.values.map((region) => CheckboxListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(region.toString()),
                        value: regionFilter.contains(region),
                        onChanged: (value) => setState(() => value!
                            ? regionFilter.add(region)
                            : regionFilter.remove(region)))),
                    SizedBox(height: 20),
                    OutlinedButton(
                        onPressed: downloadReport,
                        child: Text('Download Report'))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 5),
                  elevation: 0,
                  shape: RoundedRectangleBorder(),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                              hintText: 'Search tower by name or id',
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.transparent)),
                              prefixIcon: Icon(Icons.search)),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                    margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    shape: RoundedRectangleBorder(),
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Text('Tower'),
                          Spacer(),
                          Text('On-Site Audit'),
                          SizedBox(width: 100),
                          Text('As-Built Drawing'),
                          SizedBox(width: 50),
                        ],
                      ),
                    )),
                Expanded(
                  child: ListView.builder(
                      itemCount: towers.length,
                      itemBuilder: (context, index) {
                        final tower = towers[index];

                        return Container(
                          margin: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  top: BorderSide(color: Colors.black12))),
                          child: ListTile(
                              onTap: () => DialogUtils.showTowerDialog(
                                  context, tower.id),
                              title: Row(
                                children: [
                                  CircleAvatar(
                                      radius: 5,
                                      backgroundColor:
                                          tower.surveyStatus.color),
                                  SizedBox(width: 10),
                                  Text(tower.name),
                                ],
                              ),
                              subtitle: Text(tower.id),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  DropdownMenu<SurveyStatus>(
                                      requestFocusOnTap: false,
                                      textAlign: TextAlign.center,
                                      initialSelection: tower.surveyStatus,
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        filled: true,
                                        fillColor: tower.surveyStatus.color
                                            .withValues(alpha: 0.1),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: tower.surveyStatus.color
                                                    .withValues(alpha: 0.5)),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      ),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      onSelected: (value) {
                                        if (value != null) {
                                          FirestoreService.updateTower(tower.id,
                                              data: {
                                                'surveyStatus': value.name
                                              });
                                        }
                                      },
                                      dropdownMenuEntries: [
                                        ...SurveyStatus.values.map((status) =>
                                            DropdownMenuEntry(
                                                value: status,
                                                label: status.toString()))
                                      ]),
                                  SizedBox(width: 20),
                                  DropdownMenu<DrawingStatus>(
                                      requestFocusOnTap: false,
                                      textAlign: TextAlign.center,
                                      initialSelection: tower.drawingStatus,
                                      inputDecorationTheme:
                                          InputDecorationTheme(
                                        filled: true,
                                        fillColor: tower.drawingStatus?.color
                                            .withValues(alpha: 0.1),
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: tower
                                                        .drawingStatus?.color
                                                        .withValues(
                                                            alpha: 0.5) ??
                                                    Colors.black12),
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                      ),
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      onSelected: (value) {
                                        if (value != null) {
                                          FirestoreService.updateTower(tower.id,
                                              data: {
                                                'drawingStatus': value.name
                                              });
                                        }
                                      },
                                      dropdownMenuEntries: [
                                        ...DrawingStatus.values.map((status) =>
                                            DropdownMenuEntry(
                                                value: status,
                                                label: status.toString()))
                                      ]),
                                ],
                              )),
                        );
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
