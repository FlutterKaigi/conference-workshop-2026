/// ドーナツチャートの本体（完成版）。
library;

import 'package:flutter/material.dart';

import '../../../../../domain/model/reading_book_value_object.dart';

import '../donut_animation_state.dart';
import '../progress_donut_chart_painter.dart';
import 'background_glow.dart';
import 'donut_chart_center_content.dart';

/// ドーナツチャートの本体。
class ProgressDonutChart extends StatefulWidget {
  /// コンストラクタ。
  const ProgressDonutChart({
    required this.animationState,
    required this.colorScheme,
    required this.value,
    super.key,
  });

  /// アニメーションの状態。
  final DonutAnimationState animationState;

  /// 色スキーム。
  final ColorScheme colorScheme;

  /// 対象の書籍。
  final ReadingBookValueObject value;

  @override
  State<ProgressDonutChart> createState() => _ProgressDonutChartState();
}

class _ProgressDonutChartState extends State<ProgressDonutChart>
    with TickerProviderStateMixin {
  @override
  void initState() {
    widget.animationState.initializeAnimations(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.animationState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation:
          widget.animationState.animationController ??
          Listenable.merge(<Listenable>[]),
      builder: (BuildContext context, Widget? child) {
        return Container(
          width: 280,
          height: 280,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: widget.colorScheme.primary.withOpacity(
                  0.1 + widget.animationState.pulseValue * 0.1,
                ),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              BackgroundGlow(
                primaryColor: widget.colorScheme.primary,
                animation:
                    widget.animationState.animationController?.value ?? 0,
              ),
              CustomPaint(
                size: const Size(280, 280),
                painter: ProgressDonutChartPainter(
                  progress: widget.animationState.animatedProgress,
                  pulseValue: widget.animationState.pulseValue,
                  colorScheme: widget.colorScheme,
                ),
              ),
              DonutChartCenterContent(
                animatedProgress: widget.animationState.animatedProgress,
                remainingPages:
                    widget.value.totalPages - widget.value.readingPageNum,
                colorScheme: widget.colorScheme,
              ),
            ],
          ),
        );
      },
    );
  }
}
