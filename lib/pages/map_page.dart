import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
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

  // determine region zoom levels here
  final Map<String, double> _regionZoomLevels = {
    'southern': 12.0,
    'northern': 13.0,
    'eastern': 12.5,
    'central': 12.0,
    'western': 13.0,
    'sabah': 11.0,
    'sarawak': 11.5,
  };

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);

    // final int surveyedCount = towersProvider.towers.where((tower) => tower.status == 'surveyed').length;
    // final int towerCount = towersProvider.towers.length;

    // function to go to a specific region
    void _zoomToRegion(String region) {
      final LatLng? position = _regionPositions[region];
      final double? zoomLevel = _regionZoomLevels[region];
      if (position != null) {
        _mapController.move(position, zoomLevel!);
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
              maxZoom: 17, // to review
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

              // standard map markers, without clustering
              // MarkerLayer(
              //   markers: towersProvider.towers.map((tower) {
              //     return Marker(
              //       point: LatLng(tower.position.latitude, tower.position.longitude),
              //       width: 80,
              //       child: GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => TowerPage(towerId: tower.id),
              //             ),
              //           );
              //         },
              //         child: Stack(
              //           alignment: Alignment.center,
              //           children: [
              //             // marker icon
              //             Icon(
              //               Icons.cell_tower,
              //               color: _getRegionColor(tower.region),
              //               size: 36,
              //             ),
              //             // information box
              //             Container(
              //               padding: EdgeInsets.symmetric(horizontal: 5),
              //               decoration: BoxDecoration(
              //                 color: Colors.black.withOpacity(0.7),
              //                 borderRadius: BorderRadius.circular(4),
              //               ),
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   // status indicator
              //                   Container(
              //                     width: 8,
              //                     height: 8,
              //                     decoration: BoxDecoration(
              //                         shape: BoxShape.circle,
              //                         color: tower.status == 'surveyed'
              //                             ? AppColors.green
              //                             : tower.status == 'in-progress'
              //                                 ? AppColors.yellow
              //                                 : AppColors.red),
              //                   ),
              //                   const SizedBox(width: 4),
              //                   // tower id
              //                   Text(
              //                     tower.id,
              //                     style: const TextStyle(
              //                       color: Colors.white,
              //                       fontSize: 10,
              //                     ),
              //                     maxLines: 1,
              //                   ),
              //                 ],
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // ),

              // clustered map markers
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 50,
                  alignment: Alignment.center,
                  centerMarkerOnClick: false,
                  // size: Size(100, 800), // TODO: make dynamic, cluster click functionality is currently unusable
                  padding: const EdgeInsets.all(10),
                  maxZoom: 15,
                  markers: towersProvider.towers.map((tower) {
                    return Marker(
                      point: LatLng(tower.position.latitude, tower.position.longitude),
                      width: 80,
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
                                color: Colors.black.withOpacity(0.7),
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
                                                : AppColors.red),
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
                  // builder: (context, markers) {
                  //   return Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: markers.map((marker) {
                  //       final tower = towersProvider.towers.firstWhere(
                  //         (tower) => LatLng(tower.position.latitude, tower.position.longitude) == marker.point,
                  //       );
                  //       return Container(
                  //         padding: const EdgeInsets.symmetric(horizontal: 5),
                  //         decoration: BoxDecoration(
                  //           color: Colors.black.withOpacity(0.7),
                  //           borderRadius: BorderRadius.circular(4),
                  //         ),
                  //         child: Row(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: [
                  //             // status indicator
                  //             Container(
                  //               width: 8,
                  //               height: 8,
                  //               decoration: BoxDecoration(
                  //                   shape: BoxShape.circle,
                  //                   color: tower.status == 'surveyed'
                  //                       ? AppColors.green
                  //                       : tower.status == 'in-progress'
                  //                           ? AppColors.yellow
                  //                           : AppColors.red),
                  //             ),
                  //             const SizedBox(width: 4),
                  //             // tower id
                  //             Text(
                  //               tower.id,
                  //               style: const TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 10,
                  //               ),
                  //               maxLines: 1,
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     }).toList(),
                  //   );
                  // },

                  // // TODO: make clusters display statuses of children, as pie chart
                  builder: (context, markers) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.black.withOpacity(0.7),
                      ),
                      child: Center(
                        child: Text(
                          markers.length.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
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
                // // debug tower counter
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                //   decoration: BoxDecoration(
                //     color: Colors.black.withOpacity(0.6),
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: Text(
                //     'Surveyed: $surveyedCount / Total: $towerCount',
                //     style: const TextStyle(
                //       color: Colors.white,
                //       fontSize: 16,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                const SizedBox(width: 5),

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
