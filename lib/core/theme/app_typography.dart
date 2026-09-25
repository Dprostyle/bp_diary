import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const String family = 'Manrope';

  static const double display = 44;
  static const double headline = 28;
  static const double title = 20;
  static const double button = 18;
  static const double body = 17;
  static const double callout = 16;
  static const double caption = 14;
  static const double micro = 12;

  static TextTheme textTheme(double scale) {
    TextStyle style(double size, FontWeight weight, double height, Color color) {
      return TextStyle(
        fontFamily: family,
        fontSize: size * scale,
        fontWeight: weight,
        height: height,
        color: color,
        letterSpacing: -0.2,
      );
    }

    return TextTheme(
      displayLarge: style(display, FontWeight.w800, 1.05, AppColors.textPrimary),
      displayMedium: style(36, FontWeight.w800, 1.05, AppColors.textPrimary),
      headlineMedium: style(headline, FontWeight.w800, 1.15, AppColors.textPrimary),
      headlineSmall: style(title, FontWeight.w800, 1.2, AppColors.textPrimary),
      titleLarge: style(button, FontWeight.w700, 1.25, AppColors.textPrimary),
      titleMedium: style(callout, FontWeight.w700, 1.3, AppColors.textPrimary),
      titleSmall: style(caption, FontWeight.w700, 1.25, AppColors.textSecondary),
      bodyLarge: style(body, FontWeight.w500, 1.4, AppColors.textSecondary),
      bodyMedium: style(callout, FontWeight.w500, 1.35, AppColors.textSecondary),
      bodySmall: style(caption, FontWeight.w600, 1.3, AppColors.textTertiary),
      labelLarge: style(button, FontWeight.w700, 1.2, AppColors.surface),
      labelMedium: style(caption, FontWeight.w700, 1.2, AppColors.textPrimary),
      labelSmall: style(micro, FontWeight.w600, 1.2, AppColors.textTertiary),
    );
  }
}
