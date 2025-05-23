part of '../index.dart';

/// ### Gray 100 Theme
/// Uses Gray 100 as the global background color and is layered first with components using Gray 90 backgrounds.
///
/// The second layer uses Gray 80 and the third layer used Gray 70.
final _gray100 = CarbonToken(
    background: CarbonColor.gray100,
    backgroundHover: CarbonColor.gray50.withValues(alpha: 0.16),
    backgroundActive: CarbonColor.gray50.withValues(alpha: 0.40),
    backgroundSelected: CarbonColor.gray50.withValues(alpha: 0.24),
    backgroundSelectedHover: CarbonColor.gray50.withValues(alpha: 0.32),
    backgroundInverse: CarbonColor.gray10,
    backgroundInverseHover: CarbonColor.gray10Hover,
    backgroundBrand: CarbonColor.blue60,
    layer01: CarbonColor.gray90,
    layer02: CarbonColor.gray80,
    layer03: CarbonColor.gray70,
    layerHover01: CarbonColor.gray90Hover,
    layerHover02: CarbonColor.gray80Hover,
    layerHover03: CarbonColor.gray70Hover,
    layerActive01: CarbonColor.gray70,
    layerActive02: CarbonColor.gray60,
    layerActive03: CarbonColor.gray50,
    layerSelected01: CarbonColor.gray80,
    layerSelected02: CarbonColor.gray70,
    layerSelected03: CarbonColor.gray60,
    layerSelectedHover01: CarbonColor.gray80Hover,
    layerSelectedHover02: CarbonColor.gray70Hover,
    layerSelectedHover03: CarbonColor.gray60Hover,
    layerSelectedInverse: CarbonColor.gray10,
    layerSelectedDisabled: CarbonColor.gray60,
    layerAccent01: CarbonColor.gray80,
    layerAccent02: CarbonColor.gray70,
    layerAccent03: CarbonColor.gray60,
    layerAccentHover01: CarbonColor.gray80Hover,
    layerAccentHover02: CarbonColor.gray70Hover,
    layerAccentHover03: CarbonColor.gray60Hover,
    layerAccentActive01: CarbonColor.gray70,
    layerAccentActive02: CarbonColor.gray50,
    layerAccentActive03: CarbonColor.gray80,
    field01: CarbonColor.gray90,
    field02: CarbonColor.gray80,
    field03: CarbonColor.gray70,
    fieldHover01: CarbonColor.gray90Hover,
    fieldHover02: CarbonColor.gray80Hover,
    fieldHover03: CarbonColor.gray70Hover,
    borderInteractive: CarbonColor.blue50,
    borderSubtle00: CarbonColor.gray80,
    borderSubtle01: CarbonColor.gray80,
    borderSubtle02: CarbonColor.gray70,
    borderSubtle03: CarbonColor.gray60,
    borderSubtleSelected01: CarbonColor.gray70,
    borderSubtleSelected02: CarbonColor.gray60,
    borderSubtleSelected03: CarbonColor.gray50,
    borderStrong01: CarbonColor.gray60,
    borderStrong02: CarbonColor.gray50,
    borderStrong03: CarbonColor.gray40,
    borderTile01: CarbonColor.gray70,
    borderTile02: CarbonColor.gray60,
    borderTile03: CarbonColor.gray50,
    borderInverse: CarbonColor.gray10,
    borderDisabled: CarbonColor.gray50.withValues(alpha: 0.50),
    textPrimary: CarbonColor.gray10,
    textSecondary: CarbonColor.gray30,
    textPlaceholder: CarbonColor.gray60,
    textOnColor: CarbonColor.white,
    textOnColorDisabled: CarbonColor.white.withValues(alpha: 0.25),
    textHelper: CarbonColor.gray50,
    textError: CarbonColor.red40,
    textInverse: CarbonColor.gray100,
    textDisabled: CarbonColor.gray10.withValues(alpha: 0.25),
    linkPrimary: CarbonColor.blue40,
    linkPrimaryHover: CarbonColor.blue30,
    linkSecondary: CarbonColor.blue30,
    linkInverse: CarbonColor.blue60,
    linkVisited: CarbonColor.purple40,
    iconPrimary: CarbonColor.gray10,
    iconSecondary: CarbonColor.gray30,
    iconOnColor: CarbonColor.white,
    iconOnColorDisabled: CarbonColor.white.withValues(alpha: 0.25),
    iconInteractive: CarbonColor.white,
    iconInverse: CarbonColor.gray100,
    iconDisabled: CarbonColor.gray10.withValues(alpha: 0.25),
    buttonPrimary: CarbonColor.blue60,
    buttonPrimaryHover: CarbonColor.blue60Hover,
    buttonPrimaryActive: CarbonColor.blue80,
    buttonSecondary: CarbonColor.gray60,
    buttonSecondaryHover: CarbonColor.gray60Hover,
    buttonSecondaryActive: CarbonColor.gray80,
    buttonTertiary: CarbonColor.white,
    buttonTertiaryHover: CarbonColor.gray10,
    buttonTertiaryActive: CarbonColor.gray30,
    buttonDangerPrimary: CarbonColor.red60,
    buttonDangerSecondary: CarbonColor.red50,
    buttonDangerHover: CarbonColor.red60Hover,
    buttonDangerActive: CarbonColor.red80,
    buttonSeparator: CarbonColor.gray100,
    buttonDisabled: CarbonColor.gray70,
    supportError: CarbonColor.red50,
    supportSuccess: CarbonColor.green40,
    supportWarning: CarbonColor.yellow,
    supportInfo: CarbonColor.blue50,
    supportErrorInverse: CarbonColor.red60,
    supportSuccessInverse: CarbonColor.green50,
    supportWarningInverse: CarbonColor.yellow,
    supportInfoInverse: CarbonColor.blue70,
    focus: CarbonColor.white,
    focusInset: CarbonColor.gray100,
    focusInverse: CarbonColor.blue60,
    interactive: CarbonColor.blue50,
    highlight: CarbonColor.blue90,
    toggleOff: CarbonColor.gray60,
    overlay: CarbonColor.gray100.withValues(alpha: 0.70),
    skeletonElement: CarbonColor.gray70,
    skeletonBackground: CarbonColor.gray80Hover);
