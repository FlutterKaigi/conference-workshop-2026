/// 星のエフェクト（完成版）。
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 星エフェクト。
///
/// 円周上に星形を配置し、[animation] の進行度に応じて
/// 距離・サイズ・不透明度が変化させる。完読時は 20 個、
/// それ以外は 12 個の星を描く。
class SparkleEffectWidget extends StatelessWidget {
  /// コンストラクタ。
  const SparkleEffectWidget({
    required this.animation,
    required this.isCompletion,
    required this.color,
    super.key,
  });

  /// 星のアニメーション（0〜1）。
  final Animation<double> animation;

  /// 完読かどうか。
  final bool isCompletion;

  /// 星の色。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double v = animation.value;
        final int starCount = isCompletion ? 20 : 12;
        return Stack(
          alignment: Alignment.center,
          children: List<Widget>.generate(starCount, (int i) {
            final double phase = (v + i * 0.1) % 1;
            final double distance = 80 + math.sin(phase * 2 * math.pi) * 40;
            final double size = 2 + math.sin(phase * 4 * math.pi) * 3;
            final double opacity = math.sin(phase * math.pi) * 0.8;
            return Positioned(
              child: Transform.translate(
                offset: Offset(
                  math.cos(i / starCount * 2 * math.pi) * distance,
                  math.sin(i / starCount * 2 * math.pi) * distance,
                ),
                child: CustomPaint(
                  size: Size(size * 4, size * 4),
                  painter: _StarPainter(
                    color: color.withOpacity(
                      opacity.clamp(0.0, 1.0).toDouble(),
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

/// 星形のペインター（10 頂点、内径は外径の 0.4 倍）。
class _StarPainter extends CustomPainter {
  /// コンストラクタ。
  const _StarPainter({required this.color});

  /// 星の色。
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final Offset center = size.center(Offset.zero);
    final double outerRadius = math.min(size.width, size.height) / 2;
    final double innerRadius = outerRadius * 0.4;
    final Path path = Path();
    for (int i = 0; i < 10; i++) {
      final double angle = i * math.pi / 5 - math.pi / 2;
      final double radius = i.isEven ? outerRadius : innerRadius;
      final Offset point = Offset(
        center.dx + math.cos(angle) * radius,
        center.dy + math.sin(angle) * radius,
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _StarPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
