import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../models/survey_status.dart';
import '../models/tower.dart';
import '../utils/pie_chart_painter.dart';
import '../utils/themes.dart';
import 'profile_page.dart';
import 'tower_page.dart';
import 'towers_list_page.dart';

// uses openstreetmap
// TODO: implement map marker filter
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LatLng _defaultPosition = const LatLng(3.140493, 101.700068);
  final MapController _mapController = MapController();

  // TODO: move this to firebase server, to allow switching incase of tile server crashes
  final String _tileLayerUrl = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  // determine region average positions here
  final Map<String, LatLng> _regionPositions = {
    'southern': const LatLng(2.0953, 103.0404),
    'northern': const LatLng(5.1152, 100.4532),
    'eastern': const LatLng(4.3120, 102.4632),
    'central': const LatLng(3.0147, 101.3747),
    'sabah': const LatLng(5.9804, 116.0735),
    'sarawak': const LatLng(1.5548, 110.3592),
  };

  // configure map tile builder here
  Widget _tileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage image,
  ) {
    const saturation = .8;
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix([
        0.213 + 0.787 * saturation,
        0.715 * (1 - saturation),
        0.072 * (1 - saturation),
        0.0,
        0.0,
        0.213 * (1 - saturation),
        0.715 + 0.285 * saturation,
        0.072 * (1 - saturation),
        0.0,
        0.0,
        0.213 * (1 - saturation),
        0.715 * (1 - saturation),
        0.072 + 0.928 * saturation,
        0.0,
        0.0,
        0.0,
        0.0,
        0.0,
        1.0,
        0.0,
      ]),
      child: tileWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final towers = Provider.of<List<Tower>>(context);

    // final int surveyedCount = towers.towers.where((tower) => tower.status == 'surveyed').length;
    // final int towerCount = towers.towers.length;

    // function to go to a specific region
    void zoomToRegion(String region) {
      final position = _regionPositions[region];
      if (position != null) {
        _mapController.move(position, 8);
      }
    }

    return Scaffold(
      body: Stack(
        children: [
          // map content
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _defaultPosition,
              initialZoom: 12,
              maxZoom: 17,
              minZoom: 8,
              backgroundColor: Theme.of(context).colorScheme.surface,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              // base map layer
              TileLayer(
                urlTemplate: _tileLayerUrl,
                tileBuilder: _tileBuilder,
              ),
              // clustered map markers
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  polygonOptions: PolygonOptions(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                  maxClusterRadius: 50,
                  alignment: Alignment.center,
                  centerMarkerOnClick: false,
                  padding: const EdgeInsets.all(10),
                  maxZoom: 13,
                  // spiderfyCluster: false,
                  markers: towers
                      .map(
                        (tower) => Marker(
                          point: LatLng(
                            tower.position.latitude,
                            tower.position.longitude,
                          ),
                          width: 80,
                          key: ValueKey(tower.id),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TowerPage(towerId: tower.id),
                                ),
                              );
                            },
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Icon(
                                  Icons.cell_tower,
                                  color: tower.region.color,
                                  size: 36,
                                ),
                                Container(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // status indicator
                                      Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: tower.surveyStatus.color,
                                        ),
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
                        ),
                      )
                      .toList(),
                  builder: (context, markers) {
                    // Calculate proportions
                    final statusCounts = <String, int>{
                      'surveyed': 0,
                      'inprogress': 0,
                      'unsurveyed': 0,
                    };

                    for (final marker in markers) {
                      try {
                        final tower = towers.firstWhere(
                          (tower) {
                            // grab the tower id from marker's key
                            // ensure type safety
                            final markerId =
                                (marker.key! as ValueKey<String>).value;
                            return tower.id == markerId;
                          },
                        );

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
                      } catch (e) {
                        // handle case where no tower matches the marker (should not happen)
                        debugPrint(
                          'No matching tower found for marker with key ${marker.key}',
                        );
                      }
                    }

                    // simplify fraction (may have to be removed to free computation power)
                    final total = statusCounts.values.reduce((a, b) => a + b);

                    // status colors
                    final statusColors = {
                      'surveyed': AppColors.green,
                      'inprogress': AppColors.yellow,
                      'unsurveyed': AppColors.red,
                    };

                    return CustomPaint(
                      size: const Size(40, 40),
                      painter:
                          PieChartPainter(statusCounts, total, statusColors),
                    );
                  },
                ),
              ),

              // add attributions here
              SimpleAttributionWidget(
                source: const Text('OpenStreetMap'),
                backgroundColor: Colors.black.withValues(alpha: 0.1),
              ),
            ],
          ),

          // top left
          Positioned(
            top: 25,
            left: 14,
            child: FloatingActionButton(
              heroTag: 'regions',
              onPressed: () async {
                final selectedRegion = await showMenu(
                  elevation: 0,
                  color: Colors.black.withValues(alpha: 0),
                  context: context,
                  position: const RelativeRect.fromLTRB(0, 70, 0, 0),
                  items: _regionPositions.keys
                      .map(
                        (region) => PopupMenuItem(
                          height: 35,
                          value: region,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${region[0].toUpperCase()}${region.substring(1)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );

                if (selectedRegion != null) {
                  zoomToRegion(selectedRegion);
                }
              },
              backgroundColor: Colors.black.withValues(alpha: 0.6),
              mini: true,
              child: const Icon(
                Icons.map,
                size: 32,
              ),
            ),
          ),

          // top right row
          Positioned(
            top: 25,
            right: 14,
            child: Row(
              children: [
                // search button
                FloatingActionButton(
                  heroTag: 'searchbar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
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
                  backgroundColor: Colors.black.withValues(alpha: 0.6),
                  mini: true,
                  child: const Icon(
                    Icons.search,
                    size: 32,
                  ),
                ),

                // profile button
                FloatingActionButton(
                  heroTag: 'profile',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            const ProfilePage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0, 1); // bottom
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          final offsetAnimation = animation.drive(
                            Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: curve)),
                          );
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  backgroundColor: Colors.black.withValues(alpha: 0.6),
                  mini: true,
                  child: const Icon(
                    Icons.person,
                    size: 32,
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
