part of '../index.dart';

sealed class CarbonTheme {
  static ThemeData get white =>
      _configuration(brightness: Brightness.light, token: _white);

  static ThemeData get gray10 =>
      _configuration(brightness: Brightness.light, token: _gray10);

  static ThemeData get gray90 =>
      _configuration(brightness: Brightness.dark, token: _gray90);

  static ThemeData get gray100 =>
      _configuration(brightness: Brightness.dark, token: _gray100);

  static ThemeData _configuration(
          {required Brightness brightness, required CarbonToken token}) =>
      ThemeData(
        useMaterial3: true,
        extensions: [token],
        fontFamily: IBMPlex.sans.fontFamily,
        package: 'carbon_design_system',
        colorScheme: ColorScheme.fromSeed(
            brightness: brightness,
            seedColor: CarbonColor.blue60,
            onSurface: token.textPrimary,
            onPrimaryContainer: token.iconOnColor,
            primaryContainer: token.backgroundHover,
            error: token.textError),
        scaffoldBackgroundColor: token.background,
        actionIconTheme: ActionIconThemeData(
            backButtonIconBuilder: (context) =>
                const Icon(CarbonIcon.arrow_left)),
        appBarTheme: AppBarTheme(
            centerTitle: false,
            backgroundColor: token.background,
            shape: Border(bottom: BorderSide(color: token.borderSubtle00)),
            iconTheme: IconThemeData(size: kIconSize, color: token.iconPrimary),
            actionsIconTheme: const IconThemeData(size: kIconSize),
            toolbarHeight: kHeaderHeight + 1, // Add bottom border width.
            titleTextStyle: CarbonTextStyle.bodyCompact02
                .copyWith(color: token.textPrimary)),
        cardTheme: CardTheme(
            color: token.layer01,
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder()),
        checkboxTheme: CheckboxThemeData(
            fillColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return token.iconPrimary;
              } else if (states.contains(WidgetState.disabled)) {
                return token.iconDisabled;
              } else {
                return Colors.transparent;
              }
            }),
            checkColor: WidgetStatePropertyAll<Color>(token.iconInverse)),
        dialogTheme: DialogTheme(
            backgroundColor: token.layer01,
            surfaceTintColor: Colors.transparent,
            titleTextStyle:
                CarbonTextStyle.heading03.copyWith(color: token.textPrimary),
            contentTextStyle:
                CarbonTextStyle.body01.copyWith(color: token.textPrimary),
            shape: Border.all()),
        drawerTheme: DrawerThemeData(
            backgroundColor: token.layer01,
            scrimColor: Colors.transparent,
            surfaceTintColor: Colors.transparent,
            shape: const RoundedRectangleBorder(),
            endShape: const RoundedRectangleBorder()),
        iconTheme: IconThemeData(size: kIconSize, color: token.iconOnColor),
        iconButtonTheme: IconButtonThemeData(
            style: IconButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder())),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: token.field01,
          enabledBorder: UnderlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: token.borderStrong01)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: token.focus, width: 2)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: token.supportError, width: 2)),
        ),
        filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
                shape: const RoundedRectangleBorder(),
                backgroundColor: token.buttonPrimary,
                disabledForegroundColor: token.buttonDisabled)),
        listTileTheme: ListTileThemeData(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            tileColor: token.layer01,
            titleTextStyle: CarbonTextStyle.body01),
        expansionTileTheme: ExpansionTileThemeData(
            iconColor: token.iconPrimary,
            collapsedIconColor: token.iconSecondary),
        popupMenuTheme: PopupMenuThemeData(
            color: token.layer01,
            shape: const RoundedRectangleBorder(),
            surfaceTintColor: Colors.transparent,
            labelTextStyle: WidgetStatePropertyAll<TextStyle>(
                CarbonTextStyle.body01.copyWith(color: token.textPrimary)),
            position: PopupMenuPosition.under,
            iconSize: kIconSize),
        progressIndicatorTheme: ProgressIndicatorThemeData(
            color: token.interactive, circularTrackColor: token.layerAccent01),
        radioTheme: RadioThemeData(
            fillColor: WidgetStatePropertyAll<Color>(token.iconPrimary)),
        tooltipTheme: TooltipThemeData(
          textStyle: CarbonTextStyle.body01.copyWith(color: token.textInverse),
          decoration: BoxDecoration(
              color: token.backgroundInverse,
              borderRadius: BorderRadius.circular(2)),
        ),
      );
}
