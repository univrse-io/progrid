import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../../models/drawing_status.dart';
import '../../models/issue.dart';
import '../../models/issue_status.dart';
import '../../models/region.dart';
import '../../models/survey_status.dart';
import '../../models/tower.dart';
import '../../utils/dialog_utils.dart';
import '../../utils/themes.dart';

final screenshotController1 = ScreenshotController();
final screenshotController2 = ScreenshotController();
final screenshotController3 = ScreenshotController();
final screenshotController4 = ScreenshotController();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final towers = Provider.of<List<Tower>>(context);
    final issues =
        Provider.of<List<Issue>>(context)
          ..sort((a, b) => b.dateTime.compareTo(a.dateTime))
          ..removeWhere((issue) => issue.status == IssueStatus.resolved);

    return Row(
      children: [
        const Spacing.$2(),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacing.$2(),
              Expanded(
                flex: 2,
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.purple, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('On-Site Audit', style: CarbonTextStyle.heading02),
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              startDegreeOffset: 45,
                              centerSpaceRadius: 45,
                              sections: [
                                ...SurveyStatus.values.map(
                                  (status) => PieChartSectionData(
                                    title:
                                        '${status == SurveyStatus.surveyed
                                            ? 'Balance'
                                            : status == SurveyStatus.inprogress
                                            ? 'In Progress'
                                            : 'Completed'}\n${(towers.where((tower) => tower.surveyStatus == status).length.toDouble() / towers.length * 100).toStringAsFixed(2)}%',
                                    titleStyle: CarbonTextStyle.label01,
                                    titlePositionPercentageOffset: 2.5,
                                    value:
                                        towers
                                            .where(
                                              (tower) =>
                                                  tower.surveyStatus == status,
                                            )
                                            .length
                                            .toDouble(),
                                    radius: 25,
                                    color: status.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Regional Breakdown',
                          style: CarbonTextStyle.heading02,
                        ),
                        Expanded(
                          child: Screenshot(
                            controller: screenshotController1,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 45,
                                startDegreeOffset: 45,
                                sections: [
                                  ...Region.values.map(
                                    (region) => PieChartSectionData(
                                      title:
                                          '$region\n${(towers.where((tower) => tower.region.name == region.name && tower.surveyStatus == SurveyStatus.surveyed).length / towers.where((tower) => tower.surveyStatus == SurveyStatus.surveyed).length * 100).toStringAsFixed(2)}%',
                                      titleStyle: CarbonTextStyle.label01,
                                      titlePositionPercentageOffset: 2.5,
                                      value:
                                          towers
                                              .where(
                                                (tower) =>
                                                    tower.region.name ==
                                                        region.name &&
                                                    tower.surveyStatus ==
                                                        SurveyStatus.surveyed,
                                              )
                                              .length
                                              .toDouble(),
                                      radius: 25,
                                      color: region.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacing.$2(),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Recent Issues Tickets',
                          style: CarbonTextStyle.heading02,
                        ),
                        const Spacing.$3(),
                        Expanded(
                          child: ListView.separated(
                            separatorBuilder: (_, _) => const Spacing.$2(),
                            itemCount: issues.length,
                            itemBuilder:
                                (context, index) => ListTile(
                                  dense: true,
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder:
                                          (context) => SimpleDialog(
                                            contentPadding:
                                                const EdgeInsets.all(20),
                                            title: Row(
                                              children: [
                                                Text(
                                                  issues[index].id,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Chip(
                                                  padding: EdgeInsets.zero,
                                                  shape: const StadiumBorder(),
                                                  side: BorderSide.none,
                                                  label: Text(
                                                    issues[index].status
                                                        .toString(),
                                                    style:
                                                        Theme.of(context)
                                                            .primaryTextTheme
                                                            .bodyMedium,
                                                  ),
                                                  backgroundColor:
                                                      issues[index]
                                                          .status
                                                          .color,
                                                ),
                                              ],
                                            ),
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      'Description:',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    issues[index].description,
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      'Issued At:',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    DateFormat(
                                                      'dd/MM/yy HH:mm a',
                                                    ).format(
                                                      issues[index].dateTime
                                                          .toDate(),
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const SizedBox(
                                                    width: 100,
                                                    child: Text(
                                                      'Tags:',
                                                      textAlign:
                                                          TextAlign.right,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    issues[index].tags.join(
                                                      ', ',
                                                    ),
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              OutlinedButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                  DialogUtils.showTowerDialog(
                                                    context,
                                                    issues[index].id
                                                        .split('-')
                                                        .first,
                                                  );
                                                },
                                                child: const Text('View Tower'),
                                              ),
                                            ],
                                          ),
                                    );
                                  },
                                  trailing: Text(
                                    DateFormat(
                                      'dd/MM/yy HH:mm a',
                                    ).format(issues[index].dateTime.toDate()),
                                  ),
                                  title: Row(
                                    children: [
                                      Spacing.$3(
                                        color: issues[index].status.color,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(issues[index].id),
                                    ],
                                  ),
                                  subtitle: Text(issues[index].tags.join(', ')),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacing.$2(),
            ],
          ),
        ),
        const Spacing.$2(),
        Expanded(
          flex: 5,
          child: Column(
            children: [
              const Spacing.$2(),
              Card(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.purple, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('On-Site Audit', style: CarbonTextStyle.heading02),
                      const Spacing.$3(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('Total', style: CarbonTextStyle.heading01),
                                Text(
                                  '${towers.length}',
                                  style: CarbonTextStyle.heading05,
                                ),
                              ],
                            ),
                          ),
                          const Spacing.$3(),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'In Progress',
                                  style: CarbonTextStyle.heading01,
                                ),
                                Text(
                                  '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress).length}',
                                  style: CarbonTextStyle.heading05,
                                ),
                              ],
                            ),
                          ),
                          const Spacing.$3(),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Completed',
                                  style: CarbonTextStyle.heading01,
                                ),
                                Text(
                                  '${towers.where((tower) => tower.surveyStatus == SurveyStatus.surveyed).length}',
                                  style: CarbonTextStyle.heading05,
                                ),
                              ],
                            ),
                          ),
                          const Spacing.$3(),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Balance',
                                  style: CarbonTextStyle.heading01,
                                ),
                                Text(
                                  '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress || tower.surveyStatus == SurveyStatus.unsurveyed).length}',
                                  style: CarbonTextStyle.heading05,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacing.$2(),
              Card(
                shape: const RoundedRectangleBorder(
                  side: BorderSide(color: Colors.green, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'As-Built Drawing',
                        style: CarbonTextStyle.heading02,
                      ),
                      const Spacing.$3(),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('Total', style: CarbonTextStyle.heading01),
                                Text(
                                  '${towers.length}',
                                  style: CarbonTextStyle.heading05,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'In Progress',
                                  style: CarbonTextStyle.heading01,
                                ),
                                Text(
                                  '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress).length}',
                                  style: CarbonTextStyle.heading05,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Submitted',
                                  style: CarbonTextStyle.heading01,
                                ),
                                Text(
                                  '${towers.where((tower) => tower.drawingStatus == DrawingStatus.submitted).length}',
                                  style: CarbonTextStyle.heading05,
                                ),
                              ],
                            ),
                          ),
                          const Spacing.$3(),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  'Balance',
                                  style: CarbonTextStyle.heading01,
                                ),
                                Text(
                                  '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress || tower.drawingStatus == null).length}',
                                  style: CarbonTextStyle.heading05,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacing.$2(),
              Expanded(
                child: Screenshot(
                  controller: screenshotController3,
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(3.1408, 101.6932),
                      initialZoom: 11,
                      interactionOptions: InteractionOptions(
                        flags: ~InteractiveFlag.doubleTapZoom,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName:
                            'dev.fleaflet.flutter_map.example',
                      ),
                      MarkerLayer(
                        markers: [
                          ...towers.map(
                            (tower) => Marker(
                              point: LatLng(
                                tower.position.latitude,
                                tower.position.longitude,
                              ),
                              width: 80,
                              // key: ValueKey(tower.id),
                              child: GestureDetector(
                                onTap: () {
                                  // TODO: implement map dialog here
                                  DialogUtils.showTowerDialog(
                                    context,
                                    tower.id,
                                  );
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // marker icon
                                    Icon(
                                      Icons.cell_tower,
                                      color: switch (tower.region.name) {
                                        'southern' => const Color.fromARGB(
                                          255,
                                          82,
                                          114,
                                          76,
                                        ),
                                        'northern' => const Color.fromARGB(
                                          255,
                                          100,
                                          68,
                                          68,
                                        ),
                                        'eastern' => const Color.fromARGB(
                                          255,
                                          134,
                                          124,
                                          79,
                                        ),
                                        'central' => const Color.fromARGB(
                                          255,
                                          63,
                                          81,
                                          100,
                                        ),
                                        'western' => const Color.fromARGB(
                                          255,
                                          104,
                                          71,
                                          104,
                                        ),
                                        'sabah' => const Color.fromARGB(
                                          255,
                                          62,
                                          88,
                                          88,
                                        ),
                                        'sarawak' => const Color.fromARGB(
                                          255,
                                          163,
                                          110,
                                          90,
                                        ),
                                        _ => Colors.grey,
                                      },
                                      size: 36,
                                    ),
                                    // information box
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.onSurface.withValues(
                                          alpha: 0.7,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: tower.surveyStatus.color,
                                            ),
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            tower.id,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacing.$2(),
            ],
          ),
        ),
        const Spacing.$2(),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Spacing.$2(),
              Expanded(
                flex: 2,
                child: Card(
                  shape: const RoundedRectangleBorder(
                    side: BorderSide(color: Colors.green, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'As-Built Drawing',
                          style: CarbonTextStyle.heading02,
                        ),
                        Expanded(
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 0,
                              centerSpaceRadius: 45,
                              startDegreeOffset: 45,
                              sections: [
                                PieChartSectionData(
                                  title:
                                      'Balance\n${(towers.where((tower) => tower.drawingStatus == null).length.toDouble() / towers.length * 100).toStringAsFixed(2)}%',
                                  titleStyle: CarbonTextStyle.label01,
                                  titlePositionPercentageOffset: 2.5,
                                  value:
                                      towers
                                          .where(
                                            (tower) =>
                                                tower.drawingStatus == null,
                                          )
                                          .length
                                          .toDouble(),
                                  radius: 25,
                                  color: CarbonColor.red60,
                                ),
                                ...DrawingStatus.values.map(
                                  (drawingStatus) => PieChartSectionData(
                                    title:
                                        '$drawingStatus\n${(towers.where((tower) => tower.drawingStatus == drawingStatus).length.toDouble() / towers.length * 100).toStringAsFixed(2)}%',
                                    titleStyle: CarbonTextStyle.label01,
                                    titlePositionPercentageOffset: 2.5,
                                    value:
                                        towers
                                            .where(
                                              (tower) =>
                                                  tower.drawingStatus ==
                                                  drawingStatus,
                                            )
                                            .length
                                            .toDouble(),
                                    radius: 25,
                                    color: drawingStatus.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          'Regional Breakdown',
                          style: CarbonTextStyle.heading02,
                        ),
                        Expanded(
                          child: Screenshot(
                            controller: screenshotController2,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 0,
                                centerSpaceRadius: 45,
                                startDegreeOffset: 45,
                                sections: [
                                  ...Region.values.map(
                                    (region) => PieChartSectionData(
                                      title:
                                          '$region\n${(towers.where((tower) => tower.region.name == region.name && tower.drawingStatus == DrawingStatus.submitted).length / towers.where((tower) => tower.drawingStatus == DrawingStatus.submitted).length * 100).toStringAsFixed(2)}%',
                                      titleStyle: CarbonTextStyle.label01,
                                      titlePositionPercentageOffset: 2.5,
                                      value:
                                          towers
                                              .where(
                                                (tower) =>
                                                    tower.region.name ==
                                                        region.name &&
                                                    tower.drawingStatus ==
                                                        DrawingStatus.submitted,
                                              )
                                              .length
                                              .toDouble(),
                                      radius: 25,
                                      color: region.color,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacing.$2(),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'On-Site Audit vs As-Built Drawing',
                          style: CarbonTextStyle.heading02,
                        ),
                        const Spacing.$3(),
                        Expanded(
                          child: Screenshot(
                            controller: screenshotController4,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Row(
                                  children: [
                                    Spacer(),
                                    Spacing.$3(color: Colors.purple),
                                    SizedBox(width: 5),
                                    Text('On-Site Audit'),
                                    Spacer(),
                                    Spacing.$3(color: Colors.green),
                                    SizedBox(width: 5),
                                    Text('As-Built Drawing'),
                                    Spacer(),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Expanded(
                                  child: BarChart(
                                    BarChartData(
                                      barGroups: [
                                        BarChartGroupData(
                                          x: 0,
                                          barRods: [
                                            BarChartRodData(
                                              borderRadius: BorderRadius.zero,
                                              toY:
                                                  towers
                                                      .where(
                                                        (tower) =>
                                                            tower.surveyStatus ==
                                                                SurveyStatus
                                                                    .surveyed &&
                                                            tower.type ==
                                                                'Sharing/Co-locate',
                                                      )
                                                      .length
                                                      .toDouble(),
                                              width: 20,
                                              color: Colors.purple,
                                            ),
                                            BarChartRodData(
                                              borderRadius: BorderRadius.zero,
                                              toY:
                                                  towers
                                                      .where(
                                                        (tower) =>
                                                            tower.drawingStatus ==
                                                                DrawingStatus
                                                                    .submitted &&
                                                            tower.type ==
                                                                'Sharing/Co-locate',
                                                      )
                                                      .length
                                                      .toDouble(),
                                              width: 20,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 1,
                                          barRods: [
                                            BarChartRodData(
                                              borderRadius: BorderRadius.zero,
                                              toY:
                                                  towers
                                                      .where(
                                                        (tower) =>
                                                            tower.surveyStatus ==
                                                                SurveyStatus
                                                                    .surveyed &&
                                                            tower.type ==
                                                                'Greenfield',
                                                      )
                                                      .length
                                                      .toDouble(),
                                              width: 20,
                                              color: Colors.purple,
                                            ),
                                            BarChartRodData(
                                              borderRadius: BorderRadius.zero,
                                              toY:
                                                  towers
                                                      .where(
                                                        (tower) =>
                                                            tower.drawingStatus ==
                                                                DrawingStatus
                                                                    .submitted &&
                                                            tower.type ==
                                                                'Greenfield',
                                                      )
                                                      .length
                                                      .toDouble(),
                                              width: 20,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                        BarChartGroupData(
                                          x: 2,
                                          barRods: [
                                            BarChartRodData(
                                              borderRadius: BorderRadius.zero,
                                              toY:
                                                  towers
                                                      .where(
                                                        (tower) =>
                                                            tower.surveyStatus ==
                                                                SurveyStatus
                                                                    .surveyed &&
                                                            tower.type ==
                                                                'Roof top',
                                                      )
                                                      .length
                                                      .toDouble(),
                                              width: 20,
                                              color: Colors.purple,
                                            ),
                                            BarChartRodData(
                                              borderRadius: BorderRadius.zero,
                                              toY:
                                                  towers
                                                      .where(
                                                        (tower) =>
                                                            tower.drawingStatus ==
                                                                DrawingStatus
                                                                    .submitted &&
                                                            tower.type ==
                                                                'Roof top',
                                                      )
                                                      .length
                                                      .toDouble(),
                                              width: 20,
                                              color: Colors.green,
                                            ),
                                          ],
                                        ),
                                      ],
                                      titlesData: FlTitlesData(
                                        rightTitles: const AxisTitles(),
                                        topTitles: const AxisTitles(),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            getTitlesWidget:
                                                (value, meta) =>
                                                    SideTitleWidget(
                                                      angle: -0.25,
                                                      axisSide: meta.axisSide,
                                                      space: 16,
                                                      child: Text(
                                                        [
                                                          'Sharing/Co-locate',
                                                          'Greenfield',
                                                          'Rooftop',
                                                        ][value.toInt()],
                                                      ),
                                                    ),
                                            reservedSize: 42,
                                          ),
                                        ),
                                        leftTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 28,
                                            getTitlesWidget:
                                                (value, meta) =>
                                                    SideTitleWidget(
                                                      axisSide: meta.axisSide,
                                                      space: 0,
                                                      child: Text(
                                                        value.toString(),
                                                      ),
                                                    ),
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      gridData: const FlGridData(show: false),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacing.$2(),
            ],
          ),
        ),
        const Spacing.$2(),
      ],
    );
  }
}
