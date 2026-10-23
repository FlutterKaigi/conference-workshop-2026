import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 爆発粒子エフェクトを描画するウィジェット。
class ParticleEffectWidget extends StatelessWidget {
  /// コンストラクタ。
  const ParticleEffectWidget({
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
          painter: _ParticlePainter(
            progress: animation.value,
            primaryColor: primaryColor,
            secondaryColor: secondaryColor,
          ),
        );
      },
    );
  }
}

class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
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
    final double v = progress;

    if (v <= 0.0 || v >= 1.0) {
      return;
    }

    // 爆発粒子 24個
    for (int i = 0; i < 24; i++) {
      final double angle = (i * 2 * math.pi) / 24;
      final double speed = 1.0 + (i % 3) * 0.5;
      final double distance = v * 200.0 * speed;
      final double particleSize = ((1.0 - v) * 10.0).clamp(1.0, 10.0);
      final double opacity = ((1.0 - v) * 0.9).clamp(0.0, 1.0);

      final Offset pos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      final Color color = (i % 2 == 0 ? primaryColor : secondaryColor)
          .withValues(alpha: opacity);

      final Paint paint = Paint()..color = color;
      canvas.drawCircle(pos, particleSize, paint);

      // 中心に白の小円
      final Paint centerPaint = Paint()
        ..color = Colors.white.withValues(alpha: opacity);
      canvas.drawCircle(pos, particleSize * 0.4, centerPaint);
    }

    // 白い火花 36個
    for (int i = 0; i < 36; i++) {
      final double angle = (i * 2 * math.pi) / 36 + 0.1;
      final double distance = v * 120.0;
      final double sparkSize = (math.sin(v * 4 * math.pi) * 2.0 + 1.0).abs();

      final Offset pos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      final Paint sparkPaint = Paint()
        ..color = Colors.white.withValues(alpha: (1.0 - v).clamp(0.0, 1.0));
      canvas.drawCircle(pos, sparkSize, sparkPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
