// ignore_for_file: constant_identifier_names

part of '../index.dart';

/// ### Typeface: IBM Plex
/// Carbon uses the open-source typeface **IBM Plex**. It has been carefully
/// designed to meet IBM’s needs as a global technology company and reflect
/// IBM’s spirit, beliefs, and design principles. IBM Plex can be accessed and
/// downloaded from the <a href="https://github.com/ibm/plex" target="_blank">
/// Plex Github Repo</a>.
enum IBMPlex {
  mono('IBM Plex Mono'),
  sans('IBM Plex Sans'),
  serif('IBM Plex Serif');

  final String fontFamily;

  const IBMPlex(this.fontFamily);
}
