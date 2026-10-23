import 'package:flutter/material.dart';

/// タイトルセクションウィジェット。
class TitleSection extends StatelessWidget {
  /// コンストラクタ。
  const TitleSection({
    required this.title,
    required this.progress,
    super.key,
  });

  /// 書籍タイトル。
  final String? title;

  /// 進捗率（0.0 〜 1.0）。
  final double progress;

  @override
  Widget build(BuildContext context) {
    final String displayTitle =
        (title != null && title!.isNotEmpty) ? title! : '読書進捗';
    final double percentage = progress * 100;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        Text(
          displayTitle,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          '${percentage.toStringAsFixed(1)}% 完了',
          style: TextStyle(
            color: colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
