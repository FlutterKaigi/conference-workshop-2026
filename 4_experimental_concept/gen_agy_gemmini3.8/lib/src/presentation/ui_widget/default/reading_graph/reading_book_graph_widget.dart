import 'dart:math' as math;
import 'package:conference_handson_2025/src/domain/model/reading_book_value_object.dart';
import 'package:conference_handson_2025/src/fundamental/ui_widget/consumer_staged_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書進捗グラフウィジェット（デフォルト版）。
// ignore: must_be_immutable
class ReadingBookGraphWidget
    extends ConsumerStagedWidget<ReadingBookValueObject, Object> {
  /// コンストラクタ。
  ReadingBookGraphWidget({
    required super.provider,
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ReadingBookValueObject value,
    Object? state,
  ) {
    final double progress = (value.totalPages <= 0 || value.readingPageNum <= 0)
        ? 0.0
        : (value.readingPageNum / value.totalPages).clamp(0.0, 1.0);

    final int percentage = (progress * 100).toInt();

    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '総ページ数: ${value.totalPages}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '読了ページ数: ${value.readingPageNum}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                height: 200,
                child: CustomPaint(
                  painter: PieChartPainter(progress: progress),
                  child: Center(
                    child: Text(
                      '$percentage%',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                  ),
                ),
              ),
              if (progress >= 1.0) ...<Widget>[
                const SizedBox(height: 24),
                Text(
                  '読了おめでとうございます！',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 円グラフ描画 CustomPainter。
class PieChartPainter extends CustomPainter {
  /// コンストラクタ。
  PieChartPainter({required this.progress});

  /// 進捗率（0.0 〜 1.0）。
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (math.min(size.width, size.height) - 20) / 2;

    final Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20;

    canvas.drawCircle(center, radius, backgroundPaint);

    if (progress > 0) {
      final Paint progressPaint = Paint()
        ..color = Colors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 20
        ..strokeCap = StrokeCap.round;

      final Rect rect = Rect.fromCircle(center: center, radius: radius);
      canvas.drawArc(
        rect,
        -math.pi / 2,
        progress * 2 * math.pi,
        false,
        progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant PieChartPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
