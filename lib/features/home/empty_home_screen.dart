import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_scale.dart';
import '../../widgets/app_content.dart';
import '../../widgets/primary_button.dart';
import '../add/add_measurement_screen.dart';
import 'widgets/monitor_art.dart';

class EmptyHomeScreen extends StatelessWidget {
  const EmptyHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: AppContent(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.px(AppDimens.lg),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            SizedBox(height: context.px(AppDimens.md)),
                            const MonitorArt(),
                            SizedBox(height: context.px(AppDimens.lg)),
                            Text(
                              AppStrings.emptyTitle,
                              textAlign: TextAlign.center,
                              style: text.headlineMedium,
                            ),
                            SizedBox(height: context.px(AppDimens.md)),
                            Text(
                              AppStrings.emptyBody,
                              textAlign: TextAlign.center,
                              style: text.bodyLarge,
                            ),
                            SizedBox(height: context.px(AppDimens.xl)),
                            const _FeatureRow(),
                          ],
                        ),
                        Column(
                          children: [
                            SizedBox(height: context.px(AppDimens.xl)),
                            PrimaryButton(
                              label: AppStrings.addMeasurement,
                              icon: Icons.add_rounded,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const AddMeasurementScreen(),
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: context.px(AppDimens.md)),
                            Text(
                              '${AppStrings.dash}  ${AppStrings.emptyHint}  ${AppStrings.dash}',
                              textAlign: TextAlign.center,
                              style: text.bodySmall,
                            ),
                            SizedBox(height: context.px(AppDimens.lg)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          child: _Feature(
            icon: Icons.verified_user_outlined,
            color: AppColors.featureShield,
            background: AppColors.featureShieldSoft,
            label: AppStrings.featureControl,
          ),
        ),
        Expanded(
          child: _Feature(
            icon: Icons.bar_chart_rounded,
            color: AppColors.featureChart,
            background: AppColors.featureChartSoft,
            label: AppStrings.featureCharts,
          ),
        ),
        Expanded(
          child: _Feature(
            icon: Icons.sentiment_satisfied_alt_outlined,
            color: AppColors.featureSmile,
            background: AppColors.featureSmileSoft,
            label: AppStrings.featureCare,
          ),
        ),
      ],
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({
    required this.icon,
    required this.color,
    required this.background,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String label;

  @override
  Widget build(BuildContext context) {
    final size = context.px(AppDimens.featureIcon);
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(color: background, shape: BoxShape.circle),
          child: Icon(icon, color: color, size: context.px(AppDimens.iconLg)),
        ),
        SizedBox(height: context.px(AppDimens.sm)),
        SizedBox(
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
        ),
      ],
    );
  }
}
