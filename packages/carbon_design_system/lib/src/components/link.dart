part of 'index.dart';

/// <a href="https://carbondesignsystem.com/components/link" target="_blank">
/// Links</a> are used as navigational elements. They navigate users to another
/// location, such as a different site, resource, or section within the same
/// page.
class CarbonLink extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final bool isInline;

  const CarbonLink(
      {super.key,
      required this.label,
      this.onPressed,
      this.icon,
      this.style,
      this.isInline = false});

  @override
  Widget build(BuildContext context) {
    final carbonToken = Theme.of(context).extension<CarbonToken>();

    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: (style ?? CarbonTextStyle.bodyCompact01).copyWith(
                  color: carbonToken?.linkPrimary,
                  decoration: isInline ? TextDecoration.underline : null,
                  decorationColor: carbonToken?.linkPrimary)),
          if (icon != null) const Spacing.$3(),
          Icon(
            icon,
            size: 16,
            color: carbonToken?.linkPrimary,
          ),
        ],
      ),
    );
  }
}
