part of '../index.dart';

@immutable
class CarbonToken extends ThemeExtension<CarbonToken> {
  /// Default page background;
  /// UI Shell base color
  final Color background;

  /// Hover color for [background];
  /// Hover color for transparent backgrounds
  final Color backgroundHover;

  /// Active color for [background]
  final Color backgroundActive;

  /// Selected color for [background]
  final Color backgroundSelected;

  /// Hover color for [backgroundSelected]
  final Color backgroundSelectedHover;

  /// High contrast backgrounds;
  /// High contrast elements
  final Color backgroundInverse;

  /// Hover color for [backgroundInverse]
  final Color backgroundInverseHover;

  /// Feature background color
  final Color backgroundBrand;

  /// Container color on [background];
  /// Secondary page background
  final Color layer01;

  /// Container color on [layer01]
  final Color layer02;

  /// Container color on [layer02]
  final Color layer03;

  /// Hover color for [layer01]
  final Color layerHover01;

  /// Hover color for [layer02]
  final Color layerHover02;

  /// Hover color for [layer03]
  final Color layerHover03;

  /// Active color for [layer01]
  final Color layerActive01;

  /// Active color for [layer02]
  final Color layerActive02;

  /// Active color for [layer03]
  final Color layerActive03;

  /// Selected color for [layer01]
  final Color layerSelected01;

  /// Selected color for [layer02]
  final Color layerSelected02;

  /// Selected color for [layer03]
  final Color layerSelected03;

  /// Hover color for [layerSelected01]
  final Color layerSelectedHover01;

  /// Hover color for [layerSelected02]
  final Color layerSelectedHover02;

  /// Hover color for [layerSelected03]
  final Color layerSelectedHover03;

  /// High contrast elements;
  /// 4.5:1 AA element contrast
  final Color layerSelectedInverse;

  /// Disabled color for selected layers
  final Color layerSelectedDisabled;

  /// Tertiary background paired with [layer01]
  final Color layerAccent01;

  /// Tertiary background paired with [layer02]
  final Color layerAccent02;

  /// Tertiary background paired with [layer03]
  final Color layerAccent03;

  /// Hover color for [layerAccent01]
  final Color layerAccentHover01;

  /// Hover color for [layerAccent02]
  final Color layerAccentHover02;

  /// Hover color for [layerAccent03]
  final Color layerAccentHover03;

  /// Active color for [layerAccent01]
  final Color layerAccentActive01;

  /// Active color for [layerAccent02]
  final Color layerAccentActive02;

  /// Active color for [layerAccent03]
  final Color layerAccentActive03;

  /// Default input fields;
  /// Fields on [background]
  final Color field01;

  /// Secondary input fields;
  /// Fields on [layer01]
  final Color field02;

  /// Tertiary input fields;
  /// Fields on [layer02]
  final Color field03;

  /// Hover color for [field01]
  final Color fieldHover01;

  /// Hover color for [field02]
  final Color fieldHover02;

  /// Hover color for [field03]
  final Color fieldHover03;

  /// 3:1 AA contrast;
  /// Selected borders;
  /// Active borders
  final Color borderInteractive;

  /// Subtle borders paired with [background]
  final Color borderSubtle00;

  /// Subtle borders paired with [layer01]
  final Color borderSubtle01;

  /// Subtle borders paired with [layer02]
  final Color borderSubtle02;

  /// Subtle borders paired with [layer03]
  final Color borderSubtle03;

  /// Selected color for [borderSubtle01]
  final Color borderSubtleSelected01;

  /// Selected color for [borderSubtle02]
  final Color borderSubtleSelected02;

  /// Selected color for [borderSubtle03]
  final Color borderSubtleSelected03;

  /// Medium contrast border;
  /// Border-bottom paired with [field01];
  /// 3:1 AA non-text contrast
  final Color borderStrong01;

  /// Medium contrast border;
  /// Border-bottom paired with [field02];
  /// 3:1 AA non-text contrast
  final Color borderStrong02;

  /// Medium contrast border;
  /// Border-bottom paired with [field03];
  /// 3:1 AA non-text contrast
  final Color borderStrong03;

  /// Operable tile indicator paired with [layer01]
  final Color borderTile01;

  /// Operable tile indicator paired with [layer02]
  final Color borderTile02;

  /// Operable tile indicator paired with [layer03]
  final Color borderTile03;

  /// High contrast border;
  /// 4.5:1 AA non-text contrast
  final Color borderInverse;

  /// Disabled border color (excluding border-subtles)
  final Color borderDisabled;

  /// Primary text;
  /// Body copy;
  /// Headers;
  /// Hover text color for [textSecondary]
  final Color textPrimary;

  /// Secondary text;
  /// Input labels
  final Color textSecondary;

  /// Placeholder text
  final Color textPlaceholder;

  /// Text on interactive colors;
  /// Text on button colors
  final Color textOnColor;

