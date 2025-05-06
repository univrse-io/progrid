import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/issue.dart';
import '../models/survey_status.dart';
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

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Issues')),
    body: Consumer<List<Issue>>(
      child: Visibility(
        visible: widget.tower.surveyStatus != SurveyStatus.surveyed,
        child: Container(
          padding: const EdgeInsets.all(24),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: CarbonPrimaryButton(
            onPressed:
                () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditIssuePage.create(tower: widget.tower),
                  ),
                ),
            label: 'Create Issue',
            icon: CarbonIcon.document_add,
          ),
        ),
      ),
      builder: (context, issues, child) {
        final relatedIssue =
            issues
                .where((issue) => issue.id.startsWith(widget.tower.id))
                .toList();
        final keyword = searchController.text.trim().toLowerCase();
        final result =
            keyword.isEmpty
                  ? relatedIssue
                  : relatedIssue
                      .where(
                        (tower) =>
                            tower.toString().toLowerCase().contains(keyword),
                      )
                      .toList()
              ..sort(
                (a, b) => (b.updatedAt ?? b.createdAt).compareTo(
                  a.updatedAt ?? a.createdAt,
                ),
              );

        return Column(
          children: [
            if (relatedIssue.length > 1)
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

                          return CustomListTile(
                            onPressed:
                                () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => IssueDetailsPage(issue),
                                  ),
                                ),
                            indicatorColor: issue.status.color,
                            title: issue.id,
                            subtitle: issue.tags.join(', '),
                            body: issue.description,
                          );
                        },
                      ),
            ),
            child!,
          ],
        );
      },
    ),
  );
}
