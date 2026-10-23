import 'package:flutter/material.dart';

/// ドーナツチャートの背景グローウィジェット。
class BackgroundGlow extends StatelessWidget {
  /// コンストラクタ。
  const BackgroundGlow({
    required this.primaryColor,
    super.key,
  });

  /// メインカラー。
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[
            primaryColor.withValues(alpha: 0.1),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
