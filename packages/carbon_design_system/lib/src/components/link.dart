part of 'index.dart';

/// <a href="https://carbondesignsystem.com/components/link" target="_blank">
/// Links</a> are used as navigational elements. They navigate users to another
/// location, such as a different site, resource, or section within the same
/// page.
class CarbonLink extends StatelessWidget {
  final String label;
  final Widget? icon;
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
    final textStyle = style ?? TextStyle(color: carbonToken?.linkPrimary);

    return GestureDetector(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: textStyle.copyWith(
                  decoration: isInline ? TextDecoration.underline : null,
                  decorationColor: textStyle.color)),
          if (icon != null) icon!,
        ],
      ),
    );
  }
}
