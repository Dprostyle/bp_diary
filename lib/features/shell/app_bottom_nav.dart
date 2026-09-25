import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_scale.dart';
import '../../widgets/app_content.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    required this.index,
    required this.onHistory,
    required this.onSettings,
    required this.onAdd,
    super.key,
  });

  final int index;
  final VoidCallback onHistory;
  final VoidCallback onSettings;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final bar = context.px(AppDimens.navHeight);
    final fab = context.px(AppDimens.fabSize);
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        DecoratedBox(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Color(0x101B3A6B),
                blurRadius: 16,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: bar,
              child: AppContent(
                child: Row(
                  children: [
                    Expanded(
                      child: _NavItem(
                        icon: Icons.bar_chart_rounded,
                        label: AppStrings.history,
                        selected: index == 0,
                        onTap: onHistory,
                      ),
                    ),
                    SizedBox(width: fab),
                    Expanded(
                      child: _NavItem(
                        icon: Icons.settings_outlined,
                        label: AppStrings.settings,
                        selected: index == 1,
                        onTap: onSettings,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, -fab / 2),
          child: _AddButton(onPressed: onAdd),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primary : AppColors.textTertiary;
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: context.px(AppDimens.iconLg)),
          SizedBox(height: context.px(AppDimens.xxs)),
          Text(
            label,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final size = context.px(AppDimens.fabSize);
    return Semantics(
      button: true,
      label: AppStrings.addMeasurement,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: Color(0x662F7BFF),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: SizedBox(
              width: size,
              height: size,
              child: Icon(
                Icons.add_rounded,
                color: AppColors.surface,
                size: context.px(AppDimens.iconXl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
