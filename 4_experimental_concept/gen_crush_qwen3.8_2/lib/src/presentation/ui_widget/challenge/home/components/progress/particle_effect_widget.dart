/// 粒子エフェクト（完成版）。
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';

/// 粒子エフェクト。
///
/// 完読時のみ表示される。爆発粒子 24 個と白い火花 36 個を描く。
class ParticleEffectWidget extends StatelessWidget {
  /// コンストラクタ。
  const ParticleEffectWidget({required this.animation, this.color});

  /// 粒子のアニメーション（0〜1）。
  final Animation<double> animation;

  /// 粒子の色。
  final Color? color;

  /// 爆発粒子の個数。
  static const int _particleCount = 24;

  /// 白い火花の個数。
  static const int _sparkCount = 36;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double v = animation.value;
        final List<Widget> particles = <Widget>[
          for (int i = 0; i < _particleCount; i++) _buildParticle(v, i, color),
          for (int i = 0; i < _sparkCount; i++) _buildSparkle(v, i, color),
        ];
        return Stack(alignment: Alignment.center, children: particles);
      },
    );
  }

  /// 爆発粒子を 1 個描く。
  Widget _buildParticle(double v, int i, Color? color) {
    final double speed = 1 + (i % 3) * 0.5;
    final double distance = v * 200 * speed;
    final double size = math.min(math.max((1 - v) * 10, 1), 10).toDouble();
    final double opacity = math.max((1 - v) * 0.9, 0).toDouble();
    final double angle = i / _particleCount * 2 * math.pi;
    return Positioned(
      child: Transform.translate(
        offset: Offset(math.cos(angle) * distance, math.sin(angle) * distance),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (color ?? Colors.white).withOpacity(opacity),
          ),
          child: Center(
            child: Container(
              width: size / 2,
              height: size / 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(opacity),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// 白い火花 1 個を描く。
  Widget _buildSparkle(double v, int i, Color? color) {
    final double distance = v * 120;
    final double size = math
        .max(math.sin(v * 4 * math.pi) * 2 + 1, 0.5)
        .toDouble();
    final double opacity = math.max((1 - v) * 0.8, 0).toDouble();
    final double angle = i / _sparkCount * 2 * math.pi;
    return Positioned(
      child: Transform.translate(
        offset: Offset(math.cos(angle) * distance, math.sin(angle) * distance),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(opacity),
          ),
        ),
      ),
    );
  }
}
