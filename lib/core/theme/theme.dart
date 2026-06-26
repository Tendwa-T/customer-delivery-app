import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

const Color kPrimary = Color(0xFF004AC6);
const Color kSecondary = Color(0xFF4B6685);
const Color kTertiary = Color(0xFFC46B00);
const Color kOnPrimary = Colors.white;

const Color kPrimaryDark = Color(0xFF4BAAC8);
const Color kSecondaryDark = Color(0xFF8CA5B9);
const Color kTertiaryDark = Color(0xFFE59A3F);

const Color kStatusPending = Color(0xFFC46B00);
const Color kStatusInTransit = Color(0xFF004AC6);
const Color kStatusDelivered = Color(0xFF128254);
const Color kStatusCancelled = Color(0xFF606975);

const Color kStatusPendingContainer = Color(0xFFFFF2DE);
const Color kStatusInTransitContainer = Color(0xFFE5EFFF);
const Color kStatusDeliveredContainer = Color(0xFFE2F4EB);
const Color kStatusCancelledContainer = Color(0xFFF0F2F5);

const Color kStatusPendingContainerDark = Color(0xFF412402);
const Color kStatusInTransitContainerDark = Color(0xFF0D4F6A);
const Color kStatusDeliveredContainerDark = Color(0xFF04342C);
const Color kStatusCancelledContainerDark = Color(
  0xFF2C3033,
); // Cooler dark grey

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
    secondaryContainer: Color(0xFFD3DFEB),
    tertiary: kTertiary,
    tertiaryContainer: kStatusPendingContainer,
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  subThemesData: _subThemesData,
  useMaterial3: true,
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  // CRITICAL: Register the extension here
  extensions: const <ThemeExtension<dynamic>>[StatusColors.light],
);

final ThemeData darkTheme = FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: kPrimaryDark,
    primaryContainer: kStatusInTransitContainerDark,
    secondary: kSecondaryDark,
    secondaryContainer: Color(0xFF2E4054), // Darker slate to match secondary
    tertiary: kTertiaryDark,
    tertiaryContainer: kStatusPendingContainerDark,
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 13,
  subThemesData: _subThemesData,
  useMaterial3: true,
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  extensions: const <ThemeExtension<dynamic>>[StatusColors.dark],
);

@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  const StatusColors({
    required this.pending,
    required this.pendingContainer,
    required this.inTransit,
    required this.inTransitContainer,
    required this.delivered,
    required this.deliveredContainer,
    required this.cancelled,
    required this.cancelledContainer,
  });

  final Color pending;
  final Color pendingContainer;
  final Color inTransit;
  final Color inTransitContainer;
  final Color delivered;
  final Color deliveredContainer;
  final Color cancelled;
  final Color cancelledContainer;

  Color foregroundFor(DeliveryStatusColor status) {
    switch (status) {
      case DeliveryStatusColor.pending:
        return pending;
      case DeliveryStatusColor.inTransit:
        return inTransit;
      case DeliveryStatusColor.delivered:
        return delivered;
      case DeliveryStatusColor.cancelled:
        return cancelled;
    }
  }

  Color containerFor(DeliveryStatusColor status) {
    switch (status) {
      case DeliveryStatusColor.pending:
        return pendingContainer;
      case DeliveryStatusColor.inTransit:
        return inTransitContainer;
      case DeliveryStatusColor.delivered:
        return deliveredContainer;
      case DeliveryStatusColor.cancelled:
        return cancelledContainer;
    }
  }

  @override
  StatusColors copyWith({
    Color? pending,
    Color? pendingContainer,
    Color? inTransit,
    Color? inTransitContainer,
    Color? delivered,
    Color? deliveredContainer,
    Color? cancelled,
    Color? cancelledContainer,
  }) {
    return StatusColors(
      pending: pending ?? this.pending,
      pendingContainer: pendingContainer ?? this.pendingContainer,
      inTransit: inTransit ?? this.inTransit,
      inTransitContainer: inTransitContainer ?? this.inTransitContainer,
      delivered: delivered ?? this.delivered,
      deliveredContainer: deliveredContainer ?? this.deliveredContainer,
      cancelled: cancelled ?? this.cancelled,
      cancelledContainer: cancelledContainer ?? this.cancelledContainer,
    );
  }

  @override
  StatusColors lerp(StatusColors? other, double t) {
    if (other is! StatusColors) return this;
    return StatusColors(
      pending: Color.lerp(pending, other.pending, t)!,
      pendingContainer: Color.lerp(
        pendingContainer,
        other.pendingContainer,
        t,
      )!,
      inTransit: Color.lerp(inTransit, other.inTransit, t)!,
      inTransitContainer: Color.lerp(
        inTransitContainer,
        other.inTransitContainer,
        t,
      )!,
      delivered: Color.lerp(delivered, other.delivered, t)!,
      deliveredContainer: Color.lerp(
        deliveredContainer,
        other.deliveredContainer,
        t,
      )!,
      cancelled: Color.lerp(cancelled, other.cancelled, t)!,
      cancelledContainer: Color.lerp(
        cancelledContainer,
        other.cancelledContainer,
        t,
      )!,
    );
  }

  static const light = StatusColors(
    pending: kStatusPending,
    pendingContainer: kStatusPendingContainer,
    inTransit: kStatusInTransit,
    inTransitContainer: kStatusInTransitContainer,
    delivered: kStatusDelivered,
    deliveredContainer: kStatusDeliveredContainer,
    cancelled: kStatusCancelled,
    cancelledContainer: kStatusCancelledContainer,
  );

  static const dark = StatusColors(
    pending: kTertiaryDark, // Using lightened amber for contrast
    pendingContainer: kStatusPendingContainerDark,
    inTransit: kPrimaryDark, // Using lightened blue for contrast
    inTransitContainer: kStatusInTransitContainerDark,
    delivered: Color(0xFF5DCAA5),
    deliveredContainer: kStatusDeliveredContainerDark,
    cancelled: Color(0xFFA1AAB3), // Cool slate instead of warm grey
    cancelledContainer: kStatusCancelledContainerDark,
  );
}

enum DeliveryStatusColor { pending, inTransit, delivered, cancelled }
