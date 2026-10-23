import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/fundamental/ui_widget/consumer_staged_widget.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/complete/reading_graph/components/donut_animation_state.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/complete/reading_graph/components/progress_donut_chart.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/complete/reading_graph/components/progress_info.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/complete/reading_graph/components/title_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書進捗グラフウィジェット（完成版）。
// ignore: must_be_immutable
class ReadingBookGraphWidget
    extends ConsumerStagedWidget<ReadingBookValueObject, DonutAnimationState> {
  /// コンストラクタ。
  ReadingBookGraphWidget({
    required super.provider,
    super.key,
  });

  @override
  DonutAnimationState createWidgetState() => DonutAnimationState();

  @override
  void disposeState(DonutAnimationState? state) {
    state?.dispose();
  }

  void _onDonutTap(DonutAnimationState? state) {
    state?.triggerPulseAnimation();
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ReadingBookValueObject value,
    DonutAnimationState? state,
  ) {
    final double progress = value.totalPages <= 0
        ? 0.0
        : (value.readingPageNum / value.totalPages).clamp(0.0, 1.0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state?.animateToProgress(progress);
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: <Widget>[
            TitleSection(
              title: value.name,
              progress: progress,
            ),
            const SizedBox(height: 32),
            if (state != null)
              ProgressDonutChart(
                state: state,
                total: value.totalPages,
                read: value.readingPageNum,
                onTap: () => _onDonutTap(state),
              ),
            const SizedBox(height: 32),
            ProgressInfo(
              readPages: value.readingPageNum,
              totalPages: value.totalPages,
            ),
          ],
        ),
      ),
    );
  }
}