  /// Disabled color for [textOnColor]
  final Color textOnColorDisabled;

  /// Tertiary text;
  /// Help text
  final Color textHelper;

  /// Error message text
  final Color textError;

  /// Inverse text color
  final Color textInverse;

  /// Disabled text color
  final Color textDisabled;

  /// Primary links
  final Color linkPrimary;

  /// Hover color for [linkPrimary]
  final Color linkPrimaryHover;

  /// Secondary link color for lower contrast backgrounds
  final Color linkSecondary;

  /// Links on [backgroundInverse] backgrounds
  final Color linkInverse;

  /// Color for visited links
  final Color linkVisited;

  /// Primary icons
  final Color iconPrimary;

  /// Secondary icons
  final Color iconSecondary;

  /// Icons on interactive colors;
  /// Icons on non-layer colors
  final Color iconOnColor;

  /// Disabled color for [iconOnColor]
  final Color iconOnColorDisabled;

  /// Icons that indicate operability
  final Color iconInteractive;

  /// Inverse icon color
  final Color iconInverse;

  /// Disabled icon color
  final Color iconDisabled;

  /// Primary button color
  final Color buttonPrimary;

  /// Hover color for [buttonPrimary]
  final Color buttonPrimaryHover;

  /// Active color for [buttonPrimary]
  final Color buttonPrimaryActive;

  /// Secondary button color
  final Color buttonSecondary;

  /// Hover color for [buttonSecondary]
  final Color buttonSecondaryHover;

  /// Active color for [buttonSecondary]
  final Color buttonSecondaryActive;

  /// Tertiary button color;
  /// 4.5:1 AA text contrast
  final Color buttonTertiary;

  /// Hover color for [buttonTertiary]
  final Color buttonTertiaryHover;

  /// Active color for [buttonTertiary]
  final Color buttonTertiaryActive;

  /// Primary danger button color;
  /// 3:1 AA non-text contrast
  final Color buttonDangerPrimary;

  /// Tertiary danger button color;
  /// Ghost danger button color;
  /// 4.5:1 AA text contrast
  final Color buttonDangerSecondary;

  /// Hover color for [buttonDangerPrimary];
  /// Hover color for [buttonDangerSecondary]
  final Color buttonDangerHover;

  /// Active color for [buttonDangerPrimary];
  /// Active color for [buttonDangerSecondary]
  final Color buttonDangerActive;

  /// Fluid button separator;
  /// 3:1 AA non-text contrast
  final Color buttonSeparator;

  /// Disabled color for button elements
  final Color buttonDisabled;

  /// Error;
  /// Invalid state
  final Color supportError;

  /// Success;
  /// On
  final Color supportSuccess;

  /// Warning;
  /// Caution
  final Color supportWarning;

  /// Information
  final Color supportInfo;

  /// Error in high contrast moments
  final Color supportErrorInverse;

  /// Success in high contrast moments
  final Color supportSuccessInverse;

  /// Warning in high contrast moments
  final Color supportWarningInverse;

  /// Information in high contrast moments
  final Color supportInfoInverse;

  /// Focus border;
  /// Focus underline
  final Color focus;

  /// Contrast border paired with [focus]
  final Color focusInset;

  /// Focus on high contrast moments
  final Color focusInverse;

  /// 3:1 AA contrast;
  /// Selected elements;
  /// Active elements;
  /// Accent icons
  final Color interactive;

  /// Highlight color
  final Color highlight;

  /// Off background;
  /// 3:1 AA contrast
  final Color toggleOff;

  /// Background overlay
  final Color overlay;

  /// Skeleton color for text and UI elements
  final Color skeletonElement;

  /// Skeleton color for containers
  final Color skeletonBackground;

