import 'dart:math' as math;
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/reading_graph/components/background_glow.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/reading_graph/components/donut_animation_state.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/reading_graph/components/donut_chart_center_content.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/complete/reading_graph/components/progress_donut_chart_painter.dart';
import 'package:flutter/material.dart';

/// プログレスドーナツチャートウィジェット（ハンズオン演習版）。
class ProgressDonutChart extends StatefulWidget {
  /// コンストラクタ。
  const ProgressDonutChart({
    required this.state,
    required this.total,
    required this.read,
    this.onTap,
    super.key,
  });

  /// アニメーション状態。
  final DonutAnimationState state;

  /// 総ページ数。
  final int total;

  /// 読了ページ数。
  final int read;

  /// タップ時のコールバック。
  final VoidCallback? onTap;

  @override
  State<ProgressDonutChart> createState() => _ProgressDonutChartState();
}

class _ProgressDonutChartState extends State<ProgressDonutChart>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.state.initializeAnimations(this);
  }

  @override
  void dispose() {
    widget.state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: widget.state.progressController!,
      builder: (BuildContext context, Widget? child) {
        return GestureDetector(
          onTap: widget.onTap,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                BackgroundGlow(primaryColor: colorScheme.primary),
                CustomPaint(
                  size: const Size(280, 280),
                  painter: ProgressDonutChartPainter(
                    progress: widget.state.animatedProgress,
                    pulseValue: widget.state.pulseValue,
                    colorScheme: colorScheme,
                  ),
                ),
                DonutChartCenterContent(
                  animatedProgress: widget.state.animatedProgress,
                  remainingPages: math.max(0, widget.total - widget.read),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
