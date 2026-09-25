import '../core/l10n/app_strings.dart';

enum PressureLevel { normal, elevated, high, crisis }

abstract final class PressureRules {
  static const int sysMin = 70;
  static const int sysMax = 250;
  static const int diaMin = 40;
  static const int diaMax = 150;
  static const int pulseMin = 35;
  static const int pulseMax = 220;

  static PressureLevel levelFor(int systolic, int diastolic) {
    if (systolic >= 180 || diastolic >= 120) return PressureLevel.crisis;
    if (systolic >= 140 || diastolic >= 90) return PressureLevel.high;
    if (systolic >= 130 || diastolic >= 85) return PressureLevel.elevated;
    return PressureLevel.normal;
  }

  static String labelFor(PressureLevel level) {
    return switch (level) {
      PressureLevel.normal => AppStrings.levelNormal,
      PressureLevel.elevated => AppStrings.levelElevated,
      PressureLevel.high => AppStrings.levelHigh,
      PressureLevel.crisis => AppStrings.levelCrisis,
    };
  }

  static String? validate({int? systolic, int? diastolic, int? pulse}) {
    if (systolic == null || diastolic == null || pulse == null) return null;
    if (systolic < sysMin || systolic > sysMax) return AppStrings.sysRange;
    if (diastolic < diaMin || diastolic > diaMax) return AppStrings.diaRange;
    if (pulse < pulseMin || pulse > pulseMax) return AppStrings.pulseRange;
    if (systolic <= diastolic) return AppStrings.sysAboveDia;
    return null;
  }
}
