import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/region.dart';
import '../models/survey_status.dart';
import '../models/tower.dart';
import '../utils/pie_chart_painter.dart';
import '../utils/themes.dart';
import 'profile_page.dart';
import 'tower_page.dart';
import 'towers_list_page.dart';

// TODO: Implement map marker filter.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // TODO: Get the position of the current user.
  final defaultPosition = const LatLng(3.140493, 101.700068);
  final mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final towers = Provider.of<List<Tower>>(context);

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: defaultPosition,
              initialZoom: 12,
              maxZoom: 17,
              minZoom: 8,
              interactionOptions: const InteractionOptions(
                // INFO: Disable map rotation.
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
                                    () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder:
                                            (_) => TowerPage(towerId: tower.id),
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
                                          Spacing.$3(
                                            color: tower.surveyStatus.color,
                                          ),
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
                        final markerId =
                            (marker.key! as ValueKey<String>).value;
                        return tower.id == markerId;
                      });

                      // increment the status counts based on the tower's status
                      if (tower.surveyStatus == SurveyStatus.surveyed) {
                        statusCounts['surveyed'] =
                            statusCounts['surveyed']! + 1;
                      } else if (tower.surveyStatus ==
                          SurveyStatus.inprogress) {
                        statusCounts['inprogress'] =
                            statusCounts['inprogress']! + 1;
                      } else {
                        statusCounts['unsurveyed'] =
                            statusCounts['unsurveyed']! + 1;
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
                      painter: PieChartPainter(
                        statusCounts,
                        total,
                        statusColors,
                      ),
                    );
                  },
                ),
              ),
              const SimpleAttributionWidget(
                source: Text('OpenStreetMap'),
                backgroundColor: Colors.black12,
              ),
            ],
          ),
          Positioned(
            top: 25,
            left: 14,
            child: FloatingActionButton(
              onPressed: () async {
                final selectedRegion = await showMenu<Region>(
                  elevation: 0,
                  color: Colors.transparent,
                  context: context,
                  position: const RelativeRect.fromLTRB(0, 70, 0, 0),
                  items:
                      Region.values
                          .map(
                            (region) => PopupMenuItem(
                              value: region,
                              child: Chip(
                                side: BorderSide.none,
                                shape: const RoundedRectangleBorder(),
                                elevation: 0,
                                label: Text('$region'),
                              ),
                            ),
                          )
                          .toList(),
                );

                if (selectedRegion != null) {
                  mapController.move(selectedRegion.latlng, 8);
                }
              },
              mini: true,
              child: const Icon(CarbonIcon.plan),
            ),
          ),
          Positioned(
            top: 25,
            right: 14,
            child: Row(
              children: [
                FloatingActionButton(
                  heroTag: 'searchbar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const TowersListPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) =>
                                FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                      ),
                    );
                  },
                  mini: true,
                  child: const Icon(CarbonIcon.search),
                ),
                FloatingActionButton(
                  heroTag: 'profile',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder:
                            (context, animation, secondaryAnimation) =>
                                const ProfilePage(),
                        transitionsBuilder: (
                          context,
                          animation,
                          secondaryAnimation,
                          child,
                        ) {
                          const begin = Offset(0, 1);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          final offsetAnimation = animation.drive(
                            Tween(
                              begin: begin,
                              end: end,
                            ).chain(CurveTween(curve: curve)),
                          );
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  mini: true,
                  child: const Icon(CarbonIcon.user),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
