import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:bp_diary/core/theme/app_typography.dart';
import 'package:flutter/cupertino.dart';

class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    required this.index,
    required this.onHistory,
    required this.onSettings,
    required this.onAdd,
    super.key,
  });

  static const historyKey = Key('nav-history');
  static const addKey = Key('nav-add');
  static const settingsKey = Key('nav-settings');
  static const historyIndex = 0;
  static const settingsIndex = 1;

  final int index;
  final VoidCallback onHistory;
  final VoidCallback onSettings;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.border,
            width: AppDimens.borderWidth,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: AppDimens.navShadowBlur,
            offset: Offset(0, AppDimens.navShadowOffsetY),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: AppDimens.navBarHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _NavItem(
                        key: historyKey,
                        label: 'История',
                        icon: CupertinoIcons.chart_bar,
                        selected: index == historyIndex,
                        onPressed: onHistory,
                      ),
                    ),
                    const SizedBox(width: AppDimens.addButtonSize),
                    Expanded(
                      child: _NavItem(
                        key: settingsKey,
                        label: 'Настройки',
                        icon: CupertinoIcons.gear,
                        selected: index == settingsIndex,
                        onPressed: onSettings,
                      ),
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: const Offset(0, -AppDimens.addButtonLift),
                child: _AddButton(key: addKey, onPressed: onAdd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
    super.key,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.inactive;
    final style = selected
        ? context.appText.titleSmall
        : context.appText.labelMedium;
    return Semantics(
      selected: selected,
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size(AppDimens.minTouch, AppDimens.minTouch),
        foregroundColor: color,
        pressedOpacity: AppDimens.pressedOpacity,
        onPressed: onPressed,
        child: Align(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(icon, size: AppDimens.iconNav, color: color),
              ),
              const SizedBox(height: AppDimens.spaceXs),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label, maxLines: 1, style: style),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Добавить измерение',
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: const Size(
          AppDimens.addButtonSize,
          AppDimens.addButtonSize,
        ),
        pressedOpacity: AppDimens.pressedOpacity,
        onPressed: onPressed,
        child: ExcludeSemantics(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGlow,
                  blurRadius: AppDimens.glowBlur,
                  spreadRadius: AppDimens.glowSpread,
                  offset: Offset(0, AppDimens.glowOffsetY),
                ),
              ],
            ),
            child: const SizedBox(
              width: AppDimens.addButtonSize,
              height: AppDimens.addButtonSize,
              child: Icon(
                CupertinoIcons.add,
                size: AppDimens.iconLg,
                color: AppColors.onAccent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
