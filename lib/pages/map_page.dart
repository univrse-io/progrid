import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../models/region.dart';
import '../widgets/open_street_map.dart';
import 'profile_page.dart';
import 'towers_page.dart';

// TODO: Implement map marker filter.
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final mapController = MapController();

  @override
  Widget build(BuildContext context) => Scaffold(
    resizeToAvoidBottomInset: false,
    body: Stack(
      children: [
        OpenStreetMap(controller: mapController),
        Positioned(
          top: 25,
          left: 14,
          child: FloatingActionButton(
            tooltip: 'View Regions',
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
                tooltip: 'Search Towers',
                heroTag: 'searchbar',
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (_, _, __) => const TowersPage(),
                      transitionsBuilder:
                          (_, animation, __, child) =>
                              FadeTransition(opacity: animation, child: child),
                    ),
                  );
                },
                mini: true,
                child: const Icon(CarbonIcon.search),
              ),
              FloatingActionButton(
                tooltip: 'User Profile',
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
