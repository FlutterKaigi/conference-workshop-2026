import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/reading_graph/components/stat_item.dart';
import 'package:flutter/material.dart';

/// 読書進捗情報ウィジェット。
class ProgressInfo extends StatelessWidget {
  /// コンストラクタ。
  const ProgressInfo({
    required this.readPages,
    required this.totalPages,
    super.key,
  });

  /// 読了ページ数。
  final int readPages;

  /// 総ページ数。
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.3),
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          StatItem(
            value: '$readPages',
            label: '読了ページ',
            icon: Icons.book_outlined,
            color: colorScheme.primary,
          ),
          Container(
            width: 1,
            height: 40,
            color: colorScheme.outline.withValues(alpha: 0.3),
          ),
          StatItem(
            value: '$totalPages',
            label: '総ページ',
            icon: Icons.menu_book_outlined,
            color: colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
