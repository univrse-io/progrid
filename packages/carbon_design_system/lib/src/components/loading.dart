part of 'index.dart';

class CarbonLoading extends StatefulWidget {
  final double? value;
  final Color? color;
  final Color? backgroundColor;
  final Color? overlayColor;
  final Animation<Color?>? valueColor;
  final double radius;
  final AlignmentGeometry alignment;
  final String? label;
  final Widget? child;

  const CarbonLoading(
      {super.key,
      this.value,
      this.color,
      this.overlayColor,
      this.valueColor,
      this.radius = 44,
      this.alignment = Alignment.center})
      : backgroundColor = Colors.transparent,
        label = null,
        child = null;

  const CarbonLoading.inline(
      {super.key,
      this.value,
      this.color,
      this.backgroundColor,
      this.valueColor,
      this.radius = 8,
      this.alignment = Alignment.center,
      this.label,
      this.child})
      : overlayColor = Colors.transparent;

  @override
  State<CarbonLoading> createState() => _CarbonLoadingState();
}

class _CarbonLoadingState extends State<CarbonLoading> {
  late final carbonToken = Theme.of(context).extension<CarbonToken>();

  @override
  Widget build(BuildContext context) => Container(
        color: widget.overlayColor ?? carbonToken?.overlay,
        alignment: widget.alignment,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          SizedBox.fromSize(
            size: Size.fromRadius(widget.radius),
            child: CircularProgressIndicator(
                value: widget.value,
                color: widget.color,
                backgroundColor: widget.backgroundColor,
                valueColor: widget.valueColor),
          ),
          if (widget.child != null || widget.label != null)
            Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: widget.child ??
                    Text(widget.label!, style: CarbonTextStyle.label01))
        ]),
      );
}
