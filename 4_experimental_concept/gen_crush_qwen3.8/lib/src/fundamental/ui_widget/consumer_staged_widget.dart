/// Riverpod と組み合わせた内部状態付きウィジェット基底クラス。
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [ConsumerStagedWidget] の build メソッドの型。
typedef ConsumerStagedBuild<R, T> =
    Widget Function(BuildContext context, WidgetRef ref, R value, T? state);

/// セlector（build の選択）の型。
typedef SelectBuilder<R, T> =
    ConsumerStagedBuild<R, T> Function(
      List<ConsumerStagedBuild<R, T>> builders,
      R value,
    );

/// build メソッド群の生成子の型。
typedef ConsumerStagedBuilders<R, T> =
    List<ConsumerStagedBuild<R, T>> Function(
      BuildContext context,
      WidgetRef ref,
      R value,
      T? state,
    );

/// Riverpod と組み合わせた内部状態付きウィジェット基底クラス。
///
/// [provider] 引数で state 値 [R] を取り込み、状態値に応じて
/// `build` 〜 `build20` の中から [selectBuilder] / [selectBuild]
/// で選ばれた build を実行する。
abstract class ConsumerStagedWidget<R, T> extends StatefulWidget {
  /// コンストラクタ。
  const ConsumerStagedWidget({
    required this.provider,
    this.builders,
    this.selectBuilder,
    this.isWidgetsBindingObserve = false,
    super.key,
  });

  /// state 値 [R] を [WidgetRef] から取得する関数。
  final R Function(WidgetRef ref) provider;

  /// build メソッド群を生成する関数（省略時は [buildList]）。
  final ConsumerStagedBuilders<R, T>? builders;

  /// build の選択に使用する関数（省略時は [selectBuild]）。
  final SelectBuilder<R, T>? selectBuilder;

  /// [WidgetsBinding] のオブザーバとして登録するかどうか。
  final bool isWidgetsBindingObserve;

  @override
  State<ConsumerStagedWidget<R, T>> createState() =>
      _ConsumerStagedWidgetState<R, T>();

  /// 内部状態オブジェクトを作成する。
  T? createWidgetState();

  /// ウィジェットの初期化時に呼ばれる。
  void initState(T? state) {}

  /// 依存関係の変化時に呼ばれる。
  void didChangeDependencies(T? state) {}

  /// ウィジェットが更新されたときに呼ばれる。
  void didUpdateWidget(
    ConsumerStagedWidget<R, T> nowWidget,
    ConsumerStagedWidget<R, T> oldWidget,
    T? state,
  ) {}

  /// `build` 完了後に呼ばれる。
  void setupState(T? state) {}

  /// 破棄時に呼ばれる。
  void disposeState(T? state) {}

  /// アプリライフサイクルのハンドラ。
  void onResumed() {}
  void onInactive() {}
  void onPaused() {}
  void onHidden() {}
  void onDetached() {}

  /// state 値に対応するメインの build（index 0）。
  Widget build(BuildContext context, WidgetRef ref, R value, T? state);

  /// index 1 の build。
  Widget build2(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 2 の build。
  Widget build3(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 3 の build。
  Widget build4(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 4 の build。
  Widget build5(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 5 の build。
  Widget build6(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 6 の build。
  Widget build7(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 7 の build。
  Widget build8(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 8 の build。
  Widget build9(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 9 の build。
  Widget build10(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 10 の build。
  Widget build11(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 11 の build。
  Widget build12(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 12 の build。
  Widget build13(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 13 の build。
  Widget build14(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 14 の build。
  Widget build15(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 15 の build。
  Widget build16(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 16 の build。
  Widget build17(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 17 の build。
  Widget build18(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 18 の build。
  Widget build19(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// index 19 の build。
  Widget build20(BuildContext context, WidgetRef ref, R value, T? state) =>
      const Offstage();

  /// 使用可能な build メソッドのリスト（`build` 〜 `build20`）。
  List<ConsumerStagedBuild<R, T>> get buildList => <ConsumerStagedBuild<R, T>>[
    build,
    build2,
    build3,
    build4,
    build5,
    build6,
    build7,
    build8,
    build9,
    build10,
    build11,
    build12,
    build13,
    build14,
    build15,
    build16,
    build17,
    build18,
    build19,
    build20,
  ];

  /// build の選択（デフォルトは [builders] の先頭）。
  ConsumerStagedBuild<R, T> selectBuild(
    List<ConsumerStagedBuild<R, T>> builders,
    R value,
  ) {
    return builders[0];
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<R Function(WidgetRef)>(
        'provider',
        provider,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<SelectBuilder<R, T>>(
        'selectBuild',
        selectBuilder,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<List<ConsumerStagedBuild<R, T>>>(
        'buildList',
        buildList,
        defaultValue: <ConsumerStagedBuild<R, T>>[],
      ),
    );
    properties.add(
      DiagnosticsProperty<ConsumerStagedBuilders<R, T>>(
        'selectBuilder',
        builders,
        defaultValue: null,
      ),
    );
    properties.add(
      DiagnosticsProperty<bool>(
        'isWidgetsBindingObserve',
        isWidgetsBindingObserve,
        defaultValue: false,
      ),
    );
  }
}

class _ConsumerStagedWidgetState<R, T> extends State<ConsumerStagedWidget<R, T>>
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
  void didUpdateWidget(covariant ConsumerStagedWidget<R, T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    widget.didUpdateWidget(widget, oldWidget, state);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final R value = widget.provider(ref);
        final List<ConsumerStagedBuild<R, T>> builders =
            widget.builders?.call(context, ref, value, state) ??
            widget.buildList;
        final ConsumerStagedBuild<R, T> build =
            widget.selectBuilder?.call(builders, value) ??
            widget.selectBuild(builders, value);
        final Widget widgetResult = build(context, ref, value, state);
        widget.setupState(state);
        return widgetResult;
      },
    );
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
