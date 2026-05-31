import 'package:flutter/material.dart';

/// Breakpoint constants — one place to change them globally.
class Breakpoints {
  Breakpoints._();
  static const double mobile = 600;
  static const double tablet = 1024;
}

/// Design token colours — keeps colour values in sync across all widgets.
class AppColors {
  AppColors._();
  static const Color background = Color(0xFFFCF9F7); // Warm cream page bg
  static const Color darkBrown = Color(0xFF260F08); // Main text
  static const Color red = Color(0xFFC73E1D); // Accent / prices / stepper
  static const Color redDark = Color(0xFF952C15); // Darker variant
  static const Color green = Color(0xFF1EA952); // Confirmation checkmark
  static const Color selectedBorder = Color(
    0xFFC73E1D,
  ); // Card border when in cart
}
