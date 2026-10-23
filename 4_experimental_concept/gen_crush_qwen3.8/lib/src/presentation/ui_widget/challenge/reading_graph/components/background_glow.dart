/// 背景のグロー。
library;

import 'package:flutter/material.dart';

/// 背景のグロー。
class BackgroundGlow extends StatelessWidget {
  /// コンストラクタ。
  const BackgroundGlow({
    required this.primaryColor,
    required this.animation,
    super.key,
  });

  /// 主色。
  final Color primaryColor;

  /// グローの進行度（0〜1）。
  final double animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[]),
      builder: (BuildContext context, Widget? child) {
        return SizedBox(
          width: 280,
          height: 280,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  primaryColor.withOpacity(0.1 + animation * 0.1),
                  primaryColor.withOpacity(0.0),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
