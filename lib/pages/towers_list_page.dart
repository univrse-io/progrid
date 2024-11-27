import 'package:flutter/material.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:progrid/pages/tower_page.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

class TowersListPage extends StatefulWidget {
  const TowersListPage({super.key});

  @override
  State<TowersListPage> createState() => _TowersListPageState();
}

class _TowersListPageState extends State<TowersListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // filter towers list
  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);

    // filter towers based on search query (name, address, region, or id)
    final List<Tower> filteredTowers = towersProvider.towers
        .where((tower) =>
            tower.name.toLowerCase().contains(_searchQuery) ||
            tower.address.toLowerCase().contains(_searchQuery) ||
            tower.region.toLowerCase().contains(_searchQuery) ||
            tower.owner.toLowerCase().contains(_searchQuery) ||
            tower.id.toLowerCase().contains(_searchQuery))
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          icon: Icon(Icons.arrow_back, size: 34),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Query Towers',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 25),
        child: RefreshIndicator(
          // refresh towers list on pull-down
          onRefresh: () => towersProvider.fetchTowers(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              // search bar
              Hero(
                tag: 'openList',
                child: Material(
                  color: Colors.transparent,
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'enter id, name, address, region, etc...',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // towers list (important)
              Expanded(
                child: filteredTowers.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : Scrollbar(
                        child: ListView.builder(
                          itemCount: filteredTowers.length,
                          itemBuilder: (context, index) {
                            final tower = filteredTowers[index];
                            return GestureDetector(
                              onTap: () async {
                                print("Tapped on tower: ${tower.id}");
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      pageBuilder: (_, __, ___) =>
                                          TowerPage(tower: tower),
                                      transitionsBuilder:
                                          (_, animation, __, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      }),
                                );
                              },
                              child: Hero(
                                tag: 'item ${tower.id}',
                                child: Material(
                                  color: Colors.transparent,
                                  child: Card(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: SafeArea(
                                      minimum: EdgeInsets.all(12),
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
                                                    // completion status indicator
                                                    Container(
                                                      width: 14,
                                                      height: 14,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: tower.status ==
                                                                'active'
                                                            ? AppColors.green
                                                            : AppColors.red,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 7),
                                                    // tower id
                                                    Text(
                                                      tower.id,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                // tower name
                                                Text(
                                                  tower.name,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 0),
                                                Row(
                                                  children: [
                                                    // tower owner
                                                    Text(
                                                      tower.owner,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Text(
                                                      ",",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(width: 4),
                                                    // tower region
                                                    Text(
                                                      tower.region,
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 10,
                                            child: Icon(
                                              Icons.arrow_right,
                                              size: 38,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
              const SizedBox(height: 10),
              Center(
                  child: const Text(
                "or...",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )),
              const SizedBox(height: 10),
              // TODO: implement geolocation search in new page
              FilledButton(onPressed: () {}, child: Text("Use My Location")),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
