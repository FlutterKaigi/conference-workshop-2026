import 'package:flutter/material.dart';

/// 動的な背景エフェクトを描画するウィジェット（ハンズオン演習版）。
class DynamicBackgroundWidget extends StatelessWidget {
  /// コンストラクタ。
  const DynamicBackgroundWidget({
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
        // FIXME コードを完成させてください。
        // ステップ2: 放射グラデーション
        /*
        final double v = animation.value;
        final double radius = 0.8 + v * 0.4;

        return Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: radius,
                colors: <Color>[
                  primaryColor.withValues(alpha: 0.15 + v * 0.1),
                  secondaryColor.withValues(alpha: 0.08 + v * 0.05),
                  primaryColor.withValues(alpha: 0.03),
                  Colors.transparent,
                ],
                stops: const <double>[0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        );
        */
        const double v = 1.0;
        const double radius = 0.8 + v * 0.4;

        return Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: radius,
                colors: <Color>[
                  primaryColor.withValues(alpha: 0.15 + v * 0.1),
                  secondaryColor.withValues(alpha: 0.08 + v * 0.05),
                  primaryColor.withValues(alpha: 0.03),
                  Colors.transparent,
                ],
                stops: const <double>[0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        );
      },
    );
  }
}
