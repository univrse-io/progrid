import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:progrid/models/providers/tower_provider.dart';
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

  // configure map tiles here
  // Widget _mapThemeTileBuilder(
  //   BuildContext context,
  //   Widget tileWidget,
  //   TileImage tile,
  // ) {
  //   // black and white light theme
  //   return ColorFiltered(
  //     colorFilter: const ColorFilter.mode(
  //       Colors.white,
  //       BlendMode.saturation,
  //     ),
  //     child: tileWidget,
  //   );

  //   // dark theme
  //   // return ColorFiltered(
  //   //   colorFilter: const ColorFilter.matrix(<double>[
  //   //     -0.2126, -0.7152, -0.0722, 0, 255, // red channel
  //   //     -0.2126, -0.7152, -0.0722, 0, 255, // green channel
  //   //     -0.2126, -0.7152, -0.0722, 0, 255, // blue channel
  //   //     0, 0, 0, 1, 0, // alpha channel
  //   //   ]),
  //   //   child: tileWidget,
  //   // );
  // }

  // determing region color here
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

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);

    final int surveyedCount = towersProvider.towers.where((tower) => tower.status == 'surveyed').length;
    final int towerCount = towersProvider.towers.length;

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
              TileLayer(
                urlTemplate: _tileLayerUrl,
              ),
              MarkerLayer(
                alignment: Alignment.topCenter, // define marker alignment here
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
                                    color: tower.status == 'surveyed' ? AppColors.green : AppColors.red,
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
              ),
              SimpleAttributionWidget(
                source: Text('OpenStreetMap'),
                backgroundColor: Colors.black.withOpacity(0.1),
              ),
            ],
          ),

          // top row
          Positioned(
            top: 30,
            right: 14,
            child: Row(
              children: [
                // tower counter
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Surveyed: $surveyedCount / Total: $towerCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
