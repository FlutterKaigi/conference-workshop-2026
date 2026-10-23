import 'package:flutter/material.dart';

/// ドーナツチャート中央コンテンツ（ハンズオン演習版）。
class DonutChartCenterContent extends StatelessWidget {
  /// コンストラクタ。
  const DonutChartCenterContent({
    required this.animatedProgress,
    required this.remainingPages,
    super.key,
  });

  /// アニメーション適用後の進捗率。
  final double animatedProgress;

  /// 残りページ数。
  final int remainingPages;

  @override
  Widget build(BuildContext context) {
    // FIXME コードを完成させてください。
    // ステップ3: AnimatedSwitcher による完読メッセージ切り替え
    /*
    final bool isCompleted = animatedProgress >= 1.0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 600),
      child: isCompleted
          ? const _CompletionContent(key: ValueKey<bool>(true))
          : _ProgressContent(
              key: const ValueKey<bool>(false),
              remainingPages: remainingPages,
            ),
    );
    */
    return _ProgressContent(
      key: const ValueKey<bool>(false),
      remainingPages: remainingPages,
    );
  }
}

// ignore: unused_element
class _CompletionContent extends StatelessWidget {
  const _CompletionContent();

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(
          Icons.celebration_outlined,
          size: 48,
          color: colorScheme.primary,
        ),
        const SizedBox(height: 8),
        Text(
          '完読達成！',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
        ),
      ],
    );
  }
}

class _ProgressContent extends StatelessWidget {
  const _ProgressContent({
    required this.remainingPages,
    super.key,
  });

  final int remainingPages;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          '残り',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        Text(
          '$remainingPages',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        Text(
          'ページ',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
