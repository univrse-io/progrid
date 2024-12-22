part of 'index.dart';

// TODO: Create a constructor for fluid text input.
class CarbonTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? helperText;
  final String? placeholderText;
  final int? maxLines;
  final bool autoFocus;
  final bool obscureText;
  final bool readOnly;
  final bool hideUnderline;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextDirection? textDirection;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? textInputFormatters;
  final Widget? Function(TextEditingController? controller)? counter;

  const CarbonTextInput(
      {super.key,
      this.controller,
      this.focusNode,
      this.labelText,
      this.helperText,
      this.placeholderText,
      this.maxLines = 1,
      this.autoFocus = false,
      this.obscureText = false,
      this.readOnly = false,
      this.hideUnderline = false,
      this.fillColor,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.textDirection,
      this.validator,
      this.onFieldSubmitted,
      this.textInputFormatters,
      this.counter});

  CarbonTextInput.search(
      {super.key,
      required this.controller,
      this.focusNode,
      this.helperText,
      this.placeholderText,
      this.autoFocus = false,
      this.hideUnderline = false,
      this.fillColor,
      this.keyboardType,
      this.textDirection,
      this.validator,
      this.onFieldSubmitted,
      this.textInputFormatters,
      this.counter})
      : labelText = null,
        maxLines = 1,
        obscureText = false,
        readOnly = false,
        prefixIcon = textDirection == TextDirection.rtl
            ? _clearButton(controller!)
            : _searchButton(),
        suffixIcon = textDirection == TextDirection.rtl
            ? _searchButton()
            : _clearButton(controller!);

  static Widget _searchButton() => const Icon(CarbonIcon.search, size: 20);

  static Widget _clearButton(TextEditingController controller) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, snapshot, child) =>
            Visibility(visible: snapshot.text.isNotEmpty, child: child!),
        child: GestureDetector(
            onTap: controller.clear,
            child: const Icon(CarbonIcon.close, size: 20)),
      );

  @override
  State<CarbonTextInput> createState() => _CarbonTextInputState();
}

class _CarbonTextInputState extends State<CarbonTextInput> {
  late final carbonToken = Theme.of(context).extension<CarbonToken>();
  late var isVisible = !widget.obscureText;
  String? errorText;

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        if (widget.labelText != null) ...[
          Row(children: [
            Text('${widget.labelText}', style: CarbonTextStyle.label01),
            const Spacer(),
            if (widget.counter != null &&
                widget.counter!(widget.controller) != null)
              widget.counter!(widget.controller)!,
          ]),
          const Spacing.$3(),
        ],
        TextFormField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            autofocus: widget.autoFocus,
            obscureText: !isVisible,
            readOnly: widget.readOnly,
            style: CarbonTextStyle.bodyCompact01,
            keyboardType: widget.keyboardType,
            textDirection: widget.textDirection,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            inputFormatters: widget.textInputFormatters,
            decoration: InputDecoration(
                fillColor:
                    widget.readOnly ? Colors.transparent : widget.fillColor,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon ??
                    (widget.obscureText
                        ? GestureDetector(
                            onTap: () => setState(() => isVisible = !isVisible),
                            child: Icon(isVisible
                                ? CarbonIcon.view_off
                                : CarbonIcon.view))
                        : errorText != null
                            ? Icon(CarbonIcon.warning_filled,
                                color: carbonToken?.supportError)
                            : null),
                suffixIconConstraints: const BoxConstraints(
                    maxHeight: kToolbarHeight,
                    minWidth: kMinInteractiveDimension),
                hintText: widget.placeholderText,
                enabledBorder: errorText != null
                    ? Theme.of(context).inputDecorationTheme.errorBorder
                    : widget.hideUnderline
                        ? const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.zero)
                        : null),
            onChanged: (input) =>
                setState(() => errorText = widget.validator?.call(input)),
            onTapOutside: (_) =>
                (widget.focusNode ?? FocusManager.instance.primaryFocus)
                    ?.unfocus(),
            onFieldSubmitted: widget.onFieldSubmitted),
        if (errorText != null || widget.helperText != null) ...[
          const Spacing.$2(),
          Text('${errorText ?? widget.helperText}',
              style: CarbonTextStyle.helperText01.copyWith(
                  color: errorText != null
                      ? carbonToken?.textError
                      : carbonToken?.textHelper)),
        ],
      ]);
}
