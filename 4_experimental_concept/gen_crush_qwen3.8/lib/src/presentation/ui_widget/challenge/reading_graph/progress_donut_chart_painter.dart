/// ドーナツチャートペインター（complete / challenge 共用）。
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// ドーナツチャートのペインター。
class ProgressDonutChartPainter extends CustomPainter {
  /// コンストラクタ。
  const ProgressDonutChartPainter({
    required this.progress,
    required this.pulseValue,
    required this.colorScheme,
  });

  /// 進捗率（0〜1）。
  final double progress;

  /// pulse 値（0〜1）。
  final double pulseValue;

  /// 色スキーム。
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (math.min(size.width, size.height) / 2) - 20;
    final double strokeWidth = 16.0;
    final Offset center = size.center(Offset.zero);
    final Rect rect = Rect.fromCircle(center: center, radius: radius);

    // 背景円は outline α0.2。
    final Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = colorScheme.outline.withOpacity(0.2);
    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      // 1. グロー円弧：primary α(0.3+p×0.2)、線幅 +8、blur 8。
      final Paint glowPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8
        ..color = colorScheme.primary.withOpacity(
          (0.3 + progress * 0.2).clamp(0.0, 1.0).toDouble(),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawArc(
        rect,
        -math.pi / 2,
        progress * 2 * math.pi,
        false,
        glowPaint,
      );

      // 2. 本体円弧：線幅 16+p×4。
      final Paint bodyPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = strokeWidth + progress * 4
        ..color = colorScheme.primary;
      canvas.drawArc(
        rect,
        -math.pi / 2,
        progress * 2 * math.pi,
        false,
        bodyPaint,
      );

      // 3. 終端ドット：グロー 8+p×3（blur 4）、本体 6+p×2。
      final double endAngle = -math.pi / 2 + progress * 2 * math.pi;
      final Offset endPoint = Offset(
        center.dx + math.cos(endAngle) * radius,
        center.dy + math.sin(endAngle) * radius,
      );
      final Paint dotGlowPaint = Paint()
        ..color = colorScheme.primary.withOpacity(
          (0.3 + pulseValue * 0.2).clamp(0.0, 1.0).toDouble(),
        )
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
      canvas.drawCircle(endPoint, 8 + pulseValue * 3, dotGlowPaint);
      final Paint dotPaint = Paint()..color = colorScheme.primary;
      canvas.drawCircle(endPoint, 6 + pulseValue * 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressDonutChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulseValue != pulseValue;
  }
}
