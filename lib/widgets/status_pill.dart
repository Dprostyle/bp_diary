import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_scale.dart';
import '../data/pressure_level.dart';

class StatusPill extends StatelessWidget {
  const StatusPill({required this.level, super.key});

  final PressureLevel level;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg, IconData icon) = switch (level) {
      PressureLevel.normal => (
          AppColors.normal,
          AppColors.normalSoft,
          Icons.check_rounded,
        ),
      PressureLevel.elevated => (
          AppColors.elevated,
          AppColors.elevatedSoft,
          Icons.remove_rounded,
        ),
      PressureLevel.high => (
          AppColors.high,
          AppColors.highSoft,
          Icons.priority_high_rounded,
        ),
      PressureLevel.crisis => (
          AppColors.crisis,
          AppColors.crisisSoft,
          Icons.priority_high_rounded,
        ),
    };
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.px(AppDimens.sm),
        vertical: context.px(AppDimens.xs),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(context.px(AppDimens.radiusPill)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: fg, size: context.px(AppDimens.iconSm)),
          SizedBox(width: context.px(AppDimens.xs)),
          Text(
            PressureRules.labelFor(level),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg),
          ),
        ],
      ),
    );
  }
}
