import 'package:conference_handson_2025/src/fundamental/ui_widget/consumer_staged_widget.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書進捗アニメーション表示ウィジェット（デフォルト版）。
// ignore: must_be_immutable
class ReadingProgressAnimationsWidget
    extends ConsumerStagedWidget<ProgressAnimationTypeEnum, Object> {
  /// コンストラクタ。
  ReadingProgressAnimationsWidget({
    required super.provider,
    super.key,
  });

  @override
  ConsumerStagedBuild<ProgressAnimationTypeEnum, Object> selectBuild(
    List<ConsumerStagedBuild<ProgressAnimationTypeEnum, Object>> builders,
    ProgressAnimationTypeEnum value,
  ) {
    return builders[value.index];
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    return const Offstage();
  }

  @override
  Widget build2(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    final String bookName =
        ref.watch(readingBooksProvider.notifier).editedReadingBook?.name ?? '';
    return _buildContainer(
      context,
      message: '$bookName 読了率 10%を達成しました！ 🔥',
    );
  }

  @override
  Widget build3(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    final String bookName =
        ref.watch(readingBooksProvider.notifier).editedReadingBook?.name ?? '';
    return _buildContainer(
      context,
      message: '$bookName 読了率 50%を達成しました！ 🔥',
    );
  }

  @override
  Widget build4(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    final String bookName =
        ref.watch(readingBooksProvider.notifier).editedReadingBook?.name ?? '';
    return _buildContainer(
      context,
      message: '$bookName 読了率 80%を達成しました！ 🔥',
    );
  }

  @override
  Widget build5(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    final String bookName =
        ref.watch(readingBooksProvider.notifier).editedReadingBook?.name ?? '';
    return _buildContainer(
      context,
      message: '$bookName 読了おめでとうございます！ 🔥',
    );
  }

  Widget _buildContainer(
    BuildContext context, {
    required String message,
  }) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.blue,
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
