/// ホーム画面の「読書進捗アニメーション」ウィジェット（完成版）。
library;

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../fundamental/ui_widget/consumer_staged_widget.dart';
import '../../../model/default/reading_books_view_model.dart';
import '../../../model/default/reading_progress_animations_view_model.dart';
import 'components/progress/progress_achievement_animation.dart';

/// ホーム画面の「読書進捗アニメーション」ウィジェット（完成版）。
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

  /// 書名（編集中書籍の名前）。
  String _editedBookName(WidgetRef ref) {
    return ref.read(readingBooksProvider.notifier).editedReadingBook?.name ??
        '';
  }

  /// build（none）：オフステージ。
  Widget build(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    return const Offstage();
  }

  /// build2（10%）：進捗達成アニメーション。
  @override
  Widget build2(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    return ProgressAchievementAnimation(
      progressPercentage: 10,
      message: '素晴らしいスタート！',
      primaryColor: const Color(0xFF2196F3),
      secondaryColor: const Color(0xFF03DAC6),
      icon: Icons.rocket_launch,
      isCompletion: false,
      bookName: _editedBookName(ref),
    );
  }

  /// build3（50%）：進捗達成アニメーション。
  @override
  Widget build3(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    return ProgressAchievementAnimation(
      progressPercentage: 50,
      message: '折り返し地点到達！',
      primaryColor: const Color(0xFFFF9800),
      secondaryColor: const Color(0xFFFFEB3B),
      icon: Icons.trending_up,
      isCompletion: false,
      bookName: _editedBookName(ref),
    );
  }

  /// build4（80%）：進捗達成アニメーション。
  @override
  Widget build4(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    return ProgressAchievementAnimation(
      progressPercentage: 80,
      message: 'もうすぐゴール！',
      primaryColor: const Color(0xFF9C27B0),
      secondaryColor: const Color(0xFFE91E63),
      icon: Icons.speed,
      isCompletion: false,
      bookName: _editedBookName(ref),
    );
  }

  /// build5（100%）：完読アニメーション。
  @override
  Widget build5(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    return ProgressAchievementAnimation(
      progressPercentage: 100,
      message: '完読おめでとう！',
      primaryColor: const Color(0xFF4CAF50),
      secondaryColor: const Color(0xFFFFD700),
      icon: Icons.celebration,
      isCompletion: true,
      bookName: _editedBookName(ref),
    );
  }
}
