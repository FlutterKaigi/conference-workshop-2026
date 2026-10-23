/// ホーム画面の「読書進捗アニメーション」ウィジェット。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../fundamental/ui_widget/consumer_staged_widget.dart';
import '../../../model/default/reading_books_view_model.dart';
import '../../../model/default/reading_progress_animations_view_model.dart';

/// ホーム画面の「読書進捗アニメーション」ウィジェット。
class ReadingProgressAnimationsWidget
    extends ConsumerStagedWidget<ProgressAnimationTypeEnum, Object> {
  /// コンストラクタ。
  const ReadingProgressAnimationsWidget({required super.provider, super.key});

  @override
  Object? createWidgetState() {
    return null;
  }

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
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          '${_editedBookName(ref)} 読了率 10%を達成しました！ 🔥',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build3(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          '${_editedBookName(ref)} 読了率 50%を達成しました！ 🔥',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build4(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          '${_editedBookName(ref)} 読了率 80%を達成しました！ 🔥',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build5(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    return Container(
      color: Colors.blue,
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          '${_editedBookName(ref)} 読了おめでとうございます！ 🔥',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}

String _editedBookName(WidgetRef ref) {
  return ref.read(readingBooksProvider.notifier).editedReadingBook?.name ?? '';
}
