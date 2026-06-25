import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

const Color kPrimary = Color(0xFF1A6B8A);
const Color kSecondary = Color(0xFF4A6572);
const Color kTertiary = Color(0xFFC47F17);

const Color kStatusPending = Color(0xFFE8A020);
const Color kStatusInTransit = Color(0xFF1A6B8A);
const Color kStatusDelivered = Color(0xFF1D9E75);
const Color kStatusCancelled = Color(0xFF888780);

const Color kStatusPendingContainer = Color(0xFFFAEEDA);
const Color kStatusInTransitContainer = Color(0xFFE1F3F8);
const Color kStatusDeliveredContainer = Color(0xFFE1F5EE);
const Color kStatusCancelledContainer = Color(0xFFF1EFE8);

const FlexSubThemesData _subThemesData = FlexSubThemesData(
  cardRadius: 12.0,
  inputDecoratorRadius: 8.0,
  elevatedButtonRadius: 8.0,
  inputDecoratorBorderType: FlexInputBorderType.outline,
  filledButtonRadius: 8.0,
  outlinedButtonRadius: 8.0,
  fabRadius: 16.0,
);

final ThemeData lightTheme = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xFF1A6B8A),
    primaryContainer: Color(0xFFC8E8F2),
    secondary: Color(0xFF4A6572),
    secondaryContainer: Color(0xFFDDE8EC),
    tertiary: Color(0xFFC47F17),
    tertiaryContainer: Color(0xFFFAEEDA),
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  subThemesData: _subThemesData,
  useMaterial3: true,
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
);
