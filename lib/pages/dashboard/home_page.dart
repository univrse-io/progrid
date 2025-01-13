import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:progrid/models/drawing_status.dart';
import 'package:progrid/models/issue.dart';
import 'package:progrid/models/region.dart';
import 'package:progrid/models/survey_status.dart';
import 'package:progrid/models/tower.dart';
import 'package:provider/provider.dart';

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
    final issues = Provider.of<List<Issue>>(context)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Padding(
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.purple, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('On-Site Audit',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Expanded(
                            child: PieChart(PieChartData(
                                sectionsSpace: 0,
                                startDegreeOffset: 45,
                                centerSpaceRadius: 40,
                                sections: [
                                  PieChartSectionData(
                                    title:
                                        'Completed\n${(towers.where((tower) => tower.surveyStatus == SurveyStatus.surveyed).length.toDouble() / towers.length * 100).toStringAsFixed(2)}%',
                                    titleStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                    titlePositionPercentageOffset: 2,
                                    value: towers
                                        .where((tower) =>
                                            tower.surveyStatus ==
                                            SurveyStatus.surveyed)
                                        .length
                                        .toDouble(),
                                    radius: 30,
                                    color: Colors.green,
                                  ),
                                  PieChartSectionData(
                                    title:
                                        'In Progress\n${(towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress).length.toDouble() / towers.length * 100).toStringAsFixed(2)}%',
                                    titleStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                    titlePositionPercentageOffset: 2,
                                    value: towers
                                        .where((tower) =>
                                            tower.surveyStatus ==
                                            SurveyStatus.inprogress)
                                        .length
                                        .toDouble(),
                                    radius: 30,
                                    color: Colors.amber,
                                  ),
                                  PieChartSectionData(
                                    title:
                                        'Balance\n${(towers.where((tower) => tower.surveyStatus == SurveyStatus.unsurveyed).length.toDouble() / towers.length * 100).toStringAsFixed(2)}%',
                                    titleStyle:
                                        Theme.of(context).textTheme.labelSmall,
                                    titlePositionPercentageOffset: 2,
                                    value: towers
                                        .where((tower) =>
                                            tower.surveyStatus ==
                                            SurveyStatus.unsurveyed)
                                        .length
                                        .toDouble(),
                                    radius: 30,
                                    color: Colors.red,
                                  ),
                                ])),
                          ),
                          Text('Regional Breakdown',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  startDegreeOffset: 45,
                                  sections: [
                                    ...Region.values
                                        .map((region) => PieChartSectionData(
                                              title:
                                                  '$region\n${(towers.where((tower) => tower.region.name == region.name && tower.surveyStatus == SurveyStatus.surveyed).length / towers.where((tower) => tower.surveyStatus == SurveyStatus.surveyed).length * 100).toStringAsFixed(2)}%',
                                              titleStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                              titlePositionPercentageOffset: 2,
                                              value: towers
                                                  .where((tower) =>
                                                      tower.region.name ==
                                                          region.name &&
                                                      tower.surveyStatus ==
                                                          SurveyStatus.surveyed)
                                                  .length
                                                  .toDouble(),
                                              radius: 30,
                                              color: region.color,
                                            )),
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                    child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Recent Issues Tickets',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(height: 10),
                        Expanded(
                          child: ListView.builder(
                              itemCount: issues.length,
                              itemBuilder: (context, index) => Visibility(
                                    visible:
                                        issues[index].status == 'unresolved',
                                    child: Card(
                                      margin: EdgeInsets.symmetric(vertical: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          side: BorderSide(
                                              color: Colors.black12, width: 2)),
                                      child: ListTile(
                                        dense: true,
                                        trailing: Text(
                                            DateFormat('dd/MM/yy HH:mm').format(
                                                issues[index]
                                                    .dateTime
                                                    .toDate())),
                                        title: Row(
                                          children: [
                                            CircleAvatar(
                                                radius: 5,
                                                backgroundColor: Colors.red),
                                            SizedBox(width: 5),
                                            Text(issues[index].id,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall),
                                          ],
                                        ),
                                        subtitle:
                                            Text(issues[index].tags.join(', ')),
                                      ),
                                    ),
                                  )),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
          SizedBox(width: 5),
          Expanded(
              flex: 5,
              child: Column(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.purple, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('On-Site Audit',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Total',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text('${towers.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall)
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('In Progress',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress).length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall)
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Completed',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${towers.where((tower) => tower.surveyStatus == SurveyStatus.surveyed).length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall)
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Balance',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${towers.where((tower) => tower.surveyStatus == SurveyStatus.inprogress || tower.surveyStatus == SurveyStatus.unsurveyed).length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.green, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('As-Built Drawing',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Total',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text('${towers.length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall)
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('In Progress',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress).length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall)
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Submitted',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${towers.where((tower) => tower.drawingStatus == DrawingStatus.submitted).length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall)
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text('Balance',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        '${towers.where((tower) => tower.drawingStatus == DrawingStatus.inprogress || tower.drawingStatus == null).length}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall)
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: FlutterMap(
                        options: MapOptions(
                            initialCenter: LatLng(3.1408, 101.6932),
                            initialZoom: 11,
                            interactionOptions: InteractionOptions(
                                flags: ~InteractiveFlag.doubleTapZoom)),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                          ),
                          MarkerLayer(markers: [
                            ...towers.map((tower) => Marker(
                                  point: LatLng(tower.position.latitude,
                                      tower.position.longitude),
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: () {},
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        // marker icon
                                        Icon(
                                          Icons.cell_tower,
                                          color: switch (tower.region.name) {
                                            'southern' =>
                                              Color.fromARGB(255, 82, 114, 76),
                                            'northern' =>
                                              Color.fromARGB(255, 100, 68, 68),
                                            'eastern' =>
                                              Color.fromARGB(255, 134, 124, 79),
                                            'central' =>
                                              Color.fromARGB(255, 63, 81, 100),
                                            'western' =>
                                              Color.fromARGB(255, 104, 71, 104),
                                            'sabah' =>
                                              Color.fromARGB(255, 62, 88, 88),
                                            'sarawak' =>
                                              Color.fromARGB(255, 163, 110, 90),
                                            _ => Colors.grey
                                          },
                                          size: 36,
                                        ),

                                        // information box
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withValues(alpha: 0.7),
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              // status indicator
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: tower
                                                        .surveyStatus.color),
                                              ),
                                              const SizedBox(width: 4),

                                              // tower id
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
                                ))
                          ])
                        ]),
                  ),
                ],
              )),
          SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.green, width: 2)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('As-Built Drawing',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  startDegreeOffset: 45,
                                  sections: [
                                    PieChartSectionData(
                                      title:
                                          'Balance\n${(towers.where((tower) => tower.drawingStatus == null).length.toDouble() / towers.length * 100).toStringAsFixed(2)}%',
                                      titleStyle: Theme.of(context)
                                          .textTheme
                                          .labelSmall,
                                      titlePositionPercentageOffset: 2,
                                      value: towers
                                          .where((tower) =>
                                              tower.drawingStatus == null)
                                          .length
                                          .toDouble(),
                                      radius: 30,
                                      color: Colors.red,
                                    ),
                                    ...DrawingStatus.values.map(
                                        (drawingStatus) => PieChartSectionData(
                                              title:
                                                  '$drawingStatus\n${(towers.where((tower) => tower.drawingStatus == drawingStatus).length.toDouble() / towers.length * 100).toStringAsFixed(2)}%',
                                              titleStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                              titlePositionPercentageOffset: 2,
                                              value: towers
                                                  .where((tower) =>
                                                      tower.drawingStatus ==
                                                      drawingStatus)
                                                  .length
                                                  .toDouble(),
                                              radius: 30,
                                              color: drawingStatus.color,
                                            )),
                                  ]),
                            ),
                          ),
                          Text('Regional Breakdown',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                  sectionsSpace: 0,
                                  centerSpaceRadius: 40,
                                  startDegreeOffset: 45,
                                  sections: [
                                    ...Region.values
                                        .map((region) => PieChartSectionData(
                                              title:
                                                  '$region\n${(towers.where((tower) => tower.region.name == region.name && tower.drawingStatus == DrawingStatus.submitted).length / towers.where((tower) => tower.drawingStatus == DrawingStatus.submitted).length * 100).toStringAsFixed(2)}%',
                                              titleStyle: Theme.of(context)
                                                  .textTheme
                                                  .labelSmall,
                                              titlePositionPercentageOffset: 2,
                                              value: towers
                                                  .where((tower) =>
                                                      tower.region.name ==
                                                          region.name &&
                                                      tower.drawingStatus ==
                                                          DrawingStatus
                                                              .submitted)
                                                  .length
                                                  .toDouble(),
                                              radius: 30,
                                              color: region.color,
                                            )),
                                  ]),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Expanded(
                    child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('On-Site Audit vs As-Built Drawing',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Spacer(),
                            CircleAvatar(
                                backgroundColor: Colors.purple, radius: 5),
                            SizedBox(width: 5),
                            Text('On-Site Audit'),
                            Spacer(),
                            CircleAvatar(
                                backgroundColor: Colors.green, radius: 5),
                            SizedBox(width: 5),
                            Text('As-Built Drawing'),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 20),
                        Expanded(
                            child: BarChart(BarChartData(
                          barGroups: [
                            BarChartGroupData(x: 0, barRods: [
                              BarChartRodData(
                                  borderRadius: BorderRadius.zero,
                                  toY: towers
                                      .where((tower) =>
                                          tower.surveyStatus ==
                                              SurveyStatus.surveyed &&
                                          tower.type == 'Sharing/Co-locate')
                                      .length
                                      .toDouble(),
                                  width: 20,
                                  color: Colors.purple),
                              BarChartRodData(
                                  borderRadius: BorderRadius.zero,
                                  toY: towers
                                      .where((tower) =>
                                          tower.drawingStatus ==
                                              DrawingStatus.submitted &&
                                          tower.type == 'Sharing/Co-locate')
                                      .length
                                      .toDouble(),
                                  width: 20,
                                  color: Colors.green)
                            ]),
                            BarChartGroupData(x: 1, barRods: [
                              BarChartRodData(
                                  borderRadius: BorderRadius.zero,
                                  toY: towers
                                      .where((tower) =>
                                          tower.surveyStatus ==
                                              SurveyStatus.surveyed &&
                                          tower.type == 'Greenfield')
                                      .length
                                      .toDouble(),
                                  width: 20,
                                  color: Colors.purple),
                              BarChartRodData(
                                  borderRadius: BorderRadius.zero,
                                  toY: towers
                                      .where((tower) =>
                                          tower.drawingStatus ==
                                              DrawingStatus.submitted &&
                                          tower.type == 'Greenfield')
                                      .length
                                      .toDouble(),
                                  width: 20,
                                  color: Colors.green)
                            ]),
                            BarChartGroupData(x: 2, barRods: [
                              BarChartRodData(
                                  borderRadius: BorderRadius.zero,
                                  toY: towers
                                      .where((tower) =>
                                          tower.surveyStatus ==
                                              SurveyStatus.surveyed &&
                                          tower.type == 'Roof top')
                                      .length
                                      .toDouble(),
                                  width: 20,
                                  color: Colors.purple),
                              BarChartRodData(
                                  borderRadius: BorderRadius.zero,
                                  toY: towers
                                      .where((tower) =>
                                          tower.drawingStatus ==
                                              DrawingStatus.submitted &&
                                          tower.type == 'Roof top')
                                      .length
                                      .toDouble(),
                                  width: 20,
                                  color: Colors.green)
                            ]),
                          ],
                          titlesData: FlTitlesData(
                            rightTitles: const AxisTitles(),
                            topTitles: const AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) =>
                                    SideTitleWidget(
                                  angle: -0.25,
                                  axisSide: meta.axisSide,
                                  space: 16,
                                  child: Text([
                                    'Sharing/Co-locate',
                                    'Greenfield',
                                    'Rooftop'
                                  ][value.toInt()]),
                                ),
                                reservedSize: 42,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) =>
                                    SideTitleWidget(
                                  axisSide: meta.axisSide,
                                  space: 0,
                                  child: Text(value.toString()),
                                ),
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: const FlGridData(show: false),
                        ))),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          )
        ],
      ),
    );
  }
}
