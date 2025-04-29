import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/issue.dart';
import '../models/tower.dart';
import 'create_issue_page.dart';
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

    return keyword.isEmpty
        ? issues.where((issue) => issue.id.startsWith(widget.tower.id)).toList()
        : issues
            .where(
              (issue) =>
                  issue.id.startsWith(widget.tower.id) &&
                  issue.id.toLowerCase().contains(keyword),
              // tower.name.toLowerCase().contains(query) ||
              // tower.id.toLowerCase().contains(query) ||
              // tower.address.toLowerCase().contains(query) ||
              // tower.region.name.contains(query) ||
              // tower.type.contains(query),
            )
            .toList();
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
                    itemBuilder: (context, index) {
                      final issue = result[index];

                      return ListTile(
                        dense: true,
                        isThreeLine: true,
                        onTap:
                            () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => IssueDetailsPage(issue: issue),
                              ),
                            ),
                        title: Row(
                          children: [
                            Spacing.$4(color: issue.status.color),
                            const Spacing.$3(),
                            Text(issue.id),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              issue.tags.join(', '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CarbonTextStyle.heading02,
                            ),
                            Text(
                              issue.context,
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
        Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: FilledButton(
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => CreateIssuePage(tower: widget.tower),
                  ),
                ),
            child: const Text('Create Issue'),
          ),
        ),
      ],
    ),
  );
}
