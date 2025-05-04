part of '../index.dart';

/// For actions that could have destructive effects on the user’s data (for
/// example, delete or remove).
class CarbonDangerPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final double _height;

  const CarbonDangerPrimaryButton({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 48;

  const CarbonDangerPrimaryButton.small({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 32;

  const CarbonDangerPrimaryButton.medium({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 40;

  const CarbonDangerPrimaryButton.extraLarge({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 64;

  const CarbonDangerPrimaryButton.xxl({
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
        backgroundColor: carbonToken?.buttonDangerPrimary,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label != null)
            Expanded(child: Text(label!, overflow: TextOverflow.ellipsis)),
          Icon(icon),
        ],
      ),
    );
  }
}
