import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_scale.dart';
import '../../widgets/app_content.dart';
import '../../widgets/confirm_dialog.dart';
import '../../widgets/measurement_scope.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final repo = MeasurementScope.of(context);
    return AppContent(
      child: Padding(
        padding: EdgeInsets.all(context.px(AppDimens.lg)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppStrings.settings, style: text.headlineMedium),
            SizedBox(height: context.px(AppDimens.lg)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(context.px(AppDimens.lg)),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(context.px(AppDimens.radiusLg)),
                boxShadow: AppShadows.card,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppStrings.settingsBody, style: text.titleMedium),
                  SizedBox(height: context.px(AppDimens.sm)),
                  Text(AppStrings.settingsNote, style: text.bodyLarge),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              height: context.px(AppDimens.buttonHeight),
              width: double.infinity,
              child: OutlinedButton(
                onPressed: repo.measurements.isEmpty
                    ? null
                    : () async {
                        final confirmed = await showConfirmDialog(
                          context,
                          title: AppStrings.deleteAllTitle,
                          body: AppStrings.deleteAllBody,
                          confirmLabel: AppStrings.delete,
                          destructive: true,
                        );
                        if (!confirmed) return;
                        await repo.clear();
                      },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.danger,
                  side: BorderSide(
                    color: AppColors.danger,
                    width: context.px(AppDimens.borderWidth),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.px(AppDimens.radiusMd)),
                  ),
                  textStyle: text.labelLarge,
                ),
                child: const Text(AppStrings.deleteAll),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
