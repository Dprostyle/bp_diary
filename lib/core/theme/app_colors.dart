import 'package:flutter/material.dart';

abstract final class AppColors {
  static const background = Color(0xFFF5F8FC);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF1B2430);
  static const textSecondary = Color(0xFF5E6B7C);
  static const textTertiary = Color(0xFF8B97A8);
  static const primary = Color(0xFF2F7BFF);
  static const primaryDark = Color(0xFF1E66F5);
  static const grid = Color(0xFFE7EDF4);
  static const divider = Color(0xFFE3E9F0);
  static const systolic = Color(0xFF3B82F6);
  static const diastolic = Color(0xFF2EC5A0);
  static const normal = Color(0xFF1F9D55);
  static const normalSoft = Color(0xFFE5F8EC);
  static const elevated = Color(0xFFC47B09);
  static const elevatedSoft = Color(0xFFFFF4DE);
  static const high = Color(0xFFDC2626);
  static const highSoft = Color(0xFFFDECEC);
  static const crisis = Color(0xFF9F1239);
  static const crisisSoft = Color(0xFFFCE7EF);
  static const featureShield = Color(0xFF22C58B);
  static const featureShieldSoft = Color(0xFFE5F8EF);
  static const featureChart = Color(0xFF7C6CF0);
  static const featureChartSoft = Color(0xFFF0ECFF);
  static const featureSmile = Color(0xFF4C9DFF);
  static const featureSmileSoft = Color(0xFFE8F3FF);
  static const fieldFill = Color(0xFFF7FAFD);
  static const danger = Color(0xFFDC2626);

  static const primaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF4C9BFF), Color(0xFF2B6DFF)],
  );

  static const cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF7FBFF), Color(0xFFEAF3FF)],
  );

  static const dangerGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFFF07171), Color(0xFFE23B3B)],
  );
}

abstract final class AppShadows {
  static List<BoxShadow> card = [
    BoxShadow(
      color: const Color(0xFF1B3A6B).withValues(alpha: 0.06),
      blurRadius: 24,
      offset: const Offset(0, 10),
    ),
  ];

  static List<BoxShadow> button = [
    BoxShadow(
      color: const Color(0xFF2F7BFF).withValues(alpha: 0.28),
      blurRadius: 18,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> nav = [
    BoxShadow(
      color: const Color(0xFF1B3A6B).withValues(alpha: 0.06),
      blurRadius: 16,
      offset: const Offset(0, -4),
    ),
  ];
}
