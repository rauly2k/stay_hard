import 'package:flutter/material.dart';

/// StayHard App Color Schemes
/// Based on Material 3 design system with custom primary color

class AppColorSchemes {
  // Primary color - StayHard Orange
  static const Color primaryColor = Color(0xFFFF6B35);

  // Light Theme Colors
  static final ColorScheme lightColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.light,
  ).copyWith(
    primary: primaryColor,
    // Override specific colors as needed
  );

  // Dark Theme Colors
  static final ColorScheme darkColorScheme = ColorScheme.fromSeed(
    seedColor: primaryColor,
    brightness: Brightness.dark,
  ).copyWith(
    primary: primaryColor,
    // Override specific colors as needed
  );

  // Custom semantic colors
  static const Color successColor = Color(0xFF90BE6D);
  static const Color errorColor = Color(0xFFF94144);
  static const Color infoColor = Color(0xFF277DA1);
}
