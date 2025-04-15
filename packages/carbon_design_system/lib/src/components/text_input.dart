part of 'index.dart';

// TODO: Create a constructor for fluid text input.
class CarbonTextInput extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? helperText;
  final String? placeholderText;
  final int? maxCharacters;
  final int? maxWords;
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

  const CarbonTextInput({
    super.key,
    this.controller,
    this.focusNode,
    this.labelText,
    this.helperText,
    this.placeholderText,
    this.maxCharacters,
    this.maxWords,
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
  }) : assert(maxCharacters == null || maxWords == null,
            'Cannot limit the number of characters and words simultaneously.');

  CarbonTextInput.search(
      {super.key,
      required this.controller,
      this.focusNode,
      this.helperText,
      this.placeholderText,
      this.maxCharacters,
      this.maxWords,
      this.autoFocus = false,
      this.hideUnderline = false,
      this.fillColor,
      this.keyboardType,
      this.textDirection,
      this.validator,
      this.onFieldSubmitted,
      this.textInputFormatters})
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

  static Widget _clearButton(TextEditingController controller) =>
      ValueListenableBuilder<TextEditingValue>(
        valueListenable: controller,
        builder: (context, snapshot, child) =>
            Visibility(visible: snapshot.text.isNotEmpty, child: child!),
        child: GestureDetector(
            onTap: controller.clear,
            child: const Icon(CarbonIcon.close, size: 20)),
      );

  static Widget _searchButton() => const Icon(CarbonIcon.search, size: 20);

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
            if (widget.maxCharacters != null)
              Text('${widget.controller?.text.length}/${widget.maxCharacters}',
                  style: CarbonTextStyle.label01),
            if (widget.maxWords != null)
              Text(
                  '${RegExp(r'\b\w+\b').allMatches(widget.controller!.text).length}/${widget.maxWords}',
                  style: CarbonTextStyle.label01),
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
            maxLines: widget.keyboardType == TextInputType.multiline
                ? null
                : widget.obscureText
                    ? 1
                    : widget.maxLines,
            inputFormatters: [
              ...?widget.textInputFormatters,
              LengthLimitingTextInputFormatter(widget.maxCharacters),
              WordLimitingTextInputFormatter(widget.maxWords),
            ],
            textAlignVertical:
                widget.obscureText ? TextAlignVertical.center : null,
            decoration: InputDecoration(
                fillColor:
                    widget.readOnly ? Colors.transparent : widget.fillColor,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.suffixIcon ??
                    (widget.obscureText
                        ? IconButton(
                            tooltip:
                                isVisible ? 'Hide Password' : 'Show Password',
                            onPressed: () =>
                                setState(() => isVisible = !isVisible),
                            icon: Icon(isVisible
                                ? CarbonIcon.view_off
                                : CarbonIcon.view))
                        : errorText != null
                            ? Icon(CarbonIcon.warning_filled,
                                color: carbonToken?.supportError)
                            : null),
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

class WordLimitingTextInputFormatter extends TextInputFormatter {
  final int? maxWord;

  const WordLimitingTextInputFormatter(this.maxWord)
      : assert(maxWord == null || maxWord > 0);

  @override
  TextEditingValue formatEditUpdate(
          TextEditingValue oldValue, TextEditingValue newValue) =>
      maxWord == null
          ? newValue
          : RegExp(r'\b\w+\b').allMatches(newValue.text).length > maxWord!
              ? oldValue
              : newValue;
}
