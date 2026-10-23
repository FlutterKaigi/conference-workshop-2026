import 'dart:math' as math;
import 'package:flutter/material.dart';

/// キラキラ星エフェクトを描画するウィジェット。
class SparkleEffectWidget extends StatelessWidget {
  /// コンストラクタ。
  const SparkleEffectWidget({
    required this.animation,
    required this.isCompletion,
    required this.primaryColor,
    super.key,
  });

  /// アニメーション。
  final Animation<double> animation;

  /// 完読フラグ。
  final bool isCompletion;

  /// メインカラー。
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return CustomPaint(
          size: Size.infinite,
          painter: _SparklePainter(
            progress: animation.value,
            isCompletion: isCompletion,
            primaryColor: primaryColor,
          ),
        );
      },
    );
  }
}

class _SparklePainter extends CustomPainter {
  _SparklePainter({
    required this.progress,
    required this.isCompletion,
    required this.primaryColor,
  });

  final double progress;
  final bool isCompletion;
  final Color primaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final int count = isCompletion ? 20 : 12;

    for (int i = 0; i < count; i++) {
      final double phase = (progress + i * 0.1) % 1.0;
      final double angle = (i * 2 * math.pi) / count;
      final double distance = 80.0 + math.sin(phase * 2 * math.pi) * 40.0;
      final double starSize =
          (2.0 + math.sin(phase * 4 * math.pi) * 3.0).clamp(1.0, 8.0);
      final double opacity =
          (math.sin(phase * math.pi) * 0.8).clamp(0.0, 1.0);

      final Offset pos = Offset(
        center.dx + math.cos(angle) * distance,
        center.dy + math.sin(angle) * distance,
      );

      final Paint paint = Paint()
        ..color = (i % 2 == 0 ? primaryColor : Colors.white)
            .withValues(alpha: opacity);

      _drawStar(canvas, pos, starSize, paint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double outerRadius, Paint paint) {
    final double innerRadius = outerRadius * 0.4;
    final Path path = Path();
    const int points = 10;

    for (int i = 0; i < points; i++) {
      final double r = i.isEven ? outerRadius : innerRadius;
      final double a = (i * math.pi) / (points / 2) - math.pi / 2;
      final double x = center.dx + r * math.cos(a);
      final double y = center.dy + r * math.sin(a);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _SparklePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
