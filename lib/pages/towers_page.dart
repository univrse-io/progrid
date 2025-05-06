import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tower.dart';
import '../widgets/custom_list_tile.dart';
import 'tower_details_page.dart';

class TowersPage extends StatefulWidget {
  const TowersPage({super.key});

  @override
  State<TowersPage> createState() => _TowersPageState();
}

class _TowersPageState extends State<TowersPage> {
  late final searchController =
      TextEditingController()..addListener(() => setState(() {}));

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Towers')),
    body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Hero(
            tag: 'searchbar',
            child: Material(
              color: Colors.transparent,
              child: CarbonTextInput.search(
                controller: searchController,
                placeholderText: 'Search',
              ),
            ),
          ),
        ),
        Expanded(
          child: Consumer<List<Tower>>(
            builder: (context, towers, _) {
              final keyword = searchController.text.trim().toLowerCase();
              final result =
                  keyword.isEmpty
                      ? towers
                      : towers
                          .where(
                            (tower) => tower.toString().toLowerCase().contains(
                              keyword,
                            ),
                          )
                          .toList();

              return result.isEmpty
                  ? const Center(child: Text('No Towers Found'))
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      final tower = result[index];

                      return CustomListTile(
                        onPressed:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TowerDetailsPage(tower),
                              ),
                            ),
                        indicatorColor: tower.surveyStatus.color,
                        title: tower.id,
                        subtitle: tower.name,
                        body: tower.description,
                      );
                    },
                  );
            },
          ),
        ),
      ],
    ),
  );
}
