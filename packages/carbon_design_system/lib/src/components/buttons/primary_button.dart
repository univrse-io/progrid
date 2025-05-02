part of '../index.dart';

/// For the principal call to action on the page. Primary buttons should only
/// appear once per screen (not including the application header, modal dialog,
/// or side panel).
class CarbonPrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final IconData? icon;
  final double _height;

  const CarbonPrimaryButton({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 48;

  const CarbonPrimaryButton.small({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 32;

  const CarbonPrimaryButton.medium({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 40;

  const CarbonPrimaryButton.extraLarge({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 64;

  const CarbonPrimaryButton.xxl({
    this.onPressed,
    this.label,
    this.icon,
    super.key,
  }) : _height = 80;

  @override
  Widget build(BuildContext context) => FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(fixedSize: Size.fromHeight(_height)),
        child: Row(
          children: [
            if (label != null) Text(label!, overflow: TextOverflow.ellipsis),
            if (label != null && icon != null) const Spacer(),
            Icon(icon),
          ],
        ),
      );
}
