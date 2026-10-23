/// ホーム画面の「読書応援アニメーション」ウィジェット。
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../fundamental/ui_widget/consumer_staged_widget.dart';
import '../../../model/default/reading_support_animations_view_model.dart';

/// ホーム画面の「読書応援アニメーション」ウィジェット。
class ReadingSupportAnimationsWidget
    extends ConsumerStagedWidget<SupportAnimationTypeEnum, Object> {
  /// コンストラクタ。
  const ReadingSupportAnimationsWidget({required super.provider, super.key});

  @override
  Object? createWidgetState() {
    return null;
  }

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
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          '頑張って！応援してるよ！🎉',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build3(
    BuildContext context,
    WidgetRef ref,
    SupportAnimationTypeEnum value,
    Object? state,
  ) {
    return Container(
      color: Colors.orange,
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          'もっと集中して！喝！🔥',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
