import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:bp_diary/core/theme/app_theme.dart';
import 'package:bp_diary/core/theme/app_typography.dart';
import 'package:bp_diary/widgets/screen_title.dart';
import 'package:flutter/widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ScreenTitle('Настройки'),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppDimens.spaceLg,
              AppDimens.spaceMd,
              AppDimens.spaceLg,
              AppDimens.spaceXl,
            ),
            child: DecoratedBox(
              decoration: AppDecorations.elevated,
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.spaceLg),
                child: Text(
                  'Записи хранятся только на этом устройстве.',
                  style: context.appText.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
