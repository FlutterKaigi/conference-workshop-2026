import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// トグルスイッチの状態更新ハンドラの型定義。
typedef UpdateToggleSwitchState = void Function({
  required bool value,
  required void Function({required bool value}) updateState,
});

/// トグルスイッチの ViewModel。
class ToggleSwitchViewModel {
  /// コンストラクタ。
  ToggleSwitchViewModel({
    required bool initValue,
    required this.updateHandler,
    this.onBind,
    this.onUnBind,
  }) : _isEnable = initValue;

  /// 状態更新ハンドラ。
  final UpdateToggleSwitchState updateHandler;

  /// バインド時のコールバック。
  final void Function()? onBind;

  /// バインド解除時のコールバック。
  final void Function()? onUnBind;

  bool _isEnable;
  VoidCallback? _updateStateCallback;

  /// 有効状態を取得する。
  bool get isEnable => _isEnable;

  /// バインドされているかどうかを取得する。
  bool get isBinding => _updateStateCallback != null;

  void _bindUpdateState(VoidCallback updateState) {
    _updateStateCallback = updateState;
    onBind?.call();
  }

  void _unbindUpdateState() {
    _updateStateCallback = null;
    onUnBind?.call();
  }

  void _update(bool value) {
    _isEnable = value;
    _updateStateCallback?.call();
    updateHandler(
      value: value,
      updateState: updateState,
    );
  }

  /// 外部から状態を更新する。
  void updateState({required bool value}) {
    _isEnable = value;
    _updateStateCallback?.call();
  }
}

/// トグルスイッチウィジェット。
class ToggleSwitch extends StatefulWidget {
  /// コンストラクタ。
  const ToggleSwitch({
    required this.viewModel,
    super.key,
  });

  /// ViewModel。
  final ToggleSwitchViewModel viewModel;

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<ToggleSwitchViewModel>('viewModel', viewModel),
    );
  }
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  @override
  void initState() {
    super.initState();
    widget.viewModel._bindUpdateState(() {
      if (mounted) {
        setState(() {});
      }
    });
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
