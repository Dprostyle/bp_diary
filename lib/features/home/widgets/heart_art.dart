import 'package:flutter/material.dart';

import '../../../core/theme/app_dimens.dart';
import '../../../core/theme/app_scale.dart';

class HeartArt extends StatelessWidget {
  const HeartArt({super.key});

  @override
  Widget build(BuildContext context) {
    final size = context.px(AppDimens.heartArt);
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _HeartPainter()),
    );
  }
}

class _HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final heart = Path()
      ..moveTo(size.width * 0.50, size.height * 0.84)
      ..cubicTo(
        size.width * 0.10,
        size.height * 0.58,
        size.width * 0.02,
        size.height * 0.28,
        size.width * 0.28,
        size.height * 0.22,
      )
      ..cubicTo(
        size.width * 0.40,
        size.height * 0.18,
        size.width * 0.48,
        size.height * 0.30,
        size.width * 0.50,
        size.height * 0.38,
      )
      ..cubicTo(
        size.width * 0.52,
        size.height * 0.30,
        size.width * 0.60,
        size.height * 0.18,
        size.width * 0.72,
        size.height * 0.22,
      )
      ..cubicTo(
        size.width * 0.98,
        size.height * 0.28,
        size.width * 0.90,
        size.height * 0.58,
        size.width * 0.50,
        size.height * 0.84,
      )
      ..close();

    canvas.drawPath(
      heart,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF8EBAFF), Color(0xFF6A7BFF), Color(0xFFB07CFF)],
        ).createShader(Offset.zero & size),
    );

    final orbit = Path()
      ..addOval(
        Rect.fromCenter(
          center: Offset(size.width * 0.52, size.height * 0.46),
          width: size.width * 0.92,
          height: size.height * 0.48,
        ),
      );
    canvas.drawPath(
      orbit,
      Paint()
        ..color = const Color(0xFFD7E6FF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.6,
    );
    canvas.drawCircle(
      Offset(size.width * 0.92, size.height * 0.46),
      3.2,
      Paint()..color = const Color(0xFF8EB6FF),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
