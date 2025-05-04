part of '../index.dart';

/// For secondary actions on each page. Secondary buttons can only be used in
/// conjunction with a primary button. As part of a pair, the secondary button’s
/// function is to perform the negative action of the set, such as “Cancel” or
/// “Back”. Do not use a secondary button in isolation and do not use a
/// secondary button for a positive action.
class CarbonSecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final double _height;

  const CarbonSecondaryButton({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 48;

  const CarbonSecondaryButton.small({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 32;

  const CarbonSecondaryButton.medium({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 40;

  const CarbonSecondaryButton.extraLarge({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 64;

  const CarbonSecondaryButton.xxl({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 80;

  @override
  Widget build(BuildContext context) {
    final carbonToken = Theme.of(context).extension<CarbonToken>();

    return FilledButton(
      onPressed: onPressed,
      style: FilledButton.styleFrom(
        maximumSize: Size.fromHeight(_height),
        backgroundColor: carbonToken?.buttonSecondary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null) Text(label!, overflow: TextOverflow.ellipsis),
          const Spacer(),
          Icon(icon),
        ],
      ),
    );
  }
}
