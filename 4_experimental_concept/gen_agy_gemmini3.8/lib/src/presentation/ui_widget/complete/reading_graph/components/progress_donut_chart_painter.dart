import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ドーナツチャート描画 CustomPainter。
class ProgressDonutChartPainter extends CustomPainter {
  /// コンストラクタ。
  ProgressDonutChartPainter({
    required this.progress,
    required this.pulseValue,
    required this.colorScheme,
  });

  /// 進捗率（0.0 〜 1.0）。
  final double progress;

  /// パルス値（0.0 〜 1.0）。
  final double pulseValue;

  /// カラースキーム。
  final ColorScheme colorScheme;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = math.min(size.width, size.height) / 2 - 20;
    const double baseStrokeWidth = 16.0;

    // 背景円
    final Paint bgPaint = Paint()
      ..color = colorScheme.outline.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = baseStrokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final Rect rect = Rect.fromCircle(center: center, radius: radius);
      final double sweepAngle = progress * 2 * math.pi;

      // 1. グロー円弧
      final Paint glowPaint = Paint()
        ..color = colorScheme.primary.withValues(
          alpha: (0.3 + pulseValue * 0.2).clamp(0.0, 1.0),
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = baseStrokeWidth + 8.0
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0)
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, glowPaint);

      // 2. 本体円弧
      final Paint mainPaint = Paint()
        ..color = colorScheme.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = baseStrokeWidth + pulseValue * 4.0
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, mainPaint);

      // 3. 終端ドット
      final double endAngle = -math.pi / 2 + sweepAngle;
      final Offset dotCenter = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );

      final Paint dotGlowPaint = Paint()
        ..color = colorScheme.primary
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

      canvas.drawCircle(
        dotCenter,
        8.0 + pulseValue * 3.0,
        dotGlowPaint,
      );

      final Paint dotPaint = Paint()..color = colorScheme.primary;

      canvas.drawCircle(
        dotCenter,
        6.0 + pulseValue * 2.0,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant ProgressDonutChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.pulseValue != pulseValue ||
        oldDelegate.colorScheme != colorScheme;
  }
}
