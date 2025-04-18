import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tower.dart';
import 'tower_page.dart';

class TowersListPage extends StatefulWidget {
  const TowersListPage({super.key});

  @override
  State<TowersListPage> createState() => _TowersListPageState();
}

class _TowersListPageState extends State<TowersListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  // on call search query
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final towers = Provider.of<List<Tower>>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text(
          'Search Database',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Hero(
              tag: 'searchbar',
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    hintText: 'Enter ID, name, address, region, etc...',
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: towers.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: towers.length,
                      itemBuilder: (context, index) {
                        final tower = towers[index];

                        // filter towers based on search query
                        if (_searchQuery.isNotEmpty &&
                            !(tower.name.toLowerCase().contains(_searchQuery) ||
                                tower.address
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                tower.region.name.contains(_searchQuery) ||
                                tower.owner
                                    .toLowerCase()
                                    .contains(_searchQuery) ||
                                tower.id
                                    .toLowerCase()
                                    .contains(_searchQuery))) {
                          return const SizedBox.shrink();
                        }

                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  TowerPage(towerId: tower.id),
                              transitionsBuilder: (_, animation, __, child) =>
                                  FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            ),
                          ),
                          child: Card(
                            margin: const EdgeInsets.symmetric(vertical: 3),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SafeArea(
                              minimum: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 9,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 70,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // completion status
                                            Container(
                                              width: 12,
                                              height: 12,
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
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // tower name
                                        Text(
                                          tower.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            // // owner
                                            // Text(
                                            //   tower.owner,
                                            //   style: const TextStyle(
                                            //       fontSize: 14,
                                            //       fontWeight: FontWeight.bold),
                                            // ),

                                            // type
                                            Text(
                                              tower.type,
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),

                                            const Text(
                                              ',',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            // region
                                            Text(
                                              tower.region.toString(),
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(
                                    flex: 10,
                                    child: Icon(
                                      Icons.arrow_right,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
