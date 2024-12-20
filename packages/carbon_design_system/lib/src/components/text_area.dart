part of 'index.dart';

class CarbonTextArea extends CarbonTextInput {
  final int? maxCharacters;
  final int? maxWords;
  final List<FilteringTextInputFormatter>? filteringTextInputFormatters;

  CarbonTextArea(
      {super.key,
      super.controller,
      this.maxCharacters,
      this.maxWords,
      super.labelText,
      super.helperText,
      super.placeholderText,
      super.autoFocus,
      super.readOnly,
      super.validator,
      super.onFieldSubmitted,
      this.filteringTextInputFormatters})
      : assert(maxCharacters == null || maxWords == null),
        super(
            counter: (controller) {
              if (maxCharacters != null) {
                return Text('${controller?.text.length}/$maxCharacters',
                    style: CarbonTextStyle.label01);
              } else if (maxWords != null) {
                return Text(
                    '${RegExp(r'\b\w+\b').allMatches(controller!.text).length}/$maxWords',
                    style: CarbonTextStyle.label01);
              } else {
                return null;
              }
            },
            textInputFormatters: [
              ...?filteringTextInputFormatters,
              LengthLimitingTextInputFormatter(maxCharacters),
              WordLimitingTextInputFormatter(maxWords),
            ],
            keyboardType: TextInputType.multiline,
            maxLines: null,
            obscureText: false);
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
