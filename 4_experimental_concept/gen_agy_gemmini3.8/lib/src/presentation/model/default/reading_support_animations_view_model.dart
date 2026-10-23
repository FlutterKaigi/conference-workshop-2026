import 'dart:async';
import 'package:conference_handson_2025/src/fundamental/ui_widget/toggle_switch.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 読書応援アニメーションの種類を表す列挙型。
enum SupportAnimationTypeEnum {
  /// アニメーションなし
  none,

  /// 応援
  cheer,

  /// 喝
  scolding,
}

/// 読書応援アニメーションのプロバイダ。
final NotifierProvider<ReadingSupportAnimationsViewModel,
        SupportAnimationTypeEnum> readingSupportAnimationsProvider =
    NotifierProvider<ReadingSupportAnimationsViewModel,
        SupportAnimationTypeEnum>(
  ReadingSupportAnimationsViewModel.new,
);

/// 読書応援アニメーションの ViewModel。
class ReadingSupportAnimationsViewModel
    extends Notifier<SupportAnimationTypeEnum> {
  static void Function({required SupportAnimationTypeEnum animationType})?
      _updateAnimationType;

  Timer? _timer;

  /// 読書開始イベント発行トグル。
  late final ToggleSwitchViewModel debugStartReading = ToggleSwitchViewModel(
    initValue: false,
    updateHandler: ({
      required value,
      required updateState,
    }) {
      if (value) {
        Timer(const Duration(seconds: 10), () {
          _updateAnimationType?.call(
            animationType: SupportAnimationTypeEnum.cheer,
          );
          updateState(value: false);
        });
      }
    },
  );

  /// 読書終了イベント発行トグル。
  late final ToggleSwitchViewModel debugEndReading = ToggleSwitchViewModel(
    initValue: false,
    updateHandler: ({
      required value,
      required updateState,
    }) {
      if (value) {
        Timer(const Duration(seconds: 10), () {
          _updateAnimationType?.call(
            animationType: SupportAnimationTypeEnum.scolding,
          );
          updateState(value: false);
        });
      }
    },
  );

  @override
  SupportAnimationTypeEnum build() {
    _updateAnimationType = updateAnimationType;
    ref.onDispose(() {
      _timer?.cancel();
      _updateAnimationType = null;
    });
    return SupportAnimationTypeEnum.none;
  }

  /// アニメーション種別を更新し、10秒後にリセットする。
  void updateAnimationType({
    required SupportAnimationTypeEnum animationType,
  }) {
    _timer?.cancel();
    state = animationType;
    if (animationType != SupportAnimationTypeEnum.none) {
      _timer = Timer(const Duration(seconds: 10), () {
        state = SupportAnimationTypeEnum.none;
      });
    }
  }
}
