import 'package:flutter/material.dart';

/// 統計値アイテムウィジェット。
class StatItem extends StatelessWidget {
  /// コンストラクタ。
  const StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    super.key,
  });

  /// 表示値。
  final String value;

  /// ラベル。
  final String label;

  /// アイコン。
  final IconData icon;

  /// カラー。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          icon,
          size: 24,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
