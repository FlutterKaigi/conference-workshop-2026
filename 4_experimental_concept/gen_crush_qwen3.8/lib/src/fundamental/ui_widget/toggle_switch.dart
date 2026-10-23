/// スイッチ（[Switch]）をViewModelにバインドするためのウィジェット。
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// スイッチの状態を更新する関数の型。
typedef UpdateToggleSwitchState =
    void Function({
      required bool value,
      required void Function({required bool value}) updateState,
    });

/// [Switch] をバインドするための ViewModel。
class ToggleSwitchViewModel {
  /// コンストラクタ。
  ToggleSwitchViewModel({
    required bool initValue,
    required UpdateToggleSwitchState updateHandler,
    this.onBind,
    this.onUnBind,
  }) : _isEnable = initValue,
       _updateHandler = updateHandler;

  /// スイッチの現在の値。
  bool _isEnable;

  /// 状態の更新ハンドラ。
  final UpdateToggleSwitchState _updateHandler;

  /// バインド時に呼ばれるコールバック。
  final void Function()? onBind;

  /// アンバインド時に呼ばれるコールバック。
  final void Function()? onUnBind;

  bool _isBinding = false;
  void Function()? _updateState;

  /// スイッチの現在の値。
  bool get isEnable => _isEnable;

  /// 更新関数がバインド中かどうか。
  bool get isBinding => _isBinding;

  /// ウィジェット側から再描画用の関数をバインドする。
  void _bindUpdateState(void Function() updateState) {
    _updateState = updateState;
    _isBinding = true;
    onBind?.call();
  }

  /// 再描画用の関数のバインドを解除する。
  void _unbindUpdateState() {
    _updateState = null;
    _isBinding = false;
    onUnBind?.call();
  }

  /// スイッチの更新（[Switch.onChanged] 側で呼ばれる）。
  void _update(bool value) {
    _updateHandler(value: value, updateState: updateState);
    _isEnable = value;
  }

  /// 値を更新して再描画する。
  void updateState({required bool value}) {
    _isEnable = value;
    _updateState?.call();
  }
}

/// [Switch] を [ToggleSwitchViewModel] とバインドするウィジェット。
class ToggleSwitch extends StatefulWidget {
  /// コンストラクタ。
  const ToggleSwitch({required this.viewModel, super.key});

  /// 使用する [ToggleSwitchViewModel]。
  final ToggleSwitchViewModel viewModel;

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<bool>('isEnable', viewModel.isEnable));
    properties.add(DiagnosticsProperty<bool>('isBinding', viewModel.isBinding));
  }
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  @override
  void initState() {
    widget.viewModel._bindUpdateState(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    widget.viewModel._unbindUpdateState();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: widget.viewModel.isEnable,
      onChanged: widget.viewModel._update,
    );
  }
}
