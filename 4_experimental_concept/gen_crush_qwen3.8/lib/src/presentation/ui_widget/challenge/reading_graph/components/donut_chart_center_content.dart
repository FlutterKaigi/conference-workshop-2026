/// 読了後の中央アイコン。
library;

import 'package:flutter/material.dart';

/// 読了後の中央アイコン。
class DonutChartCenterContent extends StatelessWidget {
  /// コンストラクタ。
  const DonutChartCenterContent({
    required this.animatedProgress,
    required this.remainingPages,
    required this.colorScheme,
    super.key,
  });

  /// アニメーション済みの進捗率（0〜1）。
  final double animatedProgress;

  /// 残りページ数。
  final int remainingPages;

  /// 色スキーム。
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = animatedProgress >= 1.0;
    // FIXME コードを完成させてください。
    // ステップ3: AnimatedSwitcher による完読メッセージ切り替え
    // 正解のコード（コメントアウト）:
    // return SizedBox(
    //   width: 200,
    //   height: 200,
    //   child: AnimatedSwitcher(
    //     duration: const Duration(milliseconds: 600),
    //     child: isCompleted
    //         ? _buildCompletion(context, isCompleted)
    //         : _buildProgress(context, isCompleted),
    //   ),
    // );
    // 仮コード: AnimatedSwitcher を使わず、常に ProgressContent を表示する。
    return SizedBox(
      width: 200,
      height: 200,
      child: _buildProgress(context, isCompleted),
    );
  }

  /// 読了時の内容。
  Widget _buildCompletion(BuildContext context, bool isCompleted) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.celebration_outlined, size: 48),
          const SizedBox(height: 8),
          Text('完読達成！', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }

  /// 未読了時の内容。
  Widget _buildProgress(BuildContext context, bool isCompleted) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('残り', style: Theme.of(context).textTheme.bodyLarge),
          Text(
            '$remainingPages',
            style: Theme.of(
              context,
            ).textTheme.displayMedium?.copyWith(fontWeight: FontWeight.w900),
          ),
          Text('ページ', style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
