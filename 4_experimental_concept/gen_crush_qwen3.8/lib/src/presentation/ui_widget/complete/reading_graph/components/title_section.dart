/// タイトルセクション（完成版）。
library;

import 'package:flutter/material.dart';

/// タイトルセクション。
///
/// 書名と現在率を表示する。
class TitleSection extends StatelessWidget {
  /// コンストラクタ。
  const TitleSection({
    required this.bookName,
    required this.progress,
    super.key,
  });

  /// 書名。
  final String bookName;

  /// 進捗率（0〜1）。
  final double progress;

  @override
  Widget build(BuildContext context) {
    final TextTheme themeTextTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            bookName.isEmpty ? '読書進捗' : bookName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: themeTextTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(progress * 100).toStringAsFixed(1)}% 完了',
            style: themeTextTheme.titleLarge,
          ),
        ],
      ),
    );
  }
}
