import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// 空実装の補助状態クラス。
class StagedWidgetState {
  /// コンストラクタ。
  const StagedWidgetState();

  /// 空の setState メソッド。
  void setState(VoidCallback fn) {}
}

/// 内部状態を持つウィジェットの基底クラス。
// ignore: must_be_immutable
abstract class StagedWidget<T> extends StatefulWidget
    with WidgetsBindingObserver {
  /// コンストラクタ。
  StagedWidget({
    super.key,
    this.isWidgetsBindingObserve = false,
  });

  /// アプリライフサイクルを監視するかどうかのフラグ。
  final bool isWidgetsBindingObserve;

  /// ウィジェットが保持する内部状態への参照。
  T? _state;

  /// 内部状態を取得する。
  T? get state => _state;

  /// 内部状態を生成する。派生クラスで実装する。
  T? createWidgetState();

  /// 初期化フック。
  void initState(T? state) {}

  /// 依存関係変更フック。
  void didChangeDependencies(T? state) {}

  /// ウィジェット更新フック。
  void didUpdateWidget(
    covariant StagedWidget<T> now,
    covariant StagedWidget<T> old,
    T? state,
  ) {}

  /// build 直後のセットアップフック。
  void setupState(T? state) {}

  /// 破棄フック。
  void disposeState(T? state) {}

  /// ウィジェットの破棄処理。
  void dispose() {}

  /// レジューム時のフック。
  void onResumed(T? state) {}

  /// 非アクティブ時のフック。
  void onInactive(T? state) {}

  /// 一時停止時のフック。
  void onPaused(T? state) {}

  /// 非表示時のフック。
  void onHidden(T? state) {}

  /// デタッチ時のフック。
  void onDetached(T? state) {}

  /// ウィジェットを描画する。
  Widget build(BuildContext context, T? state);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed(_state);
      case AppLifecycleState.inactive:
        onInactive(_state);
      case AppLifecycleState.paused:
        onPaused(_state);
      case AppLifecycleState.hidden:
        onHidden(_state);
      case AppLifecycleState.detached:
        onDetached(_state);
        dispose();
    }
  }

  @override
  State<StagedWidget<T>> createState() => _StagedWidgetState<T>();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<bool>(
        'isWidgetsBindingObserve',
        isWidgetsBindingObserve,
      ),
    );
  }
}

class _StagedWidgetState<T> extends State<StagedWidget<T>> {
  T? _state;

  @override
  void initState() {
    super.initState();
    if (widget.isWidgetsBindingObserve) {
      WidgetsBinding.instance.addObserver(widget);
    }
    _state = widget.createWidgetState();
    widget._state = _state;
    widget.initState(_state);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies(_state);
  }

  @override
  void didUpdateWidget(covariant StagedWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget._state = _state;
    widget.didUpdateWidget(widget, oldWidget, _state);
  }

  @override
  Widget build(BuildContext context) {
    final Widget result = widget.build(context, _state);
    widget.setupState(_state);
    return result;
  }

  @override
  void dispose() {
    widget.disposeState(_state);
    widget.dispose();
    _state = null;
    widget._state = null;
    if (widget.isWidgetsBindingObserve) {
      WidgetsBinding.instance.removeObserver(widget);
    }
    super.dispose();
  }
}
