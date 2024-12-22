part of '../index.dart';

sealed class CarbonTextStyle {
  /// This is for inline code snippets and smaller code elements.
  static TextStyle get code01 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexMono.fontFamily,
      fontSize: 12,
      height: 1,
      fontWeight: FontWeight.w400,
      letterSpacing: .32,
      package: 'carbon_design_system');

  /// This is for large code snippets and larger code elements.
  static TextStyle get code02 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexMono.fontFamily,
      fontSize: 14,
      height: 1.25,
      fontWeight: FontWeight.w400,
      letterSpacing: .32,
      package: 'carbon_design_system');

  /// This is a multipurpose type style that can be used for field labels in components, error messages, and captions.
  /// It should not be used for body copy.
  static TextStyle get label01 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 12,
      height: 1,
      fontWeight: FontWeight.w400,
      letterSpacing: .32,
      package: 'carbon_design_system');

  /// This is a multipurpose type style that can be used for field labels in components, error messages, and captions.
  /// It should not be used for body copy.
  static TextStyle get label02 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 14,
      height: 1.125,
      fontWeight: FontWeight.w400,
      letterSpacing: .16,
      package: 'carbon_design_system');

  /// This is for explanatory helper text that appears below a field title within a component.
  static TextStyle get helperText01 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 12,
      height: 1,
      fontWeight: FontWeight.w400,
      letterSpacing: .32,
      package: 'carbon_design_system');

  /// This is for explanatory helper text that appears below a field title within a component.
  static TextStyle get helperText02 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 14,
      height: 1.125,
      fontWeight: FontWeight.w400,
      letterSpacing: .16,
      package: 'carbon_design_system');

  /// This is for legal copy appearing in product pages.
  static TextStyle get legal01 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 12,
      height: 1,
      fontWeight: FontWeight.w400,
      letterSpacing: .32,
      package: 'carbon_design_system');

  /// This is for legal copy appearing in web pages.
  static TextStyle get legal02 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 14,
      height: 1.125,
      fontWeight: FontWeight.w400,
      letterSpacing: .16,
      package: 'carbon_design_system');

  /// This is for short paragraphs with no more than four lines and is commonly used in components.
  static TextStyle get bodyCompact01 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 14,
      height: 1.125,
      fontWeight: FontWeight.w400,
      letterSpacing: .16,
      package: 'carbon_design_system');

  /// This is for short paragraphs with no more than four lines.
  /// Use in expressive components, such as button and link.
  static TextStyle get bodyCompact02 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 16,
      height: 1.375,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      package: 'carbon_design_system');

  /// With a slightly taller line height than [bodyCompact01], this body style is used in productive layouts for long paragraphs with more than four lines.
  /// Use also for longer body copy in components such as accordion or structured list.
  /// It is always left-aligned.
  static TextStyle get body01 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 14,
      height: 1.25,
      fontWeight: FontWeight.w400,
      letterSpacing: .16,
      package: 'carbon_design_system');

  /// With a slightly taller line height than [bodyCompact02], this style is commonly used in expressive layouts for long paragraphs with four lines or more.
  /// It is always left-aligned.
  static TextStyle get body02 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      package: 'carbon_design_system');

  /// This is for component and layout headings.
  /// It pairs with [bodyCompact01].
  static TextStyle get headingCompact01 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 14,
      height: 1.125,
      fontWeight: FontWeight.w600,
      letterSpacing: .16,
      package: 'carbon_design_system');

  /// This is for smaller layout headings.
  /// It pairs with [bodyCompact02].
  static TextStyle get headingCompact02 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 16,
      height: 1.375,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      package: 'carbon_design_system');

  /// This is for component and layout headings.
  /// It pairs with [body01].
  static TextStyle get heading01 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 14,
      height: 1.25,
      fontWeight: FontWeight.w600,
      letterSpacing: .16,
      package: 'carbon_design_system');

  /// This is for smaller layout headings.
  /// It pairs with [body02].
  static TextStyle get heading02 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 16,
      height: 1.5,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      package: 'carbon_design_system');

  /// This is for component and layout headings.
  static TextStyle get heading03 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 20,
      height: 1.75,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      package: 'carbon_design_system');

  /// This is for layout headings.
  static TextStyle get heading04 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 28,
      height: 2.25,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      package: 'carbon_design_system');

  /// This is for layout headings.
  static TextStyle get heading05 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 32,
      height: 2.5,
      fontWeight: FontWeight.w400,
      letterSpacing: 0,
      package: 'carbon_design_system');

  /// This is for layout headings.
  static TextStyle get heading06 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 42,
      height: 3.125,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
      package: 'carbon_design_system');

  /// This is for layout headings.
  static TextStyle get heading07 => TextStyle(
      fontFamily: CarbonTypeface.IBMPlexSans.fontFamily,
      fontSize: 54,
      height: 4,
      fontWeight: FontWeight.w300,
      letterSpacing: 0,
      package: 'carbon_design_system');
}
