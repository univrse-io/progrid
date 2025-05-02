part of 'index.dart';

class CarbonCheckbox extends StatelessWidget {
  final bool? value;
  final ValueChanged<bool?> onChanged;
  final String? label;
  final bool tristate;

  const CarbonCheckbox({
    required this.value,
    required this.onChanged,
    this.label,
    this.tristate = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          switch (value) {
            case false:
              onChanged(true);
            case true:
              onChanged(tristate ? null : false);
            case null:
              onChanged(false);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: 0.85,
                child: Checkbox(
                  value: value,
                  onChanged: onChanged,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              if (label != null)
                Text('$label', style: CarbonTextStyle.bodyCompact01),
            ],
          ),
        ),
      );
}
