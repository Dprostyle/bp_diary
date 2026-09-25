import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:bp_diary/core/theme/app_typography.dart';
import 'package:flutter/cupertino.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
      padding: EdgeInsets.zero,
      minimumSize: const Size(AppDimens.buttonHeight, AppDimens.buttonHeight),
      borderRadius: BorderRadius.circular(AppDimens.radiusPill),
      color: AppColors.accent,
      disabledColor: AppColors.inactive,
      foregroundColor: AppColors.onAccent,
      pressedOpacity: AppDimens.pressedOpacity,
      onPressed: onPressed,
      child: SizedBox(
        height: AppDimens.buttonHeight,
        child: Align(child: Text(label, style: context.appText.labelLarge)),
      ),
    );
  }
}
