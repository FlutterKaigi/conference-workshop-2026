/// 読書応援アニメーションの ViewModel。
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../fundamental/ui_widget/toggle_switch.dart';

/// 読書応援アニメーションの種別。
enum SupportAnimationTypeEnum {
  /// アニメーションなし。
  none,

  /// 応援（cheer）。
  cheer,

  /// 喝（scolding）。
  scolding,
}

/// [ReadingSupportAnimationsViewModel] の [NotifierProvider]。
final NotifierProvider<
  ReadingSupportAnimationsViewModel,
  SupportAnimationTypeEnum
>
readingSupportAnimationsProvider =
    NotifierProvider<
      ReadingSupportAnimationsViewModel,
      SupportAnimationTypeEnum
    >(ReadingSupportAnimationsViewModel.new);

/// `updateAnimationType` を static な関数変数として保持。
/// [build] 内でバインドされる。
void Function(SupportAnimationTypeEnum animationType)? _updateAnimationType;

/// 読書応援アニメーションの ViewModel。
class ReadingSupportAnimationsViewModel
    extends Notifier<SupportAnimationTypeEnum> {
  /// 初期化時に [SupportAnimationTypeEnum.none] を返す。
  ///
  /// `updateAnimationType` を static な関数変数 [_updateAnimationType]
  /// にバインドする。
  @override
  SupportAnimationTypeEnum build() {
    _updateAnimationType = (SupportAnimationTypeEnum animationType) {
      return updateAnimationType(animationType: animationType);
    };
    return SupportAnimationTypeEnum.none;
  }

  /// アニメーションの種別を更新する（10 秒後に [none] に戻す）。
  void updateAnimationType({required SupportAnimationTypeEnum animationType}) {
    state = animationType;
    Timer(const Duration(seconds: 10), () {
      state = SupportAnimationTypeEnum.none;
    });
  }

  /// デバッグ用：読書開始イベント。
  ///
  /// スイッチを ON にすると 10 秒後に cheer のアニメーション種別を
  /// 発行し、スイッチを OFF に戻す。
  final ToggleSwitchViewModel debugStartReading = ToggleSwitchViewModel(
    initValue: false,
    updateHandler:
        ({
          required bool value,
          required void Function({required bool value}) updateState,
        }) {
          if (value) {
            Timer(const Duration(seconds: 10), () {
              _updateAnimationType?.call(SupportAnimationTypeEnum.cheer);
              updateState(value: false);
            });
          }
        },
  );

  /// デバッグ用：読書終了イベント。
  ///
  /// スイッチを ON にすると 10 秒後に scolding のアニメーション種別を
  /// 発行し、スイッチを OFF に戻す。
  final ToggleSwitchViewModel debugEndReading = ToggleSwitchViewModel(
    initValue: false,
    updateHandler:
        ({
          required bool value,
          required void Function({required bool value}) updateState,
        }) {
          if (value) {
            Timer(const Duration(seconds: 10), () {
              _updateAnimationType?.call(SupportAnimationTypeEnum.scolding);
              updateState(value: false);
            });
          }
        },
  );
}
