import 'package:conference_handson_2025/src/fundamental/ui_widget/consumer_staged_widget.dart';
import 'package:conference_handson_2025/src/presentation/model/view_model_packages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書応援アニメーション表示ウィジェット（デフォルト版）。
// ignore: must_be_immutable
class ReadingSupportAnimationsWidget
    extends ConsumerStagedWidget<SupportAnimationTypeEnum, Object> {
  /// コンストラクタ。
  ReadingSupportAnimationsWidget({
    required super.provider,
    super.key,
  });

  @override
  ConsumerStagedBuild<SupportAnimationTypeEnum, Object> selectBuild(
    List<ConsumerStagedBuild<SupportAnimationTypeEnum, Object>> builders,
    SupportAnimationTypeEnum value,
  ) {
    return builders[value.index];
  }

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
    SupportAnimationTypeEnum value,
    Object? state,
  ) {
    return const Offstage();
  }

  @override
  Widget build2(
    BuildContext context,
    WidgetRef ref,
    SupportAnimationTypeEnum value,
    Object? state,
  ) {
    return _buildContainer(
      context,
      message: '頑張って！応援してるよ！🎉',
      color: Colors.green,
    );
  }

  @override
  Widget build3(
    BuildContext context,
    WidgetRef ref,
    SupportAnimationTypeEnum value,
    Object? state,
  ) {
    return _buildContainer(
      context,
      message: 'もっと集中して！喝！🔥',
      color: Colors.orange,
    );
  }

  Widget _buildContainer(
    BuildContext context, {
    required String message,
    required Color color,
  }) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(16),
        color: color,
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
