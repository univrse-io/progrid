import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/issue.dart';
import '../models/tower.dart';
import '../widgets/custom_list_tile.dart';
import 'edit_issue_page.dart';
import 'issue_details_page.dart';

class IssuesPage extends StatefulWidget {
  final Tower tower;

  const IssuesPage({required this.tower, super.key});

  @override
  State<IssuesPage> createState() => _IssuesPageState();
}

class _IssuesPageState extends State<IssuesPage> {
  late final searchController =
      TextEditingController()..addListener(() => setState(() {}));

  List<Issue> get result {
    final issues = Provider.of<List<Issue>>(context, listen: false);
    final keyword = searchController.text.trim().toLowerCase();

    return issues
        .where(
          (issue) =>
              issue.id.startsWith(widget.tower.id) &&
              (keyword.isEmpty ||
                  issue.toString().toLowerCase().contains(keyword)),
        )
        .toList()
      ..sort(
        (a, b) =>
            (b.updatedAt ?? b.createdAt).compareTo(a.updatedAt ?? a.createdAt),
      );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Issues')),
    body: Column(
      children: [
        if (context
                .watch<List<Issue>>()
                .where((issue) => issue.id.startsWith(widget.tower.id))
                .length >
            1)
          Container(
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).scaffoldBackgroundColor,
            child: CarbonTextInput.search(
              controller: searchController,
              placeholderText: 'Search',
            ),
          )
        else
          const Spacing.$6(),
        Expanded(
          child:
              result.isEmpty
                  ? const Center(child: Text('No Issues Found'))
                  : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    separatorBuilder: (_, __) => const Divider(),
                    itemCount: result.length,
                    itemBuilder:
                        (context, index) => CustomListTile(
                          onPressed:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          IssueDetailsPage(result[index]),
                                ),
                              ),
                          indicatorColor: result[index].status.color,
                          title: result[index].id,
                          subtitle: result[index].tags.join(', '),
                          body: result[index].description,
                        ),
                  ),
        ),
        Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CarbonPrimaryButton(
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => EditIssuePage.create(tower: widget.tower),
                  ),
                ),
            label: 'Create Issue',
            icon: CarbonIcon.document_add,
          ),
        ),
      ],
    ),
  );
}
