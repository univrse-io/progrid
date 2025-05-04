import 'package:carbon_design_system/carbon_design_system.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String body;
  final Color indicatorColor;
  final VoidCallback onPressed;
  final Widget? trailing;

  const CustomListTile({
    required this.title,
    required this.subtitle,
    required this.body,
    required this.indicatorColor,
    required this.onPressed,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    isThreeLine: true,
    onTap: onPressed,
    title: Row(
      children: [
        Spacing.$4(color: indicatorColor),
        const Spacing.$3(),
        Text(title),
      ],
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: CarbonTextStyle.heading02,
        ),
        Text(
          body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    ),
    trailing: trailing,
  );
}
