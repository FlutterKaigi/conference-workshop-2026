import 'package:conference_handson_2025/src/fundamental/ui_widget/consumer_staged_widget.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:conference_handson_2025/src/presentation/ui_widget/challenge/home/components/progress/progress_achievement_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書進捗アニメーション表示ウィジェット（ハンズオン演習版）。
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
    final String? title =
        ref.watch(readingBooksProvider.notifier).editedReadingBook?.name;
    return ProgressAchievementAnimation(
      targetPercentage: 10,
      message: '素晴らしいスタート！',
      title: title,
      primaryColor: const Color(0xFF2196F3),
      secondaryColor: const Color(0xFF03DAC6),
      iconData: Icons.rocket_launch,
      isCompletion: false,
    );
  }

  @override
  Widget build3(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    final String? title =
        ref.watch(readingBooksProvider.notifier).editedReadingBook?.name;
    return ProgressAchievementAnimation(
      targetPercentage: 50,
      message: '折り返し地点到達！',
      title: title,
      primaryColor: const Color(0xFFFF9800),
      secondaryColor: const Color(0xFFFFEB3B),
      iconData: Icons.trending_up,
      isCompletion: false,
    );
  }

  @override
  Widget build4(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    final String? title =
        ref.watch(readingBooksProvider.notifier).editedReadingBook?.name;
    return ProgressAchievementAnimation(
      targetPercentage: 80,
      message: 'もうすぐゴール！',
      title: title,
      primaryColor: const Color(0xFF9C27B0),
      secondaryColor: const Color(0xFFE91E63),
      iconData: Icons.speed,
      isCompletion: false,
    );
  }

  @override
  Widget build5(
    BuildContext context,
    WidgetRef ref,
    ProgressAnimationTypeEnum value,
    Object? state,
  ) {
    final String? title =
        ref.watch(readingBooksProvider.notifier).editedReadingBook?.name;
    return ProgressAchievementAnimation(
      targetPercentage: 100,
      message: '完読おめでとう！',
      title: title,
      primaryColor: const Color(0xFF4CAF50),
      secondaryColor: const Color(0xFFFFD700),
      iconData: Icons.celebration,
      isCompletion: true,
    );
  }
}
