import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTypography {
  static const family = 'Inter';

  static TextTheme textTheme(double scale) {
    TextStyle style({
      required double size,
      required FontWeight weight,
      required Color color,
      double height = 1.3,
      double letterSpacing = 0,
      bool tabular = false,
    }) {
      final visual = size * scale;
      return TextStyle(
        fontFamily: family,
        fontFamilyFallback: const ['sans-serif'],
        fontSize: visual,
        fontWeight: weight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        fontFeatures: tabular ? const [FontFeature.tabularFigures()] : const [],
        fontVariations: [
          FontVariation('wght', weight.value.toDouble()),
          FontVariation('opsz', visual.clamp(14, 32).toDouble()),
        ],
      );
    }

    return TextTheme(
      displayLarge: style(
        size: 48,
        weight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.05,
        letterSpacing: -0.8,
        tabular: true,
      ),
      displayMedium: style(
        size: 40,
        weight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.05,
        letterSpacing: -0.6,
        tabular: true,
      ),
      headlineLarge: style(
        size: 34,
        weight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.15,
        letterSpacing: -0.4,
      ),
      headlineMedium: style(
        size: 28,
        weight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.15,
        letterSpacing: -0.3,
        tabular: true,
      ),
      titleLarge: style(
        size: 22,
        weight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.2,
        tabular: true,
      ),
      titleMedium: style(
        size: 18,
        weight: FontWeight.w600,
        color: AppColors.textPrimary,
        height: 1.25,
      ),
      titleSmall: style(
        size: 16,
        weight: FontWeight.w600,
        color: AppColors.accent,
        height: 1.2,
      ),
      bodyLarge: style(
        size: 18,
        weight: FontWeight.w400,
        color: AppColors.textPrimary,
        height: 1.35,
      ),
      bodyMedium: style(
        size: 17,
        weight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.35,
      ),
      bodySmall: style(
        size: 15,
        weight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.3,
      ),
      labelLarge: style(
        size: 18,
        weight: FontWeight.w600,
        color: AppColors.onAccent,
        height: 1.2,
      ),
      labelMedium: style(
        size: 16,
        weight: FontWeight.w500,
        color: AppColors.inactive,
        height: 1.2,
      ),
    );
  }
}

extension AppText on BuildContext {
  TextTheme get appText => Theme.of(this).textTheme;
}
