import 'package:flutter/material.dart';

import '../../../core/l10n/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_scale.dart';
import '../../../data/measurement.dart';

class DynamicsChart extends StatelessWidget {
  const DynamicsChart({
    required this.points,
    required this.periodDays,
    super.key,
  });

  final List<DayReading> points;
  final int periodDays;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.px(AppDimens.chartHeight),
      width: double.infinity,
      child: CustomPaint(
        painter: _ChartPainter(
          points: points,
          periodDays: periodDays,
          labelStyle: Theme.of(context).textTheme.labelSmall!,
        ),
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.points,
    required this.periodDays,
    required this.labelStyle,
  });

  final List<DayReading> points;
  final int periodDays;
  final TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    const yTicks = [160.0, 120.0, 80.0, 40.0];
    final left = 28.0;
    final bottom = 26.0;
    final top = 8.0;
    final chart = Rect.fromLTRB(left, top, size.width - 4, size.height - bottom);

    for (final tick in yTicks) {
      final y = _y(tick, chart);
      canvas.drawLine(
        Offset(chart.left, y),
        Offset(chart.right, y),
        Paint()
          ..color = AppColors.grid
          ..strokeWidth = 1,
      );
      _paintText(
        canvas,
        tick.toInt().toString(),
        Offset(0, y - 7),
        labelStyle,
      );
    }

    if (points.isEmpty) return;

    final start = points.last.day.subtract(Duration(days: periodDays - 1));
    final origin = points.length == 1
        ? points.first.day
        : DateTime(start.year, start.month, start.day);

    double xFor(DateTime day) {
      if (points.length == 1) return chart.center.dx;
      final index = day.difference(origin).inDays.clamp(0, periodDays - 1);
      return chart.left + (index / (periodDays - 1)) * chart.width;
    }

    _drawSeries(
      canvas,
      chart,
      points.map((point) => Offset(xFor(point.day), _y(point.systolic.toDouble(), chart))).toList(),
      AppColors.systolic,
    );
    _drawSeries(
      canvas,
      chart,
      points.map((point) => Offset(xFor(point.day), _y(point.diastolic.toDouble(), chart))).toList(),
      AppColors.diastolic,
    );

    final stride = (points.length / 6).ceil().clamp(1, points.length);
    for (var i = 0; i < points.length; i++) {
      final isLast = i == points.length - 1;
      if (i % stride != 0 && !isLast) continue;
      final x = xFor(points[i].day);
      _paintText(
        canvas,
        points[i].day.day.toString(),
        Offset(x - 8, chart.bottom + 6),
        labelStyle,
      );
    }
  }

  double _y(double value, Rect chart) {
    final clamped = value.clamp(40, 160);
    return chart.bottom - ((clamped - 40) / 120) * chart.height;
  }

  void _drawSeries(Canvas canvas, Rect chart, List<Offset> spots, Color color) {
    if (spots.isEmpty) return;
    final line = Path()..moveTo(spots.first.dx, spots.first.dy);
    for (final spot in spots.skip(1)) {
      line.lineTo(spot.dx, spot.dy);
    }
    if (spots.length > 1) {
      final fill = Path.from(line)
        ..lineTo(spots.last.dx, chart.bottom)
        ..lineTo(spots.first.dx, chart.bottom)
        ..close();
      canvas.drawPath(
        fill,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [color.withValues(alpha: 0.22), color.withValues(alpha: 0)],
          ).createShader(chart),
      );
      canvas.drawPath(
        line,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = AppDimens.chartStroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
    final dot = Paint()..color = color;
    final ring = Paint()..color = AppColors.surface;
    for (final spot in spots) {
      canvas.drawCircle(spot, AppDimens.chartDot + 1.5, ring);
      canvas.drawCircle(spot, AppDimens.chartDot, dot);
    }
  }

  void _paintText(Canvas canvas, String text, Offset offset, TextStyle style) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.periodDays != periodDays;
  }
}

String periodLabel(int days) {
  return switch (days) {
    30 => AppStrings.days30,
    90 => AppStrings.days90,
    _ => AppStrings.days7,
  };
}
