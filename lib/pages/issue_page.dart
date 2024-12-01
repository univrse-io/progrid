import 'package:flutter/material.dart';
import 'package:progrid/models/tower_provider.dart';
import 'package:progrid/models/user_provider.dart';
import 'package:progrid/utils/themes.dart';
import 'package:provider/provider.dart';

class IssuePage extends StatefulWidget {
  final String towerId;
  final String issueId;

  const IssuePage({super.key, required this.issueId, required this.towerId});

  @override
  State<IssuePage> createState() => _IssuePageState();
}

class _IssuePageState extends State<IssuePage> {
  late Issue selectedIssue;

  @override
  Widget build(BuildContext context) {
    final towersProvider = Provider.of<TowersProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    // fetch issue from provider
    selectedIssue = towersProvider.towers
        .firstWhere(
          (tower) => tower.id == widget.towerId,
          orElse: () => throw Exception('Tower not found'),
        )
        .issues
        .firstWhere(
          (issue) => issue.id == widget.issueId,
          orElse: () => throw Exception("Issue not found"),
        );

    // status dropdown will only show when issue authorid matches current login
    final bool showDropdown = selectedIssue.authorId == userProvider.userId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.issueId,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 5),

            // display tags
            const Text(
              'Tags',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            if (selectedIssue.tags.isNotEmpty)
              Wrap(
                spacing: 5,
                runSpacing: 5,
                children: selectedIssue.tags.map((tag) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 10),

            // display description
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              selectedIssue.description,
              style: TextStyle(
                  fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 10),

            // display status
            const Text(
              'Status',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            if (showDropdown)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: selectedIssue.status == 'resolved'
                      ? AppColors.green
                      : AppColors.red,
                ),
                child: DropdownButton(
                  isDense: true,
                  value: selectedIssue.status,
                  onChanged: (newStatus) async {
                    if (newStatus != null && newStatus != selectedIssue.status) {
                      try {
                        towersProvider.updateIssueStatus(widget.towerId, widget.issueId, newStatus);
                        setState(() {
                          selectedIssue.status = newStatus; // Reflect the change locally
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error updating status: $e')),
                        );
                      }
                    }

                    // setState(() {
                    //   if (newStatus != null) {
                    //     // TODO: implement proper status database update here
                    //     // update provider as well
                    //     selectedIssue.status = newStatus;
                    //   }
                    // });
                  },
                  // UNDONE: Still unable to change the text color.
                  items: [
                    DropdownMenuItem(
                        value: 'unresolved', child: Text('Unresolved', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                    DropdownMenuItem(
                        value: 'resolved', child: Text('Resolved', style: TextStyle(color: Theme.of(context).colorScheme.onSurface),)),
                  ],
                  iconEnabledColor: Theme.of(context).colorScheme.surface,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold),
                ),
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  color: selectedIssue.status == 'resolved'
                      ? AppColors.green
                      : AppColors.red,
                ),
                child: Text(
                  '${selectedIssue.status[0].toUpperCase()}${selectedIssue.status.substring(1)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // const Text(
            //   'Status',
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 7),
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(24),
            //     color: selectedIssue.status == 'resolved' ? AppColors.green : AppColors.red,
            //   ),
            //   child: Text(
            //     '${selectedIssue.status[0].toUpperCase()}${selectedIssue.status.substring(1)}',
            //     style: TextStyle(
            //       color: Theme.of(context).colorScheme.surface,
            //       fontSize: 15,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
