/// 読書進捗のドーナツグラフウィジェット（完成版）。
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../fundamental/ui_widget/consumer_staged_widget.dart';
import '../../../../domain/model/reading_book_value_object.dart';
import 'components/donut_chart_center_content.dart';
import 'components/progress_donut_chart.dart';
import 'components/progress_info.dart';
import 'components/title_section.dart';
import 'donut_animation_state.dart';

/// 読書進捗のドーナツグラフウィジェット（完成版）。
class ReadingBookGraphWidget
    extends ConsumerStagedWidget<ReadingBookValueObject, DonutAnimationState> {
  /// コンストラクタ。
  const ReadingBookGraphWidget({required super.provider, super.key});

  @override
  DonutAnimationState createWidgetState() {
    return DonutAnimationState();
  }

  @override
  void disposeState(DonutAnimationState? state) {
    state?.dispose();
  }

  /// ドーナツチャートのタップ時に呼ばれる。
  void _onDonutTap(DonutAnimationState state) {
    state.triggerPulseAnimation();
    HapticFeedback.lightImpact();
  }

  /// 現在の進捗率。
  double _currentProgress(ReadingBookValueObject value) {
    return value.totalPages <= 0
        ? 0
        : (value.readingPageNum / value.totalPages).clamp(0.0, 1.0);
  }

  /// ウィジェットを構築する。
  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ReadingBookValueObject value,
    DonutAnimationState? state,
  ) {
    final double progress = _currentProgress(value);
    final DonutAnimationState animationState = state!;
    animationState.setProgressValue(progress);
    // FIXME コードを完成させてください。
    // ステップ1: addPostFrameCallback による描画予約
    // 正解のコード（コメントアウト）:
    // WidgetsBinding.instance.addPostFrameCallback((Duration _) {
    //   animationState.animateToProgress(progress);
    // });
    // 仮コード: 描画予約を行わず、いきなり進捗を設定する。
    WidgetsBinding.instance.addPostFrameCallback((Duration _) {});

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TitleSection(bookName: value.name, progress: progress),
            const SizedBox(height: 32),
            GestureDetector(
              onTap: () => _onDonutTap(animationState),
              child: ProgressDonutChart(
                animationState: animationState,
                colorScheme: Theme.of(context).colorScheme,
                value: value,
              ),
            ),
            const SizedBox(height: 32),
            ProgressInfo(
              readingPageNum: value.readingPageNum,
              totalPages: value.totalPages,
              colorScheme: Theme.of(context).colorScheme,
            ),
          ],
        ),
      ),
    );
  }
}
