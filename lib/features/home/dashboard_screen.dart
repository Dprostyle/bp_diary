import 'package:flutter/material.dart';

import '../../core/l10n/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_scale.dart';
import '../../data/measurement.dart';
import '../../data/pressure_level.dart';
import '../../data/reading_format.dart';
import '../../widgets/app_content.dart';
import '../../widgets/measurement_scope.dart';
import '../../widgets/status_pill.dart';
import '../reading/reading_detail_screen.dart';
import 'widgets/dynamics_chart.dart';
import 'widgets/heart_art.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({required this.onOpenSettings, super.key});

  final VoidCallback onOpenSettings;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var _days = 7;

  @override
  Widget build(BuildContext context) {
    final repo = MeasurementScope.of(context);
    final latest = repo.latest;
    if (latest == null) return const SizedBox.shrink();
    final text = Theme.of(context).textTheme;
    final points = repo.dailySeries(_days);
    return AppContent(
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
              context.px(AppDimens.lg),
              context.px(AppDimens.sm),
              context.px(AppDimens.lg),
              context.px(AppDimens.fabSize) / 2,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _Header(onOpenSettings: widget.onOpenSettings),
                SizedBox(height: context.px(AppDimens.md)),
                _LastCard(measurement: latest),
                SizedBox(height: context.px(AppDimens.lg)),
                Row(
                  children: [
                    Expanded(
                      child: Text(AppStrings.dynamics, style: text.headlineSmall),
                    ),
                    TextButton(
                      onPressed: _pickPeriod,
                      child: Text(
                        '${periodLabel(_days)}  ›',
                        style: text.titleMedium?.copyWith(color: AppColors.textSecondary),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: context.px(AppDimens.sm)),
                _ChartCard(points: points, periodDays: _days),
                SizedBox(height: context.px(AppDimens.lg)),
                Text(AppStrings.records, style: text.headlineSmall),
                SizedBox(height: context.px(AppDimens.sm)),
                for (final item in repo.measurements) ...[
                  _RecordTile(measurement: item),
                  SizedBox(height: context.px(AppDimens.sm)),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _pickPeriod() async {
    final selected = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(context.px(AppDimens.radiusLg)),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(context.px(AppDimens.lg)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppStrings.periodTitle,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: context.px(AppDimens.md)),
                for (final days in const [7, 30, 90])
                  _PeriodOption(
                    label: periodLabel(days),
                    selected: days == _days,
                    onTap: () => Navigator.pop(context, days),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (selected != null) setState(() => _days = selected);
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onOpenSettings});

  final VoidCallback onOpenSettings;

  @override
  Widget build(BuildContext context) {
    final logo = context.px(AppDimens.logoSize);
    return Row(
      children: [
        Container(
          width: logo,
          height: logo,
          decoration: const BoxDecoration(
            color: Color(0xFFE8F1FF),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.monitor_heart_rounded,
            color: AppColors.primary,
            size: context.px(AppDimens.iconMd),
          ),
        ),
        SizedBox(width: context.px(AppDimens.sm)),
        Expanded(
          child: Text(
            AppStrings.appName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        IconButton(
          onPressed: onOpenSettings,
          iconSize: context.px(AppDimens.iconLg),
          icon: const Icon(Icons.person_outline_rounded),
          color: AppColors.textSecondary,
          tooltip: AppStrings.settings,
        ),
      ],
    );
  }
}

class _LastCard extends StatelessWidget {
  const _LastCard({required this.measurement});

  final Measurement measurement;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final level = PressureRules.levelFor(
      measurement.systolic,
      measurement.diastolic,
    );
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.px(AppDimens.lg)),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(context.px(AppDimens.radiusXl)),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppStrings.lastMeasurement, style: text.bodyMedium),
                SizedBox(height: context.px(AppDimens.xs)),
                Text(
                  formatReadingWhen(measurement.recordedAt, DateTime.now()),
                  style: text.titleMedium,
                ),
                SizedBox(height: context.px(AppDimens.md)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    formatPressure(measurement.systolic, measurement.diastolic),
                    style: text.displayLarge,
                  ),
                ),
                Text(AppStrings.unitPressure, style: text.bodyMedium),
                SizedBox(height: context.px(AppDimens.md)),
                Row(
                  children: [
                    Icon(
                      Icons.favorite_rounded,
                      color: AppColors.normal,
                      size: context.px(AppDimens.iconMd),
                    ),
                    SizedBox(width: context.px(AppDimens.xs)),
                    Flexible(
                      child: Text(
                        '${measurement.pulse} ${AppStrings.unitPulse}',
                        style: text.titleLarge,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: context.px(AppDimens.sm)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const HeartArt(),
              SizedBox(height: context.px(AppDimens.sm)),
              StatusPill(level: level),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.points, required this.periodDays});

  final List<DayReading> points;
  final int periodDays;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        context.px(AppDimens.md),
        context.px(AppDimens.md),
        context.px(AppDimens.md),
        context.px(AppDimens.lg),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(context.px(AppDimens.radiusXl)),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          Semantics(
            label: '${AppStrings.dynamics}, ${periodLabel(periodDays)}',
            child: DynamicsChart(points: points, periodDays: periodDays),
          ),
          if (points.isEmpty)
            Padding(
              padding: EdgeInsets.only(bottom: context.px(AppDimens.sm)),
              child: Text(AppStrings.emptyChart, style: text.bodyMedium),
            ),
          SizedBox(height: context.px(AppDimens.sm)),
          const _LegendDot(color: AppColors.systolic, label: AppStrings.systolicLegend),
          SizedBox(height: context.px(AppDimens.xs)),
          const _LegendDot(color: AppColors.diastolic, label: AppStrings.diastolicLegend),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: context.px(AppDimens.sm),
          height: context.px(AppDimens.sm),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: context.px(AppDimens.sm)),
        Expanded(
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.measurement});

  final Measurement measurement;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final level = PressureRules.levelFor(
      measurement.systolic,
      measurement.diastolic,
    );
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(context.px(AppDimens.radiusLg)),
      child: InkWell(
        borderRadius: BorderRadius.circular(context.px(AppDimens.radiusLg)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ReadingDetailScreen(id: measurement.id),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(context.px(AppDimens.md)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formatReadingWhen(measurement.recordedAt, DateTime.now()),
                      style: text.bodyMedium,
                    ),
                  ),
                  StatusPill(level: level),
                ],
              ),
              SizedBox(height: context.px(AppDimens.xs)),
              Text(
                formatPressure(measurement.systolic, measurement.diastolic),
                style: text.headlineSmall,
              ),
              Text(
                '${measurement.pulse} ${AppStrings.unitPulse}',
                style: text.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PeriodOption extends StatelessWidget {
  const _PeriodOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.px(AppDimens.buttonHeight),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.px(AppDimens.radiusMd)),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: selected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_rounded,
                color: AppColors.primary,
                size: context.px(AppDimens.iconMd),
              ),
          ],
        ),
      ),
    );
  }
}
