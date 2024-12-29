import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/pages/dashboard/as_built_drawing_page.dart';
import 'package:progrid/pages/dashboard/home_page.dart';
import 'package:progrid/pages/dashboard/on_site_audit_page.dart';
import 'package:progrid/pages/profile_page.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final pageController = PageController();

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Row(
          children: [
            Text('PROJECT MONITORING REPORT',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(width: 20),
            Image.asset('assets/images/uos.png', height: 40),
            SizedBox(width: 20),
            Image.asset('assets/images/sapura.png', height: 40),
            SizedBox(width: 20),
            Image.asset('assets/images/binasat.png', height: 40),
          ],
        ),
        actions: [
          OutlinedButton(
              onPressed: () {
                final towers = Provider.of<List<Tower>>(context, listen: false);
                final excel = Excel.createExcel();
                final sheet = excel[excel.getDefaultSheet()!];

                sheet
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 0, rowIndex: 0))
                      .value = TextCellValue('ID')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 1, rowIndex: 0))
                      .value = TextCellValue('Name')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 2, rowIndex: 0))
                      .value = TextCellValue('Region')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 3, rowIndex: 0))
                      .value = TextCellValue('Type')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 4, rowIndex: 0))
                      .value = TextCellValue('Owner')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 5, rowIndex: 0))
                      .value = TextCellValue('Address')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 6, rowIndex: 0))
                      .value = TextCellValue('Position')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 7, rowIndex: 0))
                      .value = TextCellValue('Survey Status')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 8, rowIndex: 0))
                      .value = TextCellValue('Drawing Status')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 9, rowIndex: 0))
                      .value = TextCellValue('Sign In')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 10, rowIndex: 0))
                      .value = TextCellValue('Sign Out')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 11, rowIndex: 0))
                      .value = TextCellValue('Author ID')
                  ..cell(CellIndex.indexByColumnRow(
                          columnIndex: 12, rowIndex: 0))
                      .value = TextCellValue('Notes');

                for (final tower in towers) {
                  final rowIndex = towers.indexOf(tower) + 1;

                  sheet
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 0, rowIndex: rowIndex))
                        .value = TextCellValue(tower.id)
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 1, rowIndex: rowIndex))
                        .value = TextCellValue(tower.name)
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 2, rowIndex: rowIndex))
                        .value = TextCellValue(tower.region.toString())
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 3, rowIndex: rowIndex))
                        .value = TextCellValue(tower.type)
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 4, rowIndex: rowIndex))
                        .value = TextCellValue(tower.owner)
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 5, rowIndex: rowIndex))
                        .value = TextCellValue(tower.address)
                    ..cell(CellIndex.indexByColumnRow(
                                columnIndex: 6, rowIndex: rowIndex))
                            .value =
                        TextCellValue(
                            '${tower.position.latitude}/${tower.position.longitude}')
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 7, rowIndex: rowIndex))
                        .value = TextCellValue(tower.surveyStatus)
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 8, rowIndex: rowIndex))
                        .value = TextCellValue(tower.drawingStatus.toString())
                    ..cell(CellIndex.indexByColumnRow(
                                columnIndex: 9, rowIndex: rowIndex))
                            .value =
                        TextCellValue(tower.signIn != null
                            ? DateFormat('ddMMyy HH:mm:ss')
                                .format(tower.signIn!.toDate())
                            : '')
                    ..cell(CellIndex.indexByColumnRow(
                                columnIndex: 10, rowIndex: rowIndex))
                            .value =
                        TextCellValue(tower.signOut != null
                            ? DateFormat('ddMMyy HH:mm:ss')
                                .format(tower.signOut!.toDate())
                            : '')
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 11, rowIndex: rowIndex))
                        .value = TextCellValue(tower.authorId ?? '')
                    ..cell(CellIndex.indexByColumnRow(
                            columnIndex: 12, rowIndex: rowIndex))
                        .value = TextCellValue(tower.notes ?? '');
                }

                excel.save(fileName: 'Reports.xlsx');
              },
              child: Text('Download')),
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
              title: const Text('On-Site Audit'),
              onTap: () => pageController.jumpToPage(1),
            ),
            ListTile(
              title: const Text('As-Built Drawing'),
              onTap: () => pageController.jumpToPage(2),
            ),
          ],
        ),
      ),
      body: PageView(
          controller: pageController,
          children: [
            HomePage(),
            OnSiteAuditPage(),
            AsBuiltDrawingPage(),
          ],
          physics: NeverScrollableScrollPhysics()));
}
