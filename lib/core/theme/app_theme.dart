import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:bp_diary/core/theme/app_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData material(double scale) {
    final text = AppTypography.textTheme(scale);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: AppTypography.family,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: text,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        onPrimary: AppColors.onAccent,
        secondary: AppColors.accentSecondary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
    );
  }

  static CupertinoThemeData cupertino(double scale) {
    final text = AppTypography.textTheme(scale);
    return CupertinoThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.accent,
      primaryContrastingColor: AppColors.onAccent,
      scaffoldBackgroundColor: AppColors.background,
      barBackgroundColor: AppColors.background,
      textTheme: CupertinoTextThemeData(
        textStyle: text.bodyLarge!,
        actionTextStyle: text.titleMedium!.copyWith(color: AppColors.accent),
        actionSmallTextStyle: text.titleSmall!,
        navTitleTextStyle: text.titleMedium!,
        navLargeTitleTextStyle: text.headlineLarge!,
        navActionTextStyle: text.titleMedium!.copyWith(color: AppColors.accent),
        pickerTextStyle: text.headlineMedium!,
        dateTimePickerTextStyle: text.titleLarge!,
        tabLabelTextStyle: text.labelMedium!,
      ),
    );
  }
}

abstract final class AppDecorations {
  static const elevated = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.all(Radius.circular(AppDimens.radiusLg)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.border, width: AppDimens.borderWidth),
    ),
    boxShadow: [
      BoxShadow(
        color: AppColors.shadow,
        blurRadius: AppDimens.shadowBlur,
        offset: Offset(0, AppDimens.shadowOffsetY),
      ),
    ],
  );

  static const flat = BoxDecoration(
    color: AppColors.surface,
    borderRadius: BorderRadius.all(Radius.circular(AppDimens.radiusLg)),
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.border, width: AppDimens.borderWidth),
    ),
  );
}
