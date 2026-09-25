import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_scale.dart';

class MonitorArt extends StatelessWidget {
  const MonitorArt({super.key});

  @override
  Widget build(BuildContext context) {
    final height = context.px(AppDimens.illustrationHeight);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
      child: SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(height, height),
            painter: const _GlowPainter(),
          ),
          CustomPaint(
            size: Size(context.px(280), height),
            painter: const _CuffPainter(),
          ),
          Transform.rotate(
            angle: -0.08,
            child: const _DeviceBody(),
          ),
          Positioned(
            top: context.px(AppDimens.md),
            right: context.px(AppDimens.xxl),
            child: const _HeartBadge(),
          ),
        ],
      ),
    ),
    );
  }
}

class _GlowPainter extends CustomPainter {
  const _GlowPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.48, size.height * 0.52);
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFFD7E8FF).withValues(alpha: 0.95),
          const Color(0xFFD7E8FF).withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: size.width * 0.42));
    canvas.drawCircle(center, size.width * 0.42, paint);
    final dot = Paint()..color = const Color(0xFFB9D4FF);
    canvas.drawCircle(Offset(size.width * 0.18, size.height * 0.28), 4, dot);
    canvas.drawCircle(Offset(size.width * 0.78, size.height * 0.72), 3, dot);
    canvas.drawCircle(Offset(size.width * 0.22, size.height * 0.74), 2.5, dot);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CuffPainter extends CustomPainter {
  const _CuffPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cuff = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(size.width * 0.34, size.height * 0.46),
            width: size.width * 0.34,
            height: size.height * 0.42,
          ),
          const Radius.circular(28),
        ),
      );
    canvas.save();
    canvas.translate(size.width * 0.34, size.height * 0.46);
    canvas.rotate(-0.5);
    canvas.translate(-size.width * 0.34, -size.height * 0.46);
    canvas.drawPath(
      cuff,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6E86F5), Color(0xFF3A4FBF)],
        ).createShader(Offset.zero & size),
    );
    canvas.restore();

    final tube = Path()
      ..moveTo(size.width * 0.42, size.height * 0.62)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.86,
        size.width * 0.62,
        size.height * 0.58,
      );
    canvas.drawPath(
      tube,
      Paint()
        ..color = const Color(0xFF3E7BFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 7
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DeviceBody extends StatelessWidget {
  const _DeviceBody();

  @override
  Widget build(BuildContext context) {
    final radius = context.px(AppDimens.radiusLg);
    return Container(
      width: context.px(156),
      padding: EdgeInsets.fromLTRB(
        context.px(AppDimens.sm),
        context.px(AppDimens.sm),
        context.px(AppDimens.sm),
        context.px(AppDimens.md),
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: context.px(AppDimens.md),
              vertical: context.px(AppDimens.sm),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FF),
              borderRadius: BorderRadius.circular(context.px(AppDimens.radiusMd)),
            ),
            child: const Column(
              children: [
                _DeviceRow(label: 'SYS'),
                _DeviceRow(label: 'DIA'),
                _DeviceRow(label: 'PUL', hearts: true),
              ],
            ),
          ),
          SizedBox(height: context.px(AppDimens.md)),
          Container(
            width: context.px(AppDimens.iconLg),
            height: context.px(AppDimens.iconLg),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary,
                width: context.px(AppDimens.borderWidth) + context.px(1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeviceRow extends StatelessWidget {
  const _DeviceRow({required this.label, this.hearts = false});

  final String label;
  final bool hearts;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: const Color(0xFF8AA0C8),
      fontWeight: FontWeight.w700,
    );
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.px(AppDimens.xxs)),
      child: Row(
        children: [
          Text(label, style: style),
          const Spacer(),
          if (hearts)
            Icon(
              Icons.favorite_rounded,
              size: context.px(AppDimens.iconSm),
              color: const Color(0xFFD7E2F5),
            )
          else
            Text('— —', style: style),
        ],
      ),
    );
  }
}

class _HeartBadge extends StatelessWidget {
  const _HeartBadge();

  @override
  Widget build(BuildContext context) {
    final size = context.px(54);
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A2F7BFF),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Icon(
        Icons.monitor_heart_rounded,
        color: AppColors.primary,
        size: context.px(AppDimens.iconLg),
      ),
    );
  }
}
