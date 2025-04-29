import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/tower.dart';
import 'tower_details_page.dart';

class TowersPage extends StatefulWidget {
  const TowersPage({super.key});

  @override
  State<TowersPage> createState() => _TowersPageState();
}

class _TowersPageState extends State<TowersPage> {
  late final towers = Provider.of<List<Tower>>(context);
  late final searchController =
      TextEditingController()..addListener(() => setState(() {}));

  List<Tower> get result {
    final keyword = searchController.text.trim().toLowerCase();

    return keyword.isEmpty
        ? towers
        : towers
            .where((tower) => tower.toString().toLowerCase().contains(keyword))
            .toList();
  }

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
          child:
              result.isEmpty
                  ? const Center(child: Text('No Towers Found'))
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: result.length,
                    itemBuilder: (context, index) {
                      final tower = result[index];

                      return ListTile(
                        dense: true,
                        isThreeLine: true,
                        onTap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => TowerDetailsPage(tower),
                              ),
                            ),
                        title: Row(
                          children: [
                            Spacing.$4(color: tower.surveyStatus.color),
                            const Spacing.$3(),
                            Text(tower.id),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tower.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CarbonTextStyle.heading02,
                            ),
                            Text(
                              tower.context,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
        ),
      ],
    ),
  );
}
