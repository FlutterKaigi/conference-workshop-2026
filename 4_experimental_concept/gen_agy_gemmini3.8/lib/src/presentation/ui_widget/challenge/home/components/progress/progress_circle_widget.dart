import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 進捗サークルウィジェット（ハンズオン演習版）。
class ProgressCircleWidget extends StatelessWidget {
  /// コンストラクタ。
  const ProgressCircleWidget({
    required this.progressAnimation,
    required this.pulseAnimation,
    required this.primaryColor,
    required this.secondaryColor,
    required this.iconData,
    required this.targetPercentage,
    super.key,
  });

  /// 進捗アニメーション。
  final Animation<double> progressAnimation;

  /// パルスアニメーション。
  final Animation<double> pulseAnimation;

  /// メインカラー。
  final Color primaryColor;

  /// サブカラー。
  final Color secondaryColor;

  /// 表示アイコン。
  final IconData iconData;

  /// 目標パーセンテージ。
  final int targetPercentage;

  @override
  Widget build(BuildContext context) {
    // FIXME コードを完成させてください。
    // ステップ3: アニメーション値による動き
    /*
    final double pulse = pulseAnimation.value;
    final double progress = progressAnimation.value;
    final int currentPercentage = (targetPercentage * progress).round();
    */
    const double pulse = 1.0;
    const double progress = 1.0;
    final int currentPercentage = (targetPercentage * progress).round();

    return Transform.scale(
      scale: pulse,
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: <Color>[
              Colors.white.withValues(alpha: 0.9),
              primaryColor,
              secondaryColor,
              primaryColor.withValues(alpha: 0.8),
            ],
            stops: const <double>[0.0, 0.4, 0.8, 1.0],
          ),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.6),
              blurRadius: 25 + progress * 10,
              spreadRadius: 8,
              offset: const Offset(0, 5),
            ),
            BoxShadow(
              color: secondaryColor.withValues(alpha: 0.4),
              blurRadius: 40 + progress * 15,
              spreadRadius: 15,
            ),
            BoxShadow(
              color: Colors.white.withValues(alpha: 0.3),
              blurRadius: 10,
              spreadRadius: -5,
              offset: const Offset(-3, -3),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            SizedBox(
              width: 110,
              height: 110,
              child: CustomPaint(
                painter: _Enhanced3DProgressPainter(
                  progress: progress,
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                ),
              ),
            ),
            Transform.scale(
              scale: 1.0 + progress * 0.2,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                ),
                child: Icon(
                  iconData,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '$currentPercentage%',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Enhanced3DProgressPainter extends CustomPainter {
  _Enhanced3DProgressPainter({
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
    final double radius = math.min(size.width, size.height) / 2 - 10;
    final double strokeWidth = 8.0 + progress * 4.0;

    final Paint bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final Rect rect = Rect.fromCircle(center: center, radius: radius);
      final Paint progressPaint = Paint()
        ..shader = SweepGradient(
          colors: <Color>[primaryColor, secondaryColor, primaryColor],
          startAngle: -math.pi / 2,
          endAngle: 3 * math.pi / 2,
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2,
        progress * 2 * math.pi,
        false,
        progressPaint,
      );

      final Paint highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.6 + progress * 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        -math.pi / 2,
        progress * 2 * math.pi,
        false,
        highlightPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _Enhanced3DProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
