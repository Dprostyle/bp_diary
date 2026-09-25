import 'package:bp_diary/core/format/ru_date.dart';
import 'package:bp_diary/core/theme/app_colors.dart';
import 'package:bp_diary/core/theme/app_dimens.dart';
import 'package:bp_diary/core/theme/app_theme.dart';
import 'package:bp_diary/core/theme/app_typography.dart';
import 'package:bp_diary/data/measurement.dart';
import 'package:bp_diary/widgets/measurement_scope.dart';
import 'package:bp_diary/widgets/screen_title.dart';
import 'package:flutter/widgets.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = MeasurementScope.of(context).items;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const ScreenTitle('История'),
        if (items.isEmpty)
          const Expanded(child: _EmptyHistory())
        else
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.spaceLg,
                AppDimens.spaceMd,
                AppDimens.spaceLg,
                AppDimens.spaceXl,
              ),
              children: [
                _LatestCard(item: items.first),
                if (items.length > 1) ...[
                  const SizedBox(height: AppDimens.spaceLg),
                  for (var i = 1; i < items.length; i++) ...[
                    _PastRow(item: items[i]),
                    if (i != items.length - 1) const _Hairline(),
                  ],
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.spaceXl),
      child: Center(
        child: Text(
          'Пока нет измерений',
          style: context.appText.titleLarge,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _LatestCard extends StatelessWidget {
  const _LatestCard({required this.item});

  final Measurement item;

  @override
  Widget build(BuildContext context) {
    final text = context.appText;
    return DecoratedBox(
      decoration: AppDecorations.elevated,
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    RuDate.date(item.recordedAt),
                    style: text.bodyMedium,
                    maxLines: 2,
                  ),
                ),
                const SizedBox(width: AppDimens.spaceMd),
                Text(RuDate.time(item.recordedAt), style: text.bodyMedium),
              ],
            ),
            const SizedBox(height: AppDimens.spaceLg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _Metric(label: 'Верхнее', value: item.systolic),
                ),
                const SizedBox(width: AppDimens.spaceLg),
                Expanded(
                  child: _Metric(label: 'Нижнее', value: item.diastolic),
                ),
              ],
            ),
            const SizedBox(height: AppDimens.spaceSm),
            Text('мм рт. ст.', style: text.bodyMedium),
            const SizedBox(height: AppDimens.spaceLg),
            DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.skySoft,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppDimens.radiusPill),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceMd,
                  vertical: AppDimens.spaceSm,
                ),
                child: Text('${item.pulse} уд/мин', style: text.titleMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    final text = context.appText;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: text.bodyMedium),
        const SizedBox(height: AppDimens.spaceXs),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text('$value', style: text.displayLarge),
        ),
      ],
    );
  }
}

class _PastRow extends StatelessWidget {
  const _PastRow({required this.item});

  final Measurement item;

  @override
  Widget build(BuildContext context) {
    final text = context.appText;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimens.spaceMd),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item.systolic} / ${item.diastolic}',
                  style: text.titleLarge,
                ),
                const SizedBox(height: AppDimens.spaceXs),
                Text(
                  RuDate.dateTime(item.recordedAt),
                  style: text.bodyMedium,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.spaceMd),
          Text('${item.pulse} уд/мин', style: text.bodyLarge),
        ],
      ),
    );
  }
}

class _Hairline extends StatelessWidget {
  const _Hairline();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: AppDimens.borderWidth,
      width: double.infinity,
      child: ColoredBox(color: AppColors.border),
    );
  }
}
