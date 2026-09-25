import 'package:flutter/material.dart';

import '../core/l10n/app_strings.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_dimens.dart';
import '../core/theme/app_scale.dart';
import 'primary_button.dart';

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  required String confirmLabel,
  bool destructive = false,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return Dialog(
        child: Padding(
          padding: EdgeInsets.all(context.px(AppDimens.lg)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              SizedBox(height: context.px(AppDimens.sm)),
              Text(body, style: Theme.of(context).textTheme.bodyLarge),
              SizedBox(height: context.px(AppDimens.lg)),
              PrimaryButton(
                label: AppStrings.cancel,
                onPressed: () => Navigator.pop(context, false),
              ),
              SizedBox(height: context.px(AppDimens.sm)),
              SizedBox(
                height: context.px(AppDimens.buttonHeight),
                child: TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    confirmLabel,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: destructive ? AppColors.danger : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
  return result ?? false;
}
