part of 'index.dart';

class CarbonDropdown<T> extends DropdownMenu<T> {
  const CarbonDropdown({
    required super.dropdownMenuEntries,
    super.key,
    super.enabled = true,
    super.width,
    super.menuHeight,
    super.leadingIcon,
    super.trailingIcon = const Icon(CarbonIcon.chevron_down, size: kIconSize),
    super.label,
    super.hintText,
    super.helperText,
    super.errorText,
    super.selectedTrailingIcon =
        const Icon(CarbonIcon.chevron_up, size: kIconSize),
    super.enableFilter = false,
    super.enableSearch = true,
    super.keyboardType,
    super.textStyle,
    super.textAlign = TextAlign.start,
    super.inputDecorationTheme,
    super.menuStyle,
    super.controller,
    super.initialSelection,
    super.onSelected,
    super.focusNode,
    super.requestFocusOnTap,
    super.expandedInsets,
    super.filterCallback,
    super.searchCallback,
    super.alignmentOffset,
    super.inputFormatters,
    super.closeBehavior = DropdownMenuCloseBehavior.all,
  }) : assert(filterCallback == null || enableFilter);
}
