import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 波紋エフェクトを描画するウィジェット。
class RippleEffectWidget extends StatelessWidget {
  /// コンストラクタ。
  const RippleEffectWidget({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
    super.key,
  });

  /// アニメーション。
  final Animation<double> animation;

  /// メインカラー。
  final Color primaryColor;

  /// サブカラー。
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _RipplePainter(
            progress: animation.value,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
        );
      },
    );
  }
}

class _RipplePainter extends CustomPainter {
  _RipplePainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final double progress;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double maxRadius = math.max(size.width, size.height) / 2;

    for (int i = 0; i < 4; i++) {
      final double rippleProgress = (progress - i * 0.25).clamp(0.0, 1.0);
      if (rippleProgress <= 0.0 || rippleProgress >= 1.0) {
        continue;
      }

      final double radius = maxRadius * rippleProgress;
      final double opacity = (1.0 - rippleProgress) * 0.3;
      final double strokeWidth = 3.0 - rippleProgress * 2.0;
      final Color color = (i % 2 == 0 ? primaryColor : secondaryColor)
          .withValues(alpha: opacity);

      final Paint paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;

      canvas.drawCircle(center, radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