  const CarbonToken({
    required this.background,
    required this.backgroundHover,
    required this.backgroundActive,
    required this.backgroundSelected,
    required this.backgroundSelectedHover,
    required this.backgroundInverse,
    required this.backgroundInverseHover,
    required this.backgroundBrand,
    required this.layer01,
    required this.layer02,
    required this.layer03,
    required this.layerHover01,
    required this.layerHover02,
    required this.layerHover03,
    required this.layerActive01,
    required this.layerActive02,
    required this.layerActive03,
    required this.layerSelected01,
    required this.layerSelected02,
    required this.layerSelected03,
    required this.layerSelectedHover01,
    required this.layerSelectedHover02,
    required this.layerSelectedHover03,
    required this.layerSelectedInverse,
    required this.layerSelectedDisabled,
    required this.layerAccent01,
    required this.layerAccent02,
    required this.layerAccent03,
    required this.layerAccentHover01,
    required this.layerAccentHover02,
    required this.layerAccentHover03,
    required this.layerAccentActive01,
    required this.layerAccentActive02,
    required this.layerAccentActive03,
    required this.field01,
    required this.field02,
    required this.field03,
    required this.fieldHover01,
    required this.fieldHover02,
    required this.fieldHover03,
    required this.borderInteractive,
    required this.borderSubtle00,
    required this.borderSubtle01,
    required this.borderSubtle02,
    required this.borderSubtle03,
    required this.borderSubtleSelected01,
    required this.borderSubtleSelected02,
    required this.borderSubtleSelected03,
    required this.borderStrong01,
    required this.borderStrong02,
    required this.borderStrong03,
    required this.borderTile01,
    required this.borderTile02,
    required this.borderTile03,
    required this.borderInverse,
    required this.borderDisabled,
    required this.textPrimary,
    required this.textSecondary,
    required this.textPlaceholder,
    required this.textOnColor,
    required this.textOnColorDisabled,
    required this.textHelper,
    required this.textError,
    required this.textInverse,
    required this.textDisabled,
    required this.linkPrimary,
    required this.linkPrimaryHover,
    required this.linkSecondary,
    required this.linkInverse,
    required this.linkVisited,
    required this.iconPrimary,
    required this.iconSecondary,
    required this.iconOnColor,
    required this.iconOnColorDisabled,
    required this.iconInteractive,
    required this.iconInverse,
    required this.iconDisabled,
    required this.buttonPrimary,
    required this.buttonPrimaryHover,
    required this.buttonPrimaryActive,
    required this.buttonSecondary,
    required this.buttonSecondaryHover,
    required this.buttonSecondaryActive,
    required this.buttonTertiary,
    required this.buttonTertiaryHover,
    required this.buttonTertiaryActive,
    required this.buttonDangerPrimary,
    required this.buttonDangerSecondary,
    required this.buttonDangerHover,
    required this.buttonDangerActive,
    required this.buttonSeparator,
    required this.buttonDisabled,
    required this.supportError,
    required this.supportSuccess,
    required this.supportWarning,
    required this.supportInfo,
    required this.supportErrorInverse,
    required this.supportSuccessInverse,
    required this.supportWarningInverse,
    required this.supportInfoInverse,
    required this.focus,
    required this.focusInset,
    required this.focusInverse,
    required this.interactive,
    required this.highlight,
    required this.toggleOff,
    required this.overlay,
    required this.skeletonElement,
    required this.skeletonBackground,
  });

