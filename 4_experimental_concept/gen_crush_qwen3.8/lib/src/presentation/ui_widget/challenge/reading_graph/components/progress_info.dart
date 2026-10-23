/// 進捗情報の表示（完成版）。
library;

import 'package:flutter/material.dart';

/// 進捗情報の表示。
///
/// 読了ページ・総ページを表示する。
class ProgressInfo extends StatelessWidget {
  /// コンストラクタ。
  const ProgressInfo({
    required this.readingPageNum,
    required this.totalPages,
    required this.colorScheme,
    super.key,
  });

  /// 読了ページ数。
  final int readingPageNum;

  /// 総ページ数。
  final int totalPages;

  /// 色スキーム。
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StatItem(
          value: '$readingPageNum',
          label: '読了ページ',
          icon: Icons.book_outlined,
          color: scheme.primary,
        ),
        const SizedBox(width: 16),
        Container(width: 1, height: 40, color: scheme.outlineVariant),
        const SizedBox(width: 16),
        StatItem(
          value: '$totalPages',
          label: '総ページ',
          icon: Icons.menu_book_outlined,
          color: scheme.secondary,
        ),
      ],
    );
  }
}

/// 単一の統計項目。
class StatItem extends StatelessWidget {
  /// コンストラクタ。
  const StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    super.key,
  });

  /// 値。
  final String value;

  /// ラベル。
  final String label;

  /// アイコン。
  final IconData icon;

  /// 色。
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
