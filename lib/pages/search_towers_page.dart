import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tower.dart';
import 'tower_page.dart';

class SearchTowersPage extends StatefulWidget {
  const SearchTowersPage({super.key});

  @override
  State<SearchTowersPage> createState() => _SearchTowersPageState();
}

class _SearchTowersPageState extends State<SearchTowersPage> {
  late final towers = Provider.of<List<Tower>>(context);
  late final searchController = TextEditingController();
  late List<Tower> queriedTowers = towers;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Search Towers')),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Hero(
            tag: 'searchbar',
            child: Material(
              color: Colors.transparent,
              child: CarbonTextInput.search(
                controller: searchController,
                placeholderText: 'Enter ID, name, address, region, etc...',
                onChanged: (value) {
                  final query = searchController.text.trim().toLowerCase();

                  setState(() {
                    queriedTowers =
                        towers
                            .where(
                              (tower) =>
                                  tower.name.toLowerCase().contains(query) ||
                                  tower.address.toLowerCase().contains(query) ||
                                  tower.region.name.contains(query) ||
                                  tower.owner.toLowerCase().contains(query) ||
                                  tower.id.toLowerCase().contains(query),
                            )
                            .toList();
                  });
                },
              ),
            ),
          ),
        ),
        Expanded(
          child:
              towers.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    separatorBuilder: (_, __) => const Spacing.$3(),
                    itemCount: queriedTowers.length,
                    itemBuilder: (context, index) {
                      final tower = queriedTowers[index];

                      return InkWell(
                        onTap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TowerPage(tower),
                              ),
                            ),
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Spacing.$4(color: tower.surveyStatus.color),
                                    const Spacing.$3(),
                                    Text(tower.id),
                                  ],
                                ),
                                Text(
                                  tower.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CarbonTextStyle.heading03,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      '${tower.type},',
                                      style: CarbonTextStyle.headingCompact01,
                                    ),
                                    const Spacing.$2(),
                                    Text(
                                      tower.region.toString(),
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    ),
  );
}
