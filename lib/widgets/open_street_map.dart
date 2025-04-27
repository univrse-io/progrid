import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/survey_status.dart';
import '../models/tower.dart';
import '../pages/tower_page.dart';
import '../utils/dialog_utils.dart';
import '../utils/pie_chart_painter.dart';
import '../utils/themes.dart';

class OpenStreetMap extends StatelessWidget {
  final MapController? controller;

  const OpenStreetMap({this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Get the position of the current user.
    const defaultPosition = LatLng(3.140493, 101.700068);
    final towers = Provider.of<List<Tower>>(context);

    return FlutterMap(
      mapController: controller,
      options: const MapOptions(
        initialCenter: defaultPosition,
        initialZoom: 11,
        minZoom: 5,
        maxZoom: 17,
        interactionOptions: InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
        keepAlive: true,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          // retinaMode: RetinaMode.isHighDensity(context),
        ),
        MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            polygonOptions: const PolygonOptions(color: Colors.black12),
            maxClusterRadius: 50,
            maxZoom: 13,
            markers:
                towers
                    .map(
                      (tower) => Marker(
                        key: ValueKey(tower.id),
                        point: LatLng(
                          tower.position.latitude,
                          tower.position.longitude,
                        ),
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap:
                              kIsWeb
                                  ? () {
                                    DialogUtils.showTowerDialog(
                                      context,
                                      tower.id,
                                    );
                                  }
                                  : () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => TowerPage(tower),
                                    ),
                                  ),
                          child: Column(
                            children: [
                              ColoredBox(
                                color: Colors.black54,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Spacing.$2(),
                                    Spacing.$3(color: tower.surveyStatus.color),
                                    const Spacing.$2(),
                                    Text(
                                      tower.id,
                                      style:
                                          Theme.of(
                                            context,
                                          ).primaryTextTheme.labelSmall,
                                    ),
                                    const Spacing.$2(),
                                  ],
                                ),
                              ),
                              const Spacing.$1(),
                              Icon(
                                CarbonIcon.transmission_lte,
                                color: tower.region.color,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
            builder: (context, markers) {
              final statusCounts = <String, int>{
                'surveyed': 0,
                'inprogress': 0,
                'unsurveyed': 0,
              };

              for (final marker in markers) {
                final tower = towers.firstWhere((tower) {
                  // grab the tower id from marker's key
                  // ensure type safety
                  final markerId = (marker.key! as ValueKey<String>).value;
                  return tower.id == markerId;
                });

                // increment the status counts based on the tower's status
                if (tower.surveyStatus == SurveyStatus.surveyed) {
                  statusCounts['surveyed'] = statusCounts['surveyed']! + 1;
                } else if (tower.surveyStatus == SurveyStatus.inprogress) {
                  statusCounts['inprogress'] = statusCounts['inprogress']! + 1;
                } else {
                  statusCounts['unsurveyed'] = statusCounts['unsurveyed']! + 1;
                }
              }

              final total = statusCounts.values.reduce((a, b) => a + b);
              final statusColors = {
                'surveyed': AppColors.green,
                'inprogress': AppColors.yellow,
                'unsurveyed': AppColors.red,
              };

              return CustomPaint(
                size: const Size(40, 40),
                painter: PieChartPainter(statusCounts, total, statusColors),
              );
            },
          ),
        ),
        const SimpleAttributionWidget(
          source: Text('OpenStreetMap'),
          backgroundColor: Colors.black12,
        ),
      ],
    );
  }
}
