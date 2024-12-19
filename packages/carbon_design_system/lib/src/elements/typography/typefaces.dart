// ignore_for_file: constant_identifier_names

part of '../index.dart';

enum CarbonTypeface {
  IBMPlexMono('IBM Plex Mono'),
  IBMPlexSans('IBM Plex Sans'),
  IBMPlexSerif('IBM Plex Serif');

  final String fontFamily;

  const CarbonTypeface(this.fontFamily);
}
