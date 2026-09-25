import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_scale.dart';
import '../../data/pressure_level.dart';
import '../../data/reading_format.dart';
import '../../widgets/app_content.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/measurement_scope.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_pill.dart';
import '../add/add_measurement_screen.dart';

class ReadingDetailScreen extends StatelessWidget {
  const ReadingDetailScreen({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context) {
    final repo = MeasurementScope.of(context);
    final item = repo.findById(id);
    if (item == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final text = Theme.of(context).textTheme;
    final level = PressureRules.levelFor(item.systolic, item.diastolic);
    return Scaffold(
      body: SafeArea(
        child: AppContent(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: context.px(AppDimens.lg)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: context.px(AppDimens.buttonHeight),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        iconSize: context.px(AppDimens.iconLg),
                        icon: const Icon(Icons.arrow_back_rounded),
                      ),
                      Expanded(
                        child: Text(
                          formatReadingWhen(item.recordedAt, DateTime.now()),
                          textAlign: TextAlign.center,
                          style: text.titleLarge,
                        ),
                      ),
                      SizedBox(width: context.px(AppDimens.minTouch)),
                    ],
                  ),
                ),
                SizedBox(height: context.px(AppDimens.xl)),
                Text(
                  formatPressure(item.systolic, item.diastolic),
                  style: text.displayLarge,
                ),
                Text(AppStrings.unitPressure, style: text.bodyLarge),
                SizedBox(height: context.px(AppDimens.md)),
                Text(
                  '${item.pulse} ${AppStrings.unitPulse}',
                  style: text.headlineSmall,
                ),
                SizedBox(height: context.px(AppDimens.md)),
                StatusPill(level: level),
                const Spacer(),
                PrimaryButton(
                  label: AppStrings.editValues,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => AddMeasurementScreen(existing: item),
                      ),
                    );
                  },
                ),
                SizedBox(height: context.px(AppDimens.sm)),
                SizedBox(
                  height: context.px(AppDimens.buttonHeight),
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      final confirmed = await showConfirmDialog(
                        context,
                        title: AppStrings.deleteReadingTitle,
                        body: AppStrings.deleteReadingBody,
                        confirmLabel: AppStrings.delete,
                        destructive: true,
                      );
                      if (!confirmed || !context.mounted) return;
                      await repo.delete(id);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: Text(
                      AppStrings.deleteReading,
                      style: text.labelLarge?.copyWith(color: AppColors.danger),
                    ),
                  ),
                ),
                SizedBox(height: context.px(AppDimens.lg)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
