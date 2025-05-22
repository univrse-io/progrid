part of '../index.dart';

sealed class CarbonTheme {
  static ThemeData get white => _configuration(token: _white);

  static ThemeData get gray10 => _configuration(token: _gray10);

  static ThemeData get gray90 =>
      _configuration(brightness: Brightness.dark, token: _gray90);

  static ThemeData get gray100 =>
      _configuration(brightness: Brightness.dark, token: _gray100);

  static ThemeData _configuration({
    required CarbonToken token,
    Brightness brightness = Brightness.light,
  }) =>
      ThemeData(
        actionIconTheme: ActionIconThemeData(
          backButtonIconBuilder: (context) => const Icon(CarbonIcon.arrow_left),
        ),
        appBarTheme: AppBarTheme(
          centerTitle: false,
          backgroundColor: token.background,
          shape: Border(bottom: BorderSide(color: token.borderSubtle00)),
          iconTheme: IconThemeData(size: kIconSize, color: token.iconPrimary),
          actionsIconTheme: const IconThemeData(size: kIconSize),
          toolbarHeight: kHeaderHeight + 1, // Add bottom border width.
          titleTextStyle: CarbonTextStyle.bodyCompact02.copyWith(
            color: token.textPrimary,
          ),
        ),
        cardTheme: CardThemeData(
          margin: EdgeInsets.zero,
          color: token.layer02,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(),
        ),
        checkboxTheme: CheckboxThemeData(
          side: const BorderSide(),
          shape: const BeveledRectangleBorder(),
          fillColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return token.iconPrimary;
            } else if (states.contains(WidgetState.disabled)) {
              return token.iconDisabled;
            } else {
              return Colors.transparent;
            }
          }),
          checkColor: WidgetStatePropertyAll<Color>(token.iconInverse),
        ),
        colorScheme: ColorScheme.fromSeed(
          brightness: brightness,
          seedColor: CarbonColor.blue60,
          onSurface: token.textPrimary,
          onPrimaryContainer: token.iconOnColor,
          primaryContainer: token.backgroundHover,
          error: token.textError,
        ),
        dialogTheme: DialogTheme(
          backgroundColor: token.layer01,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: CarbonTextStyle.heading03.copyWith(
            color: token.textPrimary,
          ),
          contentTextStyle: CarbonTextStyle.body01.copyWith(
            color: token.textPrimary,
          ),
          shape: const RoundedRectangleBorder(),
          actionsPadding: EdgeInsets.zero,
        ),
        drawerTheme: DrawerThemeData(
          backgroundColor: token.layer01,
          scrimColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shape: const RoundedRectangleBorder(),
          endShape: const RoundedRectangleBorder(),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          inputDecorationTheme: const InputDecorationTheme(filled: true),
          textStyle: CarbonTextStyle.bodyCompact01,
        ),
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: token.iconPrimary,
          collapsedIconColor: token.iconSecondary,
        ),
        extensions: [token],
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(32),
            fixedSize: const Size.fromHeight(48),
            maximumSize: const Size.fromHeight(80),
            shape: const RoundedRectangleBorder(),
            backgroundColor: token.buttonPrimary,
            disabledBackgroundColor: token.buttonDisabled,
            foregroundColor: token.textOnColor,
            disabledForegroundColor: token.textOnColorDisabled,
            iconColor: token.iconOnColor,
            disabledIconColor: token.iconOnColorDisabled,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: const RoundedRectangleBorder(),
          backgroundColor: token.layer01,
          foregroundColor: token.textPrimary,
        ),
        fontFamily: IBMPlex.sans.fontFamily,
        iconTheme: IconThemeData(size: kIconSize, color: token.iconPrimary),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: const RoundedRectangleBorder(),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          filled: true,
          fillColor: token.field01,
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: token.borderStrong01),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: token.focus, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.zero,
            borderSide: BorderSide(color: token.supportError, width: 2),
          ),
        ),
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          textColor: token.textPrimary,
          titleTextStyle: CarbonTextStyle.body01,
        ),
        package: 'carbon_design_system',
        popupMenuTheme: PopupMenuThemeData(
          color: token.layer01,
          shape: const RoundedRectangleBorder(),
          surfaceTintColor: Colors.transparent,
          labelTextStyle: WidgetStatePropertyAll<TextStyle>(
            CarbonTextStyle.body01.copyWith(color: token.textPrimary),
          ),
          position: PopupMenuPosition.under,
          iconSize: kIconSize,
        ),
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: token.interactive,
          circularTrackColor: token.layerAccent01,
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStatePropertyAll<Color>(token.iconPrimary),
        ),
        scaffoldBackgroundColor: token.background,
        tabBarTheme: TabBarTheme(
          unselectedLabelStyle: CarbonTextStyle.bodyCompact01,
          unselectedLabelColor: token.textSecondary,
          labelStyle: CarbonTextStyle.headingCompact01,
          labelColor: token.textPrimary,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: token.borderInteractive, width: 3),
            ),
          ),
          dividerHeight: 0,
        ),
        textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom()),
        tooltipTheme: TooltipThemeData(
          textStyle: CarbonTextStyle.body01.copyWith(color: token.textInverse),
          decoration: BoxDecoration(
            color: token.backgroundInverse,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        useMaterial3: true,
      );
}
