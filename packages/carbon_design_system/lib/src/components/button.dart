part of 'index.dart';

enum ButtonVariant {
  primary,
  secondary,
  tertiary,
  ghost,
  primaryDanger,
  tertiaryDanger,
  ghostDanger,
}

enum ButtonSize {
  small(32),
  medium(40),
  large(48),
  extraLarge(64),
  extraExtraLarge(80);

  final double height;

  const ButtonSize(this.height);
}

class CarbonButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final EdgeInsetsGeometry? margin;
  final String? label;
  final IconData? icon;

  const CarbonButton.primary(
      {super.key,
      required this.onPressed,
      this.size = ButtonSize.large,
      this.margin,
      this.label,
      this.icon})
      : variant = ButtonVariant.primary,
        assert(label != null || icon != null);

  const CarbonButton.secondary(
      {super.key,
      required this.onPressed,
      this.size = ButtonSize.large,
      this.margin,
      this.label,
      this.icon})
      : variant = ButtonVariant.secondary,
        assert(label != null || icon != null);

  const CarbonButton.tertiary(
      {super.key,
      required this.onPressed,
      this.size = ButtonSize.large,
      this.margin,
      this.label,
      this.icon})
      : variant = ButtonVariant.tertiary,
        assert(label != null || icon != null);

  const CarbonButton.ghost(
      {super.key,
      required this.onPressed,
      this.size = ButtonSize.large,
      this.margin,
      this.label,
      this.icon})
      : variant = ButtonVariant.ghost,
        assert(label != null || icon != null);

  const CarbonButton.primaryDanger(
      {super.key,
      required this.onPressed,
      this.size = ButtonSize.large,
      this.margin,
      this.label,
      this.icon})
      : variant = ButtonVariant.primaryDanger,
        assert(label != null || icon != null);

  const CarbonButton.tertiaryDanger(
      {super.key,
      required this.onPressed,
      this.size = ButtonSize.large,
      this.margin,
      this.label,
      this.icon})
      : variant = ButtonVariant.tertiaryDanger,
        assert(label != null || icon != null);

  const CarbonButton.ghostDanger(
      {super.key,
      required this.onPressed,
      this.size = ButtonSize.large,
      this.margin,
      this.label,
      this.icon})
      : variant = ButtonVariant.ghostDanger,
        assert(label != null || icon != null);

  @override
  State<CarbonButton> createState() => _CarbonButtonState();
}

class _CarbonButtonState extends State<CarbonButton> {
  late final carbonToken = Theme.of(context).extension<CarbonToken>();

  AlignmentGeometry get alignment => switch (widget.size) {
        ButtonSize.extraExtraLarge => Alignment.topLeft,
        ButtonSize.extraLarge => Alignment.topLeft,
        _ => Alignment.centerLeft,
      };

  /// Label / text color
  Color? get foregroundColor => switch (widget.variant) {
        ButtonVariant.tertiary => carbonToken?.buttonTertiary,
        ButtonVariant.ghost => carbonToken?.linkPrimary,
        ButtonVariant.tertiaryDanger => carbonToken?.buttonDangerSecondary,
        ButtonVariant.ghostDanger => carbonToken?.buttonDangerSecondary,
        _ => carbonToken?.textOnColor,
      };

  /// Label:disabled / text color
  Color? get disabledForegroundColor => switch (widget.variant) {
        ButtonVariant.primary => carbonToken?.textOnColorDisabled,
        ButtonVariant.secondary => carbonToken?.textOnColorDisabled,
        ButtonVariant.primaryDanger => carbonToken?.textOnColorDisabled,
        _ => carbonToken?.textDisabled,
      };

  /// Container / background-color
  Color? get backgroundColor => switch (widget.variant) {
        ButtonVariant.primary => carbonToken?.buttonPrimary,
        ButtonVariant.secondary => carbonToken?.buttonSecondary,
        ButtonVariant.primaryDanger => carbonToken?.buttonDangerPrimary,
        _ => Colors.transparent,
      };

  /// Container:disabled / background-color
  Color? get disabledBackgroundColor => switch (widget.variant) {
        ButtonVariant.primary => carbonToken?.buttonDisabled,
        ButtonVariant.secondary => carbonToken?.buttonDisabled,
        ButtonVariant.primaryDanger => carbonToken?.buttonDisabled,
        _ => Colors.transparent,
      };

  /// Container / border
  Color? get borderColor => switch (widget.variant) {
        ButtonVariant.tertiary => carbonToken?.buttonTertiary,
        ButtonVariant.tertiaryDanger => carbonToken?.buttonDangerSecondary,
        _ => Colors.transparent,
      };

  /// Container:disabled / border
  Color? get disabledBorderColor => switch (widget.variant) {
        ButtonVariant.tertiary => carbonToken?.buttonDisabled,
        ButtonVariant.tertiaryDanger => carbonToken?.buttonDisabled,
        _ => Colors.transparent,
      };

  @override
  Widget build(BuildContext context) => Padding(
        padding: widget.margin ?? EdgeInsets.zero,
        child: OutlinedButton(
          onPressed: widget.onPressed,
          style: OutlinedButton.styleFrom(
            fixedSize: Size.fromHeight(widget.size.height),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            alignment: alignment,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
            side: BorderSide(
                color: widget.onPressed != null
                    ? borderColor!
                    : disabledBorderColor!),
            disabledForegroundColor: disabledForegroundColor,
            disabledBackgroundColor: disabledBackgroundColor,
            shape: const RoundedRectangleBorder(),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            if (widget.label != null)
              Text('${widget.label}', overflow: TextOverflow.ellipsis),
            if (widget.label != null && widget.icon != null) const Spacer(),
            Icon(widget.icon),
          ]),
        ),
      );
}
