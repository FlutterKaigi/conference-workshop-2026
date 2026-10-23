/// 波紋エフェクト（完成版）。
library;

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

/// 波紋エフェクト。
///
/// 4 本の同心円の波紋を描く。各波紋は [animation] の
/// 進行度に応じて半径・不透明度・線幅が変わる。
class RippleEffectWidget extends StatelessWidget {
  /// コンストラクタ。
  const RippleEffectWidget({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
    super.key,
  });

  /// 波紋のアニメーション（0〜1）。
  final Animation<double> animation;

  /// 主色。
  final Color primaryColor;

  /// 副色。
  final Color secondaryColor;

  /// 波紋の本数。
  static const int _rippleCount = 4;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double v = animation.value;
        final double maxWidth = MediaQuery.of(context).size.longestSide;
        final double radius = maxWidth / 2 * v;
        return Stack(
          alignment: Alignment.center,
          children: List<Widget>.generate(_rippleCount, (int index) {
            final double rippleProgress = ((v + index * 0.25) % 1.0)
                .clamp(0.0, 1.0)
                .toDouble();
            final double rippleRadius = maxWidth / 2 * rippleProgress;
            final double opacity = (1 - rippleProgress) * 0.3;
            final double strokeWidth = 3 - rippleProgress * 2;
            final Color color = index.isEven ? primaryColor : secondaryColor;
            return Positioned(
              child: Container(
                width: rippleRadius * 2,
                height: rippleRadius * 2,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: color.withOpacity(opacity),
                    width: strokeWidth.clamp(0.0, 3.0).toDouble(),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  // ignore: unused_element
  double _radius(double radius) => radius;
}
