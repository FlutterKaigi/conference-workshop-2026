/// 進捗円・アイコン（完成版）。
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 進捗円とアイコンのウィジェット。
class ProgressCircleWidget extends StatelessWidget {
  /// コンストラクタ。
  const ProgressCircleWidget({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
    required this.icon,
    required this.pulse,
    super.key,
  });

  /// 進捗率（0〜1）。
  final double progress;

  /// 主色。
  final Color primaryColor;

  /// 副色。
  final Color secondaryColor;

  /// 中央アイコン。
  final IconData icon;

  /// pulse 値（1 より上または下）。
  final double pulse;

  @override
  Widget build(BuildContext context) {
    final double p = progress;
    return Transform.scale(
      scale: pulse,
      child: SizedBox(
        width: 140,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: <Color>[
                    Colors.white.withOpacity(0.9),
                    primaryColor,
                    secondaryColor,
                    primaryColor.withOpacity(0.8),
                  ],
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: primaryColor.withOpacity(0.6),
                    blurRadius: 25 + p * 10,
                    spreadRadius: 8,
                    offset: const Offset(0, 5),
                  ),
                  BoxShadow(
                    color: secondaryColor.withOpacity(0.4),
                    blurRadius: 40 + p * 15,
                    spreadRadius: 15,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.3),
                    blurRadius: 10,
                    spreadRadius: -5,
                    offset: const Offset(-3, -3),
                  ),
                ],
              ),
              child: const SizedBox.shrink(),
            ),
            Center(
              child: CustomPaint(
                size: const Size(110, 110),
                painter: _Enhanced3DProgressPainter(
                  progress: progress,
                  primaryColor: primaryColor,
                  secondaryColor: secondaryColor,
                ),
              ),
            ),
            Center(
              child: Transform.scale(
                scale: 1 + p * 0.2,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0x66FFFFFF),
                  ),
                  child: Icon(icon, color: Colors.white, size: 32),
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '${(progress * 100).round()}%',
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

/// 内部 110×110 のプロット（SweepGradient + ハイライト）。
class _Enhanced3DProgressPainter extends CustomPainter {
  /// コンストラクタ。
  const _Enhanced3DProgressPainter({
    required this.progress,
    required this.primaryColor,
    required this.secondaryColor,
  });

  /// 進捗率（0〜1）。
  final double progress;

  /// 主色。
  final Color primaryColor;

  /// 副色。
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final double p = progress;
    final double radius = (math.min(size.width, size.height) / 2) - 10;
    final double strokeWidth = 8 + p * 4;
    final Offset center = size.center(Offset.zero);

    final Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = RadialGradient(
        colors: <Color>[Colors.white, primaryColor, secondaryColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      final Paint gradientPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..shader = SweepGradient(
          colors: <Color>[secondaryColor, primaryColor, secondaryColor],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        progress * 2 * math.pi,
        false,
        gradientPaint,
      );

      final double endAngle = -math.pi / 2 + progress * 2 * math.pi;
      final Offset endPoint = Offset(
        center.dx + math.cos(endAngle) * radius,
        center.dy + math.sin(endAngle) * radius,
      );
      final Paint highlightPaint = Paint()
        ..color = Colors.white.withOpacity(0.6 + p * 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(endPoint, 2, highlightPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _Enhanced3DProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor;
  }
}
