/// 動的な背景グラデーション（完成版）。
library;

import 'package:flutter/material.dart';

/// 動的な背景グラデーション。
///
/// [animation] の進行度に応じて半径・色の alpha が変化させる。
class DynamicBackgroundWidget extends StatelessWidget {
  /// コンストラクタ。
  const DynamicBackgroundWidget({
    required this.animation,
    required this.primaryColor,
    required this.secondaryColor,
    super.key,
  });

  /// 背景のアニメーション（0〜1）。
  final Animation<double> animation;

  /// 主色。
  final Color primaryColor;

  /// 副色。
  final Color secondaryColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double v = animation.value;
        return Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                radius: 0.8 + v * 0.4,
                colors: <Color>[
                  Color.alphaBlend(
                    Color.fromRGBO(
                      primaryColor.red,
                      primaryColor.green,
                      primaryColor.blue,
                      0,
                    ).withOpacity(0.15 + v * 0.1),
                    Colors.transparent,
                  ),
                  Color.alphaBlend(
                    Color.fromRGBO(
                      secondaryColor.red,
                      secondaryColor.green,
                      secondaryColor.blue,
                      0,
                    ).withOpacity(0.08 + v * 0.05),
                    Colors.transparent,
                  ),
                  primaryColor.withOpacity(0.03),
                  Colors.transparent,
                ],
                stops: const <double>[0, 0.4, 0.7, 1],
              ),
            ),
          ),
        );
      },
    );
  }
}
