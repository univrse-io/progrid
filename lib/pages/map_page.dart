import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:progrid/models/providers/tower_provider.dart';
import 'package:progrid/models/tower.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

// uses openstreetmap

// shows location of all towers including self
// clicking on a tower will open correlated tower page

// UNDONE: geolocation page

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
  Widget _mapThemeTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        -0.2126, -0.7152, -0.0722, 0, 255, // red channel
        -0.2126, -0.7152, -0.0722, 0, 255, // green channel
        -0.2126, -0.7152, -0.0722, 0, 255, // blue channel
        0, 0, 0, 1, 0, // alpha channel
      ]),
      child: tileWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);

    return Scaffold(
      body: StreamBuilder<List<Tower>>(
        stream: towersProvider.getTowersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No towers available.'));
          }

          final towers = snapshot.data!;

          // create tower markers
          final List<Marker> markers = towers.map((tower) {
            return Marker(
              point: LatLng(tower.position.latitude, tower.position.longitude),
              // width: 80,
              // height: 80,
              // TODO: add a gesture detector here for individual tower clicks
              child: Icon(
                Icons.location_on,
                color: AppColors.tertiary,
                size: 25,
              ),
            );
          }).toList();

          return FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _defaultPosition,
              initialZoom: 12,
              backgroundColor: Theme.of(context).colorScheme.surface,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: _tileLayerUrl,
                tileBuilder: _mapThemeTileBuilder,
              ),
              MarkerLayer(
                markers: markers,
              ),
            ],
          );
        },
      ),
    );
  }
}
