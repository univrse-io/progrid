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
  final TextDecoration? _decoration;

  const CarbonLink({
    required this.label,
    this.icon,
    this.onPressed,
    this.style,
    super.key,
  }) : _decoration = null;

  const CarbonLink.inline({
    required this.label,
    this.onPressed,
    this.style,
    super.key,
  }) : icon = null,
       _decoration = TextDecoration.underline;

  @override
  Widget build(BuildContext context) {
    final carbonToken = Theme.of(context).extension<CarbonToken>();

    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: (style ?? CarbonTextStyle.bodyCompact01).copyWith(
              color: carbonToken?.linkPrimary,
              decoration: _decoration,
              decorationColor: carbonToken?.linkPrimary,
            ),
          ),
          if (icon != null) const Spacing.$3(),
          Icon(icon, size: 16, color: carbonToken?.linkPrimary),
        ],
      ),
    );
  }
}
