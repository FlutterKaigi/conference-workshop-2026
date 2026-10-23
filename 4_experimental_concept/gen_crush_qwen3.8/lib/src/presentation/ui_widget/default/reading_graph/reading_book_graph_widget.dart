/// 読書進捗の円グラフウィジェット（ベース UI）。
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../fundamental/ui_widget/consumer_staged_widget.dart';
import '../../../../domain/model/reading_book_value_object.dart';

/// 円グラフのペインター。
class PieChartPainter extends CustomPainter {
  /// コンストラクタ（[progress] は 0〜1）。
  const PieChartPainter(this.progress);

  /// 進捗率（0〜1）。
  final double progress;

  /// パイグラフを描画する。
  @override
  void paint(Canvas canvas, Size size) {
    // 背景の灰色の円（太さ 20）。
    final Paint backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..color = const Color(0xFFE0E0E0);
    final double radius = math.min(size.width, size.height) / 2 - 10;
    final Offset center = size.center(Offset.zero);
    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      // 12 時方向から青の円弧を描く（太さ 20、StrokeCap.round）。
      final Paint progressPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round
        ..color = const Color(0xFF2196F3);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        progress * 2 * math.pi,
        false,
        progressPaint,
      );
    }
  }

  /// 再描画の判定。
  @override
  bool shouldRepaint(PieChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// 読書進捗の円グラフウィジェット（ベース UI）。
class ReadingBookGraphWidget
    extends ConsumerStagedWidget<ReadingBookValueObject, Object> {
  /// コンストラクタ。
  const ReadingBookGraphWidget({required super.provider, super.key});

  @override
  Object? createWidgetState() {
    return null;
  }

  /// 進捗率を 0〜1 に clamp する（どちらかが 0 以下なら 0）。
  double _progress(ReadingBookValueObject value) {
    if (value.readingPageNum <= 0 || value.totalPages <= 0) {
      return 0;
    }
    return (value.readingPageNum / value.totalPages).clamp(0.0, 1.0);
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ReadingBookValueObject value,
    Object? state,
  ) {
    final double progress = _progress(value);
    final bool isComplete = progress >= 1.0;
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '総ページ数: ${value.totalPages}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              '読了ページ数: ${value.readingPageNum}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            CustomPaint(
              size: const Size(200, 200),
              painter: PieChartPainter(progress),
              child: Center(
                child: Text(
                  '${(progress * 100).toInt()}%',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (isComplete) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                '読了おめでとうございます！',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
