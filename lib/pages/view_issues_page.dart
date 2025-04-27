import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/issue.dart';
import '../models/tower.dart';
import 'create_issue_page.dart';
import 'issue_details.dart';

class ViewIssuesPage extends StatelessWidget {
  final Tower tower;

  const ViewIssuesPage({required this.tower, super.key});

  @override
  Widget build(BuildContext context) {
    final issues =
        context
            .watch<List<Issue>>()
            .where((issue) => issue.id.startsWith(tower.id))
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('View Issues')),
      body: Column(
        children: [
          Expanded(
            child:
                issues.isEmpty
                    ? const Center(child: Text('No Issues Found'))
                    : ListView.separated(
                      padding: const EdgeInsets.all(24),
                      separatorBuilder: (_, __) => const Divider(),
                      itemCount: issues.length,
                      itemBuilder: (context, index) {
                        final issue = issues[index];
                        // FIXME: Save author name inside database.
                        const authorName = 'Unknown Author';

                        return ListTile(
                          isThreeLine: true,
                          onTap:
                              () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          IssueDetailsPage(issue: issue),
                                ),
                              ),
                          title: Row(
                            children: [
                              Spacing.$4(color: issue.status.color),
                              const Spacing.$3(),
                              Text(issue.id),
                              const Spacer(),
                              Text(
                                DateFormat(
                                  'MMM d, y',
                                ).format(issue.dateTime.toDate()),
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                issue.tags.join(', '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CarbonTextStyle.heading03,
                              ),
                              Row(
                                children: [
                                  Text(
                                    '$authorName,',
                                    style: CarbonTextStyle.headingCompact01,
                                  ),
                                  const Spacing.$2(),
                                  Text(
                                    issue.status.toString(),
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: FilledButton(
              onPressed:
                  () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CreateIssuePage(tower: tower),
                    ),
                  ),
              child: const Text('Create Issue'),
            ),
          ),
        ],
      ),
    );
  }
}
