import 'dart:developer';

import 'package:excel/excel.dart' hide Border;
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';

import '../../models/drawing_status.dart';
import '../../models/issue.dart';
import '../../models/issue_status.dart';
import '../../models/region.dart';
import '../../models/survey_status.dart';
import '../../models/tower.dart';
import '../../services/firebase_firestore.dart';
import '../../utils/dialog_utils.dart';
import 'home_page.dart';

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

  Future<void> dailyProgressReportPdf() async {
    final towers = Provider.of<List<Tower>>(context, listen: false);
    final issues = Provider.of<List<Issue>>(context, listen: false)
        .where((issue) => issue.status == IssueStatus.unresolved)
        .toList();
    final pdf = pw.Document();
    final sapuraImg = await rootBundle
        .load('assets/images/sapura.png')
        .then((img) => img.buffer.asUint8List());
    final binasatImg = await rootBundle
        .load('assets/images/binasat.png')
        .then((img) => img.buffer.asUint8List());
    final uosImg = await rootBundle
        .load('assets/images/uos.png')
        .then((img) => img.buffer.asUint8List());
    final onSiteAuditRegionalChart = await screenshotController1.capture();
    final asBuiltDrawingRegionalChart = await screenshotController2.capture();
    final mapDisplay = await screenshotController3.capture();
    final onSiteAuditVsAsBuiltDrawing = await screenshotController4.capture();

    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Row(
              children: [
                pw.Image(pw.MemoryImage(sapuraImg), height: 40),
                pw.SizedBox(width: 30),
                pw.Text(
                  'Daily Progress Report',
                  style: const pw.TextStyle(fontSize: 20),
                ),
                pw.SizedBox(width: 30),
                pw.Image(pw.MemoryImage(binasatImg), height: 40),
                pw.SizedBox(width: 30),
                pw.Image(pw.MemoryImage(uosImg), height: 40),
                pw.SizedBox(width: 30),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              'Last Update: ${DateFormat('dd MMMM yyyy HH:mm a').format(DateTime.now())}',
              style: const pw.TextStyle(fontSize: 8),
              textAlign: pw.TextAlign.right,
            ),
            pw.SizedBox(height: 8),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      'Total',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      'In Progress',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      'Completed',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      'Balance',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'On-Site Audit',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Expanded(flex: 3, child: pw.Divider()),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      '${towers.length}',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress).length}',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      '${towers.where((tower) => tower.surveyStatus == SurveyStatus.surveyed).length}',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress || tower.surveyStatus == SurveyStatus.unsurveyed).length}',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Text(
                    'As-Built Drawing',
                    style: const pw.TextStyle(fontSize: 10),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Expanded(flex: 3, child: pw.Divider()),
              ],
            ),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      '${towers.length}',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress).length}',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      '${towers.where((tower) => tower.drawingStatus == DrawingStatus.submitted).length}',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 10),
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(5),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(5),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Text(
                      '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress || tower.drawingStatus == null).length}',
                      style: const pw.TextStyle(fontSize: 10),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Container(
              padding: const pw.EdgeInsets.all(5),
              decoration: pw.BoxDecoration(
                borderRadius: pw.BorderRadius.circular(12),
                border:
                    pw.Border.all(color: const PdfColor.fromInt(0xFF9E9E9E)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                children: [
                  pw.Text(
                    'Site Location',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Image(
                    fit: pw.BoxFit.fitWidth,
                    height: 150,
                    pw.MemoryImage(mapDisplay!),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 5),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(12),
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF9E9E9E),
                          ),
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'On-Site Audit',
                                  style: const pw.TextStyle(fontSize: 10),
                                ),
                                pw.SizedBox(height: 10),
                                pw.SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: pw.Image(
                                    pw.MemoryImage(
                                      onSiteAuditRegionalChart!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(width: 10),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(height: 20),
                                ...Region.values.map(
                                  (region) => pw.Row(
                                    mainAxisSize: pw.MainAxisSize.min,
                                    children: [
                                      pw.Container(
                                        height: 5,
                                        width: 5,
                                        decoration: pw.BoxDecoration(
                                          shape: pw.BoxShape.circle,
                                          color: PdfColor.fromInt(
                                            region.color.value,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(width: 10),
                                      pw.Text(
                                        region.toString(),
                                        style: const pw.TextStyle(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(height: 5),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(10),
                        decoration: pw.BoxDecoration(
                          borderRadius: pw.BorderRadius.circular(12),
                          border: pw.Border.all(
                            color: const PdfColor.fromInt(0xFF9E9E9E),
                          ),
                        ),
                        child: pw.Row(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text(
                                  'As-Built Drawing',
                                  style: const pw.TextStyle(fontSize: 10),
                                ),
                                pw.SizedBox(height: 10),
                                pw.SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: pw.Image(
                                    pw.MemoryImage(
                                      asBuiltDrawingRegionalChart!,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(width: 10),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.SizedBox(height: 20),
                                ...Region.values.map(
                                  (region) => pw.Row(
                                    mainAxisSize: pw.MainAxisSize.min,
                                    children: [
                                      pw.Container(
                                        height: 5,
                                        width: 5,
                                        decoration: pw.BoxDecoration(
                                          shape: pw.BoxShape.circle,
                                          color: PdfColor.fromInt(
                                            region.color.value,
                                          ),
                                        ),
                                      ),
                                      pw.SizedBox(width: 10),
                                      pw.Text(
                                        region.toString(),
                                        style: const pw.TextStyle(
                                          fontSize: 8,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(width: 5),
                pw.Expanded(
                  child: pw.Container(
                    height: 235,
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      borderRadius: pw.BorderRadius.circular(12),
                      border: pw.Border.all(
                        color: const PdfColor.fromInt(0xFF9E9E9E),
                      ),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'On-Site Audit vs As-Built Drawing',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.SizedBox(height: 20),
                        pw.SizedBox(
                          height: 200,
                          width: 200,
                          child: pw.Image(
                            pw.MemoryImage(
                              onSiteAuditVsAsBuiltDrawing!,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 5),
            pw.Text('Ticket Issues', style: const pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 10),
            pw.TableHelper.fromTextArray(
              headers: [
                'Site ID',
                'Site Name',
                'Region',
                'Site Type',
                'Issues',
              ],
              data: issues.sublist(0, 7).map((issue) {
                final tower = towers.singleWhere(
                  (tower) => tower.id == issue.id.split('-').first,
                );

                return [
                  tower.id,
                  tower.name,
                  tower.region,
                  tower.type,
                  issue.tags.join(', '),
                ];
              }).toList(),
              cellStyle: const pw.TextStyle(fontSize: 10),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColor.fromInt(0xFF000000)),
              headerStyle: const pw.TextStyle(
                fontSize: 10,
                color: PdfColor.fromInt(0xFFFFFFFF),
              ),
            ),
          ],
        ),
      ),
    );

    if (issues.length > 7) {
      pdf.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.TableHelper.fromTextArray(
                headers: [
                  'Site ID',
                  'Site Name',
                  'Region',
                  'Site Type',
                  'Issues',
                ],
                data: issues.sublist(7).map((issue) {
                  final tower = towers.singleWhere(
                    (tower) => tower.id == issue.id.split('-').first,
                  );

                  return [
                    tower.id,
                    tower.name,
                    tower.region,
                    tower.type,
                    issue.tags.join(', '),
                  ];
                }).toList(),
                cellStyle: const pw.TextStyle(fontSize: 10),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFF000000),
                ),
                headerStyle: const pw.TextStyle(
                  fontSize: 10,
                  color: PdfColor.fromInt(0xFFFFFFFF),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final pdfBytes = await pdf.save();
    try {
      await FileSaver.instance.saveFile(
        name: 'Daily Progress Report',
        bytes: pdfBytes,
        mimeType: MimeType.pdf,
        ext: '.pdf',
      );
      log('PDF saved successfully');
    } catch (e) {
      log('Error saving PDF: $e');
    }

    // final blob = html.Blob([pdfBytes], 'application/pdf');
    // final url = html.Url.createObjectUrlFromBlob(blob);
    // html.AnchorElement(href: url)
    //   ..setAttribute('download', 'Report.pdf')
    //   ..click();
    // html.Url.revokeObjectUrl(url);
  }

  Future<void> siteCompletedPdf(List<Tower> towers) async {
    final pdf = pw.Document();
    final sapuraImg = await rootBundle
        .load('assets/images/sapura.png')
        .then((img) => img.buffer.asUint8List());
    final binasatImg = await rootBundle
        .load('assets/images/binasat.png')
        .then((img) => img.buffer.asUint8List());
    final uosImg = await rootBundle
        .load('assets/images/uos.png')
        .then((img) => img.buffer.asUint8List());
    final chunks = <List<Tower>>[];
    const chunkSize = 35;
    for (var i = 0; i < towers.length; i += chunkSize) {
      chunks.add(
        towers.sublist(
          i,
          i + chunkSize > towers.length ? towers.length : i + chunkSize,
        ),
      );
    }

    for (final chunk in chunks) {
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              pw.Row(
                children: [
                  pw.Image(pw.MemoryImage(sapuraImg), height: 40),
                  pw.SizedBox(width: 30),
                  pw.Text(
                    'Site Completed',
                    style: const pw.TextStyle(fontSize: 20),
                  ),
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
                  'Date',
                ],
                data: chunk
                    .map(
                      (tower) => [
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
                              .format(tower.signOut!.toDate()),
                      ],
                    )
                    .toList(),
                headerDecoration: const pw.BoxDecoration(
                  color: PdfColor.fromInt(0xFF000000),
                ),
                cellStyle: const pw.TextStyle(fontSize: 5),
                headerStyle: const pw.TextStyle(
                  fontSize: 5,
                  color: PdfColor.fromInt(0xFFFFFFFF),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Last Update: ${DateFormat('dd MMMM yyyy HH:mm a').format(DateTime.now())}',
                style: const pw.TextStyle(fontSize: 8),
                textAlign: pw.TextAlign.right,
              ),
            ],
          ),
        ),
      );
    }

    final pdf2Bytes = await pdf.save();
    try {
      await FileSaver.instance.saveFile(
        name: 'Site Completed',
        bytes: pdf2Bytes,
        mimeType: MimeType.pdf,
        ext: '.pdf',
      );
      log('PDF saved successfully');
    } catch (e) {
      log('Error saving PDF: $e');
    }
  }

  Future<void> siteCompletedXlsx(List<Tower> towers) async {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];
    final header = [
      'Site ID',
      'Site Name',
      'Region',
      'Site Type',
      'Latitude',
      'Longitude',
      'Date',
    ];

    for (final title in header) {
      sheet.cell(
        CellIndex.indexByColumnRow(
          columnIndex: header.indexOf(title),
          rowIndex: 0,
        ),
      )
        ..value = TextCellValue(title)
        ..cellStyle = CellStyle(
          fontColorHex: ExcelColor.white,
          backgroundColorHex: ExcelColor.black,
        );
    }

    for (final tower in towers) {
      final rowIndex = towers.indexOf(tower) + 1;

      sheet
        ..cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = TextCellValue(tower.id)
        ..cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(tower.name)
        ..cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = TextCellValue(tower.region.toString())
        ..cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = TextCellValue(tower.type)
        ..cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = TextCellValue(tower.position.latitude.toString())
        ..cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = TextCellValue(tower.position.longitude.toString())
        ..cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = TextCellValue(
          tower.signOut != null
              ? DateFormat('dd.M.yyyy').format(tower.signOut!.toDate())
              : '',
        );
    }

    excel.save(fileName: 'Site Completed.xlsx');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final towers = Provider.of<List<Tower>>(context)
        .where(
          (tower) =>
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
                      tower.signOut!.toDate().isBefore(
                            toDateTime!.add(const Duration(days: 1)),
                          )) ||
                  (surveyStatusFilter.contains(SurveyStatus.inprogress) &&
                      tower.signIn != null &&
                      tower.signIn!
                          .toDate()
                          .isBefore(toDateTime!.add(const Duration(days: 1))))),
        )
        .toList();

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: TextField(
                              controller: fromController,
                              decoration:
                                  const InputDecoration(labelText: 'From'),
                              readOnly: true,
                              onTap: () => showDatePicker(
                                context: context,
                                firstDate: DateTime(2025),
                                lastDate: DateTime.now(),
                              ).then((value) {
                                if (value != null) {
                                  setState(() {
                                    fromDateTime = value;
                                    if (toDateTime == null) {
                                      toDateTime = DateTime.now();
                                      toController.text = DateFormat('d/M/y')
                                          .format(toDateTime!);
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
                          const SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              controller: toController,
                              decoration:
                                  const InputDecoration(labelText: 'To'),
                              readOnly: true,
                              onTap: () => showDatePicker(
                                context: context,
                                firstDate: fromDateTime ?? DateTime(2025),
                                lastDate: DateTime.now(),
                              ).then((value) {
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
                      const SizedBox(height: 15),
                      const Text(
                        'Filters',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text('On-Site Audit'),
                      ...SurveyStatus.values.map(
                        (status) => CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(status.toString()),
                          value: surveyStatusFilter.contains(status),
                          onChanged: (value) => setState(
                            () => value!
                                ? surveyStatusFilter.add(status)
                                : surveyStatusFilter.remove(status),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('As-Built Drawing'),
                      ...DrawingStatus.values.map(
                        (status) => CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(status.toString()),
                          value: drawingStatusFilter.contains(status),
                          onChanged: (value) => setState(
                            () => value!
                                ? drawingStatusFilter.add(status)
                                : drawingStatusFilter.remove(status),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('Region'),
                      ...Region.values.map(
                        (region) => CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(region.toString()),
                          value: regionFilter.contains(region),
                          onChanged: (value) => setState(
                            () => value!
                                ? regionFilter.add(region)
                                : regionFilter.remove(region),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      MenuAnchor(
                        builder: (context, controller, child) => OutlinedButton(
                          onPressed: () => controller.isOpen
                              ? controller.close()
                              : controller.open(),
                          child: const Text('Download Report'),
                        ),
                        menuChildren: [
                          MenuItemButton(
                            onPressed: dailyProgressReportPdf,
                            child: const Text('Daily Progress Report.pdf'),
                          ),
                          MenuItemButton(
                            child: const Text('Site Completed.pdf'),
                            onPressed: () => siteCompletedPdf(towers),
                          ),
                          MenuItemButton(
                            child: const Text('Site Completed.xlsx'),
                            onPressed: () => siteCompletedXlsx(towers),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Card(
                  margin: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  elevation: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextField(
                          controller: searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText: 'Search tower by name or id',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Card(
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
                  elevation: 0,
                  child: Padding(
                    padding: EdgeInsets.all(5),
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
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: towers.length,
                    itemBuilder: (context, index) {
                      final tower = towers[index];

                      return Container(
                        margin: const EdgeInsets.only(left: 5),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            top: BorderSide(color: Colors.black12),
                          ),
                        ),
                        child: ListTile(
                          onTap: () => DialogUtils.showTowerDialog(
                            context,
                            tower.id,
                          ),
                          title: Row(
                            children: [
                              CircleAvatar(
                                radius: 5,
                                backgroundColor: tower.surveyStatus.color,
                              ),
                              const SizedBox(width: 10),
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
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: tower.surveyStatus.color
                                      .withValues(alpha: 0.1),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: tower.surveyStatus.color
                                          .withValues(alpha: 0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: tower.surveyStatus.color
                                          .withValues(alpha: 0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                textStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                enabled: context.watch<bool>(),
                                onSelected: (value) {
                                  if (value != null) {
                                    FirebaseFirestoreService().updateTower(
                                      tower.id,
                                      data: {'surveyStatus': value.name},
                                    );
                                  }
                                },
                                trailingIcon: context.watch<bool>()
                                    ? null
                                    : const SizedBox(),
                                dropdownMenuEntries: [
                                  ...SurveyStatus.values.map(
                                    (status) => DropdownMenuEntry(
                                      value: status,
                                      label: status.toString(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 20),
                              DropdownMenu<DrawingStatus>(
                                requestFocusOnTap: false,
                                textAlign: TextAlign.center,
                                initialSelection: tower.drawingStatus,
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: tower.drawingStatus?.color
                                      .withValues(alpha: 0.1),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color:
                                          tower.drawingStatus?.color.withValues(
                                                alpha: 0.5,
                                              ) ??
                                              Colors.black12,
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: tower.surveyStatus.color
                                          .withValues(alpha: 0.5),
                                    ),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                textStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                enabled: context.watch<bool>(),
                                onSelected: (value) {
                                  if (value != null) {
                                    FirebaseFirestoreService().updateTower(
                                      tower.id,
                                      data: {'drawingStatus': value.name},
                                    );
                                  }
                                },
                                trailingIcon: context.watch<bool>()
                                    ? null
                                    : const SizedBox(),
                                dropdownMenuEntries: [
                                  ...DrawingStatus.values.map(
                                    (status) => DropdownMenuEntry(
                                      value: status,
                                      label: status.toString(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
