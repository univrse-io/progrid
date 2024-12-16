import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:progrid/models/pie_chart_painter.dart';
import 'package:progrid/models/providers/towers_provider.dart';
import 'package:progrid/pages/profile_page.dart';
import 'package:progrid/pages/tower_page.dart';
import 'package:progrid/pages/towers_list_page.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

// uses openstreetmap

// TODO: implement map marker filter
// TODO: implement map region jump selection

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

  // determine region color here
  Color _getRegionColor(String region) {
    switch (region.toLowerCase()) {
      case 'southern':
        return Color.fromARGB(255, 82, 114, 76);
      case 'northern':
        return Color.fromARGB(255, 100, 68, 68);
      case 'eastern':
        return Color.fromARGB(255, 134, 124, 79);
      case 'central':
        return Color.fromARGB(255, 63, 81, 100);
      case 'western':
        return Color.fromARGB(255, 104, 71, 104);
      case 'sabah':
        return Color.fromARGB(255, 62, 88, 88);
      case 'sarawak':
        return Color.fromARGB(255, 163, 110, 90);
      default:
        return Colors.grey;
    }
  }

  // detemine region average positions here
  final Map<String, LatLng> _regionPositions = {
    'southern': LatLng(2.0953, 103.0404),
    'northern': LatLng(5.1152, 100.4532),
    'eastern': LatLng(4.3120, 102.4632),
    'central': LatLng(3.0147, 101.3747),
    'western': LatLng(4.1846, 100.6604),
    'sabah': LatLng(5.9804, 116.0735),
    'sarawak': LatLng(1.5548, 110.3592),
  };

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);

    // final int surveyedCount = towersProvider.towers.where((tower) => tower.status == 'surveyed').length;
    // final int towerCount = towersProvider.towers.length;

    // function to go to a specific region
    void _zoomToRegion(String region) {
      final LatLng? position = _regionPositions[region];
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
              ),
              // clustered map markers
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  polygonOptions: PolygonOptions(color: Colors.black.withOpacity(0.1)),
                  maxClusterRadius: 50,
                  alignment: Alignment.center,
                  centerMarkerOnClick: false,
                  padding: const EdgeInsets.all(10),
                  maxZoom: 13,
                  // spiderfyCluster: false, // TODO: Review, essentially what it does is it moves the markers away from each other to make them more visible
                  markers: towersProvider.towers.map((tower) {
                    return Marker(
                      point: LatLng(tower.position.latitude, tower.position.longitude),
                      width: 80,
                      key: ValueKey(tower.id), // assign tower id to marker's key
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TowerPage(towerId: tower.id),
                            ),
                          );
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // marker icon
                            Icon(
                              Icons.cell_tower,
                              color: _getRegionColor(tower.region),
                              size: 36,
                            ),
                            // information box
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
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
                                      color: tower.status == 'surveyed'
                                          ? AppColors.green
                                          : tower.status == 'in-progress'
                                              ? AppColors.yellow
                                              : AppColors.red,
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
                    );
                  }).toList(),
                  builder: (context, markers) {
                    // Calculate proportions
                    final statusCounts = <String, int>{
                      'surveyed': 0,
                      'in-progress': 0,
                      'unsurveyed': 0,
                    };

                    for (final marker in markers) {
                      try {
                        final tower = towersProvider.towers.firstWhere(
                          (tower) {
                            // grab the tower id from marker's key
                            // ensure type safety
                            final markerId = (marker.key! as ValueKey<String>).value;
                            return tower.id == markerId;
                          },
                        );

                        // increment the status counts based on the tower's status
                        if (tower.status == 'surveyed') {
                          statusCounts['surveyed'] = statusCounts['surveyed']! + 1;
                        } else if (tower.status == 'in-progress') {
                          statusCounts['in-progress'] = statusCounts['in-progress']! + 1;
                        } else {
                          statusCounts['unsurveyed'] = statusCounts['unsurveyed']! + 1;
                        }
                      } catch (e) {
                        // handle case where no tower matches the marker (should not happen)
                        debugPrint('No matching tower found for marker with key ${marker.key}');
                      }
                    }

                    // simplify fraction (may have to be removed to free computation power)
                    final total = statusCounts.values.reduce((a, b) => a + b);

                    // status colors
                    final statusColors = {
                      'surveyed': AppColors.green,
                      'in-progress': AppColors.yellow,
                      'unsurveyed': AppColors.red,
                    };

                    return CustomPaint(
                      size: const Size(40, 40),
                      painter: PieChartPainter(statusCounts, total, statusColors),
                    );
                  },
                ),
              ),

              // add attributions here
              SimpleAttributionWidget(
                source: Text('OpenStreetMap'),
                backgroundColor: Colors.black.withOpacity(0.1),
              ),
            ],
          ),

          // top left
          Positioned(
            top: 25,
            left: 14,
            child: FloatingActionButton(
              onPressed: () async {
                final String? selectedRegion = await showMenu(
                  elevation: 0,
                  color: Colors.black.withOpacity(0),
                  context: context,
                  position: RelativeRect.fromLTRB(0, 70, 0, 0),
                  items: _regionPositions.keys.map((region) {
                    return PopupMenuItem(
                      height: 35,
                      value: region,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
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
                    );
                  }).toList(),
                );

                if (selectedRegion != null) {
                  _zoomToRegion(selectedRegion);
                }
              },
              backgroundColor: Colors.black.withOpacity(0.6),
              child: const Icon(
                Icons.map,
                size: 32,
              ),
              mini: true,
            ),
          ),

          // top right row
          Positioned(
            top: 25,
            right: 14,
            child: Row(
              children: [
                // filter button
                FloatingActionButton(
                  onPressed: () {},
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: const Icon(
                    Icons.filter_alt_outlined,
                    size: 32,
                  ),
                  mini: true,
                ),

                const SizedBox(width: 5),

                // TODO: fix hero
                // search button
                FloatingActionButton(
                  heroTag: 'searchbar',
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const TowersListPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                      ),

                      // MaterialPageRoute(
                      //   builder: (context) => const TowersListPage(),
                      // ),
                    );
                  },
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: const Icon(
                    Icons.search,
                    size: 32,
                  ),
                  mini: true,
                ),

                // profile button
                FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => const ProfilePage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(0.0, 1.0); // bottom
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          final offsetAnimation = animation.drive(Tween(begin: begin, end: end).chain(CurveTween(curve: curve)));
                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),

                      // MaterialPageRoute(
                      //   builder: (context) => const ProfilePage(),
                      // ),
                    );
                  },
                  backgroundColor: Colors.black.withOpacity(0.6),
                  child: const Icon(
                    Icons.person,
                    size: 32,
                  ),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}