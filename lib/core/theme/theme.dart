import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

// --- CORE PALETTE ---
const Color kPrimary = Color(0xFF004AC6);
// Shifted to a cooler, slate-blue to complement the new vibrant primary
const Color kSecondary = Color(0xFF4B6685);
// A rich, deep amber. Orange is the direct complementary color to blue.
const Color kTertiary = Color(0xFFC46B00);
const Color kOnPrimary = Colors.white;

// --- STATUS COLORS (Use for Text or Icons) ---
const Color kStatusPending = Color(0xFFC46B00); // Deep Amber (Matches Tertiary)
const Color kStatusInTransit = Color(
  0xFF004AC6,
); // Vibrant Blue (Matches Primary)
const Color kStatusDelivered = Color(
  0xFF128254,
); // A cooler, darker emerald green
const Color kStatusCancelled = Color(
  0xFF606975,
); // A cool, blue-tinted slate grey

// --- STATUS CONTAINERS (Use for Backgrounds) ---
// Retinted to match the new, cooler status colors while maintaining > 4.5:1 contrast
const Color kStatusPendingContainer = Color(0xFFFFF2DE);
const Color kStatusInTransitContainer = Color(0xFFE5EFFF);
const Color kStatusDeliveredContainer = Color(0xFFE2F4EB);
const Color kStatusCancelledContainer = Color(0xFFF0F2F5);

// --- THEME DATA ---
const FlexSubThemesData _subThemesData = FlexSubThemesData(
  cardRadius: 12.0,
  inputDecoratorRadius: 8.0,
  elevatedButtonRadius: 8.0,
  inputDecoratorBorderType: FlexInputBorderType.outline,
  filledButtonRadius: 8.0,
  outlinedButtonRadius: 8.0,
  fabRadius: 16.0,
  chipRadius: 36.0,
);

final ThemeData lightTheme = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: kPrimary,
    primaryContainer: kStatusInTransitContainer,
    secondary: kSecondary,
    secondaryContainer: Color(
      0xFFD3DFEB,
    ), // Tinted slate to match new secondary
    tertiary: kTertiary,
    tertiaryContainer: kStatusPendingContainer,
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  subThemesData: _subThemesData,
  useMaterial3: true,
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
);