  @override
  CarbonToken copyWith({
    Color? background,
    Color? backgroundHover,
    Color? backgroundActive,
    Color? backgroundSelected,
    Color? backgroundSelectedHover,
    Color? backgroundInverse,
    Color? backgroundInverseHover,
    Color? backgroundBrand,
    Color? layer01,
    Color? layer02,
    Color? layer03,
    Color? layerHover01,
    Color? layerHover02,
    Color? layerHover03,
    Color? layerActive01,
    Color? layerActive02,
    Color? layerActive03,
    Color? layerSelected01,
    Color? layerSelected02,
    Color? layerSelected03,
    Color? layerSelectedHover01,
    Color? layerSelectedHover02,
    Color? layerSelectedHover03,
    Color? layerSelectedInverse,
    Color? layerSelectedDisabled,
    Color? layerAccent01,
    Color? layerAccent02,
    Color? layerAccent03,
    Color? layerAccentHover01,
    Color? layerAccentHover02,
    Color? layerAccentHover03,
    Color? layerAccentActive01,
    Color? layerAccentActive02,
    Color? layerAccentActive03,
    Color? field01,
    Color? field02,
    Color? field03,
    Color? fieldHover01,
    Color? fieldHover02,
    Color? fieldHover03,
    Color? borderInteractive,
    Color? borderSubtle00,
    Color? borderSubtle01,
    Color? borderSubtle02,
    Color? borderSubtle03,
    Color? borderSubtleSelected01,
    Color? borderSubtleSelected02,
    Color? borderSubtleSelected03,
    Color? borderStrong01,
    Color? borderStrong02,
    Color? borderStrong03,
    Color? borderTile01,
    Color? borderTile02,
    Color? borderTile03,
    Color? borderInverse,
    Color? borderDisabled,
    Color? textPrimary,
    Color? textSecondary,
    Color? textPlaceholder,
    Color? textOnColor,
    Color? textOnColorDisabled,
    Color? textHelper,
    Color? textError,
    Color? textInverse,
    Color? textDisabled,
    Color? linkPrimary,
    Color? linkPrimaryHover,
    Color? linkSecondary,
    Color? linkInverse,
    Color? linkVisited,
    Color? iconPrimary,
    Color? iconSecondary,
    Color? iconOnColor,
    Color? iconOnColorDisabled,
    Color? iconInteractive,
    Color? iconInverse,
    Color? iconDisabled,
    Color? buttonPrimary,
    Color? buttonPrimaryHover,
    Color? buttonPrimaryActive,
    Color? buttonSecondary,
    Color? buttonSecondaryHover,
    Color? buttonSecondaryActive,
    Color? buttonTertiary,
    Color? buttonTertiaryHover,
    Color? buttonTertiaryActive,
    Color? buttonDangerPrimary,
    Color? buttonDangerSecondary,
    Color? buttonDangerHover,
    Color? buttonDangerActive,
    Color? buttonSeparator,
    Color? buttonDisabled,
    Color? supportError,
    Color? supportSuccess,
    Color? supportWarning,
    Color? supportInfo,
    Color? supportErrorInverse,
    Color? supportSuccessInverse,
    Color? supportWarningInverse,
    Color? supportInfoInverse,
    Color? focus,
    Color? focusInset,
    Color? focusInverse,
    Color? interactive,
    Color? highlight,
    Color? toggleOff,
    Color? overlay,
    Color? skeletonElement,
    Color? skeletonBackground,
  }) => CarbonToken(
    background: background ?? this.background,
    backgroundHover: backgroundHover ?? this.backgroundHover,
    backgroundActive: backgroundActive ?? this.backgroundActive,
    backgroundSelected: backgroundSelected ?? this.backgroundSelected,
    backgroundSelectedHover:
        backgroundSelectedHover ?? this.backgroundSelectedHover,
    backgroundInverse: backgroundInverse ?? this.backgroundInverse,
    backgroundInverseHover:
        backgroundInverseHover ?? this.backgroundInverseHover,
    backgroundBrand: backgroundBrand ?? this.backgroundBrand,
    layer01: layer01 ?? this.layer01,
    layer02: layer02 ?? this.layer02,
    layer03: layer03 ?? this.layer03,
    layerHover01: layerHover01 ?? this.layerHover01,
    layerHover02: layerHover02 ?? this.layerHover02,
    layerHover03: layerHover03 ?? this.layerHover03,
    layerActive01: layerActive01 ?? this.layerActive01,
    layerActive02: layerActive02 ?? this.layerActive02,
    layerActive03: layerActive03 ?? this.layerActive03,
    layerSelected01: layerSelected01 ?? this.layerSelected01,
    layerSelected02: layerSelected02 ?? this.layerSelected02,
    layerSelected03: layerSelected03 ?? this.layerSelected03,
    layerSelectedHover01: layerSelectedHover01 ?? this.layerSelectedHover01,
    layerSelectedHover02: layerSelectedHover02 ?? this.layerSelectedHover02,
    layerSelectedHover03: layerSelectedHover03 ?? this.layerSelectedHover03,
    layerSelectedInverse: layerSelectedInverse ?? this.layerSelectedInverse,
    layerSelectedDisabled: layerSelectedDisabled ?? this.layerSelectedDisabled,
    layerAccent01: layerAccent01 ?? this.layerAccent01,
    layerAccent02: layerAccent02 ?? this.layerAccent02,
    layerAccent03: layerAccent03 ?? this.layerAccent03,
    layerAccentHover01: layerAccentHover01 ?? this.layerAccentHover01,
    layerAccentHover02: layerAccentHover02 ?? this.layerAccentHover02,
    layerAccentHover03: layerAccentHover03 ?? this.layerAccentHover03,
    layerAccentActive01: layerAccentActive01 ?? this.layerAccentActive01,
    layerAccentActive02: layerAccentActive02 ?? this.layerAccentActive02,
    layerAccentActive03: layerAccentActive03 ?? this.layerAccentActive03,
    field01: field01 ?? this.field01,
    field02: field02 ?? this.field02,
    field03: field03 ?? this.field03,
    fieldHover01: fieldHover01 ?? this.fieldHover01,
    fieldHover02: fieldHover02 ?? this.fieldHover02,
    fieldHover03: fieldHover03 ?? this.fieldHover03,
    borderInteractive: borderInteractive ?? this.borderInteractive,
    borderSubtle00: borderSubtle00 ?? this.borderSubtle00,
    borderSubtle01: borderSubtle01 ?? this.borderSubtle01,
    borderSubtle02: borderSubtle02 ?? this.borderSubtle02,
    borderSubtle03: borderSubtle03 ?? this.borderSubtle03,
    borderSubtleSelected01:
        borderSubtleSelected01 ?? this.borderSubtleSelected01,
    borderSubtleSelected02:
        borderSubtleSelected02 ?? this.borderSubtleSelected02,
    borderSubtleSelected03:
        borderSubtleSelected03 ?? this.borderSubtleSelected03,
    borderStrong01: borderStrong01 ?? this.borderStrong01,
    borderStrong02: borderStrong02 ?? this.borderStrong02,
    borderStrong03: borderStrong03 ?? this.borderStrong03,
    borderTile01: borderTile01 ?? this.borderTile01,
    borderTile02: borderTile02 ?? this.borderTile02,
    borderTile03: borderTile03 ?? this.borderTile03,
    borderInverse: borderInverse ?? this.borderInverse,
    borderDisabled: borderDisabled ?? this.borderDisabled,
    textPrimary: textPrimary ?? this.textPrimary,
    textSecondary: textSecondary ?? this.textSecondary,
    textPlaceholder: textPlaceholder ?? this.textPlaceholder,
    textOnColor: textOnColor ?? this.textOnColor,
    textOnColorDisabled: textOnColorDisabled ?? this.textOnColorDisabled,
    textHelper: textHelper ?? this.textHelper,
    textError: textError ?? this.textError,
    textInverse: textInverse ?? this.textInverse,
    textDisabled: textDisabled ?? this.textDisabled,
    linkPrimary: linkPrimary ?? this.linkPrimary,
    linkPrimaryHover: linkPrimaryHover ?? this.linkPrimaryHover,
    linkSecondary: linkSecondary ?? this.linkSecondary,
    linkInverse: linkInverse ?? this.linkInverse,
    linkVisited: linkVisited ?? this.linkVisited,
    iconPrimary: iconPrimary ?? this.iconPrimary,
    iconSecondary: iconSecondary ?? this.iconSecondary,
    iconOnColor: iconOnColor ?? this.iconOnColor,
    iconOnColorDisabled: iconOnColorDisabled ?? this.iconOnColorDisabled,
    iconInteractive: iconInteractive ?? this.iconInteractive,
    iconInverse: iconInverse ?? this.iconInverse,
    iconDisabled: iconDisabled ?? this.iconDisabled,
    buttonPrimary: buttonPrimary ?? this.buttonPrimary,
    buttonPrimaryHover: buttonPrimaryHover ?? this.buttonPrimaryHover,
    buttonPrimaryActive: buttonPrimaryActive ?? this.buttonPrimaryActive,
    buttonSecondary: buttonSecondary ?? this.buttonSecondary,
    buttonSecondaryHover: buttonSecondaryHover ?? this.buttonSecondaryHover,
    buttonSecondaryActive: buttonSecondaryActive ?? this.buttonSecondaryActive,
    buttonTertiary: buttonTertiary ?? this.buttonTertiary,
    buttonTertiaryHover: buttonTertiaryHover ?? this.buttonTertiaryHover,
    buttonTertiaryActive: buttonTertiaryActive ?? this.buttonTertiaryActive,
    buttonDangerPrimary: buttonDangerPrimary ?? this.buttonDangerPrimary,
    buttonDangerSecondary: buttonDangerSecondary ?? this.buttonDangerSecondary,
    buttonDangerHover: buttonDangerHover ?? this.buttonDangerHover,
    buttonDangerActive: buttonDangerActive ?? this.buttonDangerActive,
    buttonSeparator: buttonSeparator ?? this.buttonSeparator,
    buttonDisabled: buttonDisabled ?? this.buttonDisabled,
    supportError: supportError ?? this.supportError,
    supportSuccess: supportSuccess ?? this.supportSuccess,
    supportWarning: supportWarning ?? this.supportWarning,
    supportInfo: supportInfo ?? this.supportInfo,
    supportErrorInverse: supportErrorInverse ?? this.supportErrorInverse,
    supportSuccessInverse: supportSuccessInverse ?? this.supportSuccessInverse,
    supportWarningInverse: supportWarningInverse ?? this.supportWarningInverse,
    supportInfoInverse: supportInfoInverse ?? this.supportInfoInverse,
    focus: focus ?? this.focus,
    focusInset: focusInset ?? this.focusInset,
    focusInverse: focusInverse ?? this.focusInverse,
    interactive: interactive ?? this.interactive,
    highlight: highlight ?? this.highlight,
    toggleOff: toggleOff ?? this.toggleOff,
    overlay: overlay ?? this.overlay,
    skeletonElement: skeletonElement ?? this.skeletonElement,
    skeletonBackground: skeletonBackground ?? this.skeletonBackground,
  );

