/// 内部状態を持つウィジェット基底クラス [StagedWidget]。
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 内部状態を持つウィジェット基底クラス。
///
/// `StatefulWidget` + `State` の代替となる。派生クラスは
/// [createWidgetState] / [initState] / [disposeState] 等のフックを
/// オーバーライドし、[build] は [T?] の状態を受け取る。
abstract class StagedWidget<T> extends StatefulWidget
    with WidgetsBindingObserver {
  /// コンストラクタ。
  const StagedWidget({super.key, this.isWidgetsBindingObserve = false});

  /// [WidgetsBinding] のオブザーバとして登録するかどうか。
  final bool isWidgetsBindingObserve;

  @override
  State<StagedWidget<T>> createState() => _StagedWidgetState<T>();

  /// 内部状態オブジェクトを作成する。
  @protected
  T? createWidgetState();

  /// ウィジェットの初期化時に呼ばれる。
  @protected
  void initState(T? state) {}

  /// 依存関係の変化時に呼ばれる。
  @protected
  void didChangeDependencies(T? state) {}

  /// ウィジェットが更新されたときに呼ばれる。
  @protected
  void didUpdateWidget(
    StagedWidget<T> nowWidget,
    StagedWidget<T> oldWidget,
    T? state,
  ) {}

  /// `build` 完了後に呼ばれる。
  @protected
  void setupState(T? state) {}

  /// 破棄時に呼ばれる。
  @protected
  void disposeState(T? state) {}

  /// ウィジェットを構築する（派生クラスが実装する）。
  Widget build(BuildContext context, T? state);

  /// アプリライフサイクルが resumed になった。
  void onResumed() {}

  /// アプリライフサイクルが inactive になった。
  void onInactive() {}

  /// アプリライフサイクルが paused になった。
  void onPaused() {}

  /// アプリライフサイクルが hidden になった。
  void onHidden() {}

  /// アプリライフサイクルが detached になった。
  void onDetached() {}

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<bool>(
        'isWidgetsBindingObserve',
        isWidgetsBindingObserve,
        defaultValue: false,
      ),
    );
  }
}

class _StagedWidgetState<T> extends State<StagedWidget<T>>
    with WidgetsBindingObserver {
  T? state;

  bool _isWatching = false;

  @override
  void initState() {
    _isWatching = widget.isWidgetsBindingObserve;
    if (_isWatching) {
      WidgetsBinding.instance.addObserver(this);
    }
    state = widget.createWidgetState();
    widget.initState(state);
    super.initState();
  }

  @override
  void dispose() {
    widget.disposeState(state);
    state = null;
    if (_isWatching) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies(state);
  }

  @override
  void didUpdateWidget(covariant StagedWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget(widget, oldWidget, state);
  }

  @override
  Widget build(BuildContext context) {
    final Widget widgetResult = widget.build(context, state);
    widget.setupState(state);
    return widgetResult;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    switch (lifecycleState) {
      case AppLifecycleState.resumed:
        widget.onResumed();
      case AppLifecycleState.inactive:
        widget.onInactive();
      case AppLifecycleState.paused:
        widget.onPaused();
      case AppLifecycleState.hidden:
        widget.onHidden();
      case AppLifecycleState.detached:
        widget.onDetached();
        dispose();
    }
  }
}

/// 補助用の状態クラス（`setState` は何もしない空メソッド）。
class StagedWidgetState {
  /// 空実装の `setState`。
  void setState(VoidCallback callback) {
    // 意図的に何も行わない。
  }
}
