import 'package:flutter/material.dart';
import 'package:progrid/components/my_button.dart';
import 'package:progrid/components/my_loader.dart';
import 'package:progrid/components/my_textfield.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:progrid/services/themes.dart';
import 'package:provider/provider.dart';

class TowersPage extends StatefulWidget {
  const TowersPage({super.key});

  @override
  State<TowersPage> createState() => _TowersPageState();
}

class _TowersPageState extends State<TowersPage> {
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
    final List<Tower> towers = towersProvider.towers
        .where((tower) => tower.name.toLowerCase().contains(_searchQuery) || 
            tower.address.toLowerCase().contains(_searchQuery) ||
            tower.region.toLowerCase().contains(_searchQuery) ||
            tower.owner.toLowerCase().contains(_searchQuery) ||
            tower.id.toLowerCase().contains(_searchQuery))
        .toList();

    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 30),
        child: RefreshIndicator(
          // refresh towers list on pull-down
          onRefresh: () => towersProvider.fetchTowers(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Query Towers",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 20),

              // TODO: implement search bar
              MyTextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                hintText: 'enter id, name, address, region, etc...',
              ),
              const SizedBox(height: 10),

              const Text(
                "  we found...",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 6),

              // towers list (important)
              Expanded(
                child: towers.isEmpty
                    ? const Center(child: MyLoadingIndicator())
                    : ListView.builder(
                        itemCount: towers.length,
                        itemBuilder: (context, index) {
                          final tower = towers[index];
                          return GestureDetector(
                            onTap: () {
                              // TODO: navigate to dedicated tower page
                              print("Tapped on tower: ${tower.id}");
                            },
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
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
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              // completion status indicator
                                              Container(
                                                width: 14,
                                                height: 14,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: tower.status == 'active' 
                                                    ? AppColors.green 
                                                    : AppColors.red,
                                                ),
                                              ),
                                              const SizedBox(width: 7),
                                              // tower id
                                              Text(
                                                tower.id,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 0),

                                          // tower name
                                          Text(
                                            tower.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 0),
                                          Row(
                                            children: [
                                              // tower owner
                                              Text(
                                                tower.owner,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              Text(
                                                ",",
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              // tower region
                                              Text(
                                                tower.region,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.normal
                                                ),
                                              )
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
                          );
                        },
                      ),
              ),
              const SizedBox(height: 10),
              Center(child: const Text("or...", style: TextStyle(fontWeight: FontWeight.bold, ),)),
              const SizedBox(height: 10),
              MyButton(
                text: "Use My Location",
                onTap: () {}, // TODO: implement geolocation in new page
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