  @override
  CarbonToken lerp(CarbonToken? other, double t) {
    if (other is! CarbonToken) return this;

    return CarbonToken(
      background: Color.lerp(background, other.background, t)!,
      backgroundHover: Color.lerp(backgroundHover, other.backgroundHover, t)!,
      backgroundActive:
          Color.lerp(backgroundActive, other.backgroundActive, t)!,
      backgroundSelected:
          Color.lerp(backgroundSelected, other.backgroundSelected, t)!,
      backgroundSelectedHover:
          Color.lerp(
            backgroundSelectedHover,
            other.backgroundSelectedHover,
            t,
          )!,
      backgroundInverse:
          Color.lerp(backgroundInverse, other.backgroundInverse, t)!,
      backgroundInverseHover:
          Color.lerp(backgroundInverseHover, other.backgroundInverseHover, t)!,
      backgroundBrand: Color.lerp(backgroundBrand, other.backgroundBrand, t)!,
      layer01: Color.lerp(layer01, other.layer01, t)!,
      layer02: Color.lerp(layer02, other.layer02, t)!,
      layer03: Color.lerp(layer03, other.layer03, t)!,
      layerHover01: Color.lerp(layerHover01, other.layerHover01, t)!,
      layerHover02: Color.lerp(layerHover02, other.layerHover02, t)!,
      layerHover03: Color.lerp(layerHover03, other.layerHover03, t)!,
      layerActive01: Color.lerp(layerActive01, other.layerActive01, t)!,
      layerActive02: Color.lerp(layerActive02, other.layerActive02, t)!,
      layerActive03: Color.lerp(layerActive03, other.layerActive03, t)!,
      layerSelected01: Color.lerp(layerSelected01, other.layerSelected01, t)!,
      layerSelected02: Color.lerp(layerSelected02, other.layerSelected02, t)!,
      layerSelected03: Color.lerp(layerSelected03, other.layerSelected03, t)!,
      layerSelectedHover01:
          Color.lerp(layerSelectedHover01, other.layerSelectedHover01, t)!,
      layerSelectedHover02:
          Color.lerp(layerSelectedHover02, other.layerSelectedHover02, t)!,
      layerSelectedHover03:
          Color.lerp(layerSelectedHover03, other.layerSelectedHover03, t)!,
      layerSelectedInverse:
          Color.lerp(layerSelectedInverse, other.layerSelectedInverse, t)!,
      layerSelectedDisabled:
          Color.lerp(layerSelectedDisabled, other.layerSelectedDisabled, t)!,
      layerAccent01: Color.lerp(layerAccent01, other.layerAccent01, t)!,
      layerAccent02: Color.lerp(layerAccent02, other.layerAccent02, t)!,
      layerAccent03: Color.lerp(layerAccent03, other.layerAccent03, t)!,
      layerAccentHover01:
          Color.lerp(layerAccentHover01, other.layerAccentHover01, t)!,
      layerAccentHover02:
          Color.lerp(layerAccentHover02, other.layerAccentHover02, t)!,
      layerAccentHover03:
          Color.lerp(layerAccentHover03, other.layerAccentHover03, t)!,
      layerAccentActive01:
          Color.lerp(layerAccentActive01, other.layerAccentActive01, t)!,
      layerAccentActive02:
          Color.lerp(layerAccentActive02, other.layerAccentActive02, t)!,
      layerAccentActive03:
          Color.lerp(layerAccentActive03, other.layerAccentActive03, t)!,
      field01: Color.lerp(field01, other.field01, t)!,
      field02: Color.lerp(field02, other.field02, t)!,
      field03: Color.lerp(field03, other.field03, t)!,
      fieldHover01: Color.lerp(fieldHover01, other.fieldHover01, t)!,
      fieldHover02: Color.lerp(fieldHover02, other.fieldHover02, t)!,
      fieldHover03: Color.lerp(fieldHover03, other.fieldHover03, t)!,
      borderInteractive:
          Color.lerp(borderInteractive, other.borderInteractive, t)!,
      borderSubtle00: Color.lerp(borderSubtle00, other.borderSubtle00, t)!,
      borderSubtle01: Color.lerp(borderSubtle01, other.borderSubtle01, t)!,
      borderSubtle02: Color.lerp(borderSubtle02, other.borderSubtle02, t)!,
      borderSubtle03: Color.lerp(borderSubtle03, other.borderSubtle03, t)!,
      borderSubtleSelected01:
          Color.lerp(borderSubtleSelected01, other.borderSubtleSelected01, t)!,
      borderSubtleSelected02:
          Color.lerp(borderSubtleSelected02, other.borderSubtleSelected02, t)!,
      borderSubtleSelected03:
          Color.lerp(borderSubtleSelected03, other.borderSubtleSelected03, t)!,
      borderStrong01: Color.lerp(borderStrong01, other.borderStrong01, t)!,
      borderStrong02: Color.lerp(borderStrong02, other.borderStrong02, t)!,
      borderStrong03: Color.lerp(borderStrong03, other.borderStrong03, t)!,
      borderTile01: Color.lerp(borderTile01, other.borderTile01, t)!,
      borderTile02: Color.lerp(borderTile02, other.borderTile02, t)!,
      borderTile03: Color.lerp(borderTile03, other.borderTile03, t)!,
      borderInverse: Color.lerp(borderInverse, other.borderInverse, t)!,
      borderDisabled: Color.lerp(borderDisabled, other.borderDisabled, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textPlaceholder: Color.lerp(textPlaceholder, other.textPlaceholder, t)!,
      textOnColor: Color.lerp(textOnColor, other.textOnColor, t)!,
      textOnColorDisabled:
          Color.lerp(textOnColorDisabled, other.textOnColorDisabled, t)!,
      textHelper: Color.lerp(textHelper, other.textHelper, t)!,
      textError: Color.lerp(textError, other.textError, t)!,
      textInverse: Color.lerp(textInverse, other.textInverse, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      linkPrimary: Color.lerp(linkPrimary, other.linkPrimary, t)!,
      linkPrimaryHover:
          Color.lerp(linkPrimaryHover, other.linkPrimaryHover, t)!,
      linkSecondary: Color.lerp(linkSecondary, other.linkSecondary, t)!,
      linkInverse: Color.lerp(linkInverse, other.linkInverse, t)!,
      linkVisited: Color.lerp(linkVisited, other.linkVisited, t)!,
      iconPrimary: Color.lerp(iconPrimary, other.iconPrimary, t)!,
      iconSecondary: Color.lerp(iconSecondary, other.iconSecondary, t)!,
      iconOnColor: Color.lerp(iconOnColor, other.iconOnColor, t)!,
      iconOnColorDisabled:
          Color.lerp(iconOnColorDisabled, other.iconOnColorDisabled, t)!,
      iconInteractive: Color.lerp(iconInteractive, other.iconInteractive, t)!,
      iconInverse: Color.lerp(iconInverse, other.iconInverse, t)!,
      iconDisabled: Color.lerp(iconDisabled, other.iconDisabled, t)!,
      buttonPrimary: Color.lerp(buttonPrimary, other.buttonPrimary, t)!,
      buttonPrimaryHover:
          Color.lerp(buttonPrimaryHover, other.buttonPrimaryHover, t)!,
      buttonPrimaryActive:
          Color.lerp(buttonPrimaryActive, other.buttonPrimaryActive, t)!,
      buttonSecondary: Color.lerp(buttonSecondary, other.buttonSecondary, t)!,
      buttonSecondaryHover:
          Color.lerp(buttonSecondaryHover, other.buttonSecondaryHover, t)!,
      buttonSecondaryActive:
          Color.lerp(buttonSecondaryActive, other.buttonSecondaryActive, t)!,
      buttonTertiary: Color.lerp(buttonTertiary, other.buttonTertiary, t)!,
      buttonTertiaryHover:
          Color.lerp(buttonTertiaryHover, other.buttonTertiaryHover, t)!,
      buttonTertiaryActive:
          Color.lerp(buttonTertiaryActive, other.buttonTertiaryActive, t)!,
      buttonDangerPrimary:
          Color.lerp(buttonDangerPrimary, other.buttonDangerPrimary, t)!,
      buttonDangerSecondary:
          Color.lerp(buttonDangerSecondary, other.buttonDangerSecondary, t)!,
      buttonDangerHover:
          Color.lerp(buttonDangerHover, other.buttonDangerHover, t)!,
      buttonDangerActive:
          Color.lerp(buttonDangerActive, other.buttonDangerActive, t)!,
      buttonSeparator: Color.lerp(buttonSeparator, other.buttonSeparator, t)!,
      buttonDisabled: Color.lerp(buttonDisabled, other.buttonDisabled, t)!,
      supportError: Color.lerp(supportError, other.supportError, t)!,
      supportSuccess: Color.lerp(supportSuccess, other.supportSuccess, t)!,
      supportWarning: Color.lerp(supportWarning, other.supportWarning, t)!,
      supportInfo: Color.lerp(supportInfo, other.supportInfo, t)!,
      supportErrorInverse:
          Color.lerp(supportErrorInverse, other.supportErrorInverse, t)!,
      supportSuccessInverse:
          Color.lerp(supportSuccessInverse, other.supportSuccessInverse, t)!,
      supportWarningInverse:
          Color.lerp(supportWarningInverse, other.supportWarningInverse, t)!,
      supportInfoInverse:
          Color.lerp(supportInfoInverse, other.supportInfoInverse, t)!,
      focus: Color.lerp(focus, other.focus, t)!,
      focusInset: Color.lerp(focusInset, other.focusInset, t)!,
      focusInverse: Color.lerp(focusInverse, other.focusInverse, t)!,
      interactive: Color.lerp(interactive, other.interactive, t)!,
      highlight: Color.lerp(highlight, other.highlight, t)!,
      toggleOff: Color.lerp(toggleOff, other.toggleOff, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      skeletonElement: Color.lerp(skeletonElement, other.skeletonElement, t)!,
      skeletonBackground:
          Color.lerp(skeletonBackground, other.skeletonBackground, t)!,
    );
  }

  @override
  String toString() =>
      'CarbonToken(background: $background, '
      'background-hover: $backgroundHover, '
      'background-active: $backgroundActive, '
      'background-selected: $backgroundSelected, '
      'background-selected-hover: $backgroundSelectedHover, '
      'background-inverse: $backgroundInverse, '
      'background-inverse-hover: $backgroundInverseHover, '
      'background-brand: $backgroundBrand, '
      'layer-01: $layer01, '
      'layer-02: $layer02, '
      'layer-03: $layer03, '
      'layer-hover-01: $layerHover01, '
      'layer-hover-02: $layerHover02, '
      'layer-hover-03: $layerHover03, '
      'layer-active-01: $layerActive01, '
      'layer-active-02: $layerActive02, '
      'layer-active-03: $layerActive03, '
      'layer-selected-01: $layerSelected01, '
      'layer-selected-02: $layerSelected02, '
      'layer-selected-03: $layerSelected03, '
      'layer-selected-hover-01: $layerSelectedHover01, '
      'layer-selected-hover-02: $layerSelectedHover02, '
      'layer-selected-hover-03: $layerSelectedHover03, '
      'layer-selected-inverse: $layerSelectedInverse, '
      'layer-selected-disabled: $layerSelectedDisabled, '
      'layer-accent-01: $layerAccent01, '
      'layer-accent-02: $layerAccent02, '
      'layer-accent-03: $layerAccent03, '
      'layer-accent-hover-01: $layerAccentHover01, '
      'layer-accent-hover-02: $layerAccentHover02, '
      'layer-accent-hover-03: $layerAccentHover03, '
      'layer-accent-active-01: $layerAccentActive01, '
      'layer-accent-active-02: $layerAccentActive02, '
      'layer-accent-active-03: $layerAccentActive03, '
      'field-01: $field01, '
      'field-02: $field02, '
      'field-03: $field03, '
      'field-hover-01: $fieldHover01, '
      'field-hover-02: $fieldHover02, '
      'field-hover-03: $fieldHover03, '
      'border-interactive: $borderInteractive, '
      'border-subtle-00: $borderSubtle00, '
      'border-subtle-01: $borderSubtle01, '
      'border-subtle-02: $borderSubtle02, '
      'border-subtle-03: $borderSubtle03, '
      'border-subtle-selected-01: $borderSubtleSelected01, '
      'border-subtle-selected-02: $borderSubtleSelected02, '
      'border-subtle-selected-03: $borderSubtleSelected03, '
      'border-strong-01: $borderStrong01, '
      'border-strong-02: $borderStrong02, '
      'border-strong-03: $borderStrong03, '
      'border-tile-01: $borderTile01, '
      'border-tile-02: $borderTile02, '
      'border-tile-03: $borderTile03, '
      'border-inverse: $borderInverse, '
      'border-disabled: $borderDisabled, '
      'text-primary: $textPrimary, '
      'text-secondary: $textSecondary, '
      'text-placeholder: $textPlaceholder, '
      'text-on-color: $textOnColor, '
      'text-on-color-disabled: $textOnColorDisabled, '
      'text-helper: $textHelper, '
      'text-error: $textError, '
      'text-inverse: $textInverse, '
      'text-disabled: $textDisabled, '
      'link-primary: $linkPrimary, '
      'link-primary-hover: $linkPrimaryHover, '
      'link-secondary: $linkSecondary, '
      'link-inverse: $linkInverse, '
      'link-visited: $linkVisited, '
      'icon-primary: $iconPrimary, '
      'icon-secondary: $iconSecondary, '
      'icon-on-color: $iconOnColor, '
      'icon-on-color-disabled: $iconOnColorDisabled, '
      'icon-interactive: $iconInteractive, '
      'icon-inverse: $iconInverse, '
      'icon-disabled: $iconDisabled, '
      'button-primary: $buttonPrimary, '
      'button-primary-hover: $buttonPrimaryHover, '
      'button-primary-active: $buttonPrimaryActive, '
      'button-secondary: $buttonSecondary, '
      'button-secondary-hover: $buttonSecondaryHover, '
      'button-secondary-active: $buttonSecondaryActive, '
      'button-tertiary: $buttonTertiary, '
      'button-tertiary-hover: $buttonTertiaryHover, '
      'button-tertiary-active: $buttonTertiaryActive, '
      'button-danger-primary: $buttonDangerPrimary, '
      'button-danger-secondary: $buttonDangerSecondary, '
      'button-danger-hover: $buttonDangerHover, '
      'button-danger-active: $buttonDangerActive, '
      'button-separator: $buttonSeparator, '
      'button-disabled: $buttonDisabled, '
      'support-error: $supportError, '
      'support-success: $supportSuccess, '
      'support-warning: $supportWarning, '
      'support-info: $supportInfo, '
      'support-error-inverse: $supportErrorInverse, '
      'support-success-inverse: $supportSuccessInverse, '
      'support-warning-inverse: $supportWarningInverse, '
      'support-info-inverse: $supportInfoInverse, '
      'focus: $focus, '
      'focus-inset: $focusInset, '
      'focus-inverse: $focusInverse, '
      'interactive: $interactive, '
      'highlight: $highlight, '
      'toggle-off: $toggleOff, '
      'overlay: $overlay, '
      'skeleton-element: $skeletonElement, '
      'skeleton-background: $skeletonBackground)';
}
